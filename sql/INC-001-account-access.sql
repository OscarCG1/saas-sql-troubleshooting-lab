-- ==================================================
-- INCIDENT: INC-001
-- TITLE: Customer Cannot Access Account
-- CUSTOMER: DataFlow Systems
-- AFFECTED USER: Maria Garcia
-- ==================================================

-- STEP 1: Check user account status

SELECT
    user_id,
    full_name,
    email,
    status,
    last_login
FROM users
WHERE email = 'maria@dataflow.example';


-- STEP 2: Check customer account status

SELECT
    customer_id,
    company_name,
    status
FROM customers
WHERE customer_id = 3;


-- STEP 3: Check subscription status

SELECT
    u.full_name,
    u.status AS user_status,
    c.company_name,
    c.status AS customer_status,
    s.plan_name,
    s.status AS subscription_status,
    s.end_date
FROM users u
JOIN customers c
    ON u.customer_id = c.customer_id
JOIN subscriptions s
    ON c.customer_id = s.customer_id
WHERE u.email = 'maria@dataflow.example';
