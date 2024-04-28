create table d_acc_currency(
    id bigserial primary key, --dollar must have id = 0
    description text not null,
    rate_usd numeric (5,4),
    amount int, --amount times rate equals 1 dollar
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on d_acc_currency
for each row execute function hist_trigger_function();