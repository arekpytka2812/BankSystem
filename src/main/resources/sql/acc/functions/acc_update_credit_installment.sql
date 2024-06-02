create or replace function acc_update_credit_installment(
    p_id_credit_installment bigint,
    p_money_paid numeric(15,4),
    p_id_user bigint
)
returns boolean
language 'plpgsql'
as $function$
declare

    v_id_status bigint;
    v_amount_paid numeric(15,4);
    v_amount_to_pay numeric(15,4);

begin

    select amount_paid, amount_to_pay
    into v_amount_paid, v_amount_to_pay
    from acc_credit_installment
    where id = p_id_credit_installment;

    if v_amount_paid + p_money_paid = v_amount_to_pay then
        v_id_status := 3;
    elsif v_amount_paid + p_money_paid < v_amount_to_pay then
        v_id_status := 2;
    end if;

    update acc_credit_installment
    set id_status = v_id_status,
        payment_date = case when v_id_status = 3 then current_date end,
        amount_paid = amount_paid + p_money_paid,
        update_date = localtimestamp(0),
        update_user = p_id_user
    where
        id = p_id_credit_installment;

    return found;

end;
$function$
