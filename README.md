# SaaS Application Support & SQL Troubleshooting Lab

A hands-on technical support project simulating common incidents in a SaaS application.

The project demonstrates how SQL, Python, and structured troubleshooting techniques can be used to investigate application issues, identify data inconsistencies, and generate automated diagnostic reports.

All customer information is fictional.

## Project Overview

The laboratory simulates a SaaS platform managing:

- Customers and user accounts
- Subscription plans and lifecycle statuses
- Invoices and billing records
- Payment transactions
- Customer account activation

The environment uses a relational SQLite database containing five interconnected tables.

Five simulated support incidents have been investigated and documented.

## Technologies

| Technology | Purpose |
|---|---|
| SQLite | Relational database |
| SQL | Data investigation and troubleshooting |
| DBeaver | Database exploration |
| Python | Automated diagnostic checks |
| unittest | Automated test execution |
| CSV / JSON | Diagnostic report generation |
| Git / GitHub | Version control and documentation |
| Ubuntu | Development environment |

No external Python dependencies are required.

## Simulated Support Incidents

| Incident | Description | Technical Focus |
|---|---|---|
| INC-001 | Customer cannot access account | Account status, SQL JOIN |
| INC-002 | Invoice not generated | Missing records, NOT EXISTS |
| INC-003 | Duplicate customer records | GROUP BY, HAVING, data quality |
| INC-004 | Subscription incorrectly expired | Date validation, CASE WHEN |
| INC-005 | Payment completed but account inactive | Multi-table JOIN, payment investigation |

Each incident includes a SQL investigation script and a technical incident report.

The reports distinguish confirmed database findings from possible root causes and recommended actions.

## Project Structure

```text
saas-sql-troubleshooting-lab/
├── database/
│   ├── schema.sql
│   └── seed_data.sql
├── incidents/
│   ├── INC-001.md
│   ├── INC-002.md
│   ├── INC-003.md
│   ├── INC-004.md
│   └── INC-005.md
├── sql/
│   ├── INC-001-account-access.sql
│   ├── INC-002-missing-invoice.sql
│   ├── INC-003-duplicate-customers.sql
│   ├── INC-004-expired-subscription.sql
│   └── INC-005-payment-sync.sql
├── scripts/
│   ├── health_check.py
│   └── export_report.py
├── tests/
│   └── test_health_check.py
├── reports/
│   ├── health_check.csv
│   └── health_check.json
├── .gitignore
└── README.md
```

## Getting Started

### Requirements

- Python 3
- SQLite 3
- Git
- DBeaver (optional)

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/saas-sql-troubleshooting-lab.git
cd saas-sql-troubleshooting-lab
```

Replace `YOUR_USERNAME` with your GitHub username.

### 2. Create the Database

```bash
sqlite3 database/saas_test.db < database/schema.sql
```

### 3. Load Sample Data

```bash
sqlite3 database/saas_test.db < database/seed_data.sql
```

The sample data reproduces five simulated SaaS support scenarios.

Run the setup commands against a new, empty database.

### 4. Run the Automated Health Check

```bash
python3 scripts/health_check.py
```

The program executes five diagnostic checks against the SQLite database.

Expected summary:

```text
HEALTH CHECK SUMMARY

INC-001: 1 potential issue(s)
INC-002: 1 potential issue(s)
INC-003: 1 potential issue(s)
INC-004: 1 potential issue(s)
INC-005: 1 potential issue(s)

TOTAL: 5 potential issue(s) detected
```

The laboratory uses a fixed reference date of November 8, 2026, for the subscription date consistency check to keep the demonstration reproducible.

### 5. Run Automated Tests

```bash
python3 -m unittest discover -s tests -v
```

Expected result:

```text
Ran 5 tests

OK
```

The current tests verify that the sample database contains the expected incident scenarios.

### 6. Export Diagnostic Reports

```bash
python3 scripts/export_report.py
```

The program generates:

- `reports/health_check.json`
- `reports/health_check.csv`

These files contain structured findings that can be reviewed or imported into other tools.

## Troubleshooting Methodology

Each simulated incident follows a structured investigation process:

1. Review the reported customer issue.
2. Identify the relevant database entities.
3. Formulate possible explanations.
4. Execute SQL diagnostic queries.
5. Analyze the results.
6. Document confirmed findings.
7. Identify potential root causes.
8. Recommend further investigation or authorized corrective actions.

The project does not automatically modify production data or resolve customer accounts.

## Technical Skills Demonstrated

**SQL and databases:** SELECT, WHERE, JOIN, LEFT JOIN, GROUP BY, HAVING, NOT EXISTS, CASE WHEN, date functions, and relational data analysis.

**Python:** SQLite connectivity, reusable functions, automated checks, file handling, CSV and JSON generation.

**Application support:** Incident investigation, data consistency validation, troubleshooting documentation, and root cause analysis methodology.

**Testing:** Automated verification of expected simulated incident conditions using Python unittest.

## Current Limitations

This is a learning and portfolio project, not a production SaaS application.

- All customer and payment data is fictional.
- Business rules are simplified.
- Some checks are specific to the simulated customers and billing periods.
- The tests validate known database scenarios rather than full application behavior.
- Root causes cannot be confirmed from database records alone.

## Future Improvements

- Centralize SQL diagnostic rules.
- Add tests for the diagnostic program itself.
- Support configurable database paths and reference dates.
- Introduce structured logging.
- Add automated CI checks with GitHub Actions.
- Expand incident scenarios.

## Project Purpose

This project was developed as a practical learning exercise to strengthen technical skills relevant to SaaS application support and troubleshooting roles.

It combines relational database investigation, Python automation, testing, and structured technical documentation.
