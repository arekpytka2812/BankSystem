create or replace view v_active_credits
    as select cred.id credit_account_id,
              cred.percent,
              cred.base_installment,
              cred.no_installment number_of_installments,
              cred.full_amount,
              usr.login user_login,
              acc.account_number,
              acc.account_name credit_name,
              acc.account_open_date credit_open_date,
              acc.balance account_balance,
              curr.description currency
              from acc_credit cred
    left join acc_account acc on cred.id = acc.id
    left join usr_user usr on acc.user_id = usr.id
    left join d_acc_account_type acc_type on acc.id_account_type = acc_type.id
    left join d_acc_currency curr on acc.currency_id = curr.id
    where account_close_date is null;