create or replace function tr_add_transaction_process_log(
    p_id_transaction bigint,
    p_info text,
    p_error boolean,
    p_id_user bigint
)
returns void
language 'plpgsql'
as $function$
begin

    insert into tr_transaction_process_log(
        id_transaction,
        info,
        error,
        insert_user
    )
    values(
        p_id_transaction,
        p_info,
        p_error,
        p_id_user
    );

end;
$function$