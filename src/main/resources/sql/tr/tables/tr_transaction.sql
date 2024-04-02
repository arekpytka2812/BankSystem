create table tr_transaction(
    id bigserial primary key,
    id_ordering_user bigint not null references usr_user(id),
    id_account_from bigint not null references acc_account(id),
    id_account_to bigint not null references acc_account(id),
    id_transaction_type bigint not null references d_tr_transaction_type(id),
    id_transaction_status bigint not null references d_tr_transaction_status(id) default 1,
    money_sent numeric(15, 4) not null,
    transaction_order_date date not null,
    transaction_booking_date date,
    transaction_title text,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);