create or replace function job_backup_service()
returns bigint
language 'plpgsql'
as $function$
declare

    v_backup_file_path text;
    v_file_name text;

    v_command text;
begin

    v_backup_file_path := sys_get_register_value('JOB_BACKUP_FILE_PATH');
    v_file_name := 'db_backup_' || current_date::text || '.dump';

    select job_add_log('job_backup_service', 'Starting backup', false);

    v_command := 'pg_dump -U job_backup_service -Fc -f' || quote_literal(v_backup_file_path || v_file_name);

    select job_add_log('job_backup_service', 'Backup successful', false);

    return 0;

end;
$function$;