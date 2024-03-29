create or replace function acc_generate_account_name(
    p_id_account_type text,
    p_account_open_date date,
    p_account_close_date date
)
returns text
language 'plpgsql'
as $function$
declare

begin

    -- WIP

    return '';

end;
$function$