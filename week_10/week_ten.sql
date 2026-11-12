
SET SERVEROUTPUT ON;

-- PART A: TASK 1
BEGIN
    DBMS_OUTPUT.PUT_LINE('Welcome to TaxationDB');
END;
/

-- PART A: TASK 3 & TASK 5
DECLARE
    v_name Taxpayer.full_name%TYPE;
    v_income Taxpayer.annual_income%TYPE;
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = 1;

    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name || ', Annual Income: ' || v_income);
END;
/

-- LEVEL 0: QUESTION 1
DECLARE
    v_income Taxpayer.annual_income%TYPE;
    v_ten_percent NUMBER;
BEGIN
    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = 1;

    v_ten_percent := v_income * 0.10;
    DBMS_OUTPUT.PUT_LINE('10% of Annual Income: ' || v_ten_percent);
END;
/

-- LEVEL 0: QUESTION 2
CREATE OR REPLACE PROCEDURE show_taxpayer_info(p_taxpayer_id IN NUMBER)
IS
    v_name Taxpayer.full_name%TYPE;
    v_pan Taxpayer.pan_number%TYPE;
    v_occ Taxpayer.occupation%TYPE;
    v_income Taxpayer.annual_income%TYPE;
BEGIN
    SELECT full_name, pan_number, occupation, annual_income
    INTO v_name, v_pan, v_occ, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('PAN Number: ' || v_pan);
    DBMS_OUTPUT.PUT_LINE('Occupation: ' || v_occ);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
END;
/

EXEC show_taxpayer_info(1);

-- LEVEL 0: QUESTION 3
DECLARE
    v_status Taxpayer.is_active%TYPE;
BEGIN
    SELECT is_active
    INTO v_status
    FROM Taxpayer
    WHERE taxpayer_id = 1;

    IF v_status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Active');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Inactive');
    END IF;
END;
/

-- LEVEL 0: QUESTION 4
CREATE OR REPLACE FUNCTION check_taxable(p_amount NUMBER)
RETURN VARCHAR2
IS
BEGIN
    IF p_amount > 0 THEN
        RETURN 'Taxable';
    ELSE
        RETURN 'Non-Taxable';
    END IF;
END;
/

SELECT check_taxable(50000) FROM dual;

-- LEVEL 0: QUESTION 5
DECLARE
    v_num NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
END;
/

-- LEVEL 1: QUESTION 1
CREATE OR REPLACE PROCEDURE classify_taxpayer_income(p_taxpayer_id IN NUMBER)
IS
    v_income Taxpayer.annual_income%TYPE;
BEGIN
    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_income > 1000000 THEN
        DBMS_OUTPUT.PUT_LINE('High Income');
    ELSIF v_income >= 500000 THEN
        DBMS_OUTPUT.PUT_LINE('Medium Income');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Income');
    END IF;
END;
/

EXEC classify_taxpayer_income(1);

-- LEVEL 1: QUESTION 2
CREATE OR REPLACE FUNCTION get_annual_income(p_taxpayer_id NUMBER)
RETURN NUMBER
IS
    v_income NUMBER;
BEGIN
    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    RETURN v_income;
END;
/

SELECT full_name, get_annual_income(taxpayer_id) AS annual_income
FROM Taxpayer;

-- LEVEL 2: QUESTION 1
DECLARE
    CURSOR active_tp_cursor IS
        SELECT full_name, annual_income, occupation
        FROM Taxpayer
        WHERE is_active = 1;
BEGIN
    FOR tp_rec IN active_tp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            tp_rec.full_name || ' - ' ||
            tp_rec.annual_income || ' - ' ||
            tp_rec.occupation
        );
    END LOOP;
END;
/

-- LEVEL 2: QUESTION 2
CREATE OR REPLACE PROCEDURE fetch_taxpayer(p_taxpayer_id IN NUMBER)
IS
    v_name Taxpayer.full_name%TYPE;
    v_income Taxpayer.annual_income%TYPE;
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC fetch_taxpayer(9999);

-- OPTIONAL 1: PROCEDURE WITH UPDATE
CREATE OR REPLACE PROCEDURE update_taxpayer_income(
    p_taxpayer_id IN NUMBER,
    p_new_income IN NUMBER
)
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_count > 0 THEN
        UPDATE Taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;
        DBMS_OUTPUT.PUT_LINE('Annual income updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
    END IF;
END;
/

EXEC update_taxpayer_income(1, 900000);

-- OPTIONAL 2: CASE CLASSIFICATION
CREATE OR REPLACE PROCEDURE classify_income_case(p_income IN NUMBER)
IS
BEGIN
    CASE
        WHEN p_income > 1000000 THEN
            DBMS_OUTPUT.PUT_LINE('High');
        WHEN p_income >= 500000 THEN
            DBMS_OUTPUT.PUT_LINE('Medium');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Low');
    END CASE;
END;
/

EXEC classify_income_case(750000);

-- OPTIONAL 3: INCOME RECORDS BY TAXPAYER
CREATE OR REPLACE PROCEDURE show_income_records(p_taxpayer_id IN NUMBER)
IS
    CURSOR rec_cursor IS
        SELECT ir.income_source, ic.category_name, ir.amount, ir.received_date, fy.financial_year
        FROM Income_Record ir
        JOIN Income_Category ic ON ir.category_id = ic.category_id
        JOIN Financial_Year fy ON ir.fy_id = fy.fy_id
        WHERE ir.taxpayer_id = p_taxpayer_id;
BEGIN
    FOR r IN rec_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            r.income_source || ' | ' ||
            r.category_name || ' | ' ||
            r.amount || ' | ' ||
            r.received_date || ' | ' ||
            r.financial_year
        );
    END LOOP;
END;
/

EXEC show_income_records(1);

-- OPTIONAL 4: CURSOR PROCESSING ALL INCOME RECORDS
DECLARE
    CURSOR all_income_cursor IS
        SELECT ir.income_id, ir.income_source, ir.amount, fy.financial_year
        FROM Income_Record ir
        JOIN Financial_Year fy ON ir.fy_id = fy.fy_id;
BEGIN
    FOR r IN all_income_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            r.income_id || ' | ' ||
            r.income_source || ' | ' ||
            r.amount || ' | ' ||
            r.financial_year
        );
    END LOOP;
END;
/

-- OPTIONAL 5: FUNCTION WITH TAXATION LOGIC
CREATE OR REPLACE FUNCTION get_tax_category(p_income NUMBER)
RETURN VARCHAR2
IS
BEGIN
    IF p_income <= 500000 THEN
        RETURN 'No Tax Category';
    ELSIF p_income <= 1000000 THEN
        RETURN 'Moderate Income';
    ELSE
        RETURN 'High Income';
    END IF;
END;
/

SELECT full_name, annual_income, get_tax_category(annual_income) AS tax_category
FROM Taxpayer;


================================================================================
PART 2: MYSQL STORED PROGRAMS (week9_stored_programs_mysql.sql)
================================================================================

USE taxation_db;

-- PART A: TASK 2
DELIMITER //
CREATE PROCEDURE welcome_taxation()
BEGIN
    SELECT 'Welcome to TaxationDB' AS message;
END //
DELIMITER ;

CALL welcome_taxation();

-- PART A: TASK 4 & TASK 5
DELIMITER //
CREATE PROCEDURE get_taxpayer_details(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT v_name AS taxpayer_name, v_income AS annual_income;
END //
DELIMITER ;

CALL get_taxpayer_details(1);

-- LEVEL 0: QUESTION 1
DELIMITER //
CREATE PROCEDURE calc_ten_percent(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_ten_percent DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SET v_ten_percent = v_income * 0.10;
    SELECT v_ten_percent AS ten_percent_income;
END //
DELIMITER ;

CALL calc_ten_percent(1);

-- LEVEL 0: QUESTION 2
DELIMITER //
CREATE PROCEDURE show_taxpayer_info(IN p_taxpayer_id INT)
BEGIN
    SELECT full_name AS Taxpayer_Name,
           pan_number AS PAN_Number,
           occupation AS Occupation,
           annual_income AS Annual_Income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
END //
DELIMITER ;

CALL show_taxpayer_info(1);

-- LEVEL 0: QUESTION 3
DELIMITER //
CREATE PROCEDURE check_taxpayer_status(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_status TINYINT;

    SELECT is_active
    INTO v_status
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_status = 1 THEN
        SELECT 'Active' AS status;
    ELSE
        SELECT 'Inactive' AS status;
    END IF;
END //
DELIMITER ;

CALL check_taxpayer_status(1);

-- LEVEL 0: QUESTION 4
DELIMITER //
CREATE FUNCTION check_taxable(p_amount DECIMAL(12,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_amount > 0 THEN
        RETURN 'Taxable';
    ELSE
        RETURN 'Non-Taxable';
    END IF;
END //
DELIMITER ;

SELECT check_taxable(50000);

-- LEVEL 0: QUESTION 5
DELIMITER //
CREATE PROCEDURE print_one_to_ten()
BEGIN
    DECLARE v_num INT DEFAULT 1;

    num_loop: LOOP
        SELECT v_num;
        SET v_num = v_num + 1;
        IF v_num > 10 THEN
            LEAVE num_loop;
        END IF;
    END LOOP;
END //
DELIMITER ;

CALL print_one_to_ten();

-- LEVEL 1: QUESTION 1
DELIMITER //
CREATE PROCEDURE classify_taxpayer_income(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_income > 1000000 THEN
        SELECT 'High Income' AS classification;
    ELSEIF v_income >= 500000 THEN
        SELECT 'Medium Income' AS classification;
    ELSE
        SELECT 'Low Income' AS classification;
    END IF;
END //
DELIMITER ;

CALL classify_taxpayer_income(1);

-- LEVEL 1: QUESTION 2
DELIMITER //
