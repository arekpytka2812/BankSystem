create or replace function acc_add_balance_to_queue(
    p_id_account bigint,
    p_balance numeric(15,4),
    p_user_id bigint
)
returns void
language 'plpgsql'
as $function$
begin

    insert into acc_balance_queue(
        id_account,
        balance_change,
        insert_user
    )
    values(
        p_id_account,
        p_balance,
        p_user_id
    );

end;
$function$;