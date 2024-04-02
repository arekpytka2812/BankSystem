create or replace function acc_convert_money_between_currencies(
    p_id_currency_from bigint,
    p_id_currency_to bigint,
    p_money_to_convert numeric(15,4)
)
returns numeric(15,4)
language 'plpgsql'
as $function$
declare

    v_converted_money numeric (15,4) := -1.0000;

begin

    select p_money_to_convert * conversion_rate
    into v_converted_money
    from acc_currency_rate
    where rate_date = current_date
        and id_currency_from = p_id_currency_from
        and id_currency_to = p_id_currency_to;

    if v_converted_money < 0.0000 then
        raise exception 'Could not convert money!';
    end if;

    return v_converted_money;

end;
$function$