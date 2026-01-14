-- Using the database for online bike shop, which you already have, write SQL queries for the following task.

-- Find customers who never ordered.

SELECT c.customer_id,
       order_id,
       first_name,
       last_name,
       phone,
       email,
       street,
       city,
       state,
       zip_code
FROM customers c
         LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE order_id IS NULL;

-- Find the customer(s) who placed the most orders.

SELECT COUNT(*) AS order_count, customer_id
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC, customer_id;

-- Find the product(s) with the highest price.
SELECT *
FROM products
ORDER BY list_price DESC;
-- 
-- Find the store(s) with the highest total stock.
SELECT *
FROM stocks;
-- Using a CTE, find the most popular product per category.
-- 
-- Using a CTE, find the top-selling brand.
-- 
-- Using a CTE, compute store-level performance (total items sold).
-- 
-- Using a CTE, detect customers with unusually large orders.
-- 
-- For each brand, number products by price.
-- 
-- For each category, number products alphabetically.
-- 
-- Rank stores by total stock.
-- 
-- Rank brands by average product price.
-- 
-- USE AGGREGATE FUNCTIONS
-- 
-- Show each product with the average price of its brand.
-- 
-- Show each order with the average order quantity of that customer.
-- 
-- Show each stock row with the maximum stock of that product.
-- 
-- USE LAG()
-- 
-- Show each order with the previous order date of that customer.
-- 
-- Show each product price and the previous product price in the same brand.
-- 
-- USE LEAD()
-- Show each order and the next order date for the same customer.
-- 
-- Show product price and the next higher-priced product.
-- 
-- MIX
-- 
-- Find customers whose latest order is bigger than their previous one.
-- 
-- Find brands where the most expensive product is 2× more than average.