create table tr_transaction(
    id bigserial primary key,
    id_ordering_user bigint not null references usr_user(id),
    id_account_from bigint not null references acc_account(id),
    id_account_to bigint not null references acc_account(id),
    id_transaction_type bigint not null references d_tr_transaction_type(id),
    id_transaction_status bigint not null references d_tr_transaction_status(id) default 1,
    money_sent numeric(15, 4) not null, --discuss max number
    currency bigint not null references d_acc_currency(id) default 0,
    transaction_order_date date not null,
    transaction_process_date date,
    transaction_title text,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on tr_transaction
for each row execute function hist_trigger_function();

create index idx_tr_transaction_order_date on tr_transaction using btree(transaction_order_date);
create index idx_tr_transaction_process_date on tr_transaction using btree(transaction_process_date);