DROP TABLE IF EXISTS pivoted_sales CASCADE;
DROP TABLE IF EXISTS warehouse_2 CASCADE;
DROP TABLE IF EXISTS warehouse_1 CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC,
    manager_id INT REFERENCES employees(employee_id),
    tenure INT
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    region_id INT,
    amount NUMERIC,
    status VARCHAR(50)
);

CREATE TABLE warehouse_1 (
    product_id INT,
    product_name VARCHAR(100),
    quantity INT
);

CREATE TABLE warehouse_2 (
    product_id INT,
    product_name VARCHAR(100),
    quantity INT
);

CREATE TABLE pivoted_sales (
    product_name VARCHAR(100),
    year_2022 NUMERIC,
    year_2023 NUMERIC,
    year_2024 NUMERIC
);

INSERT INTO employees (first_name, last_name, department, salary, manager_id, tenure) VALUES
('Boss', 'Man', 'Executive', 150000, NULL, 10),
('Alice', 'Smith', 'Engineering', 90000, 1, 6),
('Bob', 'Jones', 'Sales', 60000, 1, 3),
('Charlie', 'Brown', 'Engineering', 110000, 1, 8);

INSERT INTO orders (product_name, region_id, amount, status) VALUES
('Laptop', 1, 500000, 'High Priority'),
('Mouse', 1, 600000, 'Medium Priority'),
('Keyboard', 2, 200000, 'Low Priority');

INSERT INTO warehouse_1 (product_id, product_name, quantity) VALUES
(1, 'Laptop', 5),
(2, 'Mouse', 0);

INSERT INTO warehouse_2 (product_id, product_name, quantity) VALUES
(1, 'Laptop', 10),
(3, 'Keyboard', 0);

INSERT INTO pivoted_sales (product_name, year_2022, year_2023, year_2024) VALUES
('Laptop', 1000, 1500, 2000),
('Mouse', 300, 400, 500);

SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 100000;

WITH RECURSIVE org_chart AS (
    SELECT employee_id, first_name, last_name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart;

SELECT product_name FROM warehouse_1
UNION
SELECT product_name FROM warehouse_2;

SELECT product_id FROM warehouse_1 WHERE quantity = 0
INTERSECT
SELECT product_id FROM warehouse_2 WHERE quantity = 0;

SELECT
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM employees;

SELECT
    product_name,
    SUM(CASE WHEN 2022 = 2022 THEN year_2022 ELSE 0 END) AS year_2022,
    SUM(CASE WHEN 2023 = 2023 THEN year_2023 ELSE 0 END) AS year_2023
FROM pivoted_sales
GROUP BY product_name;

SELECT product_name, '2022' AS year, year_2022 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount FROM pivoted_sales
ORDER BY product_name, year;

SELECT
    employee_id,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_salary,
    AVG(salary) FILTER (WHERE tenure > 5) OVER () AS avg_salary_senior
FROM employees;

SELECT product_name, status
FROM orders
ORDER BY
    CASE status
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority' THEN 3
        ELSE 4
    END;

EXPLAIN ANALYZE
SELECT first_name, last_name FROM employees WHERE department = 'Engineering';