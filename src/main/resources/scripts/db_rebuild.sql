/**
    jezeli potrzebyjesz cos sczegolnego dorzucic przed czyms ->
    zmieniasz kolejnosc w zmiennych w linijkach 13 - 19
*/
create or replace function db_rebuild()
returns void
language 'plpgsql'
as $function$
declare

    V_BASE_PATH             text := '../../../../home/sql';

    V_MAIN_DIRS_ORDER       text[] := array['hist', 'sys', 'usr', 'acc', 'tr', 'job'];
    V_SUB_DIRS_ORDER        text[] := array['tables', 'types', 'functions', 'inserts'];
    V_USR_TABLES_ORDER      text := '''usr_user.sql''';
    V_ACC_TABLES_ORDER      text := '''acc_account.sql'', ''acc_credit.sql'', ''acc_credit_installment.sql''';
    V_TR_TABLES_ORDER       text := '''tr_transaction.sql''';
    V_USR_INSERTS_ORDER     text := '''insert_usr_user.sql''';
    V_ACC_INSERTS_ORDER     text := '''insert_acc_account.sql'', ''insert_acc_credit.sql'', ''insert_acc_credit_installment.sql''';
    V_TR_INSERTS_ORDER      text := '''insert_tr_transaction.sql''';

    v_drop_rec record;

    v_statement text;

    v_dir text;
    v_sub_dir text;
    v_file text;

    v_query text;

begin

    -- drop
    drop extension if exists pgcrypto;

    DROP EXTENSION IF EXISTS pg_cron;

    FOR v_drop_rec IN

        select drop_stmt
        From (
            SELECT 'ALTER TABLE public.' || quote_ident(table_name) || ' DROP CONSTRAINT IF EXISTS ' ||
                    quote_ident(constraint_name) || ' CASCADE;' as drop_stmt
            FROM information_schema.table_constraints
            WHERE constraint_schema = 'public'

            UNION

            SELECT 'DROP TRIGGER IF EXISTS ' || quote_ident(trigger_name) || ' ON public.' ||
                    quote_ident(event_object_table) || ';' as drop_stmt
            FROM information_schema.triggers
            WHERE trigger_schema = 'public'

            UNION

            SELECT 'DROP INDEX IF EXISTS public.' || quote_ident(indexname) || ';' as drop_stmt
            FROM pg_indexes
            WHERE schemaname = 'public'

            UNION

            SELECT 'DROP TABLE IF EXISTS public.' || quote_ident(table_name) || ' CASCADE;' as drop_stmt
            FROM information_schema.tables
            WHERE table_schema = 'public'
            AND table_type = 'BASE TABLE'

            UNION

            SELECT 'DROP SEQUENCE IF EXISTS ' || quote_ident(sequence_name ) || ';' as drop_stmt
            FROM information_schema.sequences
            WHERE sequence_schema = 'public'

            UNION

            SELECT 'DROP FUNCTION IF EXISTS public.' || proname || ' CASCADE;' as drop_stmt
            FROM pg_proc
            WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
              and proname != 'db_rebuild'

            UNION

            SELECT 'DROP TYPE IF EXISTS ' || quote_ident(typname) || ' CASCADE;' as drop_stmt
            FROM pg_type
            WHERE typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
                and typname ~* '^t_'


        ) as foo
        order by
            case
                when drop_stmt ~* 'trigger' then 1
                when drop_stmt ~* 'alter table' then 2
                when drop_stmt ~* 'index' then 3
                when drop_stmt ~* 'drop table' then 4
                when drop_stmt ~* 'function' then 5
                else 6
            end

    LOOP
        raise notice '%', v_drop_rec.drop_stmt;
        EXECUTE v_drop_rec.drop_stmt;
    END LOOP;

    -- extensions
    create extension if not exists pgcrypto;
    CREATE EXTENSION IF NOT EXISTS pg_cron;

    -- business seq musi byc pierwszy i hist_trigger_func
    v_statement := pg_read_file(V_BASE_PATH || '/sys/sys_business_id_sequence.sql');
    execute v_statement;

    for v_dir in
        select *
        from pg_ls_dir(V_BASE_PATH)
        order by array_position(V_MAIN_DIRS_ORDER, pg_ls_dir)

    loop

        for v_sub_dir in
            select *
            from pg_ls_dir(V_BASE_PATH || '/' || v_dir)
            order by array_position(V_SUB_DIRS_ORDER, pg_ls_dir)
        loop

            if v_sub_dir ~* '.sql' then
                continue;
            end if;

            v_query := 'select * ' ||
                       'from pg_ls_dir(''' || V_BASE_PATH || '/' || v_dir || '/' || v_sub_dir || ''') ' ||
                       'order by ' ||
                            case
                                when v_sub_dir = 'tables' then
                                    'case
                                        when pg_ls_dir ~* ''^d_'' then 1
                                        else 2
                                    end,
                                    case
                                        when ''' || v_dir || ''' = ''usr'' then array_position(ARRAY[' || V_USR_TABLES_ORDER || '], pg_ls_dir)
                                        when ''' || v_dir || ''' = ''acc'' then array_position(ARRAY[' || V_ACC_TABLES_ORDER || '], pg_ls_dir)
                                        when ''' || v_dir || ''' = ''tr''  then array_position(ARRAY[' || V_TR_TABLES_ORDER  || '], pg_ls_dir)
                                        else 2
                                    end'
                                when v_sub_dir = 'inserts' then
                                    'case
                                        when pg_ls_dir ~* ''^insert_d_'' then 1
                                        else 2
                                    end,
                                    case
                                        when ''' || v_dir || ''' = ''usr'' then array_position(ARRAY[' || V_USR_INSERTS_ORDER || '], pg_ls_dir)
                                        when ''' || v_dir || ''' = ''acc'' then array_position(ARRAY[' || V_ACC_INSERTS_ORDER || '], pg_ls_dir)
                                        when ''' || v_dir || ''' = ''tr''  then array_position(ARRAY[' || V_TR_INSERTS_ORDER  || '], pg_ls_dir)
                                        else 2
                                    end'
                                else '1'
                            end;

            for v_file in
                execute v_query
            loop
                v_statement := pg_read_file(V_BASE_PATH || '/' || v_dir || '/' || v_sub_dir || '/' || v_file);

                execute v_statement;

            end loop;
        end loop;
    end loop;

end
$function$;

select * from db_rebuild();
