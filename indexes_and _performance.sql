-- ============================================================================
-- Part H: Indexes and Performance
-- ============================================================================

-- Objective:
-- Improve query performance using indexes and compare execution plans
-- before and after index creation.
-- ============================================================================


-- 35. Run a query BEFORE creating an index

SELECT *
FROM orders
WHERE customer_id = 11;


-- ============================================================================
-- 36. Check the execution plan BEFORE index creation
-- ============================================================================

EXPLAIN
SELECT *
FROM orders
WHERE customer_id = 11;


-- ============================================================================
-- 37. Create indexes
-- ============================================================================

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

CREATE INDEX idx_orders_order_date
ON orders(order_date);

CREATE INDEX idx_inventory_product_id
ON inventory(product_id);

CREATE INDEX idx_inventory_warehouse_id
ON inventory(warehouse_id);

CREATE INDEX idx_order_items_order_id
ON order_items(order_id);
-- ============================================================================
-- 38. Run the SAME query AFTER index creation
-- ============================================================================

SELECT *
FROM orders
WHERE customer_id = 1;


-- ============================================================================
-- 39. Check execution plan AFTER index creation
-- ============================================================================

EXPLAIN
SELECT *
FROM orders
WHERE customer_id = 1;


-- ============================================================================
-- Additional Performance Testing Queries
-- ============================================================================

-- Query using order_date index

EXPLAIN
SELECT *
FROM orders
WHERE order_date >= '2025-01-01';


-- Query using inventory product index

EXPLAIN
SELECT *
FROM inventory
WHERE product_id = 10;


-- Query using warehouse index

EXPLAIN
SELECT *
FROM inventory
WHERE warehouse_id = 2;


-- Query using order_items order_id index

EXPLAIN
SELECT *
FROM order_items
WHERE order_id = 5001;


-- ============================================================================
-- Performance Comparison Notes
-- ============================================================================

-- BEFORE INDEX:
-- - Full table scan may occur
-- - Higher query execution time
-- - More rows examined

-- AFTER INDEX:
-- - Index scan or seek is used
-- - Faster query execution
-- - Fewer rows examined
-- - Improved database performance

-- Common EXPLAIN Terms:
-- type = ALL        -> Full table scan
-- type = ref/range  -> Index usage
-- key               -> Index used
-- rows              -> Number of rows scanned
-- Extra             -> Additional execution details