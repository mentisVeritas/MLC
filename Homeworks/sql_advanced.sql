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
WITH store_sales AS (SELECT o.store_id, oi.quantity
                     FROM orders o
                              JOIN order_items oi ON o.order_id = oi.order_id)
SELECT store_id, SUM(quantity) AS total_items_sold
FROM store_sales
GROUP BY store_id;


-- Using a CTE, detect customers with unusually large orders
WITH order_size AS (SELECT o.order_id, o.customer_id, SUM(oi.quantity) AS order_qty
                    FROM orders o
                             JOIN order_items oi ON o.order_id = oi.order_id
                    GROUP BY o.order_id, o.customer_id
                    ORDER BY order_qty DESC),
     avg_size AS (SELECT AVG(order_qty) AS avg_qty
                  FROM order_size)
SELECT *
FROM order_size
         JOIN avg_size a ON TRUE
WHERE order_qty > avg_qty;


-- For each brand, number products by price
SELECT brand_id, list_price, RANK() OVER (PARTITION BY br)
FROM products
ORDER BY ;

-- For each category, number products alphabetically

-- Rank stores by total stock


-- Rank brands by average product price


-- Show each product with the average price of its brand


-- Show each order with the average order quantity of that customer

-- Show each stock row with the maximum stock of that product


-- Show each order with the previous order date of that customer (LAG)


-- Show each product price and the previous product price in the same brand (LAG)

-- Show each order and the next order date for the same customer (LEAD)


-- Show product price and the next higher-priced product (LEAD)


-- Find customers whose latest order is bigger than their previous one

-- Find brands where the most expensive product is 2× more than average