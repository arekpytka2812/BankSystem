create table acc_currency_rate(
    id bigserial,
    id_currency_from bigint not null references d_acc_currency(id),
    id_currency_to bigint not null references d_acc_currency(id),
    conversion_rate numeric(15,4) not null,
    rate_date date not null default current_date,
    insert_date timestamp without time zone default localtimestamp(0),
    insert_user bigint,
    update_date timestamp without time zone,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
)