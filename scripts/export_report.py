#!/usr/bin/env python3

import csv
import json
import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATABASE = BASE_DIR / "database" / "saas_test.db"
REPORTS = BASE_DIR / "reports"

CHECKS = {
    "INC-001": """
        SELECT company_name, 'Inactive customer account' AS issue
        FROM customers
        WHERE customer_id = 3 AND status = 'inactive'
    """,
    "INC-002": """
        SELECT c.company_name, 'Missing invoice' AS issue
        FROM customers c
        JOIN subscriptions s ON c.customer_id = s.customer_id
        WHERE c.customer_id = 1
        AND NOT EXISTS (
            SELECT 1 FROM invoices i
            WHERE i.subscription_id = s.subscription_id
            AND i.billing_period = '2026-10'
        )
    """,
    "INC-003": """
        SELECT company_name, 'Duplicate customer records' AS issue
        FROM customers
        GROUP BY company_name, email
        HAVING COUNT(*) > 1
    """,
    "INC-004": """
        SELECT c.company_name, 'Subscription status mismatch' AS issue
        FROM subscriptions s
        JOIN customers c ON s.customer_id = c.customer_id
        WHERE s.status = 'expired'
        AND DATE(s.start_date) <= DATE('2026-11-08')
        AND DATE(s.end_date) >= DATE('2026-11-08')
    """,
    "INC-005": """
        SELECT DISTINCT c.company_name,
               'Payment/account mismatch' AS issue
        FROM customers c
        JOIN subscriptions s ON c.customer_id = s.customer_id
        JOIN invoices i ON s.subscription_id = i.subscription_id
        JOIN payments p ON i.invoice_id = p.invoice_id
        WHERE p.payment_status = 'completed'
        AND i.status = 'paid'
        AND (c.status = 'inactive' OR s.status = 'expired')
    """
}


def main():
    if not DATABASE.is_file():
        print(f"[ERROR] Database not found: {DATABASE}")
        return

    REPORTS.mkdir(exist_ok=True)
    findings = []

    with sqlite3.connect(
        f"{DATABASE.as_uri()}?mode=ro", uri=True
    ) as connection:
        connection.row_factory = sqlite3.Row

        for incident_id, query in CHECKS.items():
            for row in connection.execute(query):
                findings.append({
                    "incident_id": incident_id,
                    "company_name": row["company_name"],
                    "issue": row["issue"],
                    "status": "REVIEW REQUIRED"
                })

    json_file = REPORTS / "health_check.json"
    csv_file = REPORTS / "health_check.csv"

    with open(json_file, "w", encoding="utf-8") as file:
        json.dump(findings, file, indent=4)

    with open(csv_file, "w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(
            file,
            fieldnames=[
                "incident_id",
                "company_name",
                "issue",
                "status"
            ]
        )
        writer.writeheader()
        writer.writerows(findings)

    print("SAAS HEALTH CHECK — REPORT EXPORT")
    print("---------------------------------")
    print(f"Findings exported: {len(findings)}")
    print(f"JSON: {json_file}")
    print(f"CSV:  {csv_file}")


if __name__ == "__main__":
    main()
