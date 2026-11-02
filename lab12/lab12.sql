DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    department_id INT,
    salary NUMERIC
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100)
);

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    amount NUMERIC
);

INSERT INTO employees (name, department, department_id, salary) VALUES
('Alice Smith', 'Engineering', 3, 80000),
('Bob Jones', 'Sales', 5, 55000),
('Charlie Brown', 'Engineering', 3, 110000),
('Diana Prince', 'Marketing', 7, 72000),
('Evan Wright', 'Sales', 5, 95000);

INSERT INTO products (product_name, price) VALUES
('Laptop', 1200),
('Wireless Mouse', 25),
('Keyboard', 45),
('Monitor', 150),
('USB Cable', 15);

INSERT INTO customers (customer_name) VALUES
('Brad Pitt'),
('Brandon Lee'),
('John Doe'),
('Alice Cooper');

INSERT INTO users (email) VALUES
('alice.smith@gmail.com'),
('BOB@GMAIL.COM'),
('charlie@yahoo.com');

INSERT INTO sales (employee_id, amount) VALUES
(1, 1500),
(2, 500),
(3, 1200),
(2, 2000);

SELECT * FROM employees;

SELECT name, department FROM employees;

SELECT name, salary, salary * 0.10 AS potential_bonus
FROM employees;

SELECT name
FROM employees
WHERE salary > 75000 AND department = 'Engineering';

SELECT product_name, price
FROM products
WHERE price BETWEEN 20 AND 50;

SELECT customer_name
FROM customers
WHERE customer_name LIKE 'Bra%';

SELECT email
FROM users
WHERE email ILIKE '%@gmail.com';

SELECT name
FROM employees
WHERE name ~ '^[AC]';

SELECT name, department
FROM employees
WHERE department_id IN (3, 5);

SELECT name
FROM employees e
WHERE EXISTS (
  SELECT 1 
  FROM sales s 
  WHERE s.employee_id = e.id AND s.amount > 1000
);

SELECT name, salary,
  CASE 
    WHEN salary > 100000 THEN 'Senior'
    WHEN salary BETWEEN 60000 AND 100000 THEN 'Mid-Level'
    ELSE 'Junior'
  END AS employee_level
FROM employees;

WITH department_averages AS (
  SELECT 
    department, 
    AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department
)
SELECT 
  e.name, 
  e.salary, 
  e.department, 
  da.avg_salary
FROM employees e
JOIN department_averages da ON e.department = da.department
WHERE e.salary > da.avg_salary;