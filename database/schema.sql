-- ==================================================
-- SaaS SQL Troubleshooting Lab
-- Database Schema
-- SQLite
-- ==================================================

PRAGMA foreign_keys = ON;

-- CUSTOMERS

CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    company_name TEXT NOT NULL,
    email TEXT NOT NULL,
    country TEXT,
    status TEXT,
    created_at TEXT
);

-- USERS

CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    status TEXT NOT NULL,
    last_login TEXT,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- SUBSCRIPTIONS

CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    plan_name TEXT NOT NULL,
    status TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- INVOICES

CREATE TABLE IF NOT EXISTS invoices (
    invoice_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    subscription_id INTEGER NOT NULL,
    invoice_number TEXT UNIQUE NOT NULL,
    billing_period TEXT NOT NULL,
    amount REAL NOT NULL,
    currency TEXT NOT NULL,
    status TEXT NOT NULL,
    issued_at TEXT,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id)
);

-- PAYMENTS

CREATE TABLE IF NOT EXISTS payments (
    payment_id INTEGER PRIMARY KEY,
    invoice_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    currency TEXT NOT NULL,
    payment_status TEXT NOT NULL,
    payment_date TEXT,
    payment_method TEXT,
    transaction_reference TEXT UNIQUE,
    FOREIGN KEY (invoice_id)
        REFERENCES invoices(invoice_id),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
