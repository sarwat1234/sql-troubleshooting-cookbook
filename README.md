# SQL Troubleshooting Cookbook

Practical SQL patterns for finding and fixing common data problems, using a small
fictional commercial-lending dataset. Each exercise shows the problem, a diagnostic
query, the expected result, why it works, and what to watch out for.

All data is invented. Nothing here comes from any real system or employer.

## Quick start
```bash
sqlite3 lending.db < data/schema_and_seed.sql
sqlite3 lending.db
```
Then paste the queries from any file in `problems/`.

## Exercises
1. [Find duplicate records](problems/01_find_duplicate_records.md)
2. [Find orphaned records](problems/02_find_orphan_records.md)
3. [Reconcile balances against payments](problems/03_reconcile_balances.md)
4. [Safely remove duplicate payments](problems/04_remove_duplicate_payments.md)

## Dataset
Three tables (`borrowers`, `loans`, `payments`) with planted issues: near-duplicate
borrowers, a loan with no borrower, a payment for a missing loan, a duplicated
payment, and a balance that doesn't match its payments.

## Approach
Diagnose with read-only queries first, understand the cause, and only then change
data, inside a transaction with a backup.
