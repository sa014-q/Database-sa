DROP TABLE IF EXISTS student_enrollments CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS blog_posts CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS students CASCADE;

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    manager_name VARCHAR(100),
    budget DECIMAL(10,2)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(100),
    salary DECIMAL(10,2),
    hire_date DATE DEFAULT CURRENT_DATE,
    dept_id INTEGER NOT NULL REFERENCES departments(dept_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT,
    profile_picture_url VARCHAR(255)
);

CREATE TABLE blog_posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    author VARCHAR(100),
    published_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES blog_posts(post_id) ON DELETE CASCADE,
    commenter_name VARCHAR(100),
    comment_text TEXT NOT NULL,
    comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    enrollment_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INTEGER NOT NULL,
    instructor VARCHAR(100)
);

CREATE TABLE student_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    grade CHAR(2),
    UNIQUE (student_id, course_id)
);

INSERT INTO departments (dept_name, location, manager_name, budget) VALUES
('Engineering', 'Building A', 'Alice Johnson', 500000.00),
('Marketing', 'Building B', 'Bob Wilson', 200000.00);

INSERT INTO employees (first_name, last_name, position, salary, dept_id) VALUES
('John', 'Smith', 'Software Engineer', 75000.00, 1),
('Jane', 'Doe', 'Senior Developer', 85000.00, 1),
('Sarah', 'Davis', 'Marketing Specialist', 55000.00, 2);

INSERT INTO users (username, email) VALUES
('johndoe', 'john@example.com');

INSERT INTO user_profiles (user_id, first_name, last_name, bio) VALUES
(1, 'John', 'Doe', 'Software developer');

INSERT INTO blog_posts (title, content, author) VALUES
('Post 1', 'Content 1', 'Author 1');

INSERT INTO comments (post_id, commenter_name, comment_text) VALUES
(1, 'Alex', 'Great post!');

INSERT INTO students (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice@university.edu'),
('Bob', 'Smith', 'bob@university.edu');

INSERT INTO courses (course_code, course_name, credits, instructor) VALUES
('CS101', 'Intro to Programming', 3, 'Dr. Brown'),
('CS201', 'Data Structures', 4, 'Dr. Davis');

INSERT INTO student_enrollments (student_id, course_id, grade) VALUES
(1, 1, 'A'),
(1, 2, 'B+'),
(2, 1, 'A-');

SELECT d.dept_name, e.first_name, e.last_name, e.position
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id;

SELECT s.first_name, c.course_code, se.grade
FROM students s
JOIN student_enrollments se ON s.student_id = se.student_id
JOIN courses c ON se.course_id = c.course_id;