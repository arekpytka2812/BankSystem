create or replace function acc_check_if_account_requires_parent(
    p_id_account_type bigint
)
returns boolean
language 'plpgsql'
as $function$
declare

    v_requires bigint;

begin

    select requires_parent
    into v_requires
    from d_acc_account_type
    where id = p_id_account_type;

    return v_requires;
end;
$function$