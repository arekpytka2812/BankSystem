create table tr_cyclical_transaction(
    id bigserial primary key,
    id_account_from bigint not null references acc_account(id),
    id_account_to bigint not null references acc_account(id),
    money_to_sent numeric(15,4) not null,
    next_transaction_date date not null,
    transaction_title text,
    interval_between_transactions interval default '1 month'::interval,
    currency bigint not null references d_acc_currency(id) default 0,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on tr_cyclical_transaction
for each row execute function hist_trigger_function();