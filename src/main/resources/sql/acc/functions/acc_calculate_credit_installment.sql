create or replace function acc_calculate_credit_installment(
    p_years integer,
    p_percent decimal(5, 4),
    p_value decimal(15, 4)
)
    returns decimal(15,4)
    language 'plpgsql'
as $function$
declare

    v_monthly_percent decimal(5, 4) := power(1+p_percent/100, 1.0/12.0) - 1; --(1+year_percent)^1/12 - 1
    v_no_intallments integer := p_years * 12;

begin

    return p_value / ((1 - power(1 + v_monthly_percent, -v_no_intallments)) / v_monthly_percent); -- PMT = PV / (1-(1+r)^-n/r)

end;
$function$;
