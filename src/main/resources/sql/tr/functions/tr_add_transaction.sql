create or replace function tr_add_transaction(
    p_id_user bigint,
    p_id_account_from bigint,
    p_account_number_to text,
    p_id_transaction_type bigint,
    p_money_sent numeric(15,4),
    p_transaction_order_date date,
    p_currency bigint,
    p_transaction_title text
)
returns void
language 'plpgsql'
as $function$
declare

    v_id_account_to bigint;

    v_transaction_order_date date;
    v_id_transaction bigint;

    v_id_balance_queue bigint;

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

    if not acc_check_if_account_has_enough_balance(p_id_account_from, p_money_sent) then
        raise exception 'This account has not enough balance!';
    end if;

    v_id_account_to := acc_get_account_id_account_by_number(p_account_number_to);

    if v_id_account_to is null then
        raise exception 'Could not find destination account!';
    end if;

    if not acc_check_if_account_can_be_destination_account(v_id_account_to) then
        raise exception 'You cannot send money to pointed account!';
    end if;

    if p_id_transaction_type = 1 then
        v_transaction_order_date := sys_get_next_work_day(p_transaction_order_date);

        -- ostantnie ksiegowanie jest o 17 w piatek wiec przestawiamy na poniedzialek
        if extract(isodow from current_date) = 5 and extract(hour from localtimestamp(0)) > 17 then
            v_transaction_order_date := sys_get_next_work_day(v_transaction_order_date + 1);
        end if;

    end if;

    v_id_balance_queue := acc_add_balance_to_queue(p_id_account_from, p_money_sent, p_id_user);

    insert into tr_transaction(
        id_ordering_user,
        id_account_from,
        id_account_to,
        id_transaction_type,
        money_sent,
        transaction_order_date,
        insert_user,
        currency,
        transaction_title
    )
    values (
        p_id_user,
        p_id_account_from,
        v_id_account_to,
        p_id_transaction_type,
        p_money_sent,
        coalesce(v_transaction_order_date, p_transaction_order_date),
        p_id_user,
        p_currency,
        p_transaction_title
    )
    returning id
    into v_id_transaction;

    if p_id_transaction_type = 1 then  -- for now standard = 1,  immediate type = 2
        perform tr_add_transaction_order(v_id_transaction, v_id_balance_queue, p_id_user);

    elsif p_id_transaction_type = 2 then
        perform tr_process_transaction(v_id_transaction, v_id_balance_queue, p_id_user);
    end if;

end;
$function$
