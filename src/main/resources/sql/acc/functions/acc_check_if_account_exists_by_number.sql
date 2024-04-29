create or replace function acc_check_if_account_exists_by_number(
    p_account_number text
)
returns boolean
language 'plpgsql'
as $function$
begin

    perform 1
    from acc_account
    where account_number = trim(p_account_number);

    return FOUND;
end;
$function$