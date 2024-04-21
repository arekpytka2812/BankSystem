create or replace function acc_convert_money_between_currencies(
    p_id_currency_from bigint,
    p_id_currency_to bigint,
    p_money_to_convert numeric(15,4)
)
returns numeric(15,4)
language 'plpgsql'
as $function$
declare

    v_to_dollars numeric (15,4) := -1.0000;
    v_converted_money numeric (15,4) := -1.0000;

begin

    select p_money_to_convert / (rate_usd * amount)
    into v_to_dollars
    from d_acc_currency
    where id = p_id_currency_from;

    select v_to_dollars * (rate_usd * amount)
    into v_converted_money
    from d_acc_currency
    where id = p_id_currency_to;

    if v_converted_money < 0.0000 then
        raise exception 'Could not convert money!';
    end if;

    return v_converted_money;

end;
$function$