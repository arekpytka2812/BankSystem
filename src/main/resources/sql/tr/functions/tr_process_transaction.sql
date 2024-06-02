create or replace function tr_process_transaction(
    p_id_transaction bigint,
    p_id_balance_queue bigint,
    p_id_user bigint
)
returns void
language 'plpgsql'
as $function$
declare

    v_row record;
    v_transaction_cost numeric(15,4) := sys_get_register_value('IMMEDIATE_TRANSACTION_COST')::numeric(15,4);

begin

    select *
    into v_row
    from tr_transaction
    where id = p_id_transaction;


    if v_row.id_transaction_type <> 2 then
        v_transaction_cost = 0;
    end if;

    perform acc_subtract_money_from_account(v_row.id_account_from, v_row.money_sent + v_transaction_cost, p_id_user);
    perform acc_add_money_to_account(v_row.id_account_to, v_row.money_sent, p_id_user);

    perform tr_update_transaction(
        p_id_transaction,
        3,
        current_date,
        2
    );

    perform tr_delete_transaction_order_if_exists(p_id_transaction);
    perform acc_delete_balance_from_queue(p_id_balance_queue);

    perform usr_add_user_notification(
        v_row.id_ordering_user,
        'Successfully processed your transaction: ' || p_id_transaction::text || ' at ' || current_date::text,
        2
    );

    perform tr_add_transaction_process_log(
        p_id_transaction,
        'Successfully processed transaction: ' || p_id_transaction::text,
        false,
        p_id_user
    );

end;
$function$