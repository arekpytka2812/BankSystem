create table tr_transaction_process_log(
    id bigserial primary key,
    id_transaction bigint not null references tr_transaction(id),
    info text,
    error boolean,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);