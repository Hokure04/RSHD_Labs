DO $$
DECLARE
    r RECORD;
    count_removed INTEGER := 0;
    schema_name TEXT := 's368274';
BEGIN

    IF schema_name IS NULL THEN
        RAISE EXCEPTION 'Не удалось определить схему';
    END IF;

    FOR r IN
        SELECT table_class.relname AS table_name, collumn.attname AS column_name
        FROM pg_class table_class
        JOIN pg_namespace namespace ON table_class.relnamespace = namespace.OID
        JOIN pg_attribute collumn ON table_class.OID = collumn.attrelid
        LEFT JOIN pg_constraint pk ON pk.conrelid = table_class.OID
            AND pk.contype = 'p'
            AND collumn.attnum = ANY(pk.conkey)
        WHERE namespace.nspname = schema_name
            AND table_class.relkind = 'r'
            AND collumn.attnum > 0
            AND collumn.attnotnull
            AND pk.conname IS NULL
    LOOP
        EXECUTE format(
                'ALTER TABLE %I.%I ALTER COLUMN %I DROP NOT NULL',
                schema_name, r.table_name, r.column_name
                );
                count_removed := count_removed + 1;
    END LOOP;

    RAISE NOTICE 'RESULT|%|%', schema_name, count_removed;
END $$;