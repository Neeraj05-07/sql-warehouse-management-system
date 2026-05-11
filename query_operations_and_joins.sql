-- ============================================================================
-- SQL WAREHOUSE MANAGEMENT 
-- ============================================================================
-- This script includes:
-- ============================================================================
-- Basic SQL Retrieval Queries and SQL Joins Operations
-- ============================================================================

-- 1. Show all products with price greater than 1000. 
SELECT *
FROM products
WHERE unit_price > 1000;

-- 2. Show all customers from a specific city. 
SELECT 
	city,
	COUNT(customer_id) AS total_customer    
FROM customers
GROUP BY city;

-- 3. Find all orders placed in the last 30 days. 
SELECT customer_id,
	order_date,
    order_status,
    total_amount
FROM orders
WHERE order_date BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW() AND 
	order_status = 'Delivered';
    
-- 4. Find total stock available for each product. 
SELECT product_id,
	SUM(quantity_available) AS total_stock
FROM inventory
GROUP BY product_id;

-- 5. Find total sales amount per customer. 

SELECT o.customer_id,
	SUM(o.total_amount) AS total_sale
FROM payments p
LEFT JOIN orders o ON p.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.customer_id
ORDER BY o.customer_id ASC;

-- 6. Find pending orders. 
SELECT 
	order_id,
    order_date,
    order_status AS pending_order,
    total_amount
FROM orders
WHERE order_status = 'Pending'
ORDER BY order_id ASC;

-- 7. Find products below reorder level. 
SELECT 
	p.product_id,
    p.product_name,
    i.quantity_available,
    p.reorder_level
FROM products p
LEFT JOIN inventory i
    ON p.product_id = i.product_id
WHERE i.quantity_available < p.reorder_level;


-- 8. Find warehouse-wise total inventory quantity. 
SELECT 
	w.warehouse_id,
    w.warehouse_name,
    w.city,
    w.state,
    sum(i.quantity_available) AS total_quantity
FROM warehouses w 
LEFT JOIN inventory i 
ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id;

-- 9. Find top 5 most expensive products. 
SELECT 
	product_id,
    product_name,
    category,
    unit_price AS price
FROM products
ORDER BY unit_price DESC
LIMIT 5;

-- 10. Find all orders with payment status as Failed or Pending.
 SELECT *
 FROM payments
 WHERE payment_status IN ('Failed', 'Pending');
 
 
 -- ============================================================================
 -- SQL Joins Operations
-- Demonstration of INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN
-- using warehouse management database tables.
-- ============================================================================

-- 1. Show order details with customer name. 
	SELECT 
		c.customer_id,
        c.customer_name,
        o.order_id,
        o.order_date,
        o.total_amount,
        o.order_status
    FROM orders o
    LEFT JOIN customers c
    ON  o.customer_id = c.customer_id;

-- 2. Show order items with product name and warehouse name. 
SELECT
	o.order_item_id,
    p.product_name,
    p.category,
    w.warehouse_name,
    w.city,
    o.unit_price
FROM order_items o
LEFT JOIN warehouses w
	ON o.warehouse_id = w.warehouse_id
LEFT JOIN products p
	ON o.product_id = P.product_id;


-- 3. Show customers who have not placed any orders. 
SELECT 
	c.customer_id,
    o.order_id,
    c.customer_name,
    c.city,
	o.order_date,
    o.total_amount AS amount,
    o.order_status
FROM customers c
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
WHERE NOT o.order_status IN ('Delivered', 'Cancelled');


-- 22. Show products that are not available in any warehouse. 

SELECT *
FROM products p 
LEFT JOIN inventory i
ON p.product_id = i.product_id
LEFT JOIN warehouses w
ON w.warehouse_id = i.warehouse_id
WHERE i.product_id IS NULL;

-- 23. Show warehouse-wise product stock. 
SELECT 
    w.warehouse_id,
    w.warehouse_name,
    p.product_id,
    p.product_name,
    SUM(i.quantity_available) AS total_stock
FROM warehouses w
INNER JOIN inventory i
    ON w.warehouse_id = i.warehouse_id
INNER JOIN products p
    ON i.product_id = p.product_id
GROUP BY w.warehouse_id, w.warehouse_name, p.product_id, p.product_name
ORDER BY w.warehouse_name, p.product_name;

-- 24. Show payment details with order and customer information. 
SELECT 
    p.payment_id,
    p.payment_date,
    p.amount_paid AS amount,
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.email
FROM payments p
INNER JOIN orders o 
    ON p.order_id = o.order_id
INNER JOIN customers c 
    ON o.customer_id = c.customer_id
ORDER BY p.payment_date DESC;



-- 25. Show shipment details with warehouse and customer information. 

SELECT 
    s.shipment_id,
    s.shipment_date,
    s.delivery_status,
    w.warehouse_id,
    w.warehouse_name,
    c.customer_id,
    c.customer_name,
    c.email
FROM shipments s
INNER JOIN warehouses w 
    ON s.warehouse_id = w.warehouse_id
INNER JOIN orders o 
    ON s.order_id = o.order_id
INNER JOIN customers c 
    ON o.customer_id = c.customer_id
ORDER BY s.shipment_date DESC;



-- ============================================================================
-- END OF JOIN OPERATIONS
-- ============================================================================
