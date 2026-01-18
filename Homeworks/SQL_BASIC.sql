-- How many employees work in the company?
SELECT COUNT(*) AS total_employees
FROM staffs;


-- What is the largest quantity of a single product in stock?
SELECT MAX(quantity) AS max_quantity
FROM stocks;


-- What is the smallest quantity recorded in stock?
SELECT MIN(quantity) AS min_quantity
FROM stocks;


-- On average, how many items are stored per stock record?
SELECT ROUND(AVG(quantity), 2) AS avg_quantity
FROM stocks;


-- How common is each order status?
SELECT order_status,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY order_status;


-- Which customers place orders most frequently?
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;


-- How many staff members work in each store?
SELECT store_id,
       COUNT(*) AS total_staff
FROM staffs
GROUP BY store_id
ORDER BY store_id;


-- How many employees report to each manager?
SELECT manager_id,
       COUNT(*) AS total_staff
FROM staffs
WHERE manager_id IS NOT NULL
GROUP BY manager_id
ORDER BY manager_id;


-- How does the average product price vary by model year?
SELECT model_year,
       ROUND(AVG(list_price), 2) AS avg_price
FROM products
GROUP BY model_year
ORDER BY model_year;


-- Which brands have a large enough product range (more than 100) to stand out?
SELECT brand_id,
       COUNT(product_id) AS product_count
FROM products
GROUP BY brand_id
HAVING COUNT(product_id) > 100
ORDER BY brand_id;


-- Find cities where customer count is between 5 and 15.
SELECT city,
       COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
HAVING COUNT(customer_id) BETWEEN 5 AND 15
ORDER BY city;


-- Find states with more than 2 cities.
SELECT state,
       COUNT(DISTINCT city) AS city_count
FROM customers
GROUP BY state
HAVING COUNT(DISTINCT city) > 2
ORDER BY state;


-- Products ordered more than 50 times.
SELECT product_id,
       COUNT(*) AS times_ordered
FROM order_items
GROUP BY product_id
HAVING COUNT(*) > 50
ORDER BY times_ordered DESC;


-- Stores where AVG(stock quantity) BETWEEN 5 AND 20.
SELECT store_id,
       ROUND(AVG(quantity), 2) AS avg_quantity
FROM stocks
GROUP BY store_id
HAVING AVG(quantity) BETWEEN 5 AND 20
ORDER BY store_id;