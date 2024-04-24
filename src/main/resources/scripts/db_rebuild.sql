/**
    jezeli potrzebyjesz cos sczegolnego dorzucic przed czyms ->
    zmieniasz kolejnosc w case w 58 linijce
*/
create or replace function db_rebuild()
returns void
language 'plpgsql'
as $function$
declare

    V_BASE_PATH text := '../../../../home/sql';

    v_statement text;

    v_dir text;

    v_sub_dir text;

    v_file text;

begin

    -- drop
--     drop table if exists * cascade;
--     drop function if exists * cascade ;

    -- business seq musi byc pierwszy
    v_statement := pg_read_file(V_BASE_PATH || '/sys/sys_business_id_sequence.sql');
    execute v_statement;
    raise notice '%', v_statement;

    for v_dir in
        select *
        from pg_ls_dir(V_BASE_PATH)
        order by array_position(array['sys', 'hist', 'usr', 'acc', 'tr', 'job'], pg_ls_dir)

    loop

        for v_sub_dir in
            select *
            from pg_ls_dir(V_BASE_PATH || '/' || v_dir)
            order by array_position(array['tables', 'functions', 'inserts'], pg_ls_dir)
        loop

            if v_sub_dir ~* '.sql' then -- caseowy warunek na biznesowy seq
                continue;
            end if;

            for v_file in
                select *
                from pg_ls_dir(V_BASE_PATH || '/' || v_dir || '/' || v_sub_dir)
                order by case
                             when pg_ls_dir ~* '^d_' then 1 -- zapewnia ze najpierw slowniki leca
                             else 2
                         end,
                         case -- warunki na poszcegolne podfoldery
                             when v_dir = 'usr' then array_position(array['usr_user.sql'], pg_ls_dir)
                             when v_dir = 'acc' then array_position(array['acc_account.sql', 'acc_credit.sql', 'acc_credit_installment.sql'], pg_ls_dir)
                             when v_dir = 'tr'  then array_position(array['tr_transaction.sql'], pg_ls_dir)
                             else 2
                         end

            loop
                v_statement := pg_read_file(V_BASE_PATH || '/' || v_dir || '/' || v_sub_dir || '/' || v_file);
                execute v_statement;
                raise notice '%', '/' || v_dir || '/' || v_sub_dir || '/' || v_file;
            end loop;

        end loop;

    end loop;


end
$function$;

select * from db_rebuild();
