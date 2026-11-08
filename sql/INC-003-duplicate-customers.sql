-- ==================================================
-- INCIDENT: INC-003
-- TITLE: Duplicate Customer Records
-- CUSTOMER: CloudBridge Ltd
-- ==================================================

-- STEP 1: Identify potential duplicate customers

SELECT
    company_name,
    email,
    COUNT(*) AS total_records
FROM customers
GROUP BY company_name, email
HAVING COUNT(*) > 1;


-- STEP 2: Retrieve duplicate customer details

SELECT
    customer_id,
    company_name,
    email,
    status,
    created_at
FROM customers
WHERE company_name = 'CloudBridge Ltd'
ORDER BY customer_id;


-- STEP 3: Investigate associated users

SELECT
    c.customer_id,
    c.company_name,
    u.user_id,
    u.full_name,
    u.email,
    u.status
FROM customers c
LEFT JOIN users u
    ON c.customer_id = u.customer_id
WHERE c.customer_id IN (2, 5)
ORDER BY c.customer_id;


-- STEP 4: Investigate associated subscriptions

SELECT
    c.customer_id,
    s.subscription_id,
    s.plan_name,
    s.status,
    s.start_date,
    s.end_date
FROM customers c
LEFT JOIN subscriptions s
    ON c.customer_id = s.customer_id
WHERE c.customer_id IN (2, 5)
ORDER BY c.customer_id;


-- STEP 5: Investigate associated invoices

SELECT
    c.customer_id,
    i.invoice_number,
    i.billing_period,
    i.amount,
    i.currency,
    i.status
FROM customers c
LEFT JOIN invoices i
    ON c.customer_id = i.customer_id
WHERE c.customer_id IN (2, 5)
ORDER BY c.customer_id;