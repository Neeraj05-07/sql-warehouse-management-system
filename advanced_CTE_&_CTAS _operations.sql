-- ============================================================================
-- Common Table Expression (CTE) 
-- Warehouse Management Database Project
-- ============================================================================
-- This file contains SQL queries using Common Table Expressions (CTEs)
-- for business analysis and reporting purposes.
--
-- 
-- Included Tasks:
-- 1. High-value customers analysis
-- 2. Low-stock products identification
-- 3. Monthly sales summary report
-- 4. Cancelled order analysis
-- ============================================================================



-- 1. High-value customers analysis
WITH high_value_customers AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(p.amount_paid) AS total_spent,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    INNER JOIN orders o 
        ON c.customer_id = o.customer_id
    INNER JOIN payments p 
        ON o.order_id = p.order_id
    GROUP BY c.customer_id, c.customer_name
    HAVING SUM(p.amount_paid) > 10000   -- threshold for "high-value"
)
SELECT 
    h.customer_id,
    h.customer_name,
    h.total_spent,
    h.total_orders,
    MAX(o.order_date) AS last_order_date
FROM high_value_customers h
INNER JOIN orders o 
    ON h.customer_id = o.customer_id
GROUP BY h.customer_id, h.customer_name, h.total_spent, h.total_orders
ORDER BY h.total_spent DESC;

-- 2. Low-stock products identification
WITH low_stock_products AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.reorder_level,
        SUM(i.quantity_available) AS total_available_stock
    FROM products p
    INNER JOIN inventory i
        ON p.product_id = i.product_id
    GROUP BY 
        p.product_id,
        p.product_name,
        p.category,
        p.reorder_level
    HAVING SUM(i.quantity_available) < p.reorder_level
)

SELECT *
FROM low_stock_products
ORDER BY total_available_stock ASC;


-- 3. Monthly sales summary report


WITH monthly_sales_summary AS (
    SELECT 
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        COUNT(o.order_id) AS total_orders,
        SUM(p.amount_paid) AS total_sales,
        AVG(p.amount_paid) AS average_order_value
    FROM orders o
    INNER JOIN payments p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY 
        YEAR(o.order_date),
        MONTH(o.order_date)
)

SELECT 
    sales_year,
    sales_month,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(average_order_value, 2) AS average_order_value
FROM monthly_sales_summary
ORDER BY sales_year DESC, sales_month DESC;

-- ============================================================================
-- 4. Cancelled Order Analysis
-- Identify customers who cancelled more than 2 orders
-- ============================================================================

WITH cancelled_order_analysis AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) AS cancelled_orders
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Cancelled'
    GROUP BY 
        c.customer_id,
        c.customer_name
    HAVING COUNT(o.order_id)> 2 
)

SELECT *
FROM cancelled_order_analysis
ORDER BY cancelled_orders DESC; 


-- ============================================================================
-- This section creates summary tables using CTAS operations.
-- CTAS is used to create a new table directly from the result of
-- a SELECT query.
-- ============================================================================

-- Montly sales summary
CREATE TABLE monthly_sales_summary AS 
SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS sales_month, 
    SUM(total_amount) AS total_sales, 
    COUNT(order_id) AS total_orders 
FROM orders 
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01');

-- Wharehouse stock summary
 
CREATE TABLE warehouse_stock_summary AS 
SELECT 
    warehouse_id, 
    SUM(quantity_available) AS total_stock 
FROM inventory 
GROUP BY warehouse_id; 

USE warehouse_management;