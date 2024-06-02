select * from acc_add_money_to_account(1, 200000, 1);

--nie mozna zalozyc lokaty bez konta nadrzednego
select * from acc_add_deposit_account(1, null, 'lokata_2', current_date, (current_date + '3 months'::interval)::date, 2, 3.0000, (current_date + '3 months'::interval)::date, 10000);

--nie można dwóch kredytów na jednego usera
select * from acc_check_creditworthiness(30, 5, 10000);
select * from acc_add_credit_account(1, null, 'kredyt_1', current_date, null, 2, 5, 2000, 24, acc_calculate_credit_value(2, 5, 2000));
select * from acc_add_credit_account(1, null, 'kredyt_2', current_date, null, 2, 5, acc_calculate_credit_installment(2, 5, 100000), 24, 100000);

--transakcje
select * from tr_add_transaction(1, 1, '43924800030000000000000001', 2, 100, current_date, 2, 'transfer na konto oszczednosicowe');
select * from tr_add_transaction(1, 2, '70924800030000000000000000', 1, 100, current_date, 2, 'transfer z konta oszczednosicowego');

--splata kredytu
select * from acc_pay_credit_installment(1, 2000, 1);
select * from acc_pay_credit_installment(1, 1000, 1);
select * from acc_pay_credit_installment(1, 100, 1);
select * from acc_pay_credit_installment(1, 3500, 1);
select * from acc_pay_credit_installment(1, 39000, 1);
select * from acc_pay_credit_installment(1, 2000, 1);