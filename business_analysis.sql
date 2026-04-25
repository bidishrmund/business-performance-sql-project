-- ==========================================
-- END-TO-END BUSINESS PERFORMANCE ANALYSIS
-- ==========================================

-- ==========================================
-- SECTION 1: CREATE TABLES
-- ==========================================

CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(50)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    region_id INT,
    signup_date DATE,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    total_amount NUMERIC(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ==========================================
-- SECTION 2: INSERT DATA
-- ==========================================

INSERT INTO regions (region_name) VALUES
('North'), ('South'), ('East'), ('West');

INSERT INTO customers (customer_name, email, region_id, signup_date) VALUES
('Amit Sharma', 'amit@gmail.com', 1, '2023-01-10'),
('Priya Singh', 'priya@gmail.com', 2, '2023-02-15'),
('Rahul Das', 'rahul@gmail.com', 3, '2023-03-20'),
('Sneha Patel', 'sneha@gmail.com', 4, '2023-04-05');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 60000),
('Phone', 'Electronics', 30000),
('Shoes', 'Fashion', 2000),
('Watch', 'Accessories', 5000);

INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1, '2023-05-01', 'Completed'),
(2, '2023-05-03', 'Completed'),
(3, '2023-05-05', 'Cancelled'),
(4, '2023-05-07', 'Completed');

INSERT INTO sales (order_id, product_id, quantity, total_amount) VALUES
(1, 1, 1, 60000),
(2, 2, 2, 60000),
(3, 3, 1, 2000),
(4, 4, 3, 15000);

INSERT INTO payments (order_id, payment_date, payment_method, payment_status) VALUES
(1, '2023-05-01', 'Credit Card', 'Paid'),
(2, '2023-05-03', 'UPI', 'Paid'),
(3, '2023-05-05', 'Debit Card', 'Failed'),
(4, '2023-05-07', 'UPI', 'Paid');

-- ==========================================
-- SECTION 3: BUSINESS ANALYSIS
-- ==========================================

-- Total Revenue
SELECT SUM(total_amount) FROM sales;

-- Total Orders
SELECT COUNT(order_id) FROM orders;

-- Top Products
SELECT p.product_name, SUM(s.quantity)
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- Customer Spending
SELECT c.customer_name, SUM(s.total_amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN sales s ON o.order_id = s.order_id
GROUP BY c.customer_name;

-- Revenue by Region
SELECT r.region_name, SUM(s.total_amount)
FROM sales s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id
GROUP BY r.region_name;