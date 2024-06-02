create or replace function acc_add_credit_account(
    p_user_id bigint,
    p_id_parent_account bigint,
    p_account_name text,
    p_account_open_date date,
    p_account_close_date date,
    p_currency_id bigint,
    p_percent numeric(5,4),
    p_base_installment numeric(15,4),
    p_no_installment integer,
    p_full_amount numeric(15,4)
)
    returns bigint
    language 'plpgsql'
as $function$
declare

    v_id bigint;
    v_account_type constant bigint := 4; --first insert types into dict table

begin

    perform 1 from acc_account
                where id_account_type = 4
                and account_close_date is null
                and user_id = p_user_id;
    if found then
        raise exception 'User cannot have more than one active credit!';
    end if;

    v_id := acc_add_account(
        p_user_id,
        v_account_type,
        p_id_parent_account,
        p_account_name,
        p_account_open_date,
        p_account_close_date,
        p_currency_id
    );

    INSERT INTO acc_credit(id, percent, base_installment, no_installment, full_amount, insert_user)
    VALUES (v_id, p_percent, p_base_installment, p_no_installment, p_full_amount, p_user_id);

    perform acc_add_credit_installment(v_id, p_base_installment, p_user_id);

    return v_id;

end;
$function$;