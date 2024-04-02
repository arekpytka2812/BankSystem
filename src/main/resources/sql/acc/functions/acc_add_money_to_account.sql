create or replace function acc_add_money_to_account(
    p_id_account_to bigint,
    p_money numeric(15,4),
    p_id_user bigint
)
returns boolean
language 'plpgsql'
as $function$
begin

    update acc_account
    set balance = balance + p_money,
        update_user = p_id_user,
        update_date = localtimestamp(0)
    where id = p_id_account_to;

end;
$function$