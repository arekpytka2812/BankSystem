create or replace function sys_get_register_value(
    p_key text
)
returns text
language 'plpgsql'
as $function$
declare

    v_value text := null;

begin

    select r.value
    into v_value
    from sys_register r
    where r.key = p_key;

    return v_value;
end;
$function$;
