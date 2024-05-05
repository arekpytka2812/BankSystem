create table d_acc_account_type(
    id bigserial primary key,
    description text not null ,
    requires_parent boolean not null,
    insert_date timestamp without time zone default localtimestamp(0),
    update_date timestamp without time zone,
    insert_user bigint,
    update_user bigint,
    business_id bigint default nextval('sys_business_id_sequence')
);

create or replace trigger hist
after insert or update or delete on d_acc_account_type
for each row execute function hist_trigger_function();