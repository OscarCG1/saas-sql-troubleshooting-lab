import sqlite3
import unittest
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent
DATABASE = BASE_DIR / "database" / "saas_test.db"


class TestSaaSHealthCheck(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.connection = sqlite3.connect(
            f"{DATABASE.as_uri()}?mode=ro",
            uri=True
        )

    @classmethod
    def tearDownClass(cls):
        cls.connection.close()

    def test_inc001_inactive_account(self):
        result = self.connection.execute("""
            SELECT COUNT(*)
            FROM customers c
            JOIN users u
                ON c.customer_id = u.customer_id
            WHERE c.customer_id = 3
              AND c.status = 'inactive'
              AND u.status = 'inactive'
        """).fetchone()[0]

        self.assertEqual(result, 1)

    def test_inc002_missing_invoice(self):
        result = self.connection.execute("""
            SELECT COUNT(*)
            FROM subscriptions s
            WHERE s.customer_id = 1
              AND NOT EXISTS (
                  SELECT 1
                  FROM invoices i
                  WHERE i.subscription_id = s.subscription_id
                    AND i.billing_period = '2026-10'
              )
        """).fetchone()[0]

        self.assertEqual(result, 1)

    def test_inc003_duplicate_customer(self):
        result = self.connection.execute("""
            SELECT COUNT(*)
            FROM (
                SELECT company_name, email
                FROM customers
                GROUP BY company_name, email
                HAVING COUNT(*) > 1
            )
        """).fetchone()[0]

        self.assertEqual(result, 1)

    def test_inc004_expired_subscription(self):
        result = self.connection.execute("""
            SELECT COUNT(*)
            FROM subscriptions
            WHERE subscription_id = 4
              AND status = 'expired'
              AND DATE(start_date) <= DATE('2026-11-08')
              AND DATE(end_date) >= DATE('2026-11-08')
        """).fetchone()[0]

        self.assertEqual(result, 1)

    def test_inc005_payment_account_mismatch(self):
        result = self.connection.execute("""
            SELECT COUNT(*)
            FROM customers c
            JOIN subscriptions s
                ON c.customer_id = s.customer_id
            JOIN invoices i
                ON s.subscription_id = i.subscription_id
            JOIN payments p
                ON i.invoice_id = p.invoice_id
            WHERE c.customer_id = 3
              AND p.payment_status = 'completed'
              AND i.status = 'paid'
              AND c.status = 'inactive'
        """).fetchone()[0]

        self.assertEqual(result, 1)


if __name__ == "__main__":
    unittest.main()
