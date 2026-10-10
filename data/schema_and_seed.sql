-- Sample lending data. Entirely fictional. Written for SQLite; works with minor tweaks elsewhere.
-- Deliberate data problems are planted so each exercise in /problems has something to find.

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS borrowers;

CREATE TABLE borrowers (
  borrower_id INTEGER PRIMARY KEY,
  name        TEXT NOT NULL,
  province    TEXT NOT NULL
);

CREATE TABLE loans (
  loan_id          INTEGER PRIMARY KEY,
  borrower_id      INTEGER,            -- nullable on purpose (bad data)
  product          TEXT NOT NULL,
  principal        NUMERIC NOT NULL,
  stated_balance   NUMERIC NOT NULL,   -- balance as reported by the "source system"
  origination_date TEXT NOT NULL
);

CREATE TABLE payments (
  payment_id   INTEGER PRIMARY KEY,
  loan_id      INTEGER NOT NULL,
  payment_date TEXT NOT NULL,
  amount       NUMERIC NOT NULL
);

INSERT INTO borrowers VALUES
 (1, 'Northwind Supplies Ltd',  'AB'),
 (2, 'Northwind Supplies Ltd.', 'AB'),   -- near-duplicate of 1
 (3, 'Maple Leaf Bakery',       'ON'),
 (4, 'maple leaf bakery ',      'ON'),   -- duplicate of 3 (case + trailing space)
 (5, 'Prairie Fuel Co',         'SK'),
 (6, 'Harbour Marine Inc',      'BC');

INSERT INTO loans VALUES
 (101, 1,    'Term Loan',      100000, 70000, '2024-01-15'),
 (102, 2,    'Line of Credit',  50000, 50000, '2024-03-01'),
 (103, 3,    'Term Loan',       80000, 60000, '2023-11-20'),
 (104, 5,    'Equipment Loan',  40000, 31000, '2024-02-10'),
 (105, NULL, 'Term Loan',       25000, 25000, '2024-05-05'),  -- no borrower
 (106, 6,    'Term Loan',       60000, 45000, '2024-04-12');

INSERT INTO payments VALUES
 (1001, 101, '2024-02-15', 10000),
 (1002, 101, '2024-03-15', 10000),
 (1003, 101, '2024-04-15', 10000),
 (1004, 103, '2024-01-20',  5000),
 (1005, 103, '2024-02-20',  5000),
 (1006, 103, '2024-02-20',  5000),   -- duplicate of 1005
 (1007, 103, '2024-03-20',  5000),
 (1008, 104, '2024-03-10',  4500),
 (1009, 104, '2024-04-10',  4500),
 (1010, 999, '2024-04-10',  1200),   -- orphan: loan 999 does not exist
 (1011, 106, '2024-05-12', 15000),
 (1012, 106, '2024-06-12', 15000);
