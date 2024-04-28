create or replace function usr_check_password_requirements(
    p_password text
)
returns boolean
language 'plpgsql'
as $function$
declare
begin

    return true;

end;
$function$