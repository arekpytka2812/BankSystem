create or replace function acc_add_savings_account(
    p_user_id bigint,
    p_id_parent_account bigint,
    p_account_name text,
    p_account_open_date date,
    p_account_close_date date,
    p_currency_id bigint,
    p_percent numeric(5,4),
    p_starting_amount numeric(15,4)
)
    returns bigint
    language 'plpgsql'
as $function$
declare

    v_id bigint;
    v_account_type constant bigint := 3; --first insert types into dict table

begin

    v_id := acc_add_account(
        p_user_id,
        v_account_type,
        p_id_parent_account,
        p_account_name,
        p_account_open_date,
        p_account_close_date,
        p_currency_id
    );

    INSERT INTO acc_savings_account(id, percent, starting_amount, insert_user)
    VALUES(v_id, p_percent, p_starting_amount, p_user_id);

    return v_id;

end;
$function$;