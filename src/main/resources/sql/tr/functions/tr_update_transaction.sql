create or replace function tr_update_transaction(
    p_id bigint,
    p_id_transaction_status bigint,
    p_transaction_process_date date,
    p_user_id bigint
)
returns void
language 'plpgsql'
as $function$
begin

    update tr_transaction
    set
        id_transaction_status = p_id_transaction_status,
        transaction_process_date = p_transaction_process_date,
        update_date = localtimestamp(0),
        update_user = p_user_id
    where id = p_id;

end;
$function$
