-- ==================================================
-- INCIDENT: INC-004
-- TITLE: Subscription Incorrectly Expired
-- CUSTOMER: NextGen Analytics
-- ==================================================

-- STEP 1: Check subscription details

SELECT
    c.company_name,
    s.subscription_id,
    s.status,
    s.start_date,
    s.end_date
FROM subscriptions s
JOIN customers c
    ON s.customer_id = c.customer_id
WHERE s.subscription_id = 4;


-- STEP 2: Detect incorrectly expired subscriptions

SELECT
    c.company_name,
    s.subscription_id,
    s.status AS recorded_status,
    s.end_date,
    'active' AS expected_status
FROM subscriptions s
JOIN customers c
    ON s.customer_id = c.customer_id
WHERE s.status = 'expired'
  AND DATE(s.start_date) <= DATE('now')
  AND DATE(s.end_date) >= DATE('now');


-- STEP 3: Classify subscription status using dates

SELECT
    c.company_name,
    s.status AS recorded_status,
    s.start_date,
    s.end_date,
    CASE
        WHEN DATE(s.end_date) < DATE('now')
            THEN 'expired'
        WHEN DATE(s.start_date) > DATE('now')
            THEN 'not_started'
        ELSE 'active'
    END AS expected_status
FROM subscriptions s
JOIN customers c
    ON s.customer_id = c.customer_id;


-- STEP 4: Post-resolution validation
-- Run after an authorized correction.

SELECT
    subscription_id,
    customer_id,
    status,
    end_date
FROM subscriptions
WHERE subscription_id = 4;