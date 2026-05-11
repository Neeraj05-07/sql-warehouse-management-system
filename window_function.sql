-- ============================================================================
-- Window Function 
-- ============================================================================

-- 1. Rank products by sales using RANK, DENSE_RANK and ROW_NUMBER

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity_ordered * oi.unit_price) AS total_sales,

    RANK() OVER (
        ORDER BY SUM(oi.quantity_ordered * oi.unit_price) DESC
    ) AS rank_position,

    DENSE_RANK() OVER (
        ORDER BY SUM(oi.quantity_ordered * oi.unit_price) DESC
    ) AS dense_rank_position,

    ROW_NUMBER() OVER (
        ORDER BY SUM(oi.quantity_ordered * oi.unit_price) DESC
    ) AS row_num

FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name;


-- 2. Rank customers by revenue and find top 10 customers
SELECT *
FROM (
SELECT 
	c.customer_id,
	c.customer_name,
    sum(P.amount_paid) AS total_revenue,
	RANK() OVER (
            ORDER BY SUM(p.amount_paid) DESC) AS customer_rank    
FROM customers c 
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
LEFT JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_id, c.customer_name
)  cutomers_rank
WHERE customer_rank <= 10;

-- 3. Find the highest-stocked product in each warehouse

SELECT *
FROM (
    SELECT 
        w.warehouse_id,
        w.warehouse_name,
        p.product_id,
        p.product_name,
        i.quantity_available,
		ROW_NUMBER() OVER (
            PARTITION BY w.warehouse_id ORDER BY i.quantity_available DESC) AS stock_rank

    FROM inventory i
    JOIN warehouses w 
        ON i.warehouse_id = w.warehouse_id
    JOIN products p 
        ON i.product_id = p.product_id
) warehouse_stock
WHERE stock_rank = 1;

-- 4. -- 33. Calculate monthly running total of sales

SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS sales_month,
    SUM(amount_paid) AS monthly_sales,

    SUM(SUM(amount_paid)) OVER ( n
        ORDER BY DATE_FORMAT(payment_date, '%Y-%m')
    ) AS running_total_sales

FROM payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m');

-- 5. Rank orders by total amount within each month

SELECT 
    order_month,
    order_id,
    total_amount,
    RANK() OVER (PARTITION BY order_month ORDER BY total_amount DESC) AS monthly_order_rank
FROM (
    SELECT 
        order_id,
        total_amount,
        DATE_FORMAT(order_date, '%Y-%m') AS order_month
    FROM orders
) monthly_orders;