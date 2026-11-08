SELECT
    payment_id,
    invoice_id,
    amount,
    payment_status,
    transaction_reference
FROM payments
ORDER BY payment_id;

-- ==================================================
-- INCIDENT: INC-005
-- TITLE: Payment Completed but Account Inactive
-- CUSTOMER: DataFlow Systems
-- ==================================================

SELECT
    c.company_name,
    c.status AS customer_status,

    u.full_name,
    u.status AS user_status,

    s.plan_name,
    s.status AS subscription_status,
    s.end_date,

    i.invoice_number,
    i.status AS invoice_status,

    p.payment_status,
    p.payment_date,
    p.transaction_reference

FROM customers c

JOIN users u
    ON c.customer_id = u.customer_id

JOIN subscriptions s
    ON c.customer_id = s.customer_id

JOIN invoices i
    ON s.subscription_id = i.subscription_id

JOIN payments p
    ON i.invoice_id = p.invoice_id

WHERE c.customer_id = 3
  AND i.invoice_number = 'INV-2026-005';


SELECT
    c.company_name,
    c.status AS customer_status,
    s.status AS subscription_status,
    i.status AS invoice_status,
    p.payment_status,

    CASE
        WHEN p.payment_status = 'completed'
         AND i.status = 'paid'
         AND (
             c.status = 'inactive'
             OR s.status = 'expired'
         )
        THEN 'REVIEW REQUIRED'

        ELSE 'NO FLAG'
    END AS investigation_result

FROM customers c

JOIN subscriptions s
    ON c.customer_id = s.customer_id

JOIN invoices i
    ON s.subscription_id = i.subscription_id

JOIN payments p
    ON i.invoice_id = p.invoice_id

WHERE c.customer_id = 3
  AND i.invoice_number = 'INV-2026-005';