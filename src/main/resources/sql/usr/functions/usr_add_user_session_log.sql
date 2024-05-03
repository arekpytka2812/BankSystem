create or replace function usr_add_user_session_log(
    p_user_id bigint
)
returns bigint
language 'plpgsql'
as $function$
declare

    v_session_id bigint;

begin

    insert into usr_user_session_log(
        id_user,
        insert_user
    )
    values(
        p_user_id,
        p_user_id
    )
    returning id
    into v_session_id;

    return v_session_id;

end;
$function$
