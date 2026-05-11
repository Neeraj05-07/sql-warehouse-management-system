-- ============================================================================
-- Advanced Database Tasks
-- ============================================================================



-- ============================================================================
-- Add User Roles
-- Roles:
-- Admin
-- Warehouse Manager
-- Sales User
-- ============================================================================

-- Create Users

CREATE USER 'admin_user'@'localhost'
IDENTIFIED BY 'Admin@123';

CREATE USER 'warehouse_manager'@'localhost'
IDENTIFIED BY 'Warehouse@123';

CREATE USER 'sales_user'@'localhost'
IDENTIFIED BY 'Sales@123';


-- Grant Permissions

-- Admin Role

GRANT ALL PRIVILEGES
ON warehouse_management.*
TO 'admin_user'@'localhost';


-- Warehouse Manager Role

GRANT SELECT, INSERT, UPDATE
ON inventory
TO 'warehouse_manager'@'localhost';

GRANT SELECT
ON products
TO 'warehouse_manager'@'localhost';


-- Sales User Role

GRANT SELECT, INSERT
ON orders
TO 'sales_user'@'localhost';

GRANT SELECT, INSERT
ON order_items
TO 'sales_user'@'localhost';

GRANT SELECT
ON customers
TO 'sales_user'@'localhost';

FLUSH PRIVILEGES;



-- ============================================================================
-- 57. Create Audit Table for Order Updates
-- ============================================================================

CREATE TABLE order_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    updated_by VARCHAR(100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



-- ============================================================================
-- 58. Trigger to Log Order Status Changes
-- ============================================================================

DELIMITER $$

CREATE TRIGGER trg_order_status_audit
AFTER UPDATE
ON orders
FOR EACH ROW
BEGIN

    -- Check whether order status changed
    IF OLD.order_status <> NEW.order_status THEN
        INSERT INTO order_audit_log (
            order_id,
            old_status,
            new_status,
            updated_by,
            updated_at
        )

        VALUES (
            OLD.order_id,
            OLD.order_status,
            NEW.order_status,
            CURRENT_USER(),
            CURRENT_TIMESTAMP
        );
    END IF;
END$$

DELIMITER ;



-- ============================================================================
-- Test Trigger
-- ============================================================================

UPDATE orders
SET order_status = 'Delivered'
WHERE order_id = 1;


-- Verify Audit Log

SELECT *
FROM order_audit_log;



-- ============================================================================
-- 59. Partition Orders Table by Month
-- ============================================================================

-- Example:
-- Partitioning based on order_date

CREATE TABLE orders_partitioned (

    order_id INT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(50)

)

PARTITION BY RANGE (MONTH(order_date)) (
    PARTITION p_jan VALUES LESS THAN (2),
    PARTITION p_feb VALUES LESS THAN (3),
    PARTITION p_mar VALUES LESS THAN (4),
    PARTITION p_apr VALUES LESS THAN (5),
    PARTITION p_may VALUES LESS THAN (6),
    PARTITION p_jun VALUES LESS THAN (7),
    PARTITION p_jul VALUES LESS THAN (8),
    PARTITION p_aug VALUES LESS THAN (9),
    PARTITION p_sep VALUES LESS THAN (10),
    PARTITION p_oct VALUES LESS THAN (11),
    PARTITION p_nov VALUES LESS THAN (12),
    PARTITION p_dec VALUES LESS THAN (13)
);



-- ============================================================================
-- 60. Materialized View for Monthly Sales Summary
-- ============================================================================

-- MySQL does not support real materialized views directly.
-- Alternative:
-- Create a summary table and refresh manually.

CREATE TABLE monthly_sales_summary AS

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,

    COUNT(order_id) AS total_orders,

    SUM(total_amount) AS total_revenue,

    AVG(total_amount) AS average_order_value

FROM orders

GROUP BY DATE_FORMAT(order_date, '%Y-%m');



-- Refresh Materialized View

TRUNCATE TABLE monthly_sales_summary;

INSERT INTO monthly_sales_summary

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,

    COUNT(order_id) AS total_orders,

    SUM(total_amount) AS total_revenue,

    AVG(total_amount) AS average_order_value

FROM orders

GROUP BY DATE_FORMAT(order_date, '%Y-%m');



-- ============================================================================
-- 61. Add Exception Handling Inside Stored Procedures
-- ============================================================================

DELIMITER $$

CREATE PROCEDURE safe_place_order (

    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT

)

BEGIN

    -- Exception handling

    DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN

        ROLLBACK;

        SELECT 'Order failed due to an exception'
        AS error_message;

    END;


    START TRANSACTION;


    -- Example order insertion

    INSERT INTO orders (

        customer_id,
        order_date,
        total_amount,
        order_status

    )

    VALUES (

        p_customer_id,
        CURRENT_DATE,
        1000,
        'Pending'

    );


    COMMIT;

END$$

DELIMITER ;



