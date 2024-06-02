create table acc_credit_installment(
    id bigserial primary key,
    id_credit bigint not null references acc_credit(id),
    amount_to_pay numeric(15,4),
    id_status bigint not null references d_acc_installment_status(id),
    amount_paid numeric(15,4),
    payment_date date,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')

);

create or replace trigger hist
after insert or update or delete on acc_credit_installment
for each row execute function hist_trigger_function();