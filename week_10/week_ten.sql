
SET SERVEROUTPUT ON;

-- PART A: TASK 1 – TAX CALCULATION FUNCTION
CREATE OR REPLACE FUNCTION calculate_tax(p_income NUMBER)
RETURN NUMBER
IS
BEGIN
    IF p_income <= 500000 THEN
        RETURN 0;
    ELSIF p_income <= 1000000 THEN
        RETURN (p_income - 500000) * 0.10;
    ELSIF p_income <= 1500000 THEN
        RETURN ((p_income - 1000000) * 0.20) + 50000;
    ELSE
        RETURN ((p_income - 1500000) * 0.30) + 150000;
    END IF;
END;
/

SELECT calculate_tax(450000) AS tax_low,
       calculate_tax(800000) AS tax_mid,
       calculate_tax(1800000) AS tax_high
FROM dual;

-- PART B: TASK 2 – INDIVIDUAL TAX ASSESSMENT
CREATE OR REPLACE PROCEDURE generate_tax_assessment(p_taxpayer_id IN NUMBER)
IS
    v_name Taxpayer.full_name%TYPE;
    v_pan Taxpayer.pan_number%TYPE;
    v_income Taxpayer.annual_income%TYPE;
    v_occ Taxpayer.occupation%TYPE;
    v_tax NUMBER;
    v_net NUMBER;
BEGIN
    SELECT full_name, pan_number, annual_income, occupation
    INTO v_name, v_pan, v_income, v_occ
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_tax := calculate_tax(v_income);
    v_net := v_income - v_tax;

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('PAN Number: ' || v_pan);
    DBMS_OUTPUT.PUT_LINE('Occupation: ' || v_occ);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || v_tax);
    DBMS_OUTPUT.PUT_LINE('Net Income after Tax: ' || v_net);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC generate_tax_assessment(1);

-- PART C: TASK 3 – CLASSIFICATION FUNCTION
CREATE OR REPLACE FUNCTION income_category(p_income NUMBER)
RETURN VARCHAR2
IS
BEGIN
    IF p_income <= 500000 THEN
        RETURN 'Low Income';
    ELSIF p_income <= 1000000 THEN
        RETURN 'Medium Income';
    ELSIF p_income <= 1500000 THEN
        RETURN 'High Income';
    ELSE
        RETURN 'Very High Income';
    END IF;
END;
/

SELECT full_name AS Taxpayer_Name,
       annual_income AS Annual_Income,
       income_category(annual_income) AS Income_Category
FROM Taxpayer;

-- LEVEL 1: QUESTION 1 – TAXPAYER SUMMARY PROCEDURE
CREATE OR REPLACE PROCEDURE taxpayer_summary(p_taxpayer_id IN NUMBER)
IS
    v_name Taxpayer.full_name%TYPE;
    v_income Taxpayer.annual_income%TYPE;
    v_cat VARCHAR2(30);
    v_tax NUMBER;
    v_net NUMBER;
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_cat := income_category(v_income);
    v_tax := calculate_tax(v_income);
    v_net := v_income - v_tax;

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Income Category: ' || v_cat);
    DBMS_OUTPUT.PUT_LINE('Calculated Tax: ' || v_tax);
    DBMS_OUTPUT.PUT_LINE('Net Income: ' || v_net);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC taxpayer_summary(1);

-- LEVEL 1: QUESTION 2 – INCOME RECORD PROCESSING
CREATE OR REPLACE PROCEDURE check_recorded_income(p_taxpayer_id IN NUMBER)
IS
    v_name Taxpayer.full_name%TYPE;
    v_annual Taxpayer.annual_income%TYPE;
    v_recorded NUMBER;
    v_rec_count NUMBER;
    v_diff NUMBER;
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_annual
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT COUNT(*), NVL(SUM(amount), 0)
    INTO v_rec_count, v_recorded
    FROM Income_Record
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_rec_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No income records exist for ' || v_name);
    ELSE
        v_diff := v_annual - v_recorded;
        DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Total Recorded Income: ' || v_recorded);
        DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_annual);
        DBMS_OUTPUT.PUT_LINE('Difference: ' || v_diff);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC check_recorded_income(1);

-- LEVEL 1: QUESTION 3 – CONDITIONAL ASSESSMENT
CREATE OR REPLACE PROCEDURE conditional_assessment(p_taxpayer_id IN NUMBER)
IS
    v_name Taxpayer.full_name%TYPE;
    v_income Taxpayer.annual_income%TYPE;
    v_status VARCHAR2(30);
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_income <= 500000 THEN
        v_status := 'No Tax Assessment';
    ELSIF v_income <= 1000000 THEN
        v_status := 'Standard Assessment';
    ELSE
        v_status := 'High Income Assessment';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Assessment Status: ' || v_status);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC conditional_assessment(1);

-- LEVEL 2: QUESTION 1 – CURSOR-BASED TAX ASSESSMENT
DECLARE
    CURSOR active_tp_cur IS
        SELECT full_name, annual_income
        FROM Taxpayer
        WHERE is_active = 1;
    v_cat VARCHAR2(30);
    v_tax NUMBER;
    v_net NUMBER;
BEGIN
    FOR rec IN active_tp_cur LOOP
        v_cat := income_category(rec.annual_income);
        v_tax := calculate_tax(rec.annual_income);
        v_net := rec.annual_income - v_tax;

        DBMS_OUTPUT.PUT_LINE(
            rec.full_name || ' | ' ||
            rec.annual_income || ' | ' ||
            v_cat || ' | ' ||
            v_tax || ' | ' ||
            v_net
        );
    END LOOP;
END;
/

-- LEVEL 2: QUESTION 2 – CURSOR WITH CONDITIONAL PROCESSING
DECLARE
    CURSOR active_tp_cur IS
        SELECT full_name, annual_income
        FROM Taxpayer
        WHERE is_active = 1;
    v_tax NUMBER;
    v_cat VARCHAR2(30);
BEGIN
    FOR rec IN active_tp_cur LOOP
        IF rec.annual_income <= 500000 THEN
            v_tax := 0;
            v_cat := 'NO TAX';
        ELSIF rec.annual_income <= 1000000 THEN
            v_tax := (rec.annual_income - 500000) * 0.10;
            v_cat := '10% Slab';
        ELSE
            v_tax := calculate_tax(rec.annual_income);
            v_cat := 'High Slab';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            rec.full_name || ' | ' ||
            rec.annual_income || ' | ' ||
            v_tax || ' | ' ||
            v_cat
        );
    END LOOP;
END;
/

-- LEVEL 2: QUESTION 3 – PROCEDURE WITH UPDATE
CREATE OR REPLACE PROCEDURE update_taxpayer_income(
    p_taxpayer_id IN NUMBER,
    p_new_income IN NUMBER
)
IS
    v_name Taxpayer.full_name%TYPE;
    v_income Taxpayer.annual_income%TYPE;
BEGIN
    IF p_new_income < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid income: Income must be greater than or equal to zero');
        RETURN;
    END IF;

    SELECT full_name
    INTO v_name
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    UPDATE Taxpayer
    SET annual_income = p_new_income
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    DBMS_OUTPUT.PUT_LINE('Updated Taxpayer: ' || v_name || ', New Annual Income: ' || v_income);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer does not exist');
END;
/

EXEC update_taxpayer_income(1, 950000);

-- LEVEL 2: QUESTION 4 – EXCEPTION HANDLING
CREATE OR REPLACE PROCEDURE safe_tax_calc(p_taxpayer_id IN NUMBER)
IS
    v_income Taxpayer.annual_income%TYPE;
    v_tax NUMBER;
BEGIN
    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_tax := calculate_tax(v_income);
    DBMS_OUTPUT.PUT_LINE('Calculated Tax: ' || v_tax);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Taxpayer ID ' || p_taxpayer_id || ' was not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error occurred: ' || SQLERRM);
END;
/

EXEC safe_tax_calc(9999);

-- LEVEL 3: QUESTION 1 – COMPLETE TAX ASSESSMENT SYSTEM
CREATE OR REPLACE PROCEDURE complete_tax_assessment(p_taxpayer_id IN NUMBER)
IS
    v_name Taxpayer.full_name%TYPE;
    v_pan Taxpayer.pan_number%TYPE;
    v_occ Taxpayer.occupation%TYPE;
    v_income Taxpayer.annual_income%TYPE;
    v_cat VARCHAR2(30);
    v_tax NUMBER;
    v_net NUMBER;
BEGIN
    SELECT full_name, pan_number, occupation, annual_income
    INTO v_name, v_pan, v_occ, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_cat := income_category(v_income);
    v_tax := calculate_tax(v_income);
    v_net := v_income - v_tax;

    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE('TAX ASSESSMENT REPORT');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE('Taxpayer Name  : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('PAN Number     : ' || v_pan);
    DBMS_OUTPUT.PUT_LINE('Occupation     : ' || v_occ);
    DBMS_OUTPUT.PUT_LINE('Annual Income  : ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Income Category: ' || v_cat);
    DBMS_OUTPUT.PUT_LINE('Tax Amount     : ' || v_tax);
    DBMS_OUTPUT.PUT_LINE('Net Income     : ' || v_net);
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC complete_tax_assessment(1);

-- LEVEL 3: QUESTION 2 – INCOME RECORD CURSOR PROCESSING
DECLARE
    CURSOR rec_cur IS
        SELECT ir.income_id, ir.taxpayer_id, ir.income_source, ic.category_name,
               ir.amount, ir.received_date, fy.financial_year
        FROM Income_Record ir
        JOIN Income_Category ic ON ir.category_id = ic.category_id
        JOIN Financial_Year fy ON ir.fy_id = fy.fy_id;
