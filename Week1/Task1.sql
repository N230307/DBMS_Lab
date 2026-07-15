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
