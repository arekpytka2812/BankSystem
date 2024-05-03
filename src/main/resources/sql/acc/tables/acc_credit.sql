create table acc_credit(
    id bigint primary key references acc_account(id),
    percent numeric(5,4),
    base_installment numeric(15,4),
    no_installment integer,
    full_amount numeric(15,4)
);

create or replace trigger hist
after insert or update or delete on acc_credit
for each row execute function hist_trigger_function();