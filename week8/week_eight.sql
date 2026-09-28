USE taxation_db;
SHOW TABLES;

SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;


SET AUTOCOMMIT = 0;
SELECT @@AUTOCOMMIT;
START TRANSACTION;
UPDATE Income_Record SET income_amount = 850000 WHERE income_record_id = 1;
SELECT * FROM Income_Record WHERE income_record_id = 1;
ROLLBACK;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 900000 WHERE income_record_id = 2;
SELECT * FROM Income_Record WHERE income_record_id = 2;
COMMIT;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 9999999 WHERE income_record_id = 3;
SELECT * FROM Income_Record WHERE income_record_id = 3;
ROLLBACK;
SELECT * FROM Income_Record WHERE income_record_id = 3;

START TRANSACTION;
INSERT INTO Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (999, 1, 1, 1, 50000);
SELECT * FROM Income_Record WHERE income_record_id = 999;
ROLLBACK;
SELECT * FROM Income_Record WHERE income_record_id = 999;

START TRANSACTION;
DELETE FROM Income_Record WHERE income_record_id = 4;
SELECT * FROM Income_Record WHERE income_record_id = 4;
ROLLBACK;
SELECT * FROM Income_Record WHERE income_record_id = 4;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 750000 WHERE income_record_id = 5;
INSERT INTO Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (888, 2, 2, 1, 60000);
COMMIT;


START TRANSACTION;
UPDATE Income_Record SET income_amount = 400000 WHERE income_record_id = 1;
SAVEPOINT sp1;
UPDATE Income_Record SET income_amount = 500000 WHERE income_record_id = 2;
ROLLBACK TO SAVEPOINT sp1;
COMMIT;

START TRANSACTION;
INSERT INTO Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (777, 3, 1, 1, 70000);
SAVEPOINT sp2;
UPDATE Income_Record SET income_amount = 300000 WHERE income_record_id = 3;
ROLLBACK TO SAVEPOINT sp2;
COMMIT;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 110000 WHERE income_record_id = 1;
SAVEPOINT first_mod;
UPDATE Income_Record SET income_amount = 220000 WHERE income_record_id = 2;
SAVEPOINT second_mod;
UPDATE Income_Record SET income_amount = 330000 WHERE income_record_id = 3;
ROLLBACK TO SAVEPOINT first_mod;
COMMIT;

START TRANSACTION;
INSERT INTO Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (666, 1, 2, 1, 80000);
UPDATE Income_Record SET income_amount = 450000 WHERE income_record_id = 2;
SAVEPOINT pre_delete;
DELETE FROM Income_Record WHERE income_record_id = 3;
ROLLBACK TO SAVEPOINT pre_delete;
COMMIT;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 950000 WHERE income_record_id = 5;
SAVEPOINT temp_sp;
RELEASE SAVEPOINT temp_sp;
COMMIT;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 120000 WHERE income_record_id = 1;
SAVEPOINT choice_sp;
UPDATE Income_Record SET income_amount = 130000 WHERE income_record_id = 2;
ROLLBACK TO SAVEPOINT choice_sp;
ROLLBACK;


CREATE USER 'tax_clerk1'@'localhost' IDENTIFIED BY 'Tax@123';

GRANT SELECT ON taxation_db.Taxpayer TO 'tax_clerk1'@'localhost';
SHOW GRANTS FOR 'tax_clerk1'@'localhost';
SELECT * FROM taxation_db.Taxpayer;

GRANT INSERT ON taxation_db.Income_Record TO 'tax_clerk1'@'localhost';
INSERT INTO taxation_db.Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (555, 1, 1, 1, 45000);

UPDATE taxation_db.Income_Record SET income_amount = 500000 WHERE income_record_id = 555;

GRANT SELECT ON taxation_db.view_above_avg_income TO 'tax_clerk1'@'localhost';
SELECT * FROM taxation_db.view_above_avg_income;

REVOKE INSERT ON taxation_db.Income_Record FROM 'tax_clerk1'@'localhost';
SHOW GRANTS FOR 'tax_clerk1'@'localhost';
INSERT INTO taxation_db.Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (444, 1, 1, 1, 45000);


CREATE USER 'tax_data_entry'@'localhost' IDENTIFIED BY 'Entry@123';
GRANT SELECT, INSERT ON taxation_db.Income_Record TO 'tax_data_entry'@'localhost';
SELECT * FROM taxation_db.Income_Record;
INSERT INTO taxation_db.Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (333, 2, 1, 1, 55000);
UPDATE taxation_db.Income_Record SET income_amount = 600000 WHERE income_record_id = 333;

CREATE USER 'tax_officer'@'localhost' IDENTIFIED BY 'Officer@123';
GRANT SELECT, INSERT, UPDATE ON taxation_db.Income_Record TO 'tax_officer'@'localhost';
DELETE FROM taxation_db.Income_Record WHERE income_record_id = 333;

GRANT SELECT ON taxation_db.view_above_avg_income TO 'tax_officer'@'localhost';
SELECT * FROM taxation_db.view_above_avg_income;

GRANT SELECT, INSERT, UPDATE ON taxation_db.Income_Record TO 'test_user_mult'@'localhost';
REVOKE UPDATE ON taxation_db.Income_Record FROM 'test_user_mult'@'localhost';
SELECT * FROM taxation_db.Income_Record;
UPDATE taxation_db.Income_Record SET income_amount = 100000 WHERE income_record_id = 1;

SHOW GRANTS FOR 'tax_data_entry'@'localhost';
SHOW GRANTS FOR 'tax_officer'@'localhost';

CREATE USER 'min_priv_user'@'localhost' IDENTIFIED BY 'MinPriv@123';
GRANT SELECT, INSERT ON taxation_db.Income_Record TO 'min_priv_user'@'localhost';
SELECT * FROM taxation_db.Income_Record;
INSERT INTO taxation_db.Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (222, 1, 1, 1, 35000);
UPDATE taxation_db.Income_Record SET income_amount = 100000 WHERE income_record_id = 222;
DELETE FROM taxation_db.Income_Record WHERE income_record_id = 222;


START TRANSACTION;
INSERT INTO Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (111, 2, 2, 1, 95000);
SELECT * FROM Income_Record WHERE income_record_id = 111;
COMMIT;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 99999999 WHERE income_record_id = 111;
ROLLBACK;

START TRANSACTION;
UPDATE Income_Record SET income_amount = 96000 WHERE income_record_id = 111;
SAVEPOINT f_valid;
UPDATE Income_Record SET income_amount = 1200 WHERE income_record_id = 111;
ROLLBACK TO SAVEPOINT f_valid;
COMMIT;

CREATE USER 'int_data_entry'@'localhost' IDENTIFIED BY 'IntEntry@123';
GRANT SELECT, INSERT ON taxation_db.Income_Record TO 'int_data_entry'@'localhost';
SELECT * FROM taxation_db.Income_Record;
INSERT INTO taxation_db.Income_Record (income_record_id, taxpayer_id, category_id, year_id, income_amount) VALUES (112, 2, 2, 1, 95000);
UPDATE taxation_db.Income_Record SET income_amount = 5000 WHERE income_record_id = 112;
DELETE FROM taxation_db.Income_Record WHERE income_record_id = 112;

GRANT SELECT ON taxation_db.view_above_avg_income TO 'int_data_entry'@'localhost';
SELECT * FROM taxation_db.view_above_avg_income;
SELECT * FROM taxation_db.Taxpayer;

GRANT DELETE ON taxation_db.Income_Record TO 'int_data_entry'@'localhost';
SHOW GRANTS FOR 'int_data_entry'@'localhost';
REVOKE DELETE ON taxation_db.Income_Record FROM 'int_data_entry'@'localhost';
SHOW GRANTS FOR 'int_data_entry'@'localhost';
DELETE FROM taxation_db.Income_Record WHERE income_record_id = 112;


SET AUTOCOMMIT = 1;
SELECT @@AUTOCOMMIT;
SELECT CURRENT_USER();
SHOW GRANTS FOR 'tax_clerk1'@'localhost';
DROP USER IF EXISTS 'tax_clerk1'@'localhost';
DROP USER IF EXISTS 'tax_data_entry'@'localhost';
DROP USER IF EXISTS 'tax_officer'@'localhost';
DROP USER IF EXISTS 'min_priv_user'@'localhost';
DROP USER IF EXISTS 'int_data_entry'@'localhost';
