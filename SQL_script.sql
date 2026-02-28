
CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;

-- Check if dates are in correct format and if there are nulls in prices
SELECT
	COUNT(*) as total_rows,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) as missing_data,
    MIN(order_purchase_timestamp) as start_date,
    Max(order_purchase_timestamp) as end_date
FROM olist_orders_dataset;
  
-- Problem 1 : Revenue Analysis
SELECT
	date_format(order_purchase_timestamp, '%Y-%m') AS order_month,
    round(SUM(p.payment_value), 2) AS monthly_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
Group by order_month
order by order_month;    
 
 -- Problem 2 : Seasonal Trends
SELECT
	dayname(order_purchase_timestamp) As day_of_week,
    count(order_id) AS total_orders
From olist_orders_dataset
Group by day_of_week
Order by total_orders DESC;

-- Problem 3: Payment Preferences 
SELECT
	payment_type,
    count(*) as count_of_payments,
    Sum(payment_installments) AS total_installments
FROM olist_order_payments_dataset
group by payment_type
order by count_of_payments DESC;

-- Data Transformation (ETL process in SQL).
SELECT 
	o.order_id,
    o.customer_id, 
    o.order_status,
    o.order_purchase_timestamp,
    t.product_category_name_english AS product_category,
    p.payment_type,
    p.payment_value,
    p.payment_installments, 
    c.customer_city, c.customer_state
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
JOIN olist_products_dataset	pr on i.product_id = pr.product_id
JOIN product_category_name_translation t on pr.product_category_name = t.ï»¿product_category_name
JOIN olist_customers_dataset c on  o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';

select * from olist_products_dataset