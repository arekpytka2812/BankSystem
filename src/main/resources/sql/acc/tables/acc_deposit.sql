create table acc_deposit(
    id bigint primary key references acc_account(id),
    percent numeric(5,4),
    finish_date date not null,
    starting_amount numeric(15,4)
);