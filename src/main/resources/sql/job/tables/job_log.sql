create table job_log (
    id bigserial primary key,
    job_service_name text not null,
    info text,
    error boolean not null,
    insert_date timestamp with time zone default localtimestamp(0),
    business_id bigint default nextval('sys_business_id_sequence')
);