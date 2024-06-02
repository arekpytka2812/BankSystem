create or replace function acc_close_account(
    p_id_account bigint,
    p_id_user bigint
)
returns boolean
language 'plpgsql'
as $function$
begin

    update acc_account
    set account_close_date = current_date,
        update_user = p_id_user,
        update_date = localtimestamp(0)
    where id = p_id_account;

end;
$function$;
