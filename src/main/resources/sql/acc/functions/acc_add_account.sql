create or replace function acc_add_account(
    p_user_id bigint,
    p_id_account_type bigint,
    p_id_parent_account bigint,
    p_account_name text,
    p_account_open_date date,
    p_account_close_date date
)
returns void
language 'plpgsql'
as $function$
declare

    v_account_name text;

begin

    if(p_user_id is null) then
        raise exception 'User is null!';
    end if;

    -- for account types that requires parent check whether id_parent is not null

    if(nullif(p_account_name, '') is null) then

        v_account_name := acc_generate_account_name(
            p_id_account_type,
            p_account_open_date,
            p_account_close_date
        );

    end if;

    insert into acc_account(
        user_id,
        id_account_type,
        id_parent_account,
        account_name,
        account_number,
        account_open_date,
        account_close_date,
        insert_user
    )
    values (
        p_user_id,
        p_id_account_type,
        p_id_parent_account,
        coalesce(p_account_name, v_account_name),
        acc_generate_account_number(p_id_account_type),
        coalesce(p_account_open_date, current_date),
        p_account_close_date,
        p_user_id
    );

end;
$function$;
