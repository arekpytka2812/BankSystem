create or replace function usr_add_user(
    p_login text,
    p_password text
)
returns bigint
language 'plpgsql'
as $function$
declare

    v_user_id bigint;

begin

    if nullif(p_login, '') is null then
        raise exception 'Login is empty!';
    end if;

    if nullif(p_password, '') is null then
        raise exception 'Password is empty!';
    end if;

    if usr_check_if_login_exists(p_login) then
        raise exception 'User with such login already exists!';
    end if;

    if not usr_check_password_requirements(p_password) then
        raise exception 'Password is too weak!';
    end if;

    insert into usr_user(
        login,
        password
    )
    values (
        p_login,
        digest(p_password, 'sha256')
    )
    returning id
    into v_user_id;

    perform acc_add_account(
    v_user_id,
    1,
    null,
    'Main account',
    current_date,
    null,
    1
    );

    return v_user_id;

end;
$function$