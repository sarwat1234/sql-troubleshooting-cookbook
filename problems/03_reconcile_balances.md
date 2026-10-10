# 03. Reconcile reported balances against payments

## The problem
The source system reports a balance for each loan. Does it match principal minus
the payments actually recorded? Differences point to missing payments, duplicates,
or bad data.

## Diagnose
Aggregate payments first, then join. Joining first and summing can multiply rows.

```sql
WITH paid AS (
  SELECT loan_id, SUM(amount) AS total_paid
  FROM payments
  GROUP BY loan_id
)
SELECT
  l.loan_id,
  l.principal,
  COALESCE(p.total_paid, 0)                                     AS total_paid,
  l.principal - COALESCE(p.total_paid, 0)                       AS calculated_balance,
  l.stated_balance,
  l.stated_balance - (l.principal - COALESCE(p.total_paid, 0))  AS difference
FROM loans l
LEFT JOIN paid p ON p.loan_id = l.loan_id
WHERE l.stated_balance <> l.principal - COALESCE(p.total_paid, 0)
ORDER BY ABS(l.stated_balance - (l.principal - COALESCE(p.total_paid, 0))) DESC;
```

## Expected result
| loan_id | principal | total_paid | calculated_balance | stated_balance | difference |
|---|---|---|---|---|---|
| 106 | 60000 | 30000 | 30000 | 45000 | 15000 |

Loan 106 has two 15,000 payments on record, but the source system only reduced the
balance once. A payment was likely recorded but never applied.

## A subtler finding
Loan 103 does *not* appear, because its stated balance (60,000) matches the
payments on record. That match is misleading: it includes the duplicate payment
from exercise 04. Reconciliation only catches what disagrees, so a duplicate that
both systems share is invisible here.

## Why it works
The CTE totals payments once per loan, `LEFT JOIN` keeps loans with no payments,
and `COALESCE` turns "no payments" into 0 instead of NULL.

## Watch out
Always `COALESCE` after a `LEFT JOIN` aggregate, or loans with no payments drop
out of the comparison.
