create table cr_user(
    id bigserial primary key,
    insert_date timestamp with time zone default localtimestamp(0),
    update_date timestamp with time zone,
    insert_user bigint,
    update_user bigint,
    login text,
    password text
);