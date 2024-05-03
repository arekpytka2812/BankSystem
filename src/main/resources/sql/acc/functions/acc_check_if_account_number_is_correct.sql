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

    if length(p_account_number) <> 26 then
        return false;
    end if;

    v_pl_country_code = v_pl_country_code || LEFT(CAST(p_account_number as text), 2);

    v_full_acc_number = CAST(RIGHT(CAST(p_account_number as text), -2) || v_pl_country_code as numeric(30,0));
    if mod(v_full_acc_number, 97) = 1 then
        return true;
    else
        return false;
    end if;


end;
$function$;