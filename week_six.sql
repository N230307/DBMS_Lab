USE taxation_db;

SELECT * FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record);
SELECT * FROM Income_Record WHERE income_amount = (SELECT MIN(income_amount) FROM Income_Record);
SELECT * FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record);
SELECT * FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record);

SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Taxpayer WHERE occupation = 'Business Owner');
SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record);
SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business'));

SELECT * FROM Income_Record WHERE year_id IN (SELECT year_id FROM Financial_Year WHERE financial_year = '2025-2026');

SELECT * FROM Income_Record WHERE income_amount > (SELECT MIN(income_amount) FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business'));

SELECT * FROM Income_Record WHERE income_amount < (SELECT MAX(income_amount) FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Salary'));

SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record));

SELECT * FROM Income_Category WHERE category_id IN (SELECT category_id FROM Income_Record);

SELECT * FROM Taxpayer WHERE taxpayer_id NOT IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));


SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

SELECT * FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business'));

SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record));

SELECT * FROM Income_Record WHERE income_amount > ANY (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

SELECT * FROM Income_Record WHERE income_amount > ALL (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

SELECT * FROM Income_Category WHERE category_id IN (SELECT category_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

SELECT * FROM Financial_Year WHERE year_id IN (SELECT year_id FROM Income_Record GROUP BY year_id HAVING SUM(income_amount) >= ALL (SELECT SUM(income_amount) FROM Income_Record GROUP BY year_id));

SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record GROUP BY taxpayer_id HAVING SUM(income_amount) > (SELECT AVG(total_income) FROM (SELECT SUM(income_amount) AS total_income FROM Income_Record GROUP BY taxpayer_id) AS temp));


SELECT * FROM Taxpayer WHERE taxpayer_id = (SELECT taxpayer_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record));

SELECT * FROM Income_Category WHERE category_id = (SELECT category_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business')) AND taxpayer_id NOT IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

SELECT * FROM Income_Record WHERE income_amount > ALL (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

SELECT * FROM Income_Record WHERE income_amount > ANY (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));
SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record GROUP BY taxpayer_id HAVING SUM(income_amount) >= ALL (SELECT SUM(income_amount) FROM Income_Record GROUP BY taxpayer_id));
SELECT ir.* FROM Income_Record ir JOIN (SELECT category_id, AVG(income_amount) AS avg_inc FROM Income_Record GROUP BY category_id) t ON ir.category_id = t.category_id WHERE ir.income_amount > t.avg_inc;
