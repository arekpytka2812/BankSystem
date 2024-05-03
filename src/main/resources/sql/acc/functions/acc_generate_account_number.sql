create or replace function acc_generate_account_number(
)
returns text
language 'plpgsql'
as $function$
declare

    v_bank_id constant numeric(8,0) := 92480003;
    v_pl_country_code constant numeric(6,0) := 252100;
    v_count_number numeric(16,0);
    v_control_sum numeric(2,0);

begin

    SELECT count(*) from acc_account
        into v_count_number;

    SELECT CAST(CAST(LPAD(CAST(v_bank_id as text), 8, '0')||LPAD(CAST(v_count_number as text),16,'0')||
                     LPAD(CAST(v_pl_country_code as text),6,'0')
        as numeric(30,0)) % 97 as numeric (2,0))
        into v_control_sum;

    SELECT 98 - v_control_sum
        into v_control_sum;

    return LPAD(CAST(v_control_sum as text),2,'0')||LPAD(CAST(v_bank_id as text), 8, '0')||
           LPAD(CAST(v_count_number as text),16,'0');

end;
$function$;