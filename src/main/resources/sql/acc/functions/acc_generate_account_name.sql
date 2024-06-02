create or replace function acc_generate_account_name(
    p_id_account_type text,
    p_account_open_date date,
    p_account_close_date date
)
returns text
language 'plpgsql'
as $function$
declare

    v_name text := '';

begin

    select description || ' opened at ' || p_account_open_date ||
        case when p_account_close_date is not null then
            ' closing at ' || p_account_close_date
        else
            ''
        end
    into v_name
    from d_acc_account_type
    where id = p_id_account_type;

    return v_name;

end;
$function$