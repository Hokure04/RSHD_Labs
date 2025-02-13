DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT table_name, column_name
        FROM information_schema.columns
        WHERE table_schema = 'public'
        AND is_nullable = 'NO'
    LOOP
        EXECUTE format(
                'ALTER TABLE %I.%I ALTER COLUMN %I DROP NOT NULL',
                'public', r.table_name, r.column_name
                );
                RAISE NOTICE 'Removed NOT NULL constraints from %.%', r.table_name, r.column_name;
    END LOOP;
END $$;

INSERT INTO public.student_test(name, surname, gender, birthday, start_study_date, finish_study_date) VALUES
(NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO public.faculty_test(name, abbreviation, code_number, available_places_count) VALUES
(NULL, NULL, NULL, NULL);

INSERT INTO public.subject_test(name, type, classes_count, status) VALUES
(NULL, NULL, NULL, NULL);