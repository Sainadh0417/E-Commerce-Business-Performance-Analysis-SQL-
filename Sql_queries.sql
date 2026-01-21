
-- E-Commerce Business Performance Analysis SQL Queries

-- 1. Total Revenue
SELECT ROUND(SUM(price),2) AS total_revenue
FROM order_items;

-- 2. Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- 3. Monthly Revenue Trend
SELECT 
DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS month,
ROUND(SUM(price),2) AS revenue
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- 4. Top 10 Products by Revenue
SELECT 
p.product_category_name,
ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- 5. City Wise Orders
SELECT 
c.customer_city,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c 
ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC;

-- 6. Payment Preference
SELECT 
payment_type,
COUNT(*) AS transactions
FROM payments
GROUP BY payment_type
ORDER BY transactions DESC;

-- 7. Late Deliveries
SELECT COUNT(*) AS late_orders
FROM orders
WHERE order_delivered_customer_date >
order_estimated_delivery_date;

-- 8. Average Review Score
SELECT ROUND(AVG(review_score),2) 
FROM reviews;

-- 9. Revenue Contribution (Window Function)
SELECT 
product_id,
SUM(price) AS revenue,
ROUND(
SUM(price)*100/
SUM(SUM(price)) OVER(),2
) AS revenue_percentage
FROM order_items
GROUP BY product_id;

-- 10. Repeat Customers
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- 11. Yearly Revenue
SELECT 
YEAR(order_purchase_timestamp) AS year,
SUM(price) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY year;

-- 12. Orders by Status
SELECT 
order_status,
COUNT(*) 
FROM orders
GROUP BY order_status;

-- 13. Average Delivery Time
SELECT 
AVG(DATEDIFF(order_delivered_customer_date,
order_purchase_timestamp)) 
AS avg_delivery_days
FROM orders;

-- 14. Highest Revenue City
SELECT 
c.customer_city,
SUM(oi.price) AS revenue
FROM orders o
JOIN customers c 
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 1;

-- 15. Orders per Customer
SELECT 
customer_id,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;
