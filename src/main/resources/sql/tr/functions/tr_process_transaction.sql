create or replace function tr_process_transaction(
    p_id_transaction bigint,
    p_id_user bigint
)
returns void
language 'plpgsql'
as $function$
declare

    v_row record;

begin

    select *
    into v_row
    from tr_transaction
    where id = p_id_transaction;

    perform acc_subtract_money_from_account(v_row.id_account_from, v_row.money_sent, p_id_user);
    perform acc_add_money_to_account(v_row.id_account_to, v_row.money_sent);

    perform tr_update_transaction(

    );

    perform tr_delete_transaction_order_if_exists(p_id_transaction);

end;
$function$