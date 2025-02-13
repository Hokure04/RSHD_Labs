CREATE OR REPLACE FUNCTION create_test_tables()
RETURNS void
LANGUAGE plpgsql AS
$func$
BEGIN
   IF NOT EXISTS (
       SELECT 1 FROM information_schema.tables
       WHERE table_schema = 'public'
       AND table_name = 'student_test'
   ) THEN
       EXECUTE 'CREATE TABLE public.student_test (
           test_id BIGSERIAL PRIMARY KEY,
           name VARCHAR(50) NOT NULL,
           surname VARCHAR(50) NOT NULL,
           gender VARCHAR(6) NOT NULL,
           birthday DATE NOT NULL,
           start_study_date DATE NOT NULL,
           finish_study_date DATE,
           CHECK ( gender = ''Female'' OR gender = ''Male'')
       )';
       RAISE NOTICE 'Table public.student_test created successfully';
   ELSE
       RAISE NOTICE 'Table public.student_test already exist';
   END IF;

   IF NOT EXISTS(
       SELECT 1 FROM information_schema.tables
       WHERE table_schema = 'public'
       AND table_name = 'faculty_test'
   ) THEN
       EXECUTE 'CREATE TABLE public.faculty_test (
           faculty_id BIGSERIAL PRIMARY KEY,
           name VARCHAR(50) NOT NULL,
           abbreviation VARCHAR(10),
           code_number VARCHAR(10) NOT NULL,
           available_places_count INTEGER NOT NULL,
            CHECK( available_places_count > 0)
       )';
       RAISE NOTICE 'Table public.faculty_test created successfully';
   ELSE
       RAISE NOTICE 'Table public.faculty_test already exist';
   END iF;

   IF NOT EXISTS (
       SELECT 1 FROM information_schema.tables
       WHERE table_schema = 'public'
       AND table_name = 'subject_test'
   ) THEN
       EXECUTE 'CREATE TABLE public.subject_test (
           subject_id BIGSERIAL PRIMARY KEY,
           name VARCHAR(50) NOT NULL,
           type VARCHAR(50) NOT NULL,
           classes_count INTEGER,
           status VARCHAR(15) NOT NULL
       )';
       RAISE NOTICE 'Table public.subject_test created successfully';
   ELSE
       RAISE NOTICE 'Table public.subject_test already exist';
   END IF;
END
$func$;


SELECT create_test_tables();

INSERT INTO public.student_test(name, surname, gender, birthday, start_study_date, finish_study_date) VALUES
('Ivan', 'Ivanov', 'Male', '2000-05-15', '2018-09-01', '2022-06-30'),
('Petr', 'Petrov', 'Male', '2004-09-09', '2020-05-01', NULL),
('Elena', 'Sidorova', 'Female', '2002-10-14', '2021-05-15', NULL);

INSERT INTO public.faculty_test(name, abbreviation, code_number, available_places_count) VALUES
('programming engineering and computer technics', 'PIiKT','06.07.04', 456),
('business informatics', 'KT','01.02.06', 154),
('software engineering', 'FITIP','02.05.03', 200);

INSERT INTO public.subject_test(name, type, classes_count, status) VALUES
('distributed storage systems', 'programming', '32', 'active'),
('operation systems', 'programming', '32', 'active'),
('ecology', 'busyness', NULL, 'inactive');