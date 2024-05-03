create table usr_user(
    id bigserial primary key,
    login text unique not null,
    password text not null,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on usr_user
for each row execute function hist_trigger_function();
