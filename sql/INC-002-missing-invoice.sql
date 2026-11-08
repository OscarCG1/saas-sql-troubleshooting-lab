CREATE TABLE invoices (
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


INSERT INTO invoices
(invoice_id, customer_id, subscription_id,
 invoice_number, billing_period, amount,
 currency, status, issued_at)
VALUES
(1, 1, 1, 'INV-2026-001', '2026-09', 299.00, 'EUR', 'paid', '2026-09-01'),
(2, 2, 2, 'INV-2026-002', '2026-10', 99.00, 'GBP', 'paid', '2026-10-01'),
(3, 4, 4, 'INV-2026-003', '2026-10', 299.00, 'PLN', 'issued', '2026-10-01'),
(4, 5, 5, 'INV-2026-004', '2026-10', 99.00, 'GBP', 'paid', '2026-10-01');



SELECT
    c.company_name,
    i.invoice_number,
    i.billing_period,
    i.amount,
    i.currency,
    i.status
FROM customers c
JOIN invoices i
    ON c.customer_id = i.customer_id
WHERE c.company_name = 'TechNova Solutions';


SELECT
    c.company_name,
    s.plan_name,
    s.status AS subscription_status,
    i.invoice_number,
    i.billing_period
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
LEFT JOIN invoices i
    ON s.subscription_id = i.subscription_id
    AND i.billing_period = '2026-10'
WHERE c.customer_id = 1;



-- ==================================================
-- INCIDENT: INC-002
-- TITLE: Invoice Not Generated
-- CUSTOMER: TechNova Solutions
-- BILLING PERIOD: October 2026
-- ==================================================

-- STEP 1: Check customer subscription

SELECT
    c.customer_id,
    c.company_name,
    s.subscription_id,
    s.plan_name,
    s.status AS subscription_status,
    s.end_date
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
WHERE c.customer_id = 1;


-- STEP 2: Retrieve existing customer invoices

SELECT
    c.company_name,
    i.invoice_number,
    i.billing_period,
    i.amount,
    i.currency,
    i.status
FROM customers c
JOIN invoices i
    ON c.customer_id = i.customer_id
WHERE c.customer_id = 1;


-- STEP 3: Detect missing October invoice

SELECT
    c.company_name,
    s.plan_name,
    s.status AS subscription_status,
    i.invoice_number,
    i.billing_period
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
LEFT JOIN invoices i
    ON s.subscription_id = i.subscription_id
    AND i.billing_period = '2026-10'
WHERE c.customer_id = 1;


-- STEP 4: Confirm missing invoice

SELECT
    c.company_name,
    s.subscription_id,
    s.status AS subscription_status
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
WHERE c.customer_id = 1
  AND NOT EXISTS (
      SELECT 1
      FROM invoices i
      WHERE i.subscription_id = s.subscription_id
        AND i.billing_period = '2026-10'
  );