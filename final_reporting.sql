-- ============================================================================
-- Final Reporting Queries
-- ============================================================================



-- ============================================================================
-- 1. Monthly Sales Report
-- Required Columns:
-- Month, Total Orders, Total Revenue, Average Order Value
-- ============================================================================

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_value
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;



-- ============================================================================
-- 2. Top 10 Customers Report
-- Required Columns:
-- Customer Name, City, Total Orders, Total Spent, Rank
-- ============================================================================

SELECT *
FROM (
    SELECT 
        c.customer_name,
        c.city,
        COUNT(o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_spent,

        RANK() OVER (
            ORDER BY SUM(o.total_amount) DESC
        ) AS customer_rank

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_id, c.customer_name, c.city
) ranked_customers
WHERE customer_rank <= 10;



-- ============================================================================
-- 3. Product Sales Report
-- Required Columns:
-- Product Name, Category, Total Quantity Sold,
-- Total Revenue, Sales Rank
-- ============================================================================

SELECT 
    p.product_name,
    p.category,

    SUM(oi.quantity_ordered) AS total_quantity_sold,

    SUM(oi.quantity_ordered * oi.unit_price) AS total_revenue,

    RANK() OVER (
        ORDER BY SUM(oi.quantity_ordered * oi.unit_price) DESC
    ) AS sales_rank

FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY p.product_id, p.product_name, p.category;



-- ============================================================================
-- 4. Warehouse Stock Report
-- Required Columns:
-- Warehouse Name, City, Total Products,
-- Total Stock Quantity, Capacity Utilization %
-- ============================================================================

SELECT 
    w.warehouse_name,
    w.city,
	COUNT(DISTINCT i.product_id) AS total_products,
	SUM(i.quantity_available) AS total_stock_quantity,
	ROUND((SUM(i.quantity_available) / w.capacity) * 100,2) AS capacity_utilization_percentage
FROM warehouses w
JOIN inventory i
    ON w.warehouse_id = i.warehouse_id
GROUP BY 
    w.warehouse_id,
    w.warehouse_name,
    w.city,
    w.capacity;



-- ============================================================================
-- 5. Low Stock Alert Report
-- Required Columns:
-- Product Name, Available Quantity,
-- Reorder Level, Warehouse Name, Status
-- ============================================================================

SELECT 
    p.product_name,
    i.quantity_available AS available_quantity,
    p.reorder_level,
    w.warehouse_name,
    CASE
        WHEN i.quantity_available < p.reorder_level
        THEN 'LOW STOCK'
        ELSE 'SUFFICIENT STOCK'
    END AS status
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
JOIN warehouses w
    ON i.warehouse_id = w.warehouse_id
WHERE i.quantity_available < p.reorder_level;