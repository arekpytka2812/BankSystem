create or replace function acc_delete_balance_from_queue(
    p_id_balance bigint
)
returns void
language 'plpgsql'
as $function$
begin

    delete from acc_balance_queue
    where id = p_id_balance;

end;
$function$;