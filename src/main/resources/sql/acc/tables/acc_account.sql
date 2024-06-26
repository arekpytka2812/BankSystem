create table acc_account(
    id bigserial primary key,
    user_id bigint not null references usr_user(id),
    id_account_type bigint not null references d_acc_account_type(id),
    id_parent_account bigint references acc_account(id),
    account_number text not null unique,
    account_name text not null, --needed?
    account_open_date date not null,
    account_close_date date,
    balance numeric(15,4) not null default 0.00,
    currency_id bigint not null references d_acc_currency(id),
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on acc_account
for each row execute function hist_trigger_function();