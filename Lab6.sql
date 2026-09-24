DROP TABLE IF EXISTS university_students;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100)
);

ALTER TABLE students
ADD COLUMN date_of_birth DATE;

ALTER TABLE students
DROP COLUMN faculty;

ALTER TABLE students
ALTER COLUMN first_name TYPE TEXT;

ALTER TABLE students
ADD CONSTRAINT unique_student_email UNIQUE (email);

ALTER TABLE students
RENAME COLUMN email TO email_address;

ALTER TABLE students
RENAME TO university_students;

CREATE TEMP TABLE temp_student_summary (
    student_id INT,
    total_courses INT
);

DROP TABLE IF EXISTS non_existing_table;

DROP TABLE IF EXISTS university_students;