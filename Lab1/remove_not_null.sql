DO $$
DECLARE
    r RECORD;
    count_removed INTEGER := 0;
    schema_name TEXT;
BEGIN
    SELECT table_schema INTO schema_name
    FROM information_schema.tables
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
    ORDER BY table_schema
    LIMIT 1;

    IF schema_name IS NULL THEN
        RAISE EXCEPTION 'Не удалось определить схему';
    END IF;

    FOR r IN
        SELECT c.table_name, c.column_name
        FROM information_schema.columns c
        LEFT JOIN information_schema.key_column_usage k
            ON c.table_name = k.table_name
            AND c.column_name = k.column_name
            AND c.table_schema = k.table_schema
        WHERE c.table_schema = schema_name
            AND c.is_nullable = 'NO'
            AND k.column_name IS NULL
    LOOP
        EXECUTE format(
                'ALTER TABLE %I.%I ALTER COLUMN %I DROP NOT NULL',
                schema_name, r.table_name, r.column_name
                );
                count_removed := count_removed + 1;
                RAISE NOTICE 'Removed NOT NULL constraints from %.%', r.table_name, r.column_name;
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