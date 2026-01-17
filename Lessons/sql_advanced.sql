-- Find products that are more expensive than the avgerage product price

SELECT *
FROM products
WHERE list_price >
      (SELECT AVG(list_price)
       FROM products);


-- Find customers who have placed more orders than the average customer

SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (SELECT AVG(order_count)
                   FROM (SELECT COUNT(*) AS order_count
                         FROM orders
                         GROUP BY customer_id) t);


-- calculate average product price per brand, then show brands above average

WITH avg_product_price AS (SELECT brand_id,
                                  AVG(list_price) AS avg_price
                           FROM products
                           GROUP BY brand_id)
SELECT brand_id,
       avg_price
FROM avg_product_price
WHERE avg_price > (SELECT AVG(avg_price)
                   FROM avg_product_price)
ORDER BY avg_price DESC;


-- Assign row numbers to orders per customer ordered by date
SELECT order_id,
       customer_id,
       order_date,
       row_number() over (
           partition BY customer_id
           ORDER BY order_date
           ) AS order_number
FROM orders;

-- Rank products by price within each brand
SELECT product_id,
       brand_id,
       list_price,
       rank() over (
           partition BY brand_id
           ORDER BY list_price DESC
           ) AS price_rank
FROM products;

-- Show each product with the average price of its brand.
SELECT product_id,
       brand_id,
       list_price,
       AVG(list_price) over (
           partition BY brand_id
           ) AS avg_brand_price
FROM products;











