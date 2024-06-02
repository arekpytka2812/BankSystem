create or replace function job_calculate_interest(
    p_user_id bigint
)
returns void
language 'plpgsql'
as $function$
declare

    v_processing_account_count bigint := 0;
    v_res bigint := 0;

    v_row record;

begin

    select count(a.*)
    into v_processing_account_count
    from acc_account a
    join acc_deposit d on a.id = d.id
    where d.finish_date <= current_date
      and a.account_close_date is null;

    perform job_add_log(
        'job_interest_calculation_service',
        'Start processing ' || v_processing_account_count || ' deposit accounts interests',
        false
    );

    for v_row in
        select a.balance, d.finish_date, a.id, d.percent
        from acc_account a
        join acc_deposit d on a.id = d.id
        where d.finish_date <= current_date
            and a.account_close_date is null
    loop

        update acc_account
        set balance = balance * pow((1 + (v_row.percent/100)), 1/(v_row.finish_date - insert_date::date)),
            update_date = localtimestamp(0),
            update_user = p_user_id
        where id = v_row.id;

        if FOUND then
            v_res := v_res + 1;
        end if;

    end loop;

    perform job_add_log(
        'job_interest_calculation_service',
        'Processed ' || v_res || ' deposit accounts interests',
        false
    );

    select count(a.*)
    into v_processing_account_count
    from acc_account a
    join acc_savings_account s on a.id = s.id
      and a.account_close_date is null;

    perform job_add_log(
        'job_interest_calculation_service',
        'Start processing ' || v_processing_account_count || ' savings accounts interests',
        false
    );

    for v_row in
        select a.balance, a.id, s.percent
        from acc_account a
        join acc_savings_account s on a.id = s.id
          and a.account_close_date is null
    loop

        update acc_account
        set balance = balance * (pow((1 + (v_row.percent/100)), 1/365)),
            update_date = localtimestamp(0),
            update_user = p_user_id
        where id = v_row.id;

        if FOUND then
            v_res := v_res + 1;
        end if;

    end loop;

    perform job_add_log(
        'job_interest_calculation_service',
        'Processed ' || v_res || ' savings accounts interests',
        false
    );

end;
$function$;
