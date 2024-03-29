create or replace function hist_add_common_history_log(
    p_hist_operation text,
    p_table_name text,
    p_operation_info text,
    p_insert_user bigint
)
returns void
language 'plpgsql'
as $function$
begin

    insert into hist_common_history_log(
        hist_operation,
        table_name,
        operation_info,
        insert_user
    )
    values (
        p_hist_operation,
        p_table_name,
        p_operation_info,
        p_insert_user
    );

end;
$function$;