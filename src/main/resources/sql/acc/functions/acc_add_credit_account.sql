create or replace function acc_add_credit_account(
    p_user_id bigint,
    p_id_account_type bigint,
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
    returns boolean
    language 'plpgsql'
as $function$
declare

    v_id bigint;
    v_account_type constant bigint := 1; --first insert types into dict table

begin

    v_id := acc_add_account(p_user_id, p_id_account_type,
                            p_id_parent_account,
                            p_account_name, p_account_open_date,
                            p_account_close_date, p_currency_id);
    INSERT INTO acc_credit(id, percent, base_installment, no_installment, full_amount) VALUES
                           (v_id, p_percent, p_base_installment, p_no_installment, p_full_amount);

end;
$function$;