-- ============================================================================
-- SQL WAREHOUSE MANAGEMENT 
-- ============================================================================
-- This script includes:
-- Part A: DDL Tasks (Table Creation)
-- Part B: DML Tasks (Sample Data Insertion)
-- ============================================================================
DROP DATABASE IF EXISTS warehouse_management;
CREATE DATABASE warehouse_management;
 
Use warehouse_management;

-- ============================================================================
-- PART A: DDL TASKS - CREATE ALL TABLES
-- ============================================================================

-- Drop tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS stock_movements;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS warehouses;

-- 1. WAREHOUSES TABLE
CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. SUPPLIERS TABLE
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- 3. PRODUCTS TABLE
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    reorder_level INT NOT NULL CHECK (reorder_level >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. INVENTORY TABLE
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_available INT NOT NULL CHECK (quantity_available >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    UNIQUE KEY unique_warehouse_product (warehouse_id, product_id)
);

-- 6. ORDERS TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
        CHECK (order_status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount > 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 7. ORDER_ITEMS TABLE
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    line_total NUMERIC(12,2) NOT NULL CHECK (line_total > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- 8. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
        CHECK (payment_status IN ('Pending', 'Completed', 'Failed')),
    amount_paid NUMERIC(12,2) NOT NULL CHECK (amount_paid > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 9. SHIPMENTS TABLE
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    shipment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
        CHECK (delivery_status IN ('Pending', 'In Transit', 'Delivered', 'Failed')),
    delivery_city VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- 10. STOCK_MOVEMENTS TABLE
CREATE TABLE stock_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    movement_type VARCHAR(10) NOT NULL CHECK (movement_type IN ('IN', 'OUT')),
    quantity INT NOT NULL CHECK (quantity > 0),
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

-- ============================================================================
-- PART B: DML TASKS - INSERT SAMPLE DATA
-- ============================================================================

-- ============================================================================
-- 1. INSERT WAREHOUSES (5 records)
-- ============================================================================
INSERT INTO warehouses (warehouse_name, city, state, capacity) VALUES
('Central Warehouse', 'Mumbai', 'Maharashtra', 10000),
('North Distribution Hub', 'Delhi', 'Delhi', 8000),
('South Storage Center', 'Bangalore', 'Karnataka', 7500),
('East Logistics Park', 'Kolkata', 'West Bengal', 6500),
('West Regional Center', 'Ahmedabad', 'Gujarat', 9000);

-- ============================================================================
-- 2. INSERT SUPPLIERS (10 records)
-- ============================================================================
INSERT INTO suppliers (supplier_name, contact_email, city) VALUES
('TechCore Industries', 'contact@techcore.com', 'Pune'),
('Global Electronics Ltd', 'sales@globalelect.com', 'Bangalore'),
('Premium Manufacturing', 'info@premiummanuf.com', 'Hyderabad'),
('Quality Imports Co', 'orders@qualityimports.com', 'Chennai'),
('Industrial Solutions', 'support@indsolutions.com', 'Surat'),
('Advanced Components', 'sales@advcomp.com', 'Delhi'),
('Standard Products Inc', 'contact@stdproducts.com', 'Mumbai'),
('Precision Parts Ltd', 'info@precisionparts.com', 'Nagpur'),
('Export Traders Group', 'trade@exporttraders.com', 'Cochin'),
('Bulk Distributors', 'bulk@distributors.com', 'Indore');

-- ============================================================================
-- 3. INSERT PRODUCTS (20 records)
-- ============================================================================
INSERT INTO products (product_name, category, unit_price, reorder_level) VALUES
('Laptop Pro 15', 'Electronics', 85000.00, 10),
('USB Type-C Cable', 'Accessories', 599.00, 100),
('Wireless Mouse', 'Peripherals', 1299.00, 50),
('Mechanical Keyboard', 'Peripherals', 5999.00, 25),
('4K Monitor', 'Electronics', 28999.00, 8),
('Router 5G WiFi', 'Networking', 8999.00, 15),
('Portable SSD 1TB', 'Storage', 12999.00, 20),
('Desktop CPU Cooler', 'Components', 3499.00, 30),
('Power Supply 750W', 'Components', 6999.00, 12),
('Phone Screen Protector', 'Accessories', 299.00, 150),
('HDMI 2.1 Cable', 'Cables', 899.00, 80),
('Webcam 1080p', 'Peripherals', 4499.00, 18),
('Gaming Headset', 'Audio', 7999.00, 22),
('USB Hub 7 Port', 'Accessories', 2499.00, 35),
('Laptop Stand', 'Accessories', 1999.00, 40),
('RAM 16GB DDR4', 'Components', 9999.00, 15),
('NVMe SSD 500GB', 'Storage', 7499.00, 25),
('Cooling Pad', 'Accessories', 3999.00, 20),
('Phone Stand', 'Accessories', 799.00, 100),
('Cable Organizer', 'Accessories', 499.00, 120);

-- ============================================================================
-- 4. INSERT CUSTOMERS (30 records)
-- ============================================================================
INSERT INTO customers (customer_name, email, city) VALUES
('Rajesh Kumar', 'rajesh.kumar@email.com', 'Mumbai'),
('Priya Sharma', 'priya.sharma@email.com', 'Delhi'),
('Amit Patel', 'amit.patel@email.com', 'Bangalore'),
('Neha Singh', 'neha.singh@email.com', 'Pune'),
('Vikram Desai', 'vikram.desai@email.com', 'Hyderabad'),
('Anjali Verma', 'anjali.verma@email.com', 'Chennai'),
('Rohan Gupta', 'rohan.gupta@email.com', 'Kolkata'),
('Divya Menon', 'divya.menon@email.com', 'Kochi'),
('Sanjay Reddy', 'sanjay.reddy@email.com', 'Bangalore'),
('Megha Nair', 'megha.nair@email.com', 'Delhi'),
('Arjun Singh', 'arjun.singh@email.com', 'Mumbai'),
('Pooja Iyer', 'pooja.iyer@email.com', 'Chennai'),
('Kabir Khan', 'kabir.khan@email.com', 'Pune'),
('Sneha Das', 'sneha.das@email.com', 'Kolkata'),
('Varun Joshi', 'varun.joshi@email.com', 'Ahmedabad'),
('Sakshi Rao', 'sakshi.rao@email.com', 'Bangalore'),
('Nikhil Sharma', 'nikhil.sharma@email.com', 'Hyderabad'),
('Isha Kapoor', 'isha.kapoor@email.com', 'Delhi'),
('Abhishek Singh', 'abhishek.singh@email.com', 'Mumbai'),
('Riya Bansal', 'riya.bansal@email.com', 'Gurgaon'),
('Karan Malhotra', 'karan.malhotra@email.com', 'Noida'),
('Ananya Bhat', 'ananya.bhat@email.com', 'Bangalore'),
('Harsh Verma', 'harsh.verma@email.com', 'Pune'),
('Simran Kaur', 'simran.kaur@email.com', 'Chandigarh'),
('Aditya Yadav', 'aditya.yadav@email.com', 'Lucknow'),
('Nisha Prabhu', 'nisha.prabhu@email.com', 'Chennai'),
('Rahul Chopra', 'rahul.chopra@email.com', 'Delhi'),
('Maya Sinha', 'maya.sinha@email.com', 'Kolkata'),
('Aryan Sethi', 'aryan.sethi@email.com', 'Jaipur'),
('Zara Malik', 'zara.malik@email.com', 'Lahore');

-- ============================================================================
-- 5. INSERT INVENTORY (Multiple products across warehouses)
-- ============================================================================
INSERT INTO inventory (warehouse_id, product_id, quantity_available) VALUES
-- Warehouse 1 (Mumbai)
(1, 1, 45), (1, 2, 200), (1, 3, 85), (1, 4, 32), (1, 5, 18),
(1, 6, 25), (1, 7, 40), (1, 8, 55), (1, 9, 28), (1, 10, 150),
(1, 11, 120), (1, 12, 35), (1, 13, 42), (1, 14, 65), (1, 15, 75),
-- Warehouse 2 (Delhi)
(2, 1, 38), (2, 2, 180), (2, 3, 92), (2, 4, 28), (2, 5, 22),
(2, 6, 19), (2, 7, 35), (2, 8, 48), (2, 9, 32), (2, 10, 160),
(2, 16, 50), (2, 17, 68), (2, 18, 45), (2, 19, 180), (2, 20, 140),
-- Warehouse 3 (Bangalore)
(3, 1, 52), (3, 2, 220), (3, 3, 78), (3, 4, 38), (3, 5, 20),
(3, 6, 28), (3, 7, 42), (3, 8, 60), (3, 9, 35), (3, 10, 175),
(3, 11, 130), (3, 12, 40), (3, 13, 48), (3, 14, 72), (3, 15, 88),
-- Warehouse 4 (Kolkata)
(4, 1, 35), (4, 2, 195), (4, 3, 88), (4, 4, 30), (4, 5, 16),
(4, 6, 22), (4, 7, 38), (4, 8, 52), (4, 9, 30), (4, 10, 155),
(4, 16, 55), (4, 17, 62), (4, 18, 50), (4, 19, 190), (4, 20, 135),
-- Warehouse 5 (Ahmedabad)
(5, 1, 48), (5, 2, 210), (5, 3, 95), (5, 4, 35), (5, 5, 24),
(5, 6, 26), (5, 7, 44), (5, 8, 58), (5, 9, 33), (5, 10, 170),
(5, 11, 125), (5, 12, 38), (5, 13, 50), (5, 14, 70), (5, 15, 82);

-- ============================================================================
-- 6. INSERT ORDERS (100 records spread over last 90 days)
-- ============================================================================
INSERT INTO orders (customer_id, order_date, order_status, total_amount) VALUES
(1, DATE_SUB(NOW(), INTERVAL 85 DAY), 'Delivered', 125000.00),
(2, DATE_SUB(NOW(), INTERVAL 84 DAY), 'Delivered', 89999.00),
(3, DATE_SUB(NOW(), INTERVAL 83 DAY), 'Delivered', 145000.00),
(4, DATE_SUB(NOW(), INTERVAL 82 DAY), 'Delivered', 67500.00),
(5, DATE_SUB(NOW(), INTERVAL 81 DAY), 'Shipped', 98600.00),
(6, DATE_SUB(NOW(), INTERVAL 80 DAY), 'Delivered', 156000.00),
(7, DATE_SUB(NOW(), INTERVAL 79 DAY), 'Delivered', 75300.00),
(8, DATE_SUB(NOW(), INTERVAL 78 DAY), 'Shipped', 112400.00),
(9, DATE_SUB(NOW(), INTERVAL 77 DAY), 'Delivered', 89999.00),
(10, DATE_SUB(NOW(), INTERVAL 76 DAY), 'Delivered', 134500.00),
(11, DATE_SUB(NOW(), INTERVAL 75 DAY), 'Delivered', 65800.00),
(12, DATE_SUB(NOW(), INTERVAL 74 DAY), 'Delivered', 128900.00),
(13, DATE_SUB(NOW(), INTERVAL 73 DAY), 'Shipped', 92300.00),
(14, DATE_SUB(NOW(), INTERVAL 72 DAY), 'Delivered', 145600.00),
(15, DATE_SUB(NOW(), INTERVAL 71 DAY), 'Cancelled', 78500.00),
(16, DATE_SUB(NOW(), INTERVAL 70 DAY), 'Delivered', 156700.00),
(17, DATE_SUB(NOW(), INTERVAL 69 DAY), 'Delivered', 85400.00),
(18, DATE_SUB(NOW(), INTERVAL 68 DAY), 'Delivered', 125600.00),
(19, DATE_SUB(NOW(), INTERVAL 67 DAY), 'Shipped', 98700.00),
(20, DATE_SUB(NOW(), INTERVAL 66 DAY), 'Delivered', 142300.00),
(1, DATE_SUB(NOW(), INTERVAL 65 DAY), 'Delivered', 67600.00),
(2, DATE_SUB(NOW(), INTERVAL 64 DAY), 'Delivered', 115900.00),
(3, DATE_SUB(NOW(), INTERVAL 63 DAY), 'Delivered', 89500.00),
(4, DATE_SUB(NOW(), INTERVAL 62 DAY), 'Shipped', 128700.00),
(5, DATE_SUB(NOW(), INTERVAL 61 DAY), 'Delivered', 145800.00),
(6, DATE_SUB(NOW(), INTERVAL 60 DAY), 'Delivered', 76400.00),
(7, DATE_SUB(NOW(), INTERVAL 59 DAY), 'Delivered', 125500.00),
(8, DATE_SUB(NOW(), INTERVAL 58 DAY), 'Shipped', 98600.00),
(9, DATE_SUB(NOW(), INTERVAL 57 DAY), 'Delivered', 134500.00),
(10, DATE_SUB(NOW(), INTERVAL 56 DAY), 'Delivered', 85700.00),
(11, DATE_SUB(NOW(), INTERVAL 55 DAY), 'Delivered', 156900.00),
(12, DATE_SUB(NOW(), INTERVAL 54 DAY), 'Cancelled', 92400.00),
(13, DATE_SUB(NOW(), INTERVAL 53 DAY), 'Delivered', 125600.00),
(14, DATE_SUB(NOW(), INTERVAL 52 DAY), 'Delivered', 145700.00),
(15, DATE_SUB(NOW(), INTERVAL 51 DAY), 'Shipped', 78600.00),
(16, DATE_SUB(NOW(), INTERVAL 50 DAY), 'Delivered', 89500.00),
(17, DATE_SUB(NOW(), INTERVAL 49 DAY), 'Delivered', 128800.00),
(18, DATE_SUB(NOW(), INTERVAL 48 DAY), 'Shipped', 98700.00),
(19, DATE_SUB(NOW(), INTERVAL 47 DAY), 'Delivered', 142400.00),
(20, DATE_SUB(NOW(), INTERVAL 46 DAY), 'Delivered', 67700.00),
(1, DATE_SUB(NOW(), INTERVAL 45 DAY), 'Delivered', 115800.00),
(2, DATE_SUB(NOW(), INTERVAL 44 DAY), 'Delivered', 89600.00),
(3, DATE_SUB(NOW(), INTERVAL 43 DAY), 'Delivered', 128900.00),
(4, DATE_SUB(NOW(), INTERVAL 42 DAY), 'Shipped', 145900.00),
(5, DATE_SUB(NOW(), INTERVAL 41 DAY), 'Delivered', 76500.00),
(6, DATE_SUB(NOW(), INTERVAL 40 DAY), 'Delivered', 125600.00),
(7, DATE_SUB(NOW(), INTERVAL 39 DAY), 'Cancelled', 98800.00),
(8, DATE_SUB(NOW(), INTERVAL 38 DAY), 'Delivered', 134600.00),
(9, DATE_SUB(NOW(), INTERVAL 37 DAY), 'Delivered', 85800.00),
(10, DATE_SUB(NOW(), INTERVAL 36 DAY), 'Delivered', 157000.00),
(11, DATE_SUB(NOW(), INTERVAL 35 DAY), 'Delivered', 92500.00),
(12, DATE_SUB(NOW(), INTERVAL 34 DAY), 'Shipped', 125700.00),
(13, DATE_SUB(NOW(), INTERVAL 33 DAY), 'Delivered', 145800.00),
(14, DATE_SUB(NOW(), INTERVAL 32 DAY), 'Delivered', 78700.00),
(15, DATE_SUB(NOW(), INTERVAL 31 DAY), 'Delivered', 89600.00),
(16, DATE_SUB(NOW(), INTERVAL 30 DAY), 'Shipped', 128900.00),
(17, DATE_SUB(NOW(), INTERVAL 29 DAY), 'Delivered', 98900.00),
(18, DATE_SUB(NOW(), INTERVAL 28 DAY), 'Delivered', 142500.00),
(19, DATE_SUB(NOW(), INTERVAL 27 DAY), 'Delivered', 67800.00),
(20, DATE_SUB(NOW(), INTERVAL 26 DAY), 'Delivered', 115900.00),
(1, DATE_SUB(NOW(), INTERVAL 25 DAY), 'Pending', 89700.00),
(2, DATE_SUB(NOW(), INTERVAL 24 DAY), 'Shipped', 129000.00),
(3, DATE_SUB(NOW(), INTERVAL 23 DAY), 'Delivered', 146000.00),
(4, DATE_SUB(NOW(), INTERVAL 22 DAY), 'Delivered', 76600.00),
(5, DATE_SUB(NOW(), INTERVAL 21 DAY), 'Delivered', 125700.00),
(6, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Delivered', 98900.00),
(7, DATE_SUB(NOW(), INTERVAL 19 DAY), 'Shipped', 134700.00),
(8, DATE_SUB(NOW(), INTERVAL 18 DAY), 'Delivered', 85900.00),
(9, DATE_SUB(NOW(), INTERVAL 17 DAY), 'Delivered', 157100.00),
(10, DATE_SUB(NOW(), INTERVAL 16 DAY), 'Cancelled', 92600.00),
(11, DATE_SUB(NOW(), INTERVAL 15 DAY), 'Delivered', 125800.00),
(12, DATE_SUB(NOW(), INTERVAL 14 DAY), 'Delivered', 145900.00),
(13, DATE_SUB(NOW(), INTERVAL 13 DAY), 'Pending', 78800.00),
(14, DATE_SUB(NOW(), INTERVAL 12 DAY), 'Shipped', 89700.00),
(15, DATE_SUB(NOW(), INTERVAL 11 DAY), 'Delivered', 129000.00),
(16, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Delivered', 99000.00),
(17, DATE_SUB(NOW(), INTERVAL 9 DAY), 'Delivered', 142600.00),
(18, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Shipped', 67900.00),
(19, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Delivered', 116000.00),
(20, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Delivered', 89800.00),
(1, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Pending', 129100.00),
(2, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Shipped', 146100.00),
(3, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Delivered', 76700.00),
(4, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Pending', 125800.00),
(5, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Pending', 99100.00),
(11, DATE_SUB(NOW(), INTERVAL 15 DAY), 'Delivered', 125800.00),
(12, DATE_SUB(NOW(), INTERVAL 14 DAY), 'Delivered', 145900.00),
(13, DATE_SUB(NOW(), INTERVAL 13 DAY), 'Pending', 78800.00),
(14, DATE_SUB(NOW(), INTERVAL 12 DAY), 'Shipped', 89700.00),
(15, DATE_SUB(NOW(), INTERVAL 11 DAY), 'Delivered', 129000.00),
(16, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Delivered', 99000.00),
(17, DATE_SUB(NOW(), INTERVAL 9 DAY), 'Delivered', 142600.00),
(18, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Shipped', 67900.00),
(19, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Delivered', 116000.00),
(20, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Delivered', 89800.00),
(1, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Pending', 129100.00),
(2, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Shipped', 146100.00),
(3, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Delivered', 76700.00),
(4, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Pending', 125800.00),
(5, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Pending', 99100.00);

-- ============================================================================
-- 7. INSERT ORDER_ITEMS (250 records)
-- ============================================================================
INSERT INTO order_items (order_id, product_id, warehouse_id, quantity_ordered, unit_price, line_total) VALUES
(1, 1, 1, 1, 85000.00, 85000.00), (1, 2, 1, 40, 599.00, 23960.00), (1, 3, 1, 1, 1299.00, 1299.00),
(2, 4, 2, 1, 5999.00, 5999.00), (2, 5, 2, 1, 28999.00, 28999.00), (2, 6, 2, 1, 8999.00, 8999.00),
(3, 7, 1, 1, 12999.00, 12999.00), (3, 8, 1, 2, 3499.00, 6998.00), (3, 9, 1, 1, 6999.00, 6999.00), (3, 10, 1, 50, 299.00, 14950.00), (3, 11, 1, 20, 899.00, 17980.00), (3, 12, 1, 2, 4499.00, 8998.00),
(4, 13, 2, 1, 7999.00, 7999.00), (4, 14, 2, 2, 2499.00, 4998.00), (4, 15, 2, 2, 1999.00, 3999.00), (4, 16, 2, 2, 9999.00, 19998.00), (4, 17, 2, 2, 7499.00, 14998.00),
(5, 1, 3, 1, 85000.00, 85000.00), (5, 6, 3, 1, 8999.00, 8999.00), (5, 18, 3, 1, 3999.00, 3999.00),
(6, 5, 1, 1, 28999.00, 28999.00), (6, 8, 1, 3, 3499.00, 10497.00), (6, 11, 1, 30, 899.00, 26970.00), (6, 13, 1, 2, 7999.00, 15998.00), (6, 19, 1, 50, 799.00, 39950.00), (6, 20, 1, 60, 499.00, 29940.00),
(7, 2, 2, 50, 599.00, 29950.00), (7, 14, 2, 3, 2499.00, 7497.00), (7, 18, 2, 1, 3999.00, 3999.00), (7, 19, 2, 30, 799.00, 23970.00),
(8, 1, 3, 1, 85000.00, 85000.00), (8, 4, 3, 1, 5999.00, 5999.00), (8, 7, 3, 1, 12999.00, 12999.00), (8, 10, 3, 40, 299.00, 11960.00),
(9, 3, 4, 2, 1299.00, 2598.00), (9, 9, 4, 1, 6999.00, 6999.00), (9, 15, 4, 3, 1999.00, 5997.00), (9, 17, 4, 2, 7499.00, 14998.00), (9, 20, 4, 80, 499.00, 39920.00),
(10, 1, 5, 1, 85000.00, 85000.00), (10, 11, 5, 25, 899.00, 22475.00), (10, 13, 5, 2, 7999.00, 15998.00), (10, 18, 5, 1, 3999.00, 3999.00),
(11, 2, 1, 35, 599.00, 20965.00), (11, 5, 1, 1, 28999.00, 28999.00), (11, 8, 1, 2, 3499.00, 6998.00),
(12, 4, 2, 1, 5999.00, 5999.00), (12, 12, 2, 2, 4499.00, 8998.00), (12, 14, 2, 3, 2499.00, 7497.00), (12, 16, 2, 1, 9999.00, 9999.00), (12, 19, 2, 40, 799.00, 31960.00), (12, 20, 2, 50, 499.00, 24950.00),
(13, 1, 3, 1, 85000.00, 85000.00), (13, 3, 3, 1, 1299.00, 1299.00), (13, 6, 3, 1, 8999.00, 8999.00),
(14, 5, 4, 1, 28999.00, 28999.00), (14, 7, 4, 1, 12999.00, 12999.00), (14, 9, 4, 1, 6999.00, 6999.00), (14, 13, 4, 2, 7999.00, 15998.00), (14, 15, 4, 2, 1999.00, 3999.00), (14, 17, 4, 1, 7499.00, 7499.00), (14, 18, 4, 3, 3999.00, 11997.00), (14, 20, 4, 70, 499.00, 34930.00),
(15, 2, 5, 45, 599.00, 26955.00), (15, 10, 5, 60, 299.00, 17940.00), (15, 19, 5, 35, 799.00, 27965.00),
(16, 1, 1, 1, 85000.00, 85000.00), (16, 4, 1, 1, 5999.00, 5999.00), (16, 8, 1, 3, 3499.00, 10497.00), (16, 12, 1, 2, 4499.00, 8998.00), (16, 14, 1, 4, 2499.00, 9996.00), (16, 16, 1, 1, 9999.00, 9999.00), (16, 17, 1, 1, 7499.00, 7499.00), (16, 18, 1, 2, 3999.00, 7998.00), (16, 20, 1, 30, 499.00, 14970.00),
(17, 3, 2, 3, 1299.00, 3897.00), (17, 6, 2, 1, 8999.00, 8999.00), (17, 11, 2, 25, 899.00, 22475.00), (17, 13, 2, 2, 7999.00, 15998.00), (17, 15, 2, 4, 1999.00, 7996.00), (17, 19, 2, 35, 799.00, 27965.00),
(18, 1, 3, 1, 85000.00, 85000.00), (18, 5, 3, 1, 28999.00, 28999.00), (18, 9, 3, 1, 6999.00, 6999.00),
(19, 2, 4, 40, 599.00, 23960.00), (19, 7, 4, 1, 12999.00, 12999.00), (19, 12, 4, 2, 4499.00, 8998.00), (19, 16, 4, 2, 9999.00, 19998.00), (19, 18, 4, 2, 3999.00, 7999.00), (19, 20, 4, 65, 499.00, 32435.00),
(20, 1, 5, 1, 85000.00, 85000.00), (20, 4, 5, 1, 5999.00, 5999.00), (20, 10, 5, 50, 299.00, 14950.00), (20, 13, 5, 2, 7999.00, 15998.00), (20, 14, 5, 3, 2499.00, 7497.00), (20, 15, 5, 2, 1999.00, 3999.00), (20, 17, 5, 2, 7499.00, 14998.00),
(21, 2, 1, 35, 599.00, 20965.00), (21, 3, 1, 1, 1299.00, 1299.00), (21, 8, 1, 2, 3499.00, 6998.00), (21, 11, 1, 22, 899.00, 19778.00),
(22, 5, 2, 1, 28999.00, 28999.00), (22, 6, 2, 1, 8999.00, 8999.00), (22, 12, 2, 2, 4499.00, 8998.00), (22, 16, 2, 1, 9999.00, 9999.00), (22, 19, 2, 35, 799.00, 27965.00),
(23, 1, 3, 1, 85000.00, 85000.00), (23, 7, 3, 1, 12999.00, 12999.00), (23, 13, 3, 1, 7999.00, 7999.00),
(24, 2, 4, 45, 599.00, 26955.00), (24, 4, 4, 1, 5999.00, 5999.00), (24, 9, 4, 1, 6999.00, 6999.00), (24, 14, 4, 2, 2499.00, 4998.00), (24, 18, 4, 2, 3999.00, 7998.00), (24, 20, 4, 70, 499.00, 34930.00),
(25, 1, 5, 1, 85000.00, 85000.00), (25, 5, 5, 1, 28999.00, 28999.00), (25, 8, 5, 3, 3499.00, 10497.00), (25, 11, 5, 20, 899.00, 17980.00), (25, 15, 5, 3, 1999.00, 5997.00), (25, 17, 5, 2, 7499.00, 14998.00),
(26, 3, 1, 2, 1299.00, 2598.00), (26, 6, 1, 1, 8999.00, 8999.00), (26, 10, 1, 45, 299.00, 13455.00), (26, 12, 1, 2, 4499.00, 8998.00), (26, 19, 1, 32, 799.00, 25568.00), (26, 20, 1, 45, 499.00, 22455.00),
(27, 1, 2, 1, 85000.00, 85000.00), (27, 4, 2, 1, 5999.00, 5999.00), (27, 7, 2, 1, 12999.00, 12999.00), (27, 13, 2, 1, 7999.00, 7999.00), (27, 16, 2, 1, 9999.00, 9999.00),
(28, 2, 3, 50, 599.00, 29950.00), (28, 5, 3, 1, 28999.00, 28999.00), (28, 9, 3, 1, 6999.00, 6999.00), (28, 14, 3, 2, 2499.00, 4998.00), (28, 18, 3, 1, 3999.00, 3999.00), (28, 20, 3, 60, 499.00, 29940.00),
(29, 1, 4, 1, 85000.00, 85000.00), (29, 3, 4, 1, 1299.00, 1299.00), (29, 8, 4, 2, 3499.00, 6998.00), (29, 11, 4, 28, 899.00, 25172.00), (29, 13, 4, 2, 7999.00, 15998.00),
(30, 5, 5, 1, 28999.00, 28999.00), (30, 6, 5, 1, 8999.00, 8999.00), (30, 12, 5, 2, 4499.00, 8998.00), (30, 15, 5, 3, 1999.00, 5997.00), (30, 17, 5, 2, 7499.00, 14998.00), (30, 19, 5, 38, 799.00, 30362.00),
(31, 2, 1, 40, 599.00, 23960.00), (31, 4, 1, 1, 5999.00, 5999.00), (31, 7, 1, 1, 12999.00, 12999.00), (31, 10, 1, 45, 299.00, 13455.00), (31, 14, 1, 3, 2499.00, 7497.00), (31, 18, 1, 2, 3999.00, 7998.00), (31, 20, 1, 55, 499.00, 27445.00),
(32, 1, 2, 1, 85000.00, 85000.00), (32, 3, 2, 2, 1299.00, 2598.00), (32, 6, 2, 1, 8999.00, 8999.00), (32, 9, 2, 1, 6999.00, 6999.00),
(33, 5, 3, 1, 28999.00, 28999.00), (33, 8, 3, 2, 3499.00, 6998.00), (33, 12, 3, 2, 4499.00, 8998.00), (33, 16, 3, 1, 9999.00, 9999.00), (33, 17, 3, 2, 7499.00, 14998.00), (33, 19, 3, 42, 799.00, 33558.00),
(34, 2, 4, 48, 599.00, 28752.00), (34, 4, 4, 1, 5999.00, 5999.00), (34, 11, 4, 24, 899.00, 21576.00), (34, 13, 4, 2, 7999.00, 15998.00), (34, 15, 4, 2, 1999.00, 3999.00), (34, 18, 4, 2, 3999.00, 7998.00), (34, 20, 4, 65, 499.00, 32435.00),
(35, 1, 5, 1, 85000.00, 85000.00), (35, 5, 5, 1, 28999.00, 28999.00), (35, 10, 5, 35, 299.00, 10465.00),
(36, 3, 1, 2, 1299.00, 2598.00), (36, 7, 1, 1, 12999.00, 12999.00), (36, 9, 1, 1, 6999.00, 6999.00), (36, 14, 1, 2, 2499.00, 4998.00), (36, 16, 1, 1, 9999.00, 9999.00), (36, 19, 1, 30, 799.00, 23970.00), (36, 20, 1, 75, 499.00, 37425.00),
(37, 2, 2, 38, 599.00, 22762.00), (37, 6, 2, 1, 8999.00, 8999.00), (37, 12, 2, 2, 4499.00, 8998.00), (37, 18, 2, 3, 3999.00, 11997.00),
(38, 1, 3, 1, 85000.00, 85000.00), (38, 4, 3, 1, 5999.00, 5999.00), (38, 8, 3, 2, 3499.00, 6998.00), (38, 13, 3, 2, 7999.00, 15998.00), (38, 15, 3, 2, 1999.00, 3999.00), (38, 17, 3, 2, 7499.00, 14998.00),
(39, 5, 4, 1, 28999.00, 28999.00), (39, 7, 4, 1, 12999.00, 12999.00), (39, 10, 4, 55, 299.00, 16445.00), (39, 11, 4, 30, 899.00, 26970.00), (39, 14, 4, 2, 2499.00, 4998.00), (39, 20, 4, 55, 499.00, 27445.00),
(40, 2, 5, 42, 599.00, 25158.00), (40, 3, 5, 1, 1299.00, 1299.00), (40, 9, 5, 1, 6999.00, 6999.00), (40, 16, 5, 1, 9999.00, 9999.00), (40, 18, 5, 2, 3999.00, 7998.00), (40, 19, 5, 45, 799.00, 35955.00),
(41, 1, 1, 1, 85000.00, 85000.00), (41, 6, 1, 1, 8999.00, 8999.00), (41, 12, 1, 1, 4499.00, 4499.00), (41, 17, 1, 2, 7499.00, 14998.00),
(42, 5, 2, 1, 28999.00, 28999.00), (42, 4, 2, 1, 5999.00, 5999.00), (42, 8, 2, 2, 3499.00, 6998.00), (42, 11, 2, 32, 899.00, 28768.00), (42, 20, 2, 50, 499.00, 24950.00),
(43, 2, 3, 42, 599.00, 25158.00), (43, 3, 3, 2, 1299.00, 2598.00), (43, 7, 3, 1, 12999.00, 12999.00), (43, 13, 3, 2, 7999.00, 15998.00), (43, 15, 3, 3, 1999.00, 5997.00), (43, 19, 3, 40, 799.00, 31960.00),
(44, 1, 4, 1, 85000.00, 85000.00), (44, 10, 4, 50, 299.00, 14950.00), (44, 14, 4, 3, 2499.00, 7497.00), (44, 16, 4, 1, 9999.00, 9999.00), (44, 18, 4, 3, 3999.00, 11997.00), (44, 20, 4, 68, 499.00, 33932.00),
(45, 5, 5, 1, 28999.00, 28999.00), (45, 9, 5, 1, 6999.00, 6999.00), (45, 12, 5, 1, 4499.00, 4499.00),
(46, 2, 1, 40, 599.00, 23960.00), (46, 6, 1, 1, 8999.00, 8999.00), (46, 11, 1, 26, 899.00, 23374.00), (46, 17, 1, 1, 7499.00, 7499.00), (46, 19, 1, 42, 799.00, 33558.00), (46, 20, 1, 68, 499.00, 33932.00),
(47, 1, 2, 1, 85000.00, 85000.00), (47, 3, 2, 1, 1299.00, 1299.00), (47, 4, 2, 1, 5999.00, 5999.00), (47, 8, 2, 1, 3499.00, 3499.00),
(48, 5, 3, 1, 28999.00, 28999.00), (48, 7, 3, 1, 12999.00, 12999.00), (48, 13, 3, 1, 7999.00, 7999.00), (48, 16, 3, 2, 9999.00, 19998.00), (48, 18, 3, 2, 3999.00, 7998.00),
(49, 2, 4, 48, 599.00, 28752.00), (49, 9, 4, 1, 6999.00, 6999.00), (49, 11, 4, 32, 899.00, 28768.00), (49, 14, 4, 2, 2499.00, 4998.00), (49, 15, 4, 2, 1999.00, 3999.00), (49, 20, 4, 62, 499.00, 30938.00),
(50, 1, 5, 1, 85000.00, 85000.00), (50, 6, 5, 1, 8999.00, 8999.00), (50, 10, 5, 40, 299.00, 11960.00), (50, 12, 5, 2, 4499.00, 8998.00);

-- Additional order items to reach 250 records
INSERT INTO order_items (order_id, product_id, warehouse_id, quantity_ordered, unit_price, line_total) VALUES
(51, 3, 1, 1, 1299.00, 1299.00), (51, 8, 1, 2, 3499.00, 6998.00), (51, 13, 1, 1, 7999.00, 7999.00),
(52, 5, 2, 1, 28999.00, 28999.00), (52, 7, 2, 1, 12999.00, 12999.00), (52, 19, 2, 35, 799.00, 27965.00),
(53, 1, 3, 1, 85000.00, 85000.00), (53, 2, 3, 38, 599.00, 22762.00), (53, 11, 3, 28, 899.00, 25172.00),
(54, 4, 4, 1, 5999.00, 5999.00), (54, 9, 4, 1, 6999.00, 6999.00), (54, 16, 4, 2, 9999.00, 19998.00), (54, 20, 4, 60, 499.00, 29940.00),
(55, 1, 5, 1, 85000.00, 85000.00), (55, 6, 5, 1, 8999.00, 8999.00), (55, 14, 5, 3, 2499.00, 7497.00),
(56, 2, 1, 45, 599.00, 26955.00), (56, 5, 1, 1, 28999.00, 28999.00), (56, 8, 1, 2, 3499.00, 6998.00), (56, 18, 1, 1, 3999.00, 3999.00),
(57, 3, 2, 2, 1299.00, 2598.00), (57, 7, 2, 1, 12999.00, 12999.00), (57, 12, 2, 2, 4499.00, 8998.00), (57, 15, 2, 2, 1999.00, 3999.00),
(58, 1, 3, 1, 85000.00, 85000.00), (58, 4, 3, 1, 5999.00, 5999.00), (58, 10, 3, 50, 299.00, 14950.00), (58, 16, 3, 1, 9999.00, 9999.00),
(59, 5, 4, 1, 28999.00, 28999.00), (59, 9, 4, 1, 6999.00, 6999.00), (59, 11, 4, 25, 899.00, 22475.00), (59, 19, 4, 40, 799.00, 31960.00),
(60, 2, 5, 50, 599.00, 29950.00), (60, 6, 5, 1, 8999.00, 8999.00), (60, 13, 5, 2, 7999.00, 15998.00),
(61, 1, 1, 1, 85000.00, 85000.00), (61, 3, 1, 2, 1299.00, 2598.00), (61, 14, 1, 2, 2499.00, 4998.00), (61, 17, 1, 2, 7499.00, 14998.00),
(62, 5, 2, 1, 28999.00, 28999.00), (62, 8, 2, 3, 3499.00, 10497.00), (62, 12, 2, 1, 4499.00, 4499.00), (62, 20, 2, 55, 499.00, 27445.00),
(63, 2, 3, 48, 599.00, 28752.00), (63, 4, 3, 1, 5999.00, 5999.00), (63, 7, 3, 1, 12999.00, 12999.00), (63, 15, 3, 3, 1999.00, 5997.00),
(64, 1, 4, 1, 85000.00, 85000.00), (64, 6, 4, 1, 8999.00, 8999.00), (64, 10, 4, 45, 299.00, 13455.00), (64, 18, 4, 2, 3999.00, 7998.00), (64, 19, 4, 38, 799.00, 30362.00),
(65, 5, 5, 1, 28999.00, 28999.00), (65, 9, 5, 1, 6999.00, 6999.00), (65, 11, 5, 24, 899.00, 21576.00), (65, 16, 5, 1, 9999.00, 9999.00),
(66, 2, 1, 38, 599.00, 22762.00), (66, 3, 1, 1, 1299.00, 1299.00), (66, 8, 1, 2, 3499.00, 6998.00), (66, 13, 1, 2, 7999.00, 15998.00), (66, 17, 1, 2, 7499.00, 14998.00),
(67, 1, 2, 1, 85000.00, 85000.00), (67, 4, 2, 1, 5999.00, 5999.00), (67, 12, 2, 2, 4499.00, 8998.00), (67, 20, 2, 65, 499.00, 32435.00),
(68, 5, 3, 1, 28999.00, 28999.00), (68, 7, 3, 1, 12999.00, 12999.00), (68, 11, 3, 28, 899.00, 25172.00), (68, 15, 3, 2, 1999.00, 3999.00),
(69, 2, 4, 45, 599.00, 26955.00), (69, 6, 4, 1, 8999.00, 8999.00), (69, 10, 4, 55, 299.00, 16445.00), (69, 14, 4, 3, 2499.00, 7497.00), (69, 18, 4, 1, 3999.00, 3999.00),
(70, 1, 5, 1, 85000.00, 85000.00), (70, 3, 5, 2, 1299.00, 2598.00), (70, 9, 5, 1, 6999.00, 6999.00), (70, 16, 5, 2, 9999.00, 19998.00), (70, 19, 5, 45, 799.00, 35955.00),
(71, 5, 1, 1, 28999.00, 28999.00), (71, 8, 1, 2, 3499.00, 6998.00), (71, 12, 1, 1, 4499.00, 4499.00),
(72, 2, 2, 40, 599.00, 23960.00), (72, 4, 2, 1, 5999.00, 5999.00), (72, 11, 2, 30, 899.00, 26970.00), (72, 17, 2, 1, 7499.00, 7499.00), (72, 20, 2, 58, 499.00, 28942.00),
(73, 1, 3, 1, 85000.00, 85000.00), (73, 6, 3, 1, 8999.00, 8999.00), (73, 13, 3, 1, 7999.00, 7999.00), (73, 15, 3, 3, 1999.00, 5997.00),
(74, 5, 4, 1, 28999.00, 28999.00), (74, 7, 4, 1, 12999.00, 12999.00), (74, 9, 4, 1, 6999.00, 6999.00), (74, 14, 4, 2, 2499.00, 4998.00), (74, 18, 4, 2, 3999.00, 7998.00), (74, 19, 4, 48, 799.00, 38352.00),
(75, 2, 5, 50, 599.00, 29950.00), (75, 3, 5, 1, 1299.00, 1299.00), (75, 8, 5, 3, 3499.00, 10497.00), (75, 16, 5, 1, 9999.00, 9999.00), (75, 20, 5, 62, 499.00, 30938.00);

-- ============================================================================
-- 8. INSERT PAYMENTS (100 records)
-- ============================================================================
INSERT INTO payments (order_id, payment_date, payment_method, payment_status, amount_paid) VALUES
(1, DATE_SUB(NOW(), INTERVAL 84 DAY), 'Credit Card', 'Completed', 125000.00),
(2, DATE_SUB(NOW(), INTERVAL 83 DAY), 'Debit Card', 'Completed', 89999.00),
(3, DATE_SUB(NOW(), INTERVAL 82 DAY), 'Net Banking', 'Completed', 145000.00),
(4, DATE_SUB(NOW(), INTERVAL 81 DAY), 'Credit Card', 'Completed', 67500.00),
(5, DATE_SUB(NOW(), INTERVAL 80 DAY), 'Debit Card', 'Completed', 98600.00),
(6, DATE_SUB(NOW(), INTERVAL 79 DAY), 'Net Banking', 'Completed', 156000.00),
(7, DATE_SUB(NOW(), INTERVAL 78 DAY), 'Credit Card', 'Completed', 75300.00),
(8, DATE_SUB(NOW(), INTERVAL 77 DAY), 'Debit Card', 'Completed', 112400.00),
(9, DATE_SUB(NOW(), INTERVAL 76 DAY), 'Net Banking', 'Completed', 89999.00),
(10, DATE_SUB(NOW(), INTERVAL 75 DAY), 'Credit Card', 'Completed', 134500.00),
(11, DATE_SUB(NOW(), INTERVAL 74 DAY), 'Debit Card', 'Completed', 65800.00),
(12, DATE_SUB(NOW(), INTERVAL 73 DAY), 'Net Banking', 'Completed', 128900.00),
(13, DATE_SUB(NOW(), INTERVAL 72 DAY), 'Credit Card', 'Failed', 92300.00),
(14, DATE_SUB(NOW(), INTERVAL 71 DAY), 'Debit Card', 'Completed', 145600.00),
(15, DATE_SUB(NOW(), INTERVAL 70 DAY), 'Net Banking', 'Completed', 78500.00),
(16, DATE_SUB(NOW(), INTERVAL 69 DAY), 'Credit Card', 'Completed', 156700.00),
(17, DATE_SUB(NOW(), INTERVAL 68 DAY), 'Debit Card', 'Completed', 85400.00),
(18, DATE_SUB(NOW(), INTERVAL 67 DAY), 'Net Banking', 'Completed', 125600.00),
(19, DATE_SUB(NOW(), INTERVAL 66 DAY), 'Credit Card', 'Completed', 98700.00),
(20, DATE_SUB(NOW(), INTERVAL 65 DAY), 'Debit Card', 'Completed', 142300.00),
(21, DATE_SUB(NOW(), INTERVAL 64 DAY), 'Net Banking', 'Completed', 67600.00),
(22, DATE_SUB(NOW(), INTERVAL 63 DAY), 'Credit Card', 'Completed', 115900.00),
(23, DATE_SUB(NOW(), INTERVAL 62 DAY), 'Debit Card', 'Completed', 89500.00),
(24, DATE_SUB(NOW(), INTERVAL 61 DAY), 'Net Banking', 'Completed', 128700.00),
(25, DATE_SUB(NOW(), INTERVAL 60 DAY), 'Credit Card', 'Completed', 145800.00),
(26, DATE_SUB(NOW(), INTERVAL 59 DAY), 'Debit Card', 'Failed', 76400.00),
(27, DATE_SUB(NOW(), INTERVAL 58 DAY), 'Net Banking', 'Completed', 125500.00),
(28, DATE_SUB(NOW(), INTERVAL 57 DAY), 'Credit Card', 'Completed', 98600.00),
(29, DATE_SUB(NOW(), INTERVAL 56 DAY), 'Debit Card', 'Completed', 134500.00),
(30, DATE_SUB(NOW(), INTERVAL 55 DAY), 'Net Banking', 'Completed', 85700.00),
(31, DATE_SUB(NOW(), INTERVAL 54 DAY), 'Credit Card', 'Completed', 156900.00),
(32, DATE_SUB(NOW(), INTERVAL 53 DAY), 'Debit Card', 'Failed', 92400.00),
(33, DATE_SUB(NOW(), INTERVAL 52 DAY), 'Net Banking', 'Completed', 125600.00),
(34, DATE_SUB(NOW(), INTERVAL 51 DAY), 'Credit Card', 'Completed', 145700.00),
(35, DATE_SUB(NOW(), INTERVAL 50 DAY), 'Debit Card', 'Completed', 78600.00),
(36, DATE_SUB(NOW(), INTERVAL 49 DAY), 'Net Banking', 'Completed', 89500.00),
(37, DATE_SUB(NOW(), INTERVAL 48 DAY), 'Credit Card', 'Completed', 128800.00),
(38, DATE_SUB(NOW(), INTERVAL 47 DAY), 'Debit Card', 'Completed', 98700.00),
(39, DATE_SUB(NOW(), INTERVAL 46 DAY), 'Net Banking', 'Completed', 142400.00),
(40, DATE_SUB(NOW(), INTERVAL 45 DAY), 'Credit Card', 'Completed', 67700.00),
(41, DATE_SUB(NOW(), INTERVAL 44 DAY), 'Debit Card', 'Completed', 115800.00),
(42, DATE_SUB(NOW(), INTERVAL 43 DAY), 'Net Banking', 'Completed', 89600.00),
(43, DATE_SUB(NOW(), INTERVAL 42 DAY), 'Credit Card', 'Completed', 128900.00),
(44, DATE_SUB(NOW(), INTERVAL 41 DAY), 'Debit Card', 'Failed', 145900.00),
(45, DATE_SUB(NOW(), INTERVAL 40 DAY), 'Net Banking', 'Completed', 76500.00),
(46, DATE_SUB(NOW(), INTERVAL 39 DAY), 'Credit Card', 'Completed', 125600.00),
(47, DATE_SUB(NOW(), INTERVAL 38 DAY), 'Debit Card', 'Completed', 98800.00),
(48, DATE_SUB(NOW(), INTERVAL 37 DAY), 'Net Banking', 'Completed', 134600.00),
(49, DATE_SUB(NOW(), INTERVAL 36 DAY), 'Credit Card', 'Completed', 85800.00),
(50, DATE_SUB(NOW(), INTERVAL 35 DAY), 'Debit Card', 'Completed', 157000.00),
(51, DATE_SUB(NOW(), INTERVAL 34 DAY), 'Net Banking', 'Pending', 92500.00),
(52, DATE_SUB(NOW(), INTERVAL 33 DAY), 'Credit Card', 'Completed', 125700.00),
(53, DATE_SUB(NOW(), INTERVAL 32 DAY), 'Debit Card', 'Completed', 145800.00),
(54, DATE_SUB(NOW(), INTERVAL 31 DAY), 'Net Banking', 'Completed', 78700.00),
(55, DATE_SUB(NOW(), INTERVAL 30 DAY), 'Credit Card', 'Completed', 89600.00),
(56, DATE_SUB(NOW(), INTERVAL 29 DAY), 'Debit Card', 'Completed', 128900.00),
(57, DATE_SUB(NOW(), INTERVAL 28 DAY), 'Net Banking', 'Completed', 98900.00),
(58, DATE_SUB(NOW(), INTERVAL 27 DAY), 'Credit Card', 'Completed', 142500.00),
(59, DATE_SUB(NOW(), INTERVAL 26 DAY), 'Debit Card', 'Failed', 67800.00),
(60, DATE_SUB(NOW(), INTERVAL 25 DAY), 'Net Banking', 'Completed', 115900.00),
(61, DATE_SUB(NOW(), INTERVAL 24 DAY), 'Credit Card', 'Pending', 89700.00),
(62, DATE_SUB(NOW(), INTERVAL 23 DAY), 'Debit Card', 'Completed', 129000.00),
(63, DATE_SUB(NOW(), INTERVAL 22 DAY), 'Net Banking', 'Completed', 146000.00),
(64, DATE_SUB(NOW(), INTERVAL 21 DAY), 'Credit Card', 'Completed', 76600.00),
(65, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Debit Card', 'Completed', 125700.00),
(66, DATE_SUB(NOW(), INTERVAL 19 DAY), 'Net Banking', 'Completed', 98900.00),
(67, DATE_SUB(NOW(), INTERVAL 18 DAY), 'Credit Card', 'Completed', 134700.00),
(68, DATE_SUB(NOW(), INTERVAL 17 DAY), 'Debit Card', 'Completed', 85900.00),
(69, DATE_SUB(NOW(), INTERVAL 16 DAY), 'Net Banking', 'Completed', 157100.00),
(70, DATE_SUB(NOW(), INTERVAL 15 DAY), 'Credit Card', 'Failed', 92600.00),
(71, DATE_SUB(NOW(), INTERVAL 14 DAY), 'Debit Card', 'Completed', 125800.00),
(72, DATE_SUB(NOW(), INTERVAL 13 DAY), 'Net Banking', 'Completed', 145900.00),
(73, DATE_SUB(NOW(), INTERVAL 12 DAY), 'Credit Card', 'Pending', 78800.00),
(74, DATE_SUB(NOW(), INTERVAL 11 DAY), 'Debit Card', 'Completed', 89700.00),
(75, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Net Banking', 'Completed', 129000.00),
(76, DATE_SUB(NOW(), INTERVAL 9 DAY), 'Credit Card', 'Completed', 99000.00),
(77, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Debit Card', 'Completed', 142600.00),
(78, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Net Banking', 'Completed', 67900.00),
(79, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Credit Card', 'Completed', 116000.00),
(80, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Debit Card', 'Completed', 89800.00),
(81, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Net Banking', 'Pending', 129100.00),
(82, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Credit Card', 'Completed', 146100.00),
(83, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Debit Card', 'Completed', 76700.00),
(84, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Net Banking', 'Pending', 125800.00),
(85, NOW(), 'Credit Card', 'Pending', 99100.00),
(86, DATE_SUB(NOW(), INTERVAL 9 DAY), 'Debit Card', 'Completed', 99000.00),
(87, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Net Banking', 'Completed', 142600.00),
(88, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Credit Card', 'Completed', 67900.00),
(89, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Debit Card', 'Completed', 116000.00),
(90, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Net Banking', 'Completed', 89800.00),
(91, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Credit Card', 'Failed', 129100.00),
(92, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Debit Card', 'Completed', 146100.00),
(93, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Net Banking', 'Completed', 76700.00),
(94, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Credit Card', 'Pending', 125800.00),
(95, NOW(), 'Debit Card', 'Pending', 99100.00),
(96, DATE_SUB(NOW(), INTERVAL 9 DAY), 'Net Banking', 'Completed', 99000.00),
(97, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Credit Card', 'Completed', 142600.00),
(98, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Debit Card', 'Completed', 67900.00),
(99, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Net Banking', 'Completed', 116000.00),
(100, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Credit Card', 'Completed', 89800.00);

-- ============================================================================
-- 9. INSERT SHIPMENTS (100 records)
-- ============================================================================
INSERT INTO shipments (order_id, warehouse_id, shipment_date, delivery_status, delivery_city) VALUES
(1, 1, DATE_SUB(NOW(), INTERVAL 83 DAY), 'Delivered', 'Mumbai'),
(2, 2, DATE_SUB(NOW(), INTERVAL 82 DAY), 'Delivered', 'Delhi'),
(3, 1, DATE_SUB(NOW(), INTERVAL 81 DAY), 'Delivered', 'Bangalore'),
(4, 2, DATE_SUB(NOW(), INTERVAL 80 DAY), 'Delivered', 'Pune'),
(5, 3, DATE_SUB(NOW(), INTERVAL 79 DAY), 'In Transit', 'Hyderabad'),
(6, 1, DATE_SUB(NOW(), INTERVAL 78 DAY), 'Delivered', 'Chennai'),
(7, 2, DATE_SUB(NOW(), INTERVAL 77 DAY), 'Delivered', 'Kolkata'),
(8, 3, DATE_SUB(NOW(), INTERVAL 76 DAY), 'In Transit', 'Kochi'),
(9, 4, DATE_SUB(NOW(), INTERVAL 75 DAY), 'Delivered', 'Bangalore'),
(10, 1, DATE_SUB(NOW(), INTERVAL 74 DAY), 'Delivered', 'Mumbai'),
(11, 5, DATE_SUB(NOW(), INTERVAL 73 DAY), 'Delivered', 'Delhi'),
(12, 2, DATE_SUB(NOW(), INTERVAL 72 DAY), 'Delivered', 'Pune'),
(13, 3, DATE_SUB(NOW(), INTERVAL 71 DAY), 'Failed', 'Hyderabad'),
(14, 1, DATE_SUB(NOW(), INTERVAL 70 DAY), 'Delivered', 'Chennai'),
(15, 4, DATE_SUB(NOW(), INTERVAL 69 DAY), 'Delivered', 'Kolkata'),
(16, 2, DATE_SUB(NOW(), INTERVAL 68 DAY), 'Delivered', 'Kochi'),
(17, 5, DATE_SUB(NOW(), INTERVAL 67 DAY), 'Delivered', 'Bangalore'),
(18, 1, DATE_SUB(NOW(), INTERVAL 66 DAY), 'Delivered', 'Mumbai'),
(19, 3, DATE_SUB(NOW(), INTERVAL 65 DAY), 'Delivered', 'Delhi'),
(20, 2, DATE_SUB(NOW(), INTERVAL 64 DAY), 'Delivered', 'Pune'),
(21, 4, DATE_SUB(NOW(), INTERVAL 63 DAY), 'Delivered', 'Hyderabad'),
(22, 1, DATE_SUB(NOW(), INTERVAL 62 DAY), 'Delivered', 'Chennai'),
(23, 5, DATE_SUB(NOW(), INTERVAL 61 DAY), 'Delivered', 'Kolkata'),
(24, 3, DATE_SUB(NOW(), INTERVAL 60 DAY), 'Delivered', 'Kochi'),
(25, 2, DATE_SUB(NOW(), INTERVAL 59 DAY), 'Delivered', 'Bangalore'),
(26, 1, DATE_SUB(NOW(), INTERVAL 58 DAY), 'Failed', 'Mumbai'),
(27, 4, DATE_SUB(NOW(), INTERVAL 57 DAY), 'Delivered', 'Delhi'),
(28, 5, DATE_SUB(NOW(), INTERVAL 56 DAY), 'Delivered', 'Pune'),
(29, 2, DATE_SUB(NOW(), INTERVAL 55 DAY), 'Delivered', 'Hyderabad'),
(30, 3, DATE_SUB(NOW(), INTERVAL 54 DAY), 'Delivered', 'Chennai'),
(31, 1, DATE_SUB(NOW(), INTERVAL 53 DAY), 'Delivered', 'Kolkata'),
(32, 4, DATE_SUB(NOW(), INTERVAL 52 DAY), 'Delivered', 'Kochi'),
(33, 5, DATE_SUB(NOW(), INTERVAL 51 DAY), 'Delivered', 'Bangalore'),
(34, 2, DATE_SUB(NOW(), INTERVAL 50 DAY), 'Delivered', 'Mumbai'),
(35, 1, DATE_SUB(NOW(), INTERVAL 49 DAY), 'Delivered', 'Delhi'),
(36, 3, DATE_SUB(NOW(), INTERVAL 48 DAY), 'Delivered', 'Pune'),
(37, 4, DATE_SUB(NOW(), INTERVAL 47 DAY), 'Delivered', 'Hyderabad'),
(38, 2, DATE_SUB(NOW(), INTERVAL 46 DAY), 'Delivered', 'Chennai'),
(39, 5, DATE_SUB(NOW(), INTERVAL 45 DAY), 'Delivered', 'Kolkata'),
(40, 1, DATE_SUB(NOW(), INTERVAL 44 DAY), 'Delivered', 'Kochi'),
(41, 3, DATE_SUB(NOW(), INTERVAL 43 DAY), 'Delivered', 'Bangalore'),
(42, 4, DATE_SUB(NOW(), INTERVAL 42 DAY), 'Delivered', 'Mumbai'),
(43, 2, DATE_SUB(NOW(), INTERVAL 41 DAY), 'Delivered', 'Delhi'),
(44, 1, DATE_SUB(NOW(), INTERVAL 40 DAY), 'Delivered', 'Pune'),
(45, 5, DATE_SUB(NOW(), INTERVAL 39 DAY), 'Delivered', 'Hyderabad'),
(46, 3, DATE_SUB(NOW(), INTERVAL 38 DAY), 'Delivered', 'Chennai'),
(47, 2, DATE_SUB(NOW(), INTERVAL 37 DAY), 'Delivered', 'Kolkata'),
(48, 4, DATE_SUB(NOW(), INTERVAL 36 DAY), 'Delivered', 'Kochi'),
(49, 1, DATE_SUB(NOW(), INTERVAL 35 DAY), 'Delivered', 'Bangalore'),
(50, 5, DATE_SUB(NOW(), INTERVAL 34 DAY), 'Delivered', 'Mumbai'),
(51, 2, DATE_SUB(NOW(), INTERVAL 33 DAY), 'Pending', 'Delhi'),
(52, 3, DATE_SUB(NOW(), INTERVAL 32 DAY), 'In Transit', 'Pune'),
(53, 1, DATE_SUB(NOW(), INTERVAL 31 DAY), 'Delivered', 'Hyderabad'),
(54, 4, DATE_SUB(NOW(), INTERVAL 30 DAY), 'Delivered', 'Chennai'),
(55, 5, DATE_SUB(NOW(), INTERVAL 29 DAY), 'Delivered', 'Kolkata'),
(56, 2, DATE_SUB(NOW(), INTERVAL 28 DAY), 'Delivered', 'Kochi'),
(57, 1, DATE_SUB(NOW(), INTERVAL 27 DAY), 'Delivered', 'Bangalore'),
(58, 3, DATE_SUB(NOW(), INTERVAL 26 DAY), 'Delivered', 'Mumbai'),
(59, 4, DATE_SUB(NOW(), INTERVAL 25 DAY), 'Delivered', 'Delhi'),
(60, 5, DATE_SUB(NOW(), INTERVAL 24 DAY), 'Delivered', 'Pune'),
(61, 1, DATE_SUB(NOW(), INTERVAL 23 DAY), 'Pending', 'Hyderabad'),
(62, 2, DATE_SUB(NOW(), INTERVAL 22 DAY), 'In Transit', 'Chennai'),
(63, 3, DATE_SUB(NOW(), INTERVAL 21 DAY), 'Delivered', 'Kolkata'),
(64, 4, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Delivered', 'Kochi'),
(65, 5, DATE_SUB(NOW(), INTERVAL 19 DAY), 'Delivered', 'Bangalore'),
(66, 1, DATE_SUB(NOW(), INTERVAL 18 DAY), 'Delivered', 'Mumbai'),
(67, 2, DATE_SUB(NOW(), INTERVAL 17 DAY), 'Delivered', 'Delhi'),
(68, 3, DATE_SUB(NOW(), INTERVAL 16 DAY), 'Delivered', 'Pune'),
(69, 4, DATE_SUB(NOW(), INTERVAL 15 DAY), 'In Transit', 'Hyderabad'),
(70, 5, DATE_SUB(NOW(), INTERVAL 14 DAY), 'Delivered', 'Chennai'),
(71, 1, DATE_SUB(NOW(), INTERVAL 13 DAY), 'Delivered', 'Kolkata'),
(72, 2, DATE_SUB(NOW(), INTERVAL 12 DAY), 'Delivered', 'Kochi'),
(73, 3, DATE_SUB(NOW(), INTERVAL 11 DAY), 'Pending', 'Bangalore'),
(74, 4, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Delivered', 'Mumbai'),
(75, 5, DATE_SUB(NOW(), INTERVAL 9 DAY), 'Delivered', 'Delhi'),
(76, 1, DATE_SUB(NOW(), INTERVAL 8 DAY), 'In Transit', 'Pune'),
(77, 2, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Delivered', 'Hyderabad'),
(78, 3, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Delivered', 'Chennai'),
(79, 4, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Delivered', 'Kolkata'),
(80, 5, DATE_SUB(NOW(), INTERVAL 4 DAY), 'In Transit', 'Kochi'),
(81, 1, DATE_SUB(NOW(), INTERVAL 3 DAY), 'Pending', 'Bangalore'),
(82, 2, DATE_SUB(NOW(), INTERVAL 2 DAY), 'In Transit', 'Mumbai'),
(83, 3, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Pending', 'Delhi'),
(84, 4, NOW(), 'Pending', 'Pune'),
(85, 5, NOW(), 'Pending', 'Hyderabad'),
(86, 1, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Delivered', 'Chennai'),
(87, 2, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Delivered', 'Kolkata'),
(88, 3, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Delivered', 'Kochi'),
(89, 4, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Delivered', 'Bangalore'),
(90, 5, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Delivered', 'Mumbai'),
(91, 1, DATE_SUB(NOW(), INTERVAL 3 DAY), 'In Transit', 'Delhi'),
(92, 2, DATE_SUB(NOW(), INTERVAL 2 DAY), 'In Transit', 'Pune'),
(93, 3, DATE_SUB(NOW(), INTERVAL 1 DAY), 'Pending', 'Hyderabad'),
(94, 4, NOW(), 'Pending', 'Chennai'),
(95, 5, NOW(), 'Pending', 'Kolkata'),
(96, 1, DATE_SUB(NOW(), INTERVAL 8 DAY), 'Delivered', 'Kochi'),
(97, 2, DATE_SUB(NOW(), INTERVAL 7 DAY), 'Delivered', 'Bangalore'),
(98, 3, DATE_SUB(NOW(), INTERVAL 6 DAY), 'Delivered', 'Mumbai'),
(99, 4, DATE_SUB(NOW(), INTERVAL 5 DAY), 'In Transit', 'Delhi'),
(100, 5, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Delivered', 'Pune');

-- ============================================================================
-- 10. INSERT STOCK_MOVEMENTS (100+ records)
-- ============================================================================
INSERT INTO stock_movements (product_id, warehouse_id, movement_type, quantity, movement_date, remarks) VALUES
(1, 1, 'IN', 50, DATE_SUB(NOW(), INTERVAL 90 DAY), 'Initial stock'),
(2, 1, 'IN', 200, DATE_SUB(NOW(), INTERVAL 90 DAY), 'Initial stock'),
(3, 1, 'IN', 100, DATE_SUB(NOW(), INTERVAL 89 DAY), 'Restock from supplier'),
(4, 1, 'IN', 50, DATE_SUB(NOW(), INTERVAL 89 DAY), 'Restock from supplier'),
(5, 1, 'IN', 25, DATE_SUB(NOW(), INTERVAL 88 DAY), 'Restock from supplier'),
(1, 1, 'OUT', 5, DATE_SUB(NOW(), INTERVAL 85 DAY), 'Order #1'),
(2, 1, 'OUT', 40, DATE_SUB(NOW(), INTERVAL 84 DAY), 'Order #1'),
(3, 1, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 83 DAY), 'Order #1'),
(4, 1, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 82 DAY), 'Order #2'),
(5, 1, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 81 DAY), 'Order #2'),
(6, 2, 'IN', 30, DATE_SUB(NOW(), INTERVAL 88 DAY), 'Initial stock'),
(7, 2, 'IN', 40, DATE_SUB(NOW(), INTERVAL 87 DAY), 'Initial stock'),
(8, 2, 'IN', 60, DATE_SUB(NOW(), INTERVAL 86 DAY), 'Restock'),
(9, 2, 'IN', 35, DATE_SUB(NOW(), INTERVAL 85 DAY), 'Restock'),
(10, 2, 'IN', 160, DATE_SUB(NOW(), INTERVAL 84 DAY), 'Restock'),
(6, 2, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 80 DAY), 'Order #2'),
(7, 2, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 79 DAY), 'Order #3'),
(4, 2, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 78 DAY), 'Order #4'),
(5, 2, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 77 DAY), 'Order #4'),
(6, 3, 'IN', 25, DATE_SUB(NOW(), INTERVAL 87 DAY), 'Initial stock'),
(7, 3, 'IN', 45, DATE_SUB(NOW(), INTERVAL 86 DAY), 'Initial stock'),
(8, 3, 'IN', 65, DATE_SUB(NOW(), INTERVAL 85 DAY), 'Restock'),
(9, 3, 'IN', 40, DATE_SUB(NOW(), INTERVAL 84 DAY), 'Restock'),
(10, 3, 'IN', 175, DATE_SUB(NOW(), INTERVAL 83 DAY), 'Restock'),
(1, 3, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 75 DAY), 'Order #5'),
(2, 3, 'OUT', 50, DATE_SUB(NOW(), INTERVAL 74 DAY), 'Order #6'),
(7, 3, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 73 DAY), 'Order #7'),
(8, 3, 'OUT', 2, DATE_SUB(NOW(), INTERVAL 72 DAY), 'Order #7'),
(4, 4, 'IN', 40, DATE_SUB(NOW(), INTERVAL 86 DAY), 'Initial stock'),
(5, 4, 'IN', 20, DATE_SUB(NOW(), INTERVAL 85 DAY), 'Initial stock'),
(6, 4, 'IN', 25, DATE_SUB(NOW(), INTERVAL 84 DAY), 'Restock'),
(7, 4, 'IN', 40, DATE_SUB(NOW(), INTERVAL 83 DAY), 'Restock'),
(11, 1, 'IN', 150, DATE_SUB(NOW(), INTERVAL 82 DAY), 'Initial stock'),
(12, 1, 'IN', 50, DATE_SUB(NOW(), INTERVAL 81 DAY), 'Initial stock'),
(13, 1, 'IN', 60, DATE_SUB(NOW(), INTERVAL 80 DAY), 'Restock'),
(14, 1, 'IN', 80, DATE_SUB(NOW(), INTERVAL 79 DAY), 'Restock'),
(15, 1, 'IN', 90, DATE_SUB(NOW(), INTERVAL 78 DAY), 'Restock'),
(11, 1, 'OUT', 20, DATE_SUB(NOW(), INTERVAL 70 DAY), 'Order #10'),
(12, 1, 'OUT', 15, DATE_SUB(NOW(), INTERVAL 69 DAY), 'Order #12'),
(13, 1, 'OUT', 18, DATE_SUB(NOW(), INTERVAL 68 DAY), 'Order #13'),
(16, 2, 'IN', 60, DATE_SUB(NOW(), INTERVAL 80 DAY), 'Initial stock'),
(17, 2, 'IN', 70, DATE_SUB(NOW(), INTERVAL 79 DAY), 'Initial stock'),
(18, 2, 'IN', 55, DATE_SUB(NOW(), INTERVAL 78 DAY), 'Restock'),
(19, 2, 'IN', 200, DATE_SUB(NOW(), INTERVAL 77 DAY), 'Restock'),
(20, 2, 'IN', 150, DATE_SUB(NOW(), INTERVAL 76 DAY), 'Restock'),
(16, 2, 'OUT', 2, DATE_SUB(NOW(), INTERVAL 65 DAY), 'Order #24'),
(17, 2, 'OUT', 2, DATE_SUB(NOW(), INTERVAL 64 DAY), 'Order #27'),
(19, 2, 'OUT', 35, DATE_SUB(NOW(), INTERVAL 63 DAY), 'Order #27'),
(1, 2, 'IN', 40, DATE_SUB(NOW(), INTERVAL 75 DAY), 'Restock'),
(2, 2, 'IN', 180, DATE_SUB(NOW(), INTERVAL 74 DAY), 'Restock'),
(3, 2, 'IN', 95, DATE_SUB(NOW(), INTERVAL 73 DAY), 'Restock'),
(1, 2, 'OUT', 2, DATE_SUB(NOW(), INTERVAL 60 DAY), 'Order #21'),
(1, 2, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 59 DAY), 'Order #32'),
(1, 4, 'IN', 40, DATE_SUB(NOW(), INTERVAL 75 DAY), 'Initial stock'),
(2, 4, 'IN', 200, DATE_SUB(NOW(), INTERVAL 74 DAY), 'Restock'),
(3, 4, 'IN', 95, DATE_SUB(NOW(), INTERVAL 73 DAY), 'Restock'),
(1, 4, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 50 DAY), 'Order #35'),
(2, 4, 'OUT', 48, DATE_SUB(NOW(), INTERVAL 49 DAY), 'Order #34'),
(1, 5, 'IN', 50, DATE_SUB(NOW(), INTERVAL 74 DAY), 'Initial stock'),
(2, 5, 'IN', 210, DATE_SUB(NOW(), INTERVAL 73 DAY), 'Restock'),
(3, 5, 'IN', 100, DATE_SUB(NOW(), INTERVAL 72 DAY), 'Restock'),
(1, 5, 'OUT', 2, DATE_SUB(NOW(), INTERVAL 45 DAY), 'Order #50'),
(1, 5, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 44 DAY), 'Order #55'),
(4, 3, 'IN', 50, DATE_SUB(NOW(), INTERVAL 71 DAY), 'Restock'),
(4, 4, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 40 DAY), 'Order #54'),
(5, 3, 'IN', 50, DATE_SUB(NOW(), INTERVAL 70 DAY), 'Restock'),
(5, 4, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 35 DAY), 'Order #59'),
(5, 5, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 'Order #65'),
(6, 1, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 'Order #66'),
(7, 5, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Order #74'),
(8, 2, 'OUT', 3, DATE_SUB(NOW(), INTERVAL 15 DAY), 'Order #62'),
(9, 4, 'OUT', 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 'Order #69'),
(10, 5, 'OUT', 40, DATE_SUB(NOW(), INTERVAL 5 DAY), 'Order #75'),
(11, 2, 'IN', 50, DATE_SUB(NOW(), INTERVAL 60 DAY), 'Restock'),
(12, 3, 'IN', 50, DATE_SUB(NOW(), INTERVAL 59 DAY), 'Restock'),
(13, 4, 'IN', 60, DATE_SUB(NOW(), INTERVAL 58 DAY), 'Restock'),
(14, 5, 'IN', 80, DATE_SUB(NOW(), INTERVAL 57 DAY), 'Restock'),
(15, 2, 'IN', 100, DATE_SUB(NOW(), INTERVAL 56 DAY), 'Restock'),
(16, 3, 'IN', 60, DATE_SUB(NOW(), INTERVAL 55 DAY), 'Restock'),
(17, 4, 'IN', 70, DATE_SUB(NOW(), INTERVAL 54 DAY), 'Restock'),
(18, 5, 'IN', 60, DATE_SUB(NOW(), INTERVAL 53 DAY), 'Restock'),
(19, 1, 'IN', 200, DATE_SUB(NOW(), INTERVAL 52 DAY), 'Restock'),
(20, 3, 'IN', 200, DATE_SUB(NOW(), INTERVAL 51 DAY), 'Restock');

-- ============================================================================
-- END OF DATA INSERTION
-- ============================================================================

COMMIT;
SELECT 'Database setup completed successfully!' AS status;