create or replace function acc_generate_account_number()
returns text
language 'plpgsql'
as $function$
declare

    v_bank_id numeric(8,0);
    v_pl_country_code numeric(6,0);
    v_count_number numeric(16,0);
    v_control_sum numeric(2,0);

begin

    v_bank_id := sys_get_register_value('BANK_ID_FOR_GENERATING_ACCOUNT_NUMBER')::numeric(8,0);
    v_pl_country_code := sys_get_register_value('ACCOUNT_NUMBER_PL_COUNTRY_CODE_FOR_GENERATION')::numeric(8,0);

    SELECT count(*) from acc_account
        into v_count_number;

    SELECT CAST(CAST(LPAD(CAST(v_bank_id as text), 8, '0')||LPAD(CAST(v_count_number as text),16,'0')||
                     LPAD(CAST(v_pl_country_code as text),6,'0')
        as numeric(30,0)) % 97 as numeric (2,0))
        into v_control_sum;

    v_control_sum := 98 - v_control_sum;

    return LPAD(CAST(v_control_sum as text),2,'0')||LPAD(CAST(v_bank_id as text), 8, '0')||
           LPAD(CAST(v_count_number as text),16,'0');

end;
$function$;