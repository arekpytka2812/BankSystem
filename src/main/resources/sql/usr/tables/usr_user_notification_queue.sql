create table usr_user_notification_queue(
    id bigserial primary key,
    id_user bigint not null references usr_user(id),
    info text,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on usr_user_notification_queue
for each row execute function hist_trigger_function();