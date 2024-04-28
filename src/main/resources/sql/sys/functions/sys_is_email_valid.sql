create or replace function sys_is_email_valid(
    p_email text
)
returns boolean
language 'plpgsql'
as $function$
begin

    return p_email ~ '[a-zA-Z]+@[a-zA-Z]+\.[a-zA-Z]+';

end;
$function$;
