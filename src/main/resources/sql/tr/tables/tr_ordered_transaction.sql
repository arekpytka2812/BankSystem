create table tr_ordered_transaction(
    id_transaction bigint not null references tr_transaction(id)
);