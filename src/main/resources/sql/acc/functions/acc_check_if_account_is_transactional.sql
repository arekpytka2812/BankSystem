create or replace function acc_check_if_account_is_transactional(
    p_id_account bigint
)
    returns boolean
    language 'plpgsql'
as $function$
begin

    -- WIP fill account type to transationals
    -- ewentualnie dolozyc pole do d_acc_account_type

    perform 1
    from acc_account
    where id = p_id_account
      and id_account_type in (1);

    return FOUND;
end;
$function$