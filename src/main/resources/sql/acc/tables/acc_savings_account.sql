create table acc_savings_account(
    id bigint primary key references acc_account(id),
    percent numeric(5,4),
    starting_amount numeric(15,4)
);