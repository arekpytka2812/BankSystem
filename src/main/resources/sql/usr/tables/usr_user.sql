create table usr_user(
    id bigserial primary key,
    email text,
    name text,
    surname text,
    date_of_birth date,
    active boolean default true,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

