create or replace function usr_get_last_user_logout_date(
    p_user_id bigint
)
returns timestamp without time zone
language 'plpgsql'
as $function$
declare

    v_timestamp timestamp without time zone;

begin

    select coalesce(logout_timestamp, login_timestamp)
    into v_timestamp
    from usr_user_session_log
    where id_user = p_user_id
    order by id desc limit 1;

    return v_timestamp;

end;
$function$