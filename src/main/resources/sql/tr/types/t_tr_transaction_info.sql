create type t_tr_transaction_info as(
      transaction_title text,
      account_number_from text,
      account_number_to text,
      transaction_type text,
      transaction_status text,
      money_sent numeric(15,4),
      currency text,
      transaction_order_date date,
      transaction_process_date date
);