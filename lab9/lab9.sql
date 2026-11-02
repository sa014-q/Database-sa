DROP TABLE IF EXISTS loans CASCADE;
DROP TABLE IF EXISTS members CASCADE;
DROP TABLE IF EXISTS book_authors CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS student_phones CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    department_head VARCHAR(100)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT REFERENCES departments(department_id)
);

CREATE TABLE student_phones (
    student_id INT,
    phone_number VARCHAR(15),
    phone_type VARCHAR(20),
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    publication_year INTEGER,
    available_copies INTEGER DEFAULT 1
);

CREATE TABLE book_authors (
    book_id INTEGER,
    author_id INTEGER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    membership_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES members(member_id),
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    loan_date DATE DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    late_fee DECIMAL(10,2) DEFAULT 0.00
);

INSERT INTO departments VALUES 
(1, 'Computer Science', 'Dr. Smith'),
(2, 'Mathematics', 'Dr. Johnson');

INSERT INTO students VALUES 
(1, 'Айбек', 1),
(2, 'Тимур', 1),
(3, 'Бектур', 2);

INSERT INTO courses VALUES 
(101, 'Базы данных', 5),
(102, 'Алгоритмы', 4);

INSERT INTO enrollments VALUES 
(1, 101, 'A'),
(1, 102, 'B+'),
(2, 101, 'A-');

INSERT INTO authors (first_name, last_name, birth_date) VALUES 
('Роберт', 'Мартин', '1952-12-05'),
('Томас', 'Кормен', '1953-06-29');

INSERT INTO books (title, isbn, publication_year, available_copies) VALUES 
('Чистый код', '9785446109357', 2018, 3),
('Алгоритмы: Построение и анализ', '9785845918543', 2015, 2);

INSERT INTO book_authors VALUES 
(1, 1),
(2, 2);

INSERT INTO members (first_name, last_name, email, phone) VALUES 
('Айбек', 'Момунов', 'aibek@example.com', '+996555123456');

INSERT INTO loans (member_id, book_id, due_date, return_date) VALUES 
(1, 1, '2026-06-01', NULL);

SELECT m.first_name, m.last_name, b.title, l.due_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;

SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY student_count DESC;