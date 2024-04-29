create or replace function usr_add_user_notification(
    p_id_user bigint,
    p_info text,
    p_id_user_insert bigint
)
returns void
language 'plpgsql'
as $function$
begin

    insert into usr_user_notification_queue(
        id_user,
        info,
        insert_user
    )
    values(
        p_id_user,
        p_info,
        p_id_user_insert
    );

end;
$function$;