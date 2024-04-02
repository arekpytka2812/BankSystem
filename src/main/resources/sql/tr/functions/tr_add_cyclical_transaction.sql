create or replace function tr_add_cyclical_transaction(
    p_id_account_from bigint,
    p_id_account_to bigint,
    p_money_to_send numeric(15,4),
    p_next_transaction_date date,
    p_transaction_title text,
    p_interval_between_transactions interval,
    p_id_user bigint
)
returns void
language 'plpgsql'
as $function$
begin

    if not acc_check_if_account_to_user_exists(p_id_account_from, p_id_user) then
        raise exception 'Chosen source account is not linked to user!';
    end if;

    if not acc_check_if_account_is_transactional(p_id_account_from) then
        raise exception 'Chosen account is non-transactional!';
    end if;

    if not acc_check_if_account_exists(p_id_account_to) then
        raise exception 'Chosen destination account does not exist!';
    end if;

    insert into tr_cyclical_transaction(
        id_account_from,
        id_account_to,
        money_to_sent,
        next_transaction_date,
        transaction_title,
        interval_between_transactions,
        insert_user
    )
    values(
        p_id_account_from,
        p_id_account_to,
        p_money_to_send,
        sys_get_next_work_day(p_next_transaction_date),
        p_transaction_title,
        coalesce(p_interval_between_transactions, default),
        p_id_user
    );

end;
$function$