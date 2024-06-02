--nie mozna zalozyc lokaty bez konta nadrzednego
select * from acc_add_deposit_account(1, null, 'lokata_2', current_date, current_date + '3 months'::interval, 2, 3.0000, current_date + '3 months'::interval, 10000);



--nie można dwóch kredytów na jednego usera