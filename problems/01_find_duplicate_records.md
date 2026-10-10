# 01. Find duplicate records

## The problem
Two pairs of borrower rows are really the same business, entered slightly
differently ("Northwind Supplies Ltd" vs "Northwind Supplies Ltd."). Duplicates
split loan history across records and distort reporting.

## Diagnose
Exact matching misses these. Normalize first (lowercase, trim whitespace, strip
punctuation), then group.

```sql
SELECT
  LOWER(REPLACE(TRIM(name), '.', '')) AS normalized_name,
  province,
  COUNT(*)                            AS record_count,
  GROUP_CONCAT(borrower_id)           AS borrower_ids
FROM borrowers
GROUP BY normalized_name, province
HAVING COUNT(*) > 1;
```

## Expected result
| normalized_name | province | record_count | borrower_ids |
|---|---|---|---|
| maple leaf bakery | ON | 2 | 3,4 |
| northwind supplies ltd | AB | 2 | 1,2 |

## Why it works
`GROUP BY` on the cleaned value collapses look-alikes, and `HAVING COUNT(*) > 1`
keeps only groups with repeats. `GROUP_CONCAT` shows which IDs to merge.

## Watch out
Never auto-delete the extras. Decide which record survives, repoint the loans to
it, and only then remove the duplicate.
