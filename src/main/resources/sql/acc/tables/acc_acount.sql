create table acc_account(
    id bigserial primary key,
    user_id bigint not null references usr_user(id),
    id_account_type bigint not null references d_acc_account_type(id),
    account_number text not null unique,
    account_name text not null,
    account_open_date date not null,
    account_close_date date,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

