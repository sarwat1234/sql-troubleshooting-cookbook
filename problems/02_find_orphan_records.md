# 02. Find orphaned records

## The problem
Some rows point at parents that don't exist (a payment for a missing loan) or
have no parent at all (a loan with no borrower). These break joins and make
totals disagree between reports.

## Diagnose
```sql
-- Payments whose loan does not exist
SELECT p.payment_id, p.loan_id, p.amount
FROM payments p
LEFT JOIN loans l ON l.loan_id = p.loan_id
WHERE l.loan_id IS NULL;

-- Loans with no valid borrower
SELECT l.loan_id, l.borrower_id
FROM loans l
LEFT JOIN borrowers b ON b.borrower_id = l.borrower_id
WHERE b.borrower_id IS NULL;
```

## Expected result
- First query: payment 1010, pointing at loan 999 (1,200).
- Second query: loan 105, whose borrower_id is NULL.

## Why it works
A `LEFT JOIN` keeps every row from the left table. When no match exists, the right
side's columns are NULL, so `WHERE right.id IS NULL` isolates the orphans.

## Watch out
`NOT IN` silently returns nothing if the subquery contains a NULL. Prefer
`LEFT JOIN ... IS NULL` or `NOT EXISTS`.
