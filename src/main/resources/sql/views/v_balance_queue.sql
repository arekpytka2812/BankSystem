create or replace view v_balance_queue
    as select bal.id balance_queue_id,
              acc.account_number,
              bal.balance_change
              from acc_balance_queue bal
    left join acc_account acc on bal.id_account = acc.id
    where bal.active = true;