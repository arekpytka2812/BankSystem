create or replace function acc_check_if_account_to_user_exists(
    p_id_account bigint,
    p_id_user bigint
)
returns boolean
language 'plpgsql'
as $function$
begin

    perform 1
    from acc_account
    where id = p_id_account
        and user_id = p_id_user;

    return FOUND;
end;
$function$