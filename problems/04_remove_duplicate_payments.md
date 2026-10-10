# 04. Safely remove duplicate payments

## The problem
Payments 1005 and 1006 are the same payment recorded twice (same loan, date,
amount). Duplicates inflate "total paid" and understate balances.

## Diagnose first (read-only)
```sql
SELECT loan_id, payment_date, amount,
       COUNT(*)                 AS copies,
       GROUP_CONCAT(payment_id) AS payment_ids
FROM payments
GROUP BY loan_id, payment_date, amount
HAVING COUNT(*) > 1;
```

Expected result: loan 103, 2024-02-20, 5000, 2 copies (payment_ids 1005,1006).

## Fix: keep the earliest, delete the rest
```sql
BEGIN;

DELETE FROM payments
WHERE payment_id NOT IN (
  SELECT MIN(payment_id)
  FROM payments
  GROUP BY loan_id, payment_date, amount
);

-- Check the result, then COMMIT; or ROLLBACK; if anything looks wrong.
```

## Why it works
For each group of identical payments, `MIN(payment_id)` picks one survivor.
Everything not in that list is a redundant copy.

## Follow-up
After the delete, loan 103 has 15,000 in payments, so its calculated balance
becomes 65,000 while the source system still says 60,000. Re-run exercise 03: the
new mismatch is the correction the source system now needs.

## Watch out
- Review the diagnose rows before any `DELETE`, and work inside a transaction.
- Confirm the rows are true duplicates, not two legitimate identical payments.
