USE taxation_db;

CREATE VIEW view_highest_income AS SELECT * FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record);
CREATE VIEW view_lowest_income AS SELECT * FROM Income_Record WHERE income_amount = (SELECT MIN(income_amount) FROM Income_Record);
CREATE VIEW view_above_avg_income AS SELECT * FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record);
CREATE VIEW view_equal_highest_income AS SELECT * FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record);

CREATE VIEW view_business_owners AS SELECT * FROM Taxpayer WHERE occupation = 'Business Owner';
CREATE VIEW view_taxpayers_with_income AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT DISTINCT taxpayer_id FROM Income_Record);
CREATE VIEW view_taxpayers_business_income AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business'));

CREATE VIEW view_income_2025_2026 AS SELECT ir.* FROM Income_Record ir JOIN Financial_Year fy ON ir.year_id = fy.year_id WHERE fy.financial_year = '2025-2026';
CREATE VIEW view_income_gt_min_business AS SELECT * FROM Income_Record WHERE income_amount > (SELECT MIN(income_amount) FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business'));
CREATE VIEW view_income_lt_max_salary AS SELECT * FROM Income_Record WHERE income_amount < (SELECT MAX(income_amount) FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Salary'));

CREATE VIEW view_taxpayers_above_avg AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record));

CREATE VIEW view_categories_with_income AS SELECT * FROM Income_Category WHERE category_id IN (SELECT DISTINCT category_id FROM Income_Record);

CREATE VIEW view_taxpayers_no_investment AS SELECT * FROM Taxpayer WHERE taxpayer_id NOT IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));


CREATE VIEW view_taxpayer_highest_income AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

CREATE VIEW view_income_gt_avg_business AS SELECT * FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business'));

CREATE VIEW view_taxpayers_gt_avg_total AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record GROUP BY taxpayer_id HAVING SUM(income_amount) > (SELECT AVG(total_income) FROM (SELECT SUM(income_amount) AS total_income FROM Income_Record GROUP BY taxpayer_id) AS temp));

CREATE VIEW view_income_gt_any_investment AS SELECT * FROM Income_Record WHERE income_amount > ANY (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

CREATE VIEW view_income_gt_all_investment AS SELECT * FROM Income_Record WHERE income_amount > ALL (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

CREATE VIEW view_category_highest_income AS SELECT * FROM Income_Category WHERE category_id IN (SELECT category_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

CREATE VIEW view_year_highest_total AS SELECT * FROM Financial_Year WHERE year_id IN (SELECT year_id FROM Income_Record GROUP BY year_id HAVING SUM(income_amount) >= ALL (SELECT SUM(income_amount) FROM Income_Record GROUP BY year_id));

CREATE VIEW view_taxpayers_highest_total_rec AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record GROUP BY taxpayer_id HAVING SUM(income_amount) > (SELECT AVG(total_income) FROM (SELECT SUM(income_amount) AS total_income FROM Income_Record GROUP BY taxpayer_id) AS temp));


CREATE VIEW view_analysis_highest_taxpayer AS SELECT * FROM Taxpayer WHERE taxpayer_id = (SELECT taxpayer_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

CREATE VIEW view_analysis_above_avg_taxpayers AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE income_amount > (SELECT AVG(income_amount) FROM Income_Record));

CREATE VIEW view_analysis_highest_category AS SELECT * FROM Income_Category WHERE category_id = (SELECT category_id FROM Income_Record WHERE income_amount = (SELECT MAX(income_amount) FROM Income_Record));

CREATE VIEW view_analysis_business_no_investment AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Business')) AND taxpayer_id NOT IN (SELECT taxpayer_id FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

CREATE VIEW view_analysis_gt_every_investment AS SELECT * FROM Income_Record WHERE income_amount > ALL (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));

CREATE VIEW view_analysis_gt_at_least_one_investment AS SELECT * FROM Income_Record WHERE income_amount > ANY (SELECT income_amount FROM Income_Record WHERE category_id IN (SELECT category_id FROM Income_Category WHERE category_name = 'Investment'));
CREATE VIEW view_analysis_highest_total_taxpayer AS SELECT * FROM Taxpayer WHERE taxpayer_id IN (SELECT taxpayer_id FROM Income_Record GROUP BY taxpayer_id HAVING SUM(income_amount) >= ALL (SELECT SUM(income_amount) FROM Income_Record GROUP BY taxpayer_id));
CREATE VIEW view_analysis_above_category_avg AS SELECT ir.* FROM Income_Record ir JOIN (SELECT category_id, AVG(income_amount) AS avg_inc FROM Income_Record GROUP BY category_id) t ON ir.category_id = t.category_id WHERE ir.income_amount > t.avg_inc;