create or replace function acc_get_account_id_account_by_number(
    p_account_number text
)
returns bigint
language 'plpgsql'
as $function$
declare

    v_id_account bigint;

begin

    select id
    into v_id_account
    from acc_account
    where account_number = trim(p_account_number);

    return v_id_account;
end;
$function$