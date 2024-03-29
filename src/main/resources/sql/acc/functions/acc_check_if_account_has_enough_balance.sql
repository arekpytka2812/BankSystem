create or replace function acc_check_if_account_has_enough_balance(
    p_id_account bigint,
    p_money numeric(15,4)
)
    returns boolean
    language 'plpgsql'
as $function$
begin

    -- mozna dorobic mechaznim ze konta nie moga miec mnie jniz
    -- i wtedy tu by sie to sparwdzalo

    perform 1
    from acc_account
    where id = p_id_account
      and balance - p_money > 0.0000;

    return FOUND;
end;
$function$


