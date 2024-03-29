create or replace function job_book_transactions_service(

)
returns void
language 'plpgsql'
as $function$
declare

    v_transactions_to_book_count bigint := 0;
    v_row   record;

begin

    select count(*)
    into v_transactions_to_book_count
    from tr_nonbooked_transaction;

    perform job_add_log(
        'transactions_booking_service',
        'Starting booking' || v_transactions_to_book_count || 'transactions',
        false
    );





end;
$function$;