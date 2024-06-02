create or replace view v_daily_transactions
    as select tr.id transaction_id,
              usr.login user_login,
              acc_from.account_number account_from,
              acc_to.account_number account_to,
              tr_type.description transaction_type,
              tr_status.description transaction_status,
              tr.money_sent,
              curr.description currency_name,
              tr.transaction_order_date order_date,
              tr.transaction_process_date process_date,
              tr.transaction_title title
              from tr_transaction tr
    left join usr_user usr on tr.id_ordering_user = usr.id
    left join acc_account acc_from on tr.id_account_from = acc_from.id
    left join acc_account acc_to on tr.id_account_to = acc_to.id
    left join d_tr_transaction_type tr_type on tr.id_transaction_type = tr_type.id
    left join d_tr_transaction_status tr_status on tr.id_transaction_status = tr_status.id
    left join d_acc_currency curr on acc_from.currency_id = curr.id
    where tr.insert_date::date = current_date;