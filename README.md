# Warehouse Management System (WMS) - SQL Project

## Project Overview

The Warehouse Management System (WMS) is a comprehensive SQL-based database project designed to simulate real-world inventory, order processing, and logistics operations. It demonstrates advanced database design principles using MySQL 8.0, including relational schema design, normalization, query optimization, and performance tuning.

This project focuses on managing multi-warehouse inventory, customer orders, payments, shipments, and stock movements while ensuring data integrity, scalability, and efficient reporting.

---

## Objectives

The primary objectives of this project are:

- Design a normalized relational database for warehouse operations  
- Track inventory across multiple warehouses  
- Manage customer orders and payments efficiently  
- Ensure real-time stock updates and reorder alerts  
- Implement role-based security for different users  
- Optimize query performance using indexes and execution plans  
- Provide business insights using advanced SQL analytics  

---

## Database Structure

The system consists of 10 interconnected tables:

- **warehouses** – Stores warehouse details and capacity  
- **products** – Product catalog with pricing and categories  
- **customers** – Customer information  
- **suppliers** – Supplier details  
- **inventory** – Tracks stock per warehouse  
- **orders** – Order master records  
- **order_items** – Line-level order details  
- **payments** – Payment transactions  
- **shipments** – Delivery tracking  
- **stock_movements** – Logs inventory changes  

This structure ensures proper normalization and reduces redundancy while maintaining referential integrity.

---

## Key Features

### 1. Data Management
- Insert, update, and delete operations using SQL (DML)
- Structured schema creation using DDL
- Transaction control using TCL

### 2. Advanced SQL Techniques
- JOIN operations (INNER, LEFT, RIGHT)
- Window functions (RANK, DENSE_RANK, ROW_NUMBER)
- Common Table Expressions (CTEs)
- Subqueries and aggregation functions

### 3. Performance Optimization
- Indexing on frequently queried columns
- Query analysis using EXPLAIN
- Improved query execution performance up to 97%

### 4. Automation
- Stored procedures for order placement and restocking
- Triggers for audit logging of order status changes
- Automatic stock updates on order processing

### 5. Security
- Role-based access control:
  - Admin (full access)
  - Warehouse Manager (inventory control)
  - Sales User (order management)

---

## Business Insights

The system generates key analytical insights such as:

- Monthly revenue trends and sales performance  
- Top-performing products and customers  
- Warehouse-wise inventory distribution  
- Low-stock alerts for restocking decisions  
- Order fulfillment and delivery efficiency  

These insights support data-driven business decisions.

---

## Performance Highlights

- 85% order delivery success rate  
- 95%+ payment success rate  
- 75–97% improvement in query performance using indexes  
- Efficient handling of 700+ records across multiple tables  

---

## Technologies Used

- MySQL 8.0  
- SQL (DDL, DML, DCL, TCL)  
- Advanced SQL (CTEs, Window Functions)  
- Query Optimization (EXPLAIN plan analysis)  
- Database Design & Normalization  



## Conclusion

This Warehouse Management System project demonstrates a complete end-to-end SQL solution for managing inventory, orders, and logistics operations. It combines strong database design principles with advanced SQL features and performance optimization techniques, making it suitable for real-world enterprise applications.

---
