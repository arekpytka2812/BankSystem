create or replace function tr_add_transaction(
    p_id_user bigint,
    p_id_account_from bigint,
    p_id_account_to bigint,
    p_id_transaction_type bigint,
    p_money_sent numeric(15,4),
    p_transaction_order_date date,
    p_currency bigint
)
returns void
language 'plpgsql'
as $function$
declare

    v_transaction_order_date date;
    v_id_transaction bigint;

begin

    if p_transaction_order_date < current_date then
        raise exception 'Chosen transaction date is in the past!';
    end if;

    -- sprawdzenie czy podany user jest wlascielem konta
    if not acc_check_if_account_to_user_exists(p_id_account_from, p_id_user) then
        raise exception 'Account - user mismatch!';
    end if;

    -- sprawdzenie czy mozna robic przelewy z konta
    -- np z lokat nie mozna przerzucac
    if not acc_check_if_account_is_transactional(p_id_account_from) then
        raise exception 'Chosen account is non - transactional!';
    end if;

    if not acc_check_if_account_exists(p_id_account_to) then
        raise exception 'Destination account does not exist!';
    end if;

    if not acc_check_if_account_has_enough_balance(p_id_account_from, p_money_sent) then
        raise exception 'This account has not enough balance!';
    end if;

    if p_id_transaction_type = 1 then
        v_transaction_order_date := sys_get_next_work_day(p_transaction_order_date);

        -- jezeli jest teraz piatek po ostatniej porze ksiegowania
        -- ustaw poniedzialemk
    end if;

    insert into tr_transaction(
        id_ordering_user,
        id_account_from,
        id_account_to,
        id_transaction_type,
        money_sent,
        transaction_order_date,
        insert_user,
        currency
    )
    values (
        p_id_user,
        p_id_account_from,
        p_id_account_to,
        p_id_transaction_type,
        p_money_sent,
        coalesce(v_transaction_order_date, p_transaction_order_date),
        p_id_user,
        p_currency
    )
    returning id
    into v_id_transaction;

    if p_id_transaction_type = 1 then  -- for now standard = 1,  immediate type = 2
        perform tr_add_transaction_order(v_id_transaction);
    elsif p_id_transaction_type = 2 then
        perform tr_process_transaction(v_id_transaction);
    end if;

end;
$function$
