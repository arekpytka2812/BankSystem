create or replace function job_process_balance_queue_service(
    p_id_user bigint
)
returns void
language 'plpgsql'
as $function$
declare

    v_accounts_to_process_count bigint;
    v_success boolean := false;

    v_successful_balances bigint := 0;

    v_row record;

begin

    select count(distinct id_account)
    from acc_balance_queue
    where active;

    perform job_add_log(
        'job_process_balance_queue_service',
        'Starting processing ' || v_accounts_to_process_count || ' accounts'' balances.',
        false
    );

    for v_row in
    select
        id_account,
        sum(balance_change) as balance
    from acc_balance_queue
    where active
    group by id_account

    loop

        v_success := acc_add_money_to_account(v_row.id_account, v_row.balance, p_id_user);

        if v_success = false then

            perform job_add_log(
                'job_process_balance_queue_service',
                'Could not balance account of ID: ' || v_row.id_account || ' at date: ' || current_date,
                true
            );

            continue;

        end if;

        v_successful_balances := v_successful_balances + 1;

    end loop;

    perform job_add_log(
        'job_process_balance_queue_service',
        'Finished balancing accounts with: ' || v_successful_balances || ' out of ' || v_accounts_to_process_count || ' at start.',
        false
    );

end
$function$;