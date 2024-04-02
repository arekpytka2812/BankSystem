create or replace function job_process_transactions_service()
returns void
language 'plpgsql'
as $function$
declare

    v_transactions_to_process_count bigint := 0;
    v_row   record;

    v_successful_processes bigint := 0;

begin

    select count(*)
    into v_transactions_to_process_count
    from tr_ordered_transaction;

    perform job_add_log(
        'job_process_transactions_service',
        'Starting processing ' || v_transactions_to_process_count || ' transactions',
        false
    );

    for v_row in
    select id_transaction
    from tr_ordered_transaction

    loop

        perform tr_process_transaction(v_row.id_transaction);

        v_successful_processes := v_successful_processes + 1;

    end loop;

    perform job_add_log(
        'process_transactions_service',
        'Finished processing with ' || v_successful_processes || ', '
            || v_transactions_to_process_count - v_successful_processes || ' transaction was not processed.',
        false
    );

end
$function$;