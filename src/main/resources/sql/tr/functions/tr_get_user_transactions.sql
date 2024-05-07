create or replace function tr_get_user_transactions(
    p_id_user bigint,
    p_date_from date,
    p_date_to date
)
returns setof t_tr_transaction_info
language 'plpgsql'
as $function$
declare

    v_row record;
    v_result t_tr_transaction_info;

begin

    for v_row in
        select
            t.transaction_title,
            afrom.account_number as account_from,
            ato.account_number as account_to,
            type.description as tr_type,
            status.description as tr_status,
            t.money_sent,
            cur.description as currency,
            t.transaction_order_date,
            t.transaction_process_date
        from tr_transaction t
        left join acc_account afrom on t.id_account_from = afrom.id
        left join acc_account ato on t.id_account_to = ato.id
        left join d_tr_transaction_type type on t.id_transaction_type = type.id
        left join d_tr_transaction_status status on t.id_transaction_status = status.id
        left join d_acc_currency cur on t.currency = cur.id
        where t.id_ordering_user = p_id_user
            and t.insert_date::date between coalesce(p_date_from, current_date - 30) and coalesce(p_date_to, current_date)

    loop

        v_result.transaction_title := v_row.transaction_title;
        v_result.account_number_from := v_row.account_from;
        v_result.account_number_to := v_row.account_to;
        v_result.transaction_type := v_row.tr_type;
        v_result.transaction_status := v_row.tr_status;
        v_result.money_sent := v_row.money_sent;
        v_result.currency := v_row.currency;
        v_result.transaction_order_date := v_row.transaction_order_date;
        v_result.transaction_process_date := v_row.transaction_process_date;

        return next v_result;

    end loop;

end;
$function$