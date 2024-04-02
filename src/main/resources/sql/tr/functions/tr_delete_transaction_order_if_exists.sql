create or replace function tr_delete_transaction_order_if_exists(
    p_id_transaction bigint
)
    returns void
    language 'plpgsql'
as $function$
begin

    delete from tr_ordered_transaction
    where id_transaction = p_id_transaction;

end;
$function$;