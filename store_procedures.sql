-- ============================================================================
-- Part K: Stored Procedures
-- ============================================================================

-- Objective:
-- Create stored procedures for common business operations.
-- ============================================================================


-- ============================================================================
-- 1. Procedure: place_order
-- ============================================================================

-- Logic:
-- 1. Accept customer ID, product ID, warehouse ID and quantity
-- 2. Check stock availability
-- 3. Insert order
-- 4. Insert order item
-- 5. Update inventory
-- 6. Insert stock movement
-- ============================================================================
DROP PROCEDURE IF EXISTS place_order;
DELIMITER $$

CREATE PROCEDURE place_order (
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_warehouse_id INT,
    IN p_quantity INT
)

BEGIN

    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_order_id INT;
    DECLARE v_total_amount DECIMAL(10,2);


    -- Get available stock

    SELECT quantity_available
    INTO v_stock
    FROM inventory
    WHERE product_id = p_product_id
      AND warehouse_id = p_warehouse_id;


    -- Check stock availability

    IF v_stock < p_quantity THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock available';

    ELSE

        -- Get product price

        SELECT unit_price
        INTO v_price
        FROM products
        WHERE product_id = p_product_id;


        -- Calculate total amount

        SET v_total_amount = v_price * p_quantity;


        -- Insert order

        INSERT INTO orders (
            customer_id,
            order_date,
            total_amount,
            order_status
        )
        VALUES (
            p_customer_id,
            CURRENT_DATE,
            v_total_amount,
            'Placed'
        );


        -- Get generated order ID

        SET v_order_id = LAST_INSERT_ID();


        -- Insert order item

        INSERT INTO order_items (
            order_id,
            product_id,
            quantity,
            unit_price
        )
        VALUES (
            v_order_id,
            p_product_id,
            p_quantity,
            v_price
        );


        -- Update inventory

        UPDATE inventory
        SET 
            quantity_available = quantity_available - p_quantity,
            last_updated = CURRENT_TIMESTAMP
        WHERE product_id = p_product_id
          AND warehouse_id = p_warehouse_id;


        -- Insert stock movement

        INSERT INTO stock_movements (
            product_id,
            warehouse_id,
            movement_type,
            quantity,
            movement_date
        )
        VALUES (
            p_product_id,
            p_warehouse_id,
            'OUT',
            p_quantity,
            CURRENT_TIMESTAMP
        );

    END IF;

END$$

DELIMITER ;


-- ============================================================================
-- 2. Procedure: restock_product
-- ============================================================================

-- Logic:
-- 1. Accept product ID, warehouse ID and quantity
-- 2. Increase inventory quantity
-- 3. Insert stock movement with movement_type = 'IN'
-- ============================================================================
DROP PROCEDURE IF EXISTS restock_product;
DELIMITER $$

CREATE PROCEDURE restock_product (
    IN p_product_id INT,
    IN p_warehouse_id INT,
    IN p_quantity INT
)

BEGIN

    -- Update inventory stock

    UPDATE inventory
    SET 
        quantity_available = quantity_available + p_quantity,
        last_updated = CURRENT_TIMESTAMP
    WHERE product_id = p_product_id
      AND warehouse_id = p_warehouse_id;


    -- Insert stock movement

    INSERT INTO stock_movements (
        product_id,
        warehouse_id,
        movement_type,
        quantity,
        movement_date
    )
    VALUES (
        p_product_id,
        p_warehouse_id,
        'IN',
        p_quantity,
        CURRENT_TIMESTAMP
    );

END$$

DELIMITER ;


-- ============================================================================
-- Execute Procedures
-- ============================================================================

-- Place Order

CALL place_order(1, 10, 2, 5);


-- Restock Product

CALL restock_product(10, 2, 20);


-- ============================================================================
-- Verify Results
-- ============================================================================

SELECT *
FROM inventory
WHERE product_id = 10;

SELECT *
FROM stock_movements
WHERE product_id = 10;