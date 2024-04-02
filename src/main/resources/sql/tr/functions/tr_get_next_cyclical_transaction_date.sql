create or replace function tr_get_next_cyclical_transaction_date(
    p_interval_to_next_transaction interval
)
returns date
language 'plpgsql'
as $function$
begin
    -- zwrocenie nastepnego dnia roboczego po wymaganym intervale
    return sys_get_next_work_day(current_date + p_interval_to_next_transaction);

end;
$function$;