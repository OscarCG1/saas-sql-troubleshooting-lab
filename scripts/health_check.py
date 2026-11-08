#!/usr/bin/env python3

"""
SaaS Application Health Check
SQL Troubleshooting Lab

Automated database checks using Python and SQLite.
"""

import sqlite3
from pathlib import Path


# Database location
BASE_DIR = Path(__file__).resolve().parent.parent
DATABASE = BASE_DIR / "database" / "saas_test.db"


def run_check(connection, title, query):
    """Execute a SQL check and display the results."""

    print(f"\n[CHECK] {title}")

    cursor = connection.execute(query)
    results = cursor.fetchall()

    if results:
        for row in results:
            print(f"  [WARNING] {dict(row)}")
    else:
        print("  [OK] No issues detected")

    return len(results)


def main():

    print("=" * 55)
    print("SAAS APPLICATION HEALTH CHECK")
    print("=" * 55)

    if not DATABASE.is_file():
        print(f"[ERROR] Database not found: {DATABASE}")
        return

    connection = sqlite3.connect(DATABASE)
    connection.row_factory = sqlite3.Row

    try:
        # INC-001: Inactive customer and user accounts
        inc001 = run_check(
            connection,
            "INC-001: Inactive customer account",
            """
            SELECT
                c.company_name,
                u.full_name,
                c.status AS customer_status,
                u.status AS user_status
            FROM customers c
            JOIN users u
                ON c.customer_id = u.customer_id
            WHERE c.customer_id = 3
              AND (
                  c.status = 'inactive'
                  OR u.status = 'inactive'
              );
            """
        )

        # INC-002: Missing October invoice
        inc002 = run_check(
            connection,
            "INC-002: Missing invoice",
            """
            SELECT
                c.company_name,
                s.subscription_id
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
            """
        )

        # INC-003: Duplicate customers
        inc003 = run_check(
            connection,
            "INC-003: Duplicate customer records",
            """
            SELECT
                company_name,
                email,
                COUNT(*) AS total_records
            FROM customers
            GROUP BY company_name, email
            HAVING COUNT(*) > 1;
            """
        )

        # INC-004: Incorrectly expired subscriptions
        inc004 = run_check(
            connection,
            "INC-004: Subscription status mismatch",
            """
            SELECT
                c.company_name,
                s.status,
                s.end_date
            FROM subscriptions s
            JOIN customers c
                ON s.customer_id = c.customer_id
            WHERE s.status = 'expired'
              AND DATE(s.start_date) <= DATE('2026-11-08')
              AND DATE(s.end_date) >= DATE('2026-11-08');
            """
        )

        # INC-005: Payment completed but account inactive
        inc005 = run_check(
            connection,
            "INC-005: Payment/account mismatch",
            """
            SELECT
                c.company_name,
                p.transaction_reference,
                p.payment_status,
                c.status AS customer_status,
                s.status AS subscription_status
            FROM customers c
            JOIN subscriptions s
                ON c.customer_id = s.customer_id
            JOIN invoices i
                ON s.subscription_id = i.subscription_id
            JOIN payments p
                ON i.invoice_id = p.invoice_id
            WHERE p.payment_status = 'completed'
              AND i.status = 'paid'
              AND (
                  c.status = 'inactive'
                  OR s.status = 'expired'
              );
            """
        )

        total = inc001 + inc002 + inc003 + inc004 + inc005

        print("\n" + "=" * 55)
        print("HEALTH CHECK SUMMARY")
        print("=" * 55)

        print(f"INC-001: {inc001} potential issue(s)")
        print(f"INC-002: {inc002} potential issue(s)")
        print(f"INC-003: {inc003} potential issue(s)")
        print(f"INC-004: {inc004} potential issue(s)")
        print(f"INC-005: {inc005} potential issue(s)")

        print("-" * 55)
        print(f"TOTAL: {total} potential issue(s) detected")
        print("=" * 55)

    except sqlite3.Error as error:
        print(f"[ERROR] SQL execution failed: {error}")

    finally:
        connection.close()


if __name__ == "__main__":
    main()
