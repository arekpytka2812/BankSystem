insert into d_acc_account_type(description, requires_parent, insert_user)
values ('Basic account', false, 1),
       ('Deposit account', true, 1),
       ('Savings account', false, 1),
       ('Credit account', false, 1);