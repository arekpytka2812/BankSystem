create or replace function hist_trigger_function()
returns trigger
language 'plpgsql'
as $function$
declare

    v_hist_operation text;
    v_table_name text;
    v_operation_info text;
    v_operation_user bigint;

begin

    -- WIP

    select hist_add_common_history_log(
        v_hist_operation,
        v_table_name,
        v_operation_info,
        v_operation_user
    );

    return NEW;

end;
$function$;