create table account(
    id bigserial primary key,
    insert_date timestamp with time zone default localtimestamp(0),
    update_date timestamp with time zone,
    insert_user bigint,
    update_user bigint,
    user_id bigint references cr_user(id),
    money numeric(15,2)
);