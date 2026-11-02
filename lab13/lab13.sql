DROP TABLE IF EXISTS employee_skills CASCADE;
DROP TABLE IF EXISTS sales_data CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC,
    age INT,
    hire_date DATE,
    bonus NUMERIC,
    experience_years INT
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC,
    rating NUMERIC
);

CREATE TABLE sales_data (
    id SERIAL PRIMARY KEY,
    department VARCHAR(50),
    sales_amount NUMERIC,
    sale_date DATE,
    amount NUMERIC
);

CREATE TABLE employee_skills (
    employee_id INT REFERENCES employees(employee_id),
    skill_name VARCHAR(50)
);

INSERT INTO employees (first_name, last_name, department, salary, age, hire_date, bonus, experience_years) VALUES
('Alice', 'Smith', 'Engineering', 85000, 28, '2022-05-10', 5000, 5),
('Bob', 'Jones', 'Sales', 55000, 35, '2021-03-15', NULL, 3),
('Charlie', 'Brown', 'Engineering', 110000, 42, '2019-11-01', 10000, 10),
('Diana', 'Prince', 'Marketing', 72000, 26, '2023-02-20', 2000, 2),
('Evan', 'Wright', 'Sales', 95000, 51, '2018-07-12', 8000, 12),
('Fiona', 'Gallagher', 'Engineering', 90000, 30, '2023-04-01', 4000, 6);

INSERT INTO products (product_name, category, price, rating) VALUES
('Laptop', 'Electronics', 1200, 4.5),
('Mouse', 'Electronics', 25, 4.2),
('Desk', 'Furniture', 300, 3.9),
('Chair', 'Furniture', 150, 4.6),
('Monitor', 'Electronics', 350, 4.8);

INSERT INTO sales_data (department, sales_amount, sale_date, amount) VALUES
('Sales', 1500, '2023-01-15', 1500),
('Sales', 2300, '2023-03-10', 2300),
('Engineering', 4000, '2023-06-22', 4000),
('Marketing', 1200, '2023-09-05', 1200);

INSERT INTO employee_skills (employee_id, skill_name) VALUES
(1, 'Python'), (1, 'SQL'),
(3, 'Java'), (3, 'C++'), (3, 'SQL'),
(4, 'SEO'), (4, 'Copywriting');

SELECT COUNT(*) AS total_employees FROM employees;

SELECT COUNT(bonus) AS employees_with_bonus FROM employees;

SELECT COUNT(DISTINCT department) AS unique_departments FROM employees;

SELECT SUM(salary) AS total_salaries FROM employees;

SELECT department, SUM(sales_amount) AS total_sales 
FROM sales_data 
GROUP BY department;

SELECT AVG(salary) AS average_salary FROM employees;

SELECT department, AVG(age) AS avg_age 
FROM employees 
GROUP BY department;

SELECT MAX(salary) AS highest_salary, MIN(salary) AS lowest_salary FROM employees;

SELECT department, MAX(hire_date) AS latest_hire 
FROM employees 
GROUP BY department;

SELECT department, STRING_AGG(first_name, ',') AS employee_names 
FROM employees 
GROUP BY department;

SELECT employee_id, STRING_AGG(skill_name, ', ' ORDER BY skill_name) AS skills 
FROM employee_skills 
GROUP BY employee_id;

SELECT department, ARRAY_AGG(salary) AS salary_array 
FROM employees 
GROUP BY department;

SELECT 
    department,
    STDDEV(salary) AS salary_std_dev,
    VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department;

SELECT CORR(experience_years, salary) AS experience_salary_correlation FROM employees;

SELECT 
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    AVG(price) AS average_price
FROM products
GROUP BY category;

SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    COUNT(*) AS total_sales,
    SUM(amount) AS total_revenue
FROM sales_data
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;

SELECT 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END;

SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

SELECT 
    employee_id,
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(bonus) AS non_null_bonuses,
    COUNT(*) - COUNT(bonus) AS null_bonuses
FROM employees;

SELECT 
    department,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 80000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date > '2022-01-01' THEN 1 END) AS recent_hires
FROM employees
GROUP BY department;

SELECT 
    department,
    COUNT(*) AS dept_count,
    COUNT(*)::FLOAT / (SELECT COUNT(*) FROM employees) * 100 AS percentage
FROM employees
GROUP BY department
ORDER BY percentage DESC;