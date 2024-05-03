create or replace function usr_update_user_session_log(
    p_id bigint,
    p_user_id bigint
)
returns void
language 'plpgsql'
as $function$
begin

    update usr_user_session_log
    set
        logout_timestamp = localtimestamp(0),
        update_date = localtimestamp(0),
        update_user = p_user_id
    where id = p_id;

end;
$function$
