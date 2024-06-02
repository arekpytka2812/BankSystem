create or replace function acc_add_credit_installment(
    p_id_credit bigint,
    p_amount_to_pay numeric(15,4),
    p_id_user bigint
)
returns bigint
language 'plpgsql'
as $function$
declare
    v_id bigint;

begin

    insert into acc_credit_installment(
        id_credit,
        amount_to_pay,
        id_status,
        amount_paid,
        payment_date,
        insert_user
    )
    values(
        p_id_credit,
        p_amount_to_pay,
        1,
        0.0000,
        null,
        p_id_user
    )
    returning id into v_id;

    return v_id;

end;
$function$