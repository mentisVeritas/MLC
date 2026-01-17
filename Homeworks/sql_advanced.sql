-- Find customers who never ordered
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
         LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Find the customer(s) who placed the most orders
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) = (SELECT MAX(cnt)
                   FROM (SELECT COUNT(*) AS cnt
                         FROM orders
                         GROUP BY customer_id) t)
ORDER BY order_count, customer_id;


-- Find the product(s) with the highest price
SELECT *
FROM products
WHERE list_price = (SELECT MAX(list_price) FROM products);


-- Find the store(s) with the highest total stock
SELECT store_id, SUM(quantity) AS total_stock
FROM stocks
GROUP BY store_id
HAVING SUM(quantity) = (SELECT MAX(total_qty)
                        FROM (SELECT SUM(quantity) AS total_qty
                              FROM stocks
                              GROUP BY store_id) t);


-- Using a CTE, find the most popular product per category
WITH product_sales AS (SELECT p.category_id, p.product_id, SUM(oi.quantity) AS total_sold
                       FROM order_items oi
                                JOIN products p ON oi.product_id = p.product_id
                       GROUP BY p.category_id, p.product_id),
     ranked AS (SELECT *, RANK() OVER (PARTITION BY category_id ORDER BY total_sold DESC) rnk
                FROM product_sales)
SELECT *
FROM ranked
WHERE rnk = 1;


-- Using a CTE, find the top-selling brand
WITH brand_sales AS (SELECT b.brand_id, SUM(oi.quantity) AS total_sold
                     FROM order_items oi
                              JOIN products p ON oi.product_id = p.product_id
                              JOIN brands b ON p.brand_id = b.brand_id
                     GROUP BY b.brand_id)
SELECT *
FROM brand_sales
ORDER BY total_sold DESC
LIMIT 1;


-- Using a CTE, compute store-level performance (total items sold)
WITH store_sales as (sel)


-- Using a CTE, detect customers with unusually large orders
with order_sizes AS (SELECT o.order_id, o.customer_id, SUM(oi.quantity) AS order_qty
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id), avg_size AS (SELECT AVG(order_qty) AS avg_qty
    FROM order_sizes)
SELECT os.*
FROM order_sizes os
         CROSS JOIN avg_size a
WHERE os.order_qty > a.avg_qty;


-- For each brand, number products by price
SELECT brand_id,
       product_name,
       list_price,
       ROW_NUMBER() OVER (PARTITION BY brand_id ORDER BY list_price DESC) AS price_num
FROM products;


-- For each category, number products alphabetically
SELECT category_id,
       product_name,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY product_name) AS name_num
FROM products;


-- Rank stores by total stock
SELECT store_id,
       SUM(quantity)                             AS total_stock,
       RANK() OVER (ORDER BY SUM(quantity) DESC) AS store_rank
FROM stocks
GROUP BY store_id;


-- Rank brands by average product price
SELECT brand_id,
       AVG(list_price)                             AS avg_price,
       RANK() OVER (ORDER BY AVG(list_price) DESC) AS brand_rank
FROM products
GROUP BY brand_id;


-- Show each product with the average price of its brand
SELECT product_id,
       product_name,
       list_price,
       AVG(list_price) OVER (PARTITION BY brand_id) AS avg_brand_price
FROM products;


-- Show each order with the average order quantity of that customer
SELECT o.order_id,
       o.customer_id,
       AVG(oi.quantity) OVER (PARTITION BY o.customer_id) AS avg_customer_qty
FROM orders o
         JOIN order_items oi ON o.order_id = oi.order_id;


-- Show each stock row with the maximum stock of that product
SELECT store_id,
       product_id,
       quantity,
       MAX(quantity) OVER (PARTITION BY product_id) AS max_product_stock
FROM stocks;


-- Show each order with the previous order date of that customer (LAG)
SELECT order_id,
       customer_id,
       order_date,
       LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
FROM orders;


-- Show each product price and the previous product price in the same brand (LAG)
SELECT brand_id,
       product_name,
       list_price,
       LAG(list_price) OVER (PARTITION BY brand_id ORDER BY list_price) AS prev_price
FROM products;


-- Show each order and the next order date for the same customer (LEAD)
SELECT order_id,
       customer_id,
       order_date,
       LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date
FROM orders;


-- Show product price and the next higher-priced product (LEAD)
SELECT product_name,
       list_price,
       LEAD(list_price) OVER (ORDER BY list_price) AS next_price
FROM products;


-- Find customers whose latest order is bigger than their previous one
WITH order_totals AS (SELECT o.order_id, o.customer_id, o.order_date, SUM(oi.quantity) AS total_qty
                      FROM orders o
                               JOIN order_items oi ON o.order_id = oi.order_id
                      GROUP BY o.order_id, o.customer_id, o.order_date),
     ranked_orders AS (SELECT *,
                              LAG(total_qty) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_qty
                       FROM order_totals)
SELECT *
FROM ranked_orders
WHERE prev_qty IS NOT NULL
  AND total_qty > prev_qty;


-- Find brands where the most expensive product is 2× more than average
SELECT brand_id,
       MAX(list_price) AS max_price,
       AVG(list_price) AS avg_price
FROM products
GROUP BY brand_id
HAVING MAX(list_price) >= 2 * AVG(list_price);