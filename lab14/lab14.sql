DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER REFERENCES employees(employee_id)
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100)
);

CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors(author_id),
    title VARCHAR(150),
    publication_year INTEGER
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    enrollment_date DATE,
    grade VARCHAR(5)
);

INSERT INTO customers (name, email) VALUES
('Alice Smith', 'alice@gmail.com'),
('Bob Jones', 'bob@gmail.com'),
('Charlie Brown', 'charlie@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-15', 120.00),
(1, '2024-02-10', 50.00),
(2, '2024-01-20', 200.00);

INSERT INTO products (product_name, price) VALUES
('Laptop', 1000.00),
('Mouse', 25.00);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2);

INSERT INTO employees (name, manager_id) VALUES
('Boss Man', NULL),
('Alice Manager', 1),
('Bob Employee', 2);

INSERT INTO users (username) VALUES ('alice_u'), ('bob_u');

INSERT INTO user_profiles (user_id, first_name, last_name, phone) VALUES
(1, 'Alice', 'Smith', '123-456'),
(2, 'Bob', 'Jones', '789-012');

INSERT INTO authors (author_name) VALUES ('J.K. Rowling'), ('George Orwell');

INSERT INTO books (author_id, title, publication_year) VALUES
(1, 'Harry Potter 1', 1997),
(2, '1984', 1949);

INSERT INTO students (student_name) VALUES ('John Doe'), ('Jane Smith');

INSERT INTO courses (course_name) VALUES ('SQL 101'), ('Python Basics');

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2024-01-10', 'A'),
(2, 2, '2024-01-12', 'B');

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.name, p.product_name
FROM customers c
CROSS JOIN products p;

SELECT c.name, o.order_date, oi.quantity, p.product_name, p.price
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

SELECT c.name, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01'
AND o.total_amount > 100;

SELECT u.username, up.first_name, up.last_name, up.phone
FROM users u
LEFT JOIN user_profiles up ON u.user_id = up.user_id;

SELECT a.author_name, b.title, b.publication_year
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
ORDER BY a.author_name, b.publication_year;

SELECT s.student_name, c.course_name, e.enrollment_date, e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY s.student_name, c.course_name;

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;