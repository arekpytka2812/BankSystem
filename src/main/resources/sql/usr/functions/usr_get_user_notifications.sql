create or replace function usr_get_user_notifications(
    p_id_user bigint
)
returns setof t_usr_notification
language 'plpgsql'
as $function$
declare

    v_last_user_logout timestamp without time zone;
    v_row record;
    v_notification t_usr_notification;

begin

    v_last_user_logout := usr_get_last_user_logout_date(p_id_user);

    for v_row in
        select info, insert_date > v_last_user_logout as is_new
        from usr_user_notification_queue
        where id_user = p_id_user
        order by id desc
    loop

        v_notification.message := v_row.info;
        v_notification.is_new := v_row.is_new;

        return next v_notification;

    end loop;

end;
$function$