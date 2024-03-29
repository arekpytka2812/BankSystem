create or replace function usr_check_if_login_exists(
    p_login text
)
returns boolean
language 'plpgsql'
as $function$
begin

    perform 1
    from usr_user_credentials
    where login = p_login;

    return FOUND;
end;
$function$