create or replace function sys_get_previous_work_day(p_date date)
    returns date
    language 'plpgsql'
as $function$
begin

    while extract(isodow from p_date) in (6,7) loop
            p_date := p_date - 1;
        end loop;

    return p_date;

end;
$function$