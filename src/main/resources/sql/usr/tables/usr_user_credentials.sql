create table usr_user_credentials(
    id bigint primary key references usr_user(id),
    login text unique not null,
    password text not null,
    user_key text not null,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);