create or replace function tr_add_transaction_order(
    p_id_transaction bigint,
    p_id_balance_queue bigint,
    p_id_user bigint
)
returns void
language 'plpgsql'
as $function$
begin

    insert into tr_ordered_transaction(
        id_transaction,
        id_balance_queue,
        insert_user
    )
    values(
        p_id_transaction,
        p_id_balance_queue,
        p_id_user
    );

end;
$function$;