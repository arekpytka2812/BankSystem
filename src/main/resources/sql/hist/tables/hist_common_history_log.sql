create table hist_common_history_log(
    id bigserial primary key,
    hist_operation text not null,
    table_name text not null,
    entity_id bigint,
    operation_info text,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint
);