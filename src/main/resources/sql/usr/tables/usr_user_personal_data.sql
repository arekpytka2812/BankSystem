create table usr_user_personal_data(
    id bigint primary key references usr_user(id),
    email text,
    name text,
    surname text,
    date_of_birth date,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on usr_user_personal_data
for each row execute function hist_trigger_function();