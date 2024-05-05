create or replace function acc_check_if_account_can_be_destination_account(
    p_id_account bigint
)
returns boolean
language 'plpgsql'
as $function$

begin

    perform  1
    from acc_account
    where id = p_id_account
        and id_account_type in (1,3,4);

    return found;

end;
$function$;
