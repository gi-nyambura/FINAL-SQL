-- Mama Mboga Grocery Delivery Database
-- Author: Patricia Nyambura
-- Description: SQL script to create the full schema for a grocery delivery system
CREATE DATABASE mamamboga;
-- Drop existing tables if re-running the script
DROP TABLE IF EXISTS order_items, orders, payments, products, vendors, customers, users;

-- USERS Table (Base table for login)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('customer', 'vendor') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CUSTOMERS Table (1-to-1 with users)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    address TEXT,
    FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- VENDORS Table (1-to-1 with users)
CREATE TABLE vendors (
    vendor_id INT PRIMARY KEY,
    shop_name VARCHAR(100) NOT NULL,
    location TEXT,
    FOREIGN KEY (vendor_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- PRODUCTS Table (1-to-Many from vendors)
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    quantity_available INT NOT NULL,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id) ON DELETE CASCADE
);

-- ORDERS Table (customer places orders)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'confirmed', 'delivered', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- ORDER_ITEMS Table (M-M between orders and products)
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- PAYMENTS Table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method ENUM('mpesa', 'airtel_money', 'visa') NOT NULL,
    status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);
