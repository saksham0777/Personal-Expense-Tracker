-- 1. DDL: Create Table
CREATE TABLE expenses (
    expense_id     NUMBER PRIMARY KEY,
    expense_date   DATE,
    description    VARCHAR2(100),
    category       VARCHAR2(50),
    amount         NUMBER(10, 2),
    payment_mode   VARCHAR2(30),
    expense_month  VARCHAR2(7),
    txn_type       VARCHAR2(20)
);

-- 2. Load Cleaned Data
INSERT INTO expenses VALUES (101, DATE '2026-10-02', 'Swiggy Lunch', 'Food', 350, 'UPI', '2026-10', 'Expense');
INSERT INTO expenses VALUES (102, DATE '2026-10-05', 'Metro Card Recharge', 'Travel', 500, 'UPI', '2026-10', 'Expense');
INSERT INTO expenses VALUES (103, DATE '2026-10-12', 'Amazon Headphones', 'Shopping', 2500, 'Card', '2026-10', 'Expense');
INSERT INTO expenses VALUES (104, DATE '2026-10-18', 'Electricity Bill', 'Bills', 1800, 'UPI', '2026-10', 'Expense');
INSERT INTO expenses VALUES (105, DATE '2026-10-22', 'Amazon Refund', 'Shopping', -2500, 'Card', '2026-10', 'Refund');
INSERT INTO expenses VALUES (106, DATE '2026-10-31', 'Late Night Dinner', 'Uncategorized', 450, 'Cash', '2026-10', 'Expense');
INSERT INTO expenses VALUES (107, DATE '2026-11-01', 'Monthly Rent', 'Bills', 8000, 'Bank Transfer', '2026-11', 'Expense');
INSERT INTO expenses VALUES (108, DATE '2026-11-05', 'Zomato Dinner', 'Food', 420, 'UPI', '2026-11', 'Expense');
INSERT INTO expenses VALUES (109, DATE '2026-11-10', 'Movie Tickets', 'Entertainment', 600, 'Card', '2026-11', 'Expense');
INSERT INTO expenses VALUES (110, DATE '2026-11-15', 'Uber Ride', 'Travel', 280, 'UPI', '2026-11', 'Expense');
INSERT INTO expenses VALUES (111, DATE '2026-11-20', 'Grocery Store', 'Food', 1500, 'UPI', '2026-11', 'Expense');
INSERT INTO expenses VALUES (112, DATE '2026-11-28', 'Mobile Recharge', 'Uncategorized', 299, 'UPI', '2026-11', 'Expense');
COMMIT;

-- 3. View: Monthly Spend Summary
CREATE OR REPLACE VIEW vw_monthly_spend AS
SELECT 
    expense_month,
    SUM(amount) AS net_spend,
    COUNT(*) AS total_transactions
FROM expenses
GROUP BY expense_month
ORDER BY expense_month;

SELECT * FROM vw_monthly_spend;

-- 4. Query: Spend by Category
SELECT category, SUM(amount) AS total_spent
FROM expenses
GROUP BY category
ORDER BY total_spent DESC;

-- 5. PL/SQL Block: Monthly Budget Breach Check (Budget = 10000)
DECLARE
    v_budget      NUMBER := 10000;
    v_nov_spend   NUMBER;
BEGIN
    SELECT SUM(amount) INTO v_nov_spend
    FROM expenses
    WHERE expense_month = '2026-11';

    IF v_nov_spend > v_budget THEN
        DBMS_OUTPUT.PUT_LINE('ALERT: November budget breached! Spent: ' || v_nov_spend);
    ELSE
        DBMS_OUTPUT.PUT_LINE('OK: Within budget. Spent: ' || v_nov_spend);
    END IF;
END;
/