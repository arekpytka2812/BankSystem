create or replace function usr_login_user(
    p_login text,
    p_password text
)
returns t_usr_login_response
language 'plpgsql'
as $function$
declare

    v_login_response t_usr_login_response;
    v_user_id bigint;

begin

    select id
    into v_user_id
    from usr_user
    where login = p_login
        and password = digest(p_password, 'sha256')::text;

    if v_user_id is null then
        raise exception 'Bad credentials!';
    end if;

    v_login_response.user_id := v_user_id;
    v_login_response.session_id := usr_add_user_session_log(v_user_id);

    return v_login_response;

end;
$function$