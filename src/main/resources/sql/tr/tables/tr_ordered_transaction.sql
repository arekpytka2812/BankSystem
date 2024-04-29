create table tr_ordered_transaction(
    id bigserial primary key,
    id_transaction bigint unique not null references tr_transaction(id),
    id_balance_queue bigint unique references acc_balance_queue(id),
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on tr_ordered_transaction
for each row execute function hist_trigger_function();