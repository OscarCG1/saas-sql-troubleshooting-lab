-- ==================================================
-- SaaS SQL Troubleshooting Lab
-- Sample Data and Simulated Incidents
-- ==================================================

PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- CUSTOMERS

INSERT INTO customers VALUES
(1, 'TechNova Solutions', 'admin@technova.example',
 'Germany', 'active', '2026-01-15'),

(2, 'CloudBridge Ltd', 'support@cloudbridge.example',
 'United Kingdom', 'active', '2026-02-10'),

(3, 'DataFlow Systems', 'contact@dataflow.example',
 'Spain', 'inactive', '2026-03-05'),

(4, 'NextGen Analytics', 'admin@nextgen.example',
 'Poland', 'active', '2026-04-12'),

(5, 'CloudBridge Ltd', 'support@cloudbridge.example',
 'United Kingdom', 'active', '2026-02-10');


-- USERS

INSERT INTO users VALUES
(1, 1, 'Anna Schmidt', 'anna@technova.example',
 'active', '2026-11-01'),

(2, 1, 'Mark Weber', 'mark@technova.example',
 'active', '2026-11-03'),

(3, 2, 'James Wilson', 'james@cloudbridge.example',
 'active', '2026-10-28'),

(4, 3, 'Maria Garcia', 'maria@dataflow.example',
 'inactive', '2026-08-15'),

(5, 4, 'Piotr Kowalski', 'piotr@nextgen.example',
 'active', '2026-11-05'),

(6, 5, 'Sarah Johnson', 'sarah@cloudbridge.example',
 'active', '2026-10-20');


-- SUBSCRIPTIONS

INSERT INTO subscriptions VALUES
(1, 1, 'Enterprise', 'active',
 '2026-01-15', '2027-01-14'),

(2, 2, 'Professional', 'active',
 '2026-02-10', '2027-02-09'),

(3, 3, 'Professional', 'expired',
 '2025-09-01', '2026-08-31'),

-- INC-004: Incorrect subscription status
(4, 4, 'Enterprise', 'expired',
 '2026-04-12', '2027-04-11'),

(5, 5, 'Professional', 'active',
 '2026-02-10', '2027-02-09');


-- INVOICES

INSERT INTO invoices VALUES
(1, 1, 1, 'INV-2026-001', '2026-09',
 299.00, 'EUR', 'paid', '2026-09-01'),

(2, 2, 2, 'INV-2026-002', '2026-10',
 99.00, 'GBP', 'paid', '2026-10-01'),

(3, 4, 4, 'INV-2026-003', '2026-10',
 299.00, 'PLN', 'issued', '2026-10-01'),

(4, 5, 5, 'INV-2026-004', '2026-10',
 99.00, 'GBP', 'paid', '2026-10-01'),

(5, 3, 3, 'INV-2026-005', '2026-11',
 99.00, 'EUR', 'paid', '2026-11-01');


-- PAYMENTS

INSERT INTO payments VALUES
(1, 1, 1, 299.00, 'EUR', 'completed',
 '2026-09-02', 'card', 'TXN-001'),

(2, 2, 2, 99.00, 'GBP', 'completed',
 '2026-10-02', 'card', 'TXN-002'),

(3, 4, 5, 99.00, 'GBP', 'completed',
 '2026-10-02', 'bank_transfer', 'TXN-003'),

-- INC-005: Payment completed but account inactive
(4, 5, 3, 99.00, 'EUR', 'completed',
 '2026-11-02', 'card', 'TXN-004');

COMMIT;
