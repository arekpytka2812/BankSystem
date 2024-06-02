create or replace function acc_check_if_account_has_enough_balance(
    p_id_account bigint,
    p_money numeric(15,4)
)
    returns boolean
    language 'plpgsql'
as $function$
declare

    v_queue_sum numeric(15,4) := 0.0000;

    v_sum numeric(15,4) := 0.0000;

begin

    select coalesce(sum(balance_change), 0.0000) -- suma aktualnych blokad na koncie
    into v_queue_sum
    from acc_balance_queue
    where id_account = p_id_account
      and active;

    select balance + v_queue_sum - p_money
    into v_sum
    from acc_account
    where id = p_id_account;

    return v_sum >= 0.0000;
end;
$function$


