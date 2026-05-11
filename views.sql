 ============================================================================
-- Views
-- ============================================================================

-- 40. Create customer order summary view

CREATE VIEW vw_customer_order_summary AS
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


-- View the data

SELECT *
FROM vw_customer_order_summary;


-- ============================================================================
-- 41. Create low-stock product view
-- ============================================================================

CREATE VIEW vw_low_stock_products AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    i.quantity_available,
    p.reorder_level
FROM products p
JOIN inventory i 
    ON p.product_id = i.product_id
WHERE i.quantity_available < p.reorder_level;


-- View the data

SELECT *
FROM vw_low_stock_products;


-- ============================================================================
-- 42. Create warehouse inventory view
-- ============================================================================

CREATE VIEW vw_warehouse_inventory AS
SELECT 
    w.warehouse_id,
    w.warehouse_name,
    p.product_name,
    i.quantity_available
FROM inventory i
JOIN warehouses w 
    ON i.warehouse_id = w.warehouse_id
JOIN products p 
    ON i.product_id = p.product_id;


-- View the data

SELECT *
FROM vw_warehouse_inventory;