create or replace function job_process_cyclical_transactions_service(
    p_user_id bigint
)
returns void
language 'plpgsql'
as $function$
declare

    v_row record;

    v_transactions_to_process_count bigint := 0;
    v_transactions_processed bigint := 0;

    v_tries_count bigint := 0;

    v_subtraction_successful boolean := false;
    v_addition_successful boolean := false;

begin

    select count(*)
    into v_transactions_to_process_count
    from tr_cyclical_transaction
    where next_transaction_date = current_date;

    perform job_add_log(
        'job_process_cyclical_transactions_service',
        'Starting processing ' || v_transactions_to_process_count || ' transactions',
        false
    );

    for v_row in
    select
        tr.id,
        tr.id_account_from,
        acc.account_name,
        tr.id_account_to,
        tr.money_to_sent,
        tr.transaction_title,
        tr.interval_between_transactions,
        acc.user_id,
        coalesce(tr.update_date, tr.insert_date) as order_date
    from tr_cyclical_transaction tr
    left join acc_account acc on tr.id_account_from = acc.id
    where next_transaction_date = current_date

    loop

        v_tries_count := 0;

        if not acc_check_if_account_is_transactional(v_row.id_account_from) then

            perform usr_add_user_notification(
                v_row.user_id,
                'Your scheduled transaction: ' || coalesce(v_row.transaction_title, '') || ' was not processed because of using non-transactional account: ' || v_row.account_name,
                p_user_id
            );

            continue;

        end if;

        if not acc_check_if_account_has_enough_balance(v_row.id_account_from, v_row.money_to_sent) then

            perform usr_add_user_notification(
                v_row.user_id,
                'Your scheduled transaction: ' || coalesce(v_row.transaction_title, '') || ' was not processed because of insufficient balance on account: ' || v_row.account_name,
                p_user_id
            );

            continue;
        end if;

        perform acc_subtract_money_from_account(v_row.id_account_from, v_row.money_to_sent, p_user_id);
        perform acc_add_money_to_account(v_row.id_account_to, v_row.money_to_sent, p_user_id);

        insert into tr_transaction(
            id_ordering_user,
            id_account_from,
            id_account_to,
            id_transaction_type,
            id_transaction_status,
            money_sent,
            transaction_order_date,
            transaction_process_date,
            insert_user,
            transaction_title
        )
        values (
            v_row.user_id,
            v_row.id_account_from,
            v_row.id_account_to,
            4,
            3,
            v_row.money_to_sent,
            v_row.order_date,
            current_date,
            v_row.user_id,
            v_row.transaction_title
        );

        update tr_cyclical_transaction
        set next_transaction_date = tr_get_next_cyclical_transaction_date(v_row.interval_between_transactions),
            update_date = localtimestamp(0),
            update_user = p_user_id
        where id = v_row.id;

        v_transactions_processed := v_transactions_processed + 1;

    end loop;

    perform job_add_log(
        'job_process_cyclical_transactions_service',
        'Processed ' || v_transactions_to_process_count || ' cyclical transactions',
        false
    );

end;
    $function$