create or replace function usr_add_user_personal_data(
    p_user_id bigint,
    p_email text,
    p_name text,
    p_surname text,
    p_date_of_birth date,
    p_income decimal(15,4)
)
returns void
language 'plpgsql'
as $function$
declare
begin

    if not sys_is_email_valid(p_email) then
        raise exception 'Email is not valid!';
    end if;

    insert into usr_user_personal_data(
        id,
        email,
        name,
        surname,
        date_of_birth,
        income,
        insert_user
    )
    values (
        p_user_id,
        p_email,
        p_name,
        p_surname,
        p_date_of_birth,
        p_income,
        p_user_id
    );

end;
$function$
