DROP TABLE IF EXISTS staging_customers CASCADE;
DROP TABLE IF EXISTS target_customers CASCADE;
DROP TABLE IF EXISTS backup_logs CASCADE;

CREATE TABLE target_customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE staging_customers AS 
SELECT * FROM target_customers WHERE 1=0;

ALTER TABLE staging_customers ADD PRIMARY KEY (customer_id);

CREATE TABLE backup_logs (
    log_id SERIAL PRIMARY KEY,
    action_name VARCHAR(100),
    action_time TIMESTAMP DEFAULT NOW()
);

INSERT INTO target_customers (first_name, last_name, email) VALUES
('Alice', 'Smith', 'alice@gmail.com'),
('Bob', 'Jones', 'bob@gmail.com');

SELECT COUNT(*) FROM target_customers;

INSERT INTO staging_customers 
SELECT * FROM target_customers;

INSERT INTO target_customers (customer_id, first_name, last_name, email)
SELECT customer_id, first_name, last_name, email 
FROM staging_customers
ON CONFLICT (customer_id) 
DO UPDATE SET 
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    email = EXCLUDED.email;

SELECT pid, usename, application_name, client_addr, state
FROM pg_stat_activity;

SELECT COUNT(*) FROM target_customers;