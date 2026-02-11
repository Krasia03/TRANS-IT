-- TRANSIT Admin Dashboard Database Schema
-- Run this SQL in MySQL to create the database and tables

CREATE DATABASE IF NOT EXISTS transit_admin;
USE transit_admin;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('super_admin', 'admin', 'cargo_owner', 'driver') NOT NULL DEFAULT 'cargo_owner',
    status ENUM('active', 'inactive', 'pending') DEFAULT 'active',
    avatar VARCHAR(10) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Trucks/Fleet table
CREATE TABLE trucks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    owner_id INT NOT NULL,
    truck_type ENUM('Fuso', 'Semi Trailer', 'Trailer', 'Pickup') NOT NULL,
    capacity_kg INT NOT NULL,
    status ENUM('verified', 'pending', 'rejected') DEFAULT 'pending',
    availability ENUM('available', 'en_route', 'offline') DEFAULT 'offline',
    rating DECIMAL(2,1) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Bookings table
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(20) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    truck_id INT DEFAULT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    distance_km INT NOT NULL,
    cargo_type ENUM('General', 'Perishable', 'Fragile', 'High Value') NOT NULL,
    weight_kg INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status ENUM('requested', 'assigned', 'en_route', 'delivered', 'completed', 'cancelled') DEFAULT 'requested',
    pickup_date DATE DEFAULT NULL,
    pickup_time TIME DEFAULT NULL,
    notes TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (truck_id) REFERENCES trucks(id) ON DELETE SET NULL
);

-- Transactions/Payments table
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(25) UNIQUE NOT NULL,
    booking_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    method ENUM('M-Pesa', 'Tigo Pesa', 'Bank Transfer', 'Cash') NOT NULL,
    status ENUM('pending', 'completed', 'in_escrow', 'refunded') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- Payouts table
CREATE TABLE payouts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    driver_id INT NOT NULL,
    booking_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    method ENUM('M-Pesa', 'Tigo Pesa', 'Bank Transfer') NOT NULL,
    status ENUM('pending', 'ready', 'processed') DEFAULT 'pending',
    processed_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- Rate Cards table
CREATE TABLE rate_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    truck_type ENUM('Fuso', 'Semi Trailer', 'Trailer', 'Pickup') NOT NULL,
    cargo_type ENUM('General', 'Perishable', 'Fragile', 'High Value') NOT NULL,
    base_rate DECIMAL(10,2) NOT NULL,
    per_km_rate DECIMAL(10,2) NOT NULL,
    per_kg_rate DECIMAL(10,2) NOT NULL,
    commission_percent DECIMAL(4,2) NOT NULL DEFAULT 15.00,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_rate (truck_type, cargo_type)
);

-- Activity Log table
CREATE TABLE activity_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    action_type ENUM('booking', 'payment', 'truck', 'alert', 'delivery') NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Insert sample data
INSERT INTO users (name, email, phone, password, role, status, avatar) VALUES
('John Mwamba', 'john@transit.co.tz', '+255 789 000 111', '$2y$10$hash', 'super_admin', 'active', 'JM'),
('Anna Mushi', 'anna@example.com', '+255 712 345 678', '$2y$10$hash', 'cargo_owner', 'active', 'AM'),
('James Kimaro', 'james@example.com', '+255 754 987 654', '$2y$10$hash', 'cargo_owner', 'active', 'JK'),
('Sarah Mbeki', 'sarah@example.com', '+255 787 123 456', '$2y$10$hash', 'cargo_owner', 'active', 'SM'),
('Peter Lema', 'peter@example.com', '+255 765 456 789', '$2y$10$hash', 'cargo_owner', 'active', 'PL'),
('Mary Ngowi', 'mary@example.com', '+255 712 789 012', '$2y$10$hash', 'cargo_owner', 'active', 'MN'),
('David Mwita', 'david@example.com', '+255 755 111 222', '$2y$10$hash', 'driver', 'active', 'DM'),
('Emmanuel Kato', 'emmanuel@example.com', '+255 767 333 444', '$2y$10$hash', 'driver', 'active', 'EK'),
('Joseph Ndalu', 'joseph@example.com', '+255 712 555 666', '$2y$10$hash', 'driver', 'active', 'JN'),
('Francis Kasongo', 'francis@example.com', '+255 784 777 888', '$2y$10$hash', 'driver', 'active', 'FK');

INSERT INTO trucks (plate_number, owner_id, truck_type, capacity_kg, status, availability, rating) VALUES
('T 123 ABC', 7, 'Fuso', 8000, 'verified', 'available', 4.8),
('T 456 DEF', 8, 'Semi Trailer', 20000, 'pending', 'offline', NULL),
('T 789 GHI', 9, 'Trailer', 30000, 'verified', 'en_route', 4.6),
('T 321 JKL', 10, 'Pickup', 3000, 'verified', 'available', 4.9);

INSERT INTO bookings (booking_id, customer_id, truck_id, origin, destination, distance_km, cargo_type, weight_kg, amount, status, pickup_date, pickup_time) VALUES
('TRN-240130-001', 2, NULL, 'Dar es Salaam', 'Arusha', 635, 'General', 5000, 850000, 'requested', '2025-01-30', '08:00:00'),
('TRN-240130-002', 3, 1, 'Mwanza', 'Dar es Salaam', 1120, 'Perishable', 3500, 1450000, 'assigned', '2025-01-30', '14:00:00'),
('TRN-240129-015', 4, 3, 'Dodoma', 'Dar es Salaam', 456, 'High Value', 800, 720000, 'en_route', '2025-01-29', '09:00:00'),
('TRN-240129-014', 5, 4, 'Tanga', 'Moshi', 298, 'Fragile', 1200, 485000, 'delivered', '2025-01-29', '10:00:00'),
('TRN-240128-022', 6, 1, 'Dar es Salaam', 'Iringa', 502, 'General', 7500, 680000, 'completed', '2025-01-28', '07:00:00');

INSERT INTO transactions (transaction_id, booking_id, amount, method, status) VALUES
('TXN-20250130-001', 1, 850000, 'M-Pesa', 'completed'),
('TXN-20250130-002', 2, 1450000, 'Tigo Pesa', 'completed'),
('TXN-20250129-015', 3, 720000, 'Bank Transfer', 'in_escrow'),
('TXN-20250129-014', 4, 485000, 'M-Pesa', 'completed');

INSERT INTO payouts (driver_id, booking_id, amount, method, status) VALUES
(7, 5, 578000, 'M-Pesa', 'ready'),
(9, 4, 412250, 'Tigo Pesa', 'ready'),
(10, 3, 325500, 'M-Pesa', 'ready');

INSERT INTO rate_cards (truck_type, cargo_type, base_rate, per_km_rate, per_kg_rate, commission_percent) VALUES
('Fuso', 'General', 50000, 1000, 20, 15.00),
('Semi Trailer', 'Perishable', 75000, 1200, 25, 15.00),
('Trailer', 'High Value', 100000, 1500, 30, 18.00);

INSERT INTO activity_log (action_type, title, description) VALUES
('booking', 'New booking created', 'TRN-240130-001 • Dar es Salaam → Arusha'),
('payment', 'Payment received', 'TZS 850,000 via M-Pesa'),
('truck', 'Truck verified', 'T 456 DEF • Fuso • 8 ton capacity'),
('delivery', 'Delivery completed', 'TRN-240129-015 • POD submitted'),
('alert', 'Delayed shipment alert', 'TRN-240129-008 • ETA exceeded by 2 hours');
