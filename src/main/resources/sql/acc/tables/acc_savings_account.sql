create table acc_savings_account(
    id bigint primary key references acc_account(id),
    percent numeric(5,4),
    starting_amount numeric(15,4)
);

create or replace trigger hist
after insert or update or delete on acc_savings_account
for each row execute function hist_trigger_function();