create or replace function acc_check_if_account_number_is_correct(
    p_account_number text
)
    returns boolean
    language 'plpgsql'
as $function$
declare

    v_pl_country_code text := '2521';
    v_full_acc_number numeric(30,0);

begin

    v_pl_country_code := sys_get_register_value('ACCOUNT_NUMBER_PL_COUNTRY_CODE');

    if length(p_account_number) <> 26 then
        return false;
    end if;

    v_pl_country_code = v_pl_country_code || LEFT(p_account_number::text, 2);

    v_full_acc_number = (RIGHT(p_account_number::text, -2) || v_pl_country_code)::numeric(30,0);

    return mod(v_full_acc_number, 97) = 1;

end;
$function$;