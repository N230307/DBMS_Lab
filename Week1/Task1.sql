create DATABASE taxation_db;
use taxation_db;

create table Taxpayer(
taxpayer_id INT PRIMARY KEY,
pan_number VARCHAR(10) Not NULL unique,
full_name VARCHAR(100) NOT NULL,
date_of_birth DATE NOT NULL,
occupation varchar(50) Not NULL,
annual_income DECIMAL(12,2) NOT NULL,
email VARCHAR(100) UNIQUE,
is_active BOOLEAN
);
create table Income_category(
category_id INT PRIMARY KEY,
category_name VARCHAR(50) NOT NULL UNIQUE,
description VARCHAR(200) NOt NULL,
taxable BOOLEAN NOT NULL
);
CREATE TABLE Financial_Year (
    year_id INT PRIMARY KEY,
    year_label VARCHAR(9) NOT NULL UNIQUE, -- Formats like '2020-2021'
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    filing_deadline DATE NOT NULL,
    is_current BOOLEAN DEFAULT FALSE
);


create table Income_Record(
income_id INT PRIMary Key,
taxpayer_id INT Not NUll,
income_source VARCHAR(100) NOT NULL,
category_name VArCHar(50) NOT null,
amount decimal(12,2) NOT Null,
received_date Date Not Null,
financial_year varchar(9) Not Null
);

INSERT INTO Taxpayer(
    taxpayer_id, 
    pan_number, 
    full_name, 
    date_of_birth, 
    occupation, 
    annual_income, 
    email, 
    is_active
) VALUES 
(101, 'ABCDE1234F', 'Ravi Kumar', '1995-06-15', 'Software Engineer', 850000.00, 'ravi.kumar@example.com', TRUE),
(102, 'BCDEF2345G', 'Priya Sharma', '1992-11-22', 'Doctor', 1200000.00, 'priya.sharma@example.com', TRUE),
(103, 'CDEFG3456H', 'Arjun Reddy', '1988-03-10', 'Business Owner', 1800000.00, 'arjun.reddy@example.com', TRUE),
(104, 'DEFGH4567J', 'Sneha Patel', '1998-08-05', 'Teacher', 620000.00, 'sneha.patel@example.com', TRUE),
(105, 'EFGHJ5678K', 'Kiran Rao', '1990-01-18', 'Freelancer', 750000.00, 'kiran.rao@example.com', TRUE),
(106, 'FGHJK6789L', 'Meera Singh', '1985-12-30', 'Consultant', 1500000.00, 'meera.singh@example.com', FALSE);


INSERT INTO Income_category (
    category_id, 
    category_name, 
    description, 
    taxable
) VALUES 
(1, 'Salary', 'Income received from employment', TRUE),
(2, 'Business', 'Income earned from business activities', TRUE),
(3, 'House Property', 'Income received from property or rent', TRUE),
(4, 'Capital Gains', 'Income from transfer of eligible assets', TRUE),
(5, 'Other Sources', 'Income such as bank interest', TRUE),
(6, 'Agricultural Income', 'Income from eligible agricultural activities', FALSE);

INSERT INTO Financial_Year (
    year_id, 
    year_label, 
    start_date, 
    end_date, 
    filing_deadline, 
    is_current
) VALUES 
(1, '2020-2021', '2020-04-01', '2021-03-31', '2021-07-31', FALSE),
(2, '2021-2022', '2021-04-01', '2022-03-31', '2022-07-31', FALSE),
(3, '2022-2023', '2022-04-01', '2023-03-31', '2023-07-31', FALSE),
(4, '2023-2024', '2023-04-01', '2024-03-31', '2024-07-31', FALSE),
(5, '2024-2025', '2024-04-01', '2025-03-31', '2025-07-31', FALSE),
(6, '2025-2026', '2025-04-01', '2026-03-31', '2026-07-31', TRUE);

INSERT INTO Income_Record (
    income_id, 
    taxpayer_id, 
    income_source, 
    category_name, 
    amount, 
    received_date, 
    financial_year
) VALUES 
(1001, 101, 'TechNova Solutions', 'Salary', 850000.00, '2026-03-31', '2025-2026'),
(1002, 102, 'City Care Hospital', 'Salary', 1200000.00, '2026-03-31', '2025-2026'),
(1003, 103, 'Reddy Enterprises', 'Business', 1800000.00, '2026-03-31', '2025-2026'),
(1004, 104, 'Sunrise School', 'Salary', 620000.00, '2026-03-31', '2025-2026'),
(1005, 106, 'Professional Consulting', 'Business', 1500000.00, '2026-03-31', '2025-2026'),
(1006, 105, 'Web Design Projects', 'Business', 750000.00, '2026-03-31', '2025-2026');


INSERT INTO Taxpayer (
    taxpayer_id, 
    pan_number, 
    full_name, 
    date_of_birth, 
    occupation, 
    annual_income, 
    email, 
    is_active
) VALUES 
(107, 'GHJKL1234F', 'Mallika', '1995-06-15', 'Software Engineer', 100000.00, 'mallika.@example.com', TRUE);

UPDATE Taxpayer 
SET annual_income = 950000.00 
WHERE taxpayer_id = 101;

UPDATE Taxpayer 
SET occupation = 'Software Consultant' 
WHERE taxpayer_id = 105;

UPDATE Taxpayer 
SET is_active = TRUE 
WHERE taxpayer_id = 106;

DELETE FROM Taxpayer 
WHERE taxpayer_id = 107;

INSERT INTO Income_category (
    category_id, 
    category_name, 
    description, 
    taxable
) VALUES 
(7, 'Rental Income', 'Income generated from leasing residential or commercial property', TRUE);

ALTER TABLE Taxpayer 
ADD COLUMN phone_number VARCHAR(15);

ALTER TABLE Income_Record 
ADD COLUMN remarks VARCHAR(255);

ALTER TABLE Taxpayer 
MODIFY COLUMN occupation VARCHAR(150) NOT NULL;


CREATE TABLE Tax_Office (
    office_id INT PRIMARY KEY,
    office_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);


INSERT INTO Tax_Office (office_id, office_name, city) 
VALUES 
(1, 'Central Tax Division', 'Mumbai'),
(2, 'Regional Tax Office', 'Bangalore');


TRUNCATE TABLE Tax_Office;

DROP TABLE Tax_Office;
