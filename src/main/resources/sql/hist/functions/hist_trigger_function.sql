create or replace function hist_trigger_function()
returns trigger
language 'plpgsql'
as $function$
declare

    v_operation_info text := '';
    v_operation_user bigint;

    v_row record;

    v_old_val text;
    v_new_val text;

begin

    if tg_op = 'INSERT' then
        v_operation_user := new.insert_user;
    elsif tg_op = 'UPDATE' or tg_op = 'DELETE' then
        v_operation_user := new.update_user;
    end if;

    for v_row in
    select column_name
    from information_schema.columns
    where table_name = tg_table_name

    loop

        if v_row.column_name in ('business_id', 'insert_date', 'update_date', 'id')  then
            continue;
        end if;

        execute format('SELECT (($1).%I)::text', v_row.column_name) into v_old_val using old;
        execute format('SELECT (($1).%I)::text', v_row.column_name) into v_new_val using new;

        if (tg_op = 'INSERT' or tg_op = 'DELETE') and nullif(v_new_val, '') is not null then
            v_operation_info := v_operation_info || v_row.column_name || ' = ' || coalesce(v_new_val, 'NULL') || ', ' ;
        end if;

        if tg_op = 'UPDATE' and v_old_val is distinct from v_new_val then
            v_operation_info := v_operation_info || v_row.column_name || ': ' || coalesce(v_old_val, 'NULL') || ' -> ' || coalesce(v_new_val, 'NULL') || ', ';
        end if;

    end loop;

    perform hist_add_common_history_log(
        tg_op,
        tg_table_name,
        new.id,
        v_operation_info,
        v_operation_user
    );

    return NEW;

end
$function$;