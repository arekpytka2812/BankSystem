create or replace function job_add_log(
    p_job_service_name text,
    p_info text,
    p_error boolean
)
returns void
language 'plpgsql'
as $function$
begin

    insert into job_log(
        job_service_name,
        info,
        error
    )
    values (
        p_job_service_name,
        p_info,
        coalesce(p_error, false)
    );

end;
$function$;