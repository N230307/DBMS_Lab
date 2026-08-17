USE taxation_db;

-- ----------------------------------------------------------------------------
-- PART A: REDESIGNING THE DATABASE (Schema Refactoring & Foreign Keys)
-- ----------------------------------------------------------------------------

-- Step 1 & 2: Drop the non-relational table and create the refactored schema
-- (Since changing existing plain text fields containing custom formats directly 
-- to foreign key constraints is cleaner with a table rebuild, we align to IDs).
DROP TABLE IF EXISTS Income_Record;

CREATE TABLE Income_Record (
    income_id INT PRIMARY KEY,
    taxpayer_id INT NOT NULL,
    income_source VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,  -- Replaced category_name plain text with ID
    amount DECIMAL(12,2) NOT NULL,
    received_date DATE NOT NULL,
    year_id INT NOT NULL       -- Replaced financial_year plain text with ID
);

-- Step 3: Establish Referential Integrity using Foreign Key Constraints
ALTER TABLE Income_Record 
ADD CONSTRAINT fk_income_taxpayer 
FOREIGN KEY (taxpayer_id) REFERENCES Taxpayer(taxpayer_id);

ALTER TABLE Income_Record 
ADD CONSTRAINT fk_income_category 
FOREIGN KEY (category_id) REFERENCES Income_Category(category_id);

ALTER TABLE Income_Record 
ADD CONSTRAINT fk_income_year 
FOREIGN KEY (year_id) REFERENCES Financial_Year(year_id);

-- Step 4: Populate/Update the table with clean relational records
INSERT INTO Income_Record (income_id, taxpayer_id, income_source, category_id, amount, received_date, year_id) VALUES 
(1001, 101, 'TechNova Solutions', 1, 850000.00, '2026-03-31', 6),
(1002, 102, 'City Care Hospital', 1, 1200000.00, '2026-03-31', 6),
(1003, 103, 'Reddy Enterprises', 2, 1800000.00, '2026-03-31', 6),
(1004, 104, 'Sunrise School', 1, 620000.00, '2026-03-31', 6),
(1005, 106, 'Professional Consulting', 2, 1500000.00, '2026-03-31', 6),
(1006, 105, 'Web Design Projects', 2, 750000.00, '2026-03-31', 6);


-- ----------------------------------------------------------------------------
-- PART B: VERIFYING FOREIGN KEYS (Practice Verification Queries)
-- ----------------------------------------------------------------------------

-- Task 1: Try inserting an invalid taxpayer_id (Will fail parent check)
-- EXPECTED RESULT: Error 1452 (Cannot add or update a child row: a foreign key constraint fails)
-- REASON: taxpayer_id 999 does not exist in the parent table 'Taxpayer'.
INSERT INTO Income_Record VALUES (1007, 999, 'Test Source', 1, 50000.00, '2026-03-31', 6);

-- Task 2: Try inserting an invalid category_id
-- EXPECTED RESULT: Error 1452 (Foreign key constraint fails)
INSERT INTO Income_Record VALUES (1008, 101, 'Test Source', 20, 50000.00, '2026-03-31', 6);

-- Task 3: Try inserting an invalid year_id
-- EXPECTED RESULT: Error 1452 (Foreign key constraint fails)
INSERT INTO Income_Record VALUES (1009, 101, 'Test Source', 1, 50000.00, '2026-03-31', 15);

-- Task 4: Try deleting a taxpayer whose records exist in child table
-- EXPECTED RESULT: Error 1451 (Cannot delete or update a parent row: a foreign key constraint fails)
DELETE FROM Taxpayer WHERE taxpayer_id = 101;

-- Task 5: Try deleting a category currently being used
-- EXPECTED RESULT: Error 1451 (Foreign key constraint fails)
DELETE FROM Income_Category WHERE category_id = 1;


-- ----------------------------------------------------------------------------
-- PART C: DISTINCT
-- ----------------------------------------------------------------------------

-- Task 1: Display all unique occupations of taxpayers
SELECT DISTINCT occupation FROM Taxpayer;

-- Task 2: Display all unique income categories available (via used records or master)
SELECT DISTINCT category_name FROM Income_Category;

-- Task 3: Display all unique financial years available in the database
SELECT DISTINCT year_label FROM Financial_Year;

-- Task 4: Display all unique income sources recorded
SELECT DISTINCT income_source FROM Income_Record;


-- ----------------------------------------------------------------------------
-- PART D: UNION (Combines results and removes duplicates)
-- ----------------------------------------------------------------------------

-- Task 1: Names of taxpayers who have either Salary income OR Business income
SELECT t.full_name FROM Taxpayer t JOIN Income_Record r ON t.taxpayer_id = r.taxpayer_id WHERE r.category_id = 1
UNION
SELECT t.full_name FROM Taxpayer t JOIN Income_Record r ON t.taxpayer_id = r.taxpayer_id WHERE r.category_id = 2;

-- Task 2: All income sources recorded in 2024-2025 UNION 2025-2026
SELECT income_source FROM Income_Record WHERE year_id = (SELECT year_id FROM Financial_Year WHERE year_label = '2024-2025')
UNION
SELECT income_source FROM Income_Record WHERE year_id = (SELECT year_id FROM Financial_Year WHERE year_label = '2025-2026');

-- Task 3: Taxpayers who belong to the occupation Teacher UNION Software Engineer
SELECT full_name FROM Taxpayer WHERE occupation = 'Teacher'
UNION
SELECT full_name FROM Taxpayer WHERE occupation = 'Software Engineer';


-- ----------------------------------------------------------------------------
-- PART E: INTERSECT (Emulated via INNER JOIN / IN for MySQL support)
-- ----------------------------------------------------------------------------

-- Task 1: Find taxpayers who have both Salary income AND Business income
SELECT t.full_name FROM Taxpayer t 
WHERE t.taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE category_id = 1)
  AND t.taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE category_id = 2);

-- Task 2: Find taxpayers who have income records in both 2024-2025 AND 2025-2026
SELECT t.full_name FROM Taxpayer t
WHERE t.taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE year_id = (SELECT year_id FROM Financial_Year WHERE year_label = '2024-2025'))
  AND t.taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE year_id = (SELECT year_id FROM Financial_Year WHERE year_label = '2025-2026'));


-- ----------------------------------------------------------------------------
-- PART F: EXCEPT / MINUS (Emulated via NOT IN / NOT EXISTS for MySQL support)
-- ----------------------------------------------------------------------------

-- Task 1: Find taxpayers who have Salary income but do not have Business income
SELECT t.full_name FROM Taxpayer t 
JOIN Income_Record r ON t.taxpayer_id = r.taxpayer_id 
WHERE r.category_id = 1
  AND t.taxpayer_id NOT IN (SELECT taxpayer_id FROM Income_Record WHERE category_id = 2);

-- Task 2: Taxpayers who submitted income records in 2025-2026 but not in 2024-2025
SELECT DISTINCT t.full_name FROM Taxpayer t
JOIN Income_Record r ON t.taxpayer_id = r.taxpayer_id
WHERE r.year_id = (SELECT year_id FROM Financial_Year WHERE year_label = '2025-2026')
  AND t.taxpayer_id NOT IN (
      SELECT taxpayer_id FROM Income_Record 
      WHERE year_id = (SELECT year_id FROM Financial_Year WHERE year_label = '2024-2025')
  );


-- ----------------------------------------------------------------------------
-- PART G: NESTED QUERIES USING IN
-- ----------------------------------------------------------------------------

-- Task 1: Names of taxpayers who have submitted at least one income record
SELECT full_name FROM Taxpayer 
WHERE taxpayer_id IN (SELECT DISTINCT taxpayer_id FROM Income_Record);

-- Task 2: Taxpayers whose occupation matches anyone currently earning Business income
SELECT full_name, occupation FROM Taxpayer 
WHERE occupation IN (
    SELECT DISTINCT t.occupation FROM Taxpayer t 
    JOIN Income_Record r ON t.taxpayer_id = r.taxpayer_id 
    WHERE r.category_id = 2
);


-- ----------------------------------------------------------------------------
-- PART H: NESTED QUERIES USING NOT IN
-- ----------------------------------------------------------------------------

-- Task 1: Display taxpayers who have not submitted any income records
SELECT full_name FROM Taxpayer 
WHERE taxpayer_id NOT IN (SELECT DISTINCT taxpayer_id FROM Income_Record);

-- Task 2: Display occupations that are not present in any income record
SELECT DISTINCT occupation FROM Taxpayer 
WHERE occupation NOT IN (
    SELECT DISTINCT t.occupation FROM Taxpayer t 
    JOIN Income_Record r ON t.taxpayer_id = r.taxpayer_id
);


-- ----------------------------------------------------------------------------
-- PART I: EXISTS
-- ----------------------------------------------------------------------------

-- Task 1: Display taxpayers for whom at least one income record exists
SELECT t.full_name FROM Taxpayer t 
WHERE EXISTS (
    SELECT 1 FROM Income_Record r WHERE r.taxpayer_id = t.taxpayer_id
);

-- Task 2: Display financial years that have at least one income record
SELECT f.year_label FROM Financial_Year f 
WHERE EXISTS (
    SELECT 1 FROM Income_Record r WHERE r.year_id = f.year_id
);


-- ----------------------------------------------------------------------------
-- PART J: NOT EXISTS
-- ----------------------------------------------------------------------------

-- Task 1: Display taxpayers who do not have any income records
SELECT t.full_name FROM Taxpayer t 
WHERE NOT EXISTS (
    SELECT 1 FROM Income_Record r WHERE r.taxpayer_id = t.taxpayer_id
);

-- Task 2: Display income categories that have never been used
SELECT c.category_name FROM Income_Category c 
WHERE NOT EXISTS (
    SELECT 1 FROM Income_Record r WHERE r.category_id = c.category_id
);


-- ----------------------------------------------------------------------------
-- PART K: ANY
-- ----------------------------------------------------------------------------

-- Task 1: Annual income greater than ANY taxpayer whose occupation is Teacher
SELECT full_name, annual_income FROM Taxpayer 
WHERE annual_income > ANY (SELECT annual_income FROM Taxpayer WHERE occupation = 'Teacher');

