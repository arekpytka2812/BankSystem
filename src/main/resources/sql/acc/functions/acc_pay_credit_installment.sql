create or replace function acc_pay_credit_installment(
    p_id_account_from bigint,
    p_money numeric(15,4),
    p_id_user bigint
)
returns bigint
language 'plpgsql'
as $function$
declare

    v_id_credit_account bigint;
    v_credit_account_number text;
    v_id_credit_currency bigint;
    v_id_current_credit_installment bigint;
    v_current_credit_installment_amount_left numeric(15,4);
    v_credit_base_installment numeric(15,4);

    v_money_to_pay bigint;

    v_res bigint;

begin

    if not acc_check_if_account_has_enough_balance(p_id_account_from, p_money) then
        raise exception 'Account has not enough balance!';
    end if;

    select a.id, a.account_number, a.currency_id, c.base_installment
    into v_id_credit_account, v_credit_account_number, v_id_credit_currency, v_credit_base_installment
    from acc_account a
    join acc_credit c on a.id = c.id
    where a.user_id = p_id_user
        and a.id_account_type = 4
        and a.account_close_date is null;

    if v_id_credit_account is null then
        raise exception 'Could not find open credit account!';
    end if;

    select id, amount_to_pay - amount_paid as amount_left
    into v_id_current_credit_installment, v_current_credit_installment_amount_left
    from acc_credit_installment
    where id_credit = v_id_credit_account
        and id_status != 3
    order by id desc limit 1;

    if v_current_credit_installment_amount_left > 0.0000 then -- splacenie ostatniej raty

        perform tr_add_transaction(
            p_id_user,
            p_id_account_from,
            v_credit_account_number,
            3,
            least(v_current_credit_installment_amount_left, p_money),
            current_date,
            v_id_credit_currency,
            'Payment for credit ' || v_id_current_credit_installment
        );

        perform acc_update_credit_installment(
            v_id_current_credit_installment,
            least(v_current_credit_installment_amount_left, p_money),
            p_id_user
        );

        p_money := p_money - least(v_current_credit_installment_amount_left, p_money);

        v_res := v_res + 1;

    end if;

    while p_money > 0.0000 loop

        v_id_current_credit_installment := acc_add_credit_installment(
            v_id_credit_account,
            v_credit_base_installment,
            p_id_user
        );

        if p_money - v_credit_base_installment > 0.0000 then

            perform tr_add_transaction(
                p_id_user,
                p_id_account_from,
                v_credit_account_number,
                3,
                v_credit_base_installment,
                current_date,
                v_id_credit_currency,
                'Payment for credit ' || v_id_current_credit_installment
            );

            p_money := p_money - v_credit_base_installment;

            v_res := v_res + 1;

        else

            perform tr_add_transaction(
                p_id_user,
                p_id_account_from,
                v_credit_account_number,
                3,
                p_money,
                current_date,
                v_id_credit_currency,
                'Payment for credit ' || v_id_current_credit_installment
            );

            perform acc_update_credit_installment(
                v_id_current_credit_installment,
                p_money,
                p_id_user
            );

            v_res := v_res + 1;

        end if;

    end loop;

    select c.full_amount - a.balance
    into v_money_to_pay
    from acc_credit c
    join acc_account a on c.id = a.id
    where c.id = v_id_credit_account;

    if v_money_to_pay = 0.0000 then

        perform acc_close_account(v_id_credit_account, p_id_user);
        perform usr_add_user_notification(p_id_user, 'You have successfully paid you credit!', p_id_user);

    elsif v_money_to_pay < 0.0000 then

        perform acc_close_account(v_id_credit_account, p_id_user);
        perform usr_add_user_notification(p_id_user, 'You overpaid your credit! Call our assistant to resolve this situation!', p_id_user);

    else

        perform acc_add_credit_installment(
            v_id_credit_account,
            least(v_credit_base_installment, v_money_to_pay),
            p_id_user
        );

    end if;

    return v_res;

end;
$function$
