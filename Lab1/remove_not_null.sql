DO $$
DECLARE
    r RECORD;
    count_removed INTEGER := 0;
    schema_name TEXT;
BEGIN
    SELECT nspname INTO schema_name
    FROM pg_namespace
    WHERE nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    ORDER BY nspname
    LIMIT 1;

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

    RAISE NOTICE 'Схема: %', schema_name;
    RAISE NOTICE 'Ограничений целостности типа NOT NULL отключено: %', count_removed;
END $$;

INSERT INTO public.student_test(name, surname, gender, birthday, start_study_date, finish_study_date) VALUES
(NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO public.faculty_test(name, abbreviation, code_number, available_places_count) VALUES
(NULL, NULL, NULL, NULL);

INSERT INTO public.subject_test(name, type, classes_count, status) VALUES
(NULL, NULL, NULL, NULL);