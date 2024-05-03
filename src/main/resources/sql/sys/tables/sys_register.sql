create table sys_register (
    id bigserial primary key,
    key text not null unique,
    value text not null,
    insert_date timestamp with time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp with time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on sys_register
for each row execute function hist_trigger_function();