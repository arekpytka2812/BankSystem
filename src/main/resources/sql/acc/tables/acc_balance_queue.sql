create table acc_balance_queue(
    id bigserial primary key,
    id_account bigint not null references acc_account(id),
    balance_change numeric(15,4) not null,
    active boolean default true,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);