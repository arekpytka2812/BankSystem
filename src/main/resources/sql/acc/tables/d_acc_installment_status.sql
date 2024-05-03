create table d_acc_installment_status(
    id bigserial primary key,
    description text,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on d_acc_installment_status
for each row execute function hist_trigger_function();