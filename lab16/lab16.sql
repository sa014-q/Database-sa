DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS user_preferences CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    balance DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT REFERENCES orders(order_id),
    product_id INT,
    quantity INT
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock INT
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE user_preferences (
    user_id INT REFERENCES users(user_id),
    theme VARCHAR(50)
);

CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    action VARCHAR(100),
    timestamp TIMESTAMP
);

INSERT INTO accounts (balance) VALUES (1000.00), (500.00);
INSERT INTO inventory (product_id, stock) VALUES (101, 10);

BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;

BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
ROLLBACK;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE balance > 100;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM accounts WHERE balance > 100;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM accounts;
UPDATE accounts SET balance = balance * 1.05;
COMMIT;

BEGIN;
INSERT INTO customers (name, email) VALUES ('Alice', 'alice@email.com');
SAVEPOINT after_customer_insert;
INSERT INTO orders (customer_id, total) VALUES (1, 500.00);
ROLLBACK TO SAVEPOINT after_customer_insert;
INSERT INTO orders (customer_id, total) VALUES (1, 300.00);
COMMIT;

BEGIN;
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO user_preferences (user_id, theme) VALUES (lastval(), 'dark');
COMMIT;