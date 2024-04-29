create or replace function acc_check_if_account_exists_by_id(
    p_id_account bigint
)
    returns boolean
    language 'plpgsql'
as $function$
begin

    perform 1
    from acc_account
    where id = p_id_account;

    return FOUND;
end;
$function$