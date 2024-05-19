create or replace function acc_check_creditworhiness(
    p_years integer,
    p_percent decimal(5, 4),
    p_income decimal(15, 4)
)
    returns decimal(15,4)
    language 'plpgsql'
as $function$
declare

        v_max_payment decimal(15, 4) := p_income * 0.30;
        v_monthly_percent decimal(5, 4) := power(1+p_percent/100, 1.0/12.0) - 1; --(1+year_percent)^1/12 - 1
        v_no_intallments integer := p_years * 12;

begin

    return v_max_payment * ((1 - power(1 + v_monthly_percent, -v_no_intallments)) / v_monthly_percent); -- PV = PMT * (1-(1+r)^-n/r)

end;
$function$;
