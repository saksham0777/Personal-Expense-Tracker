# Personal Expense Tracker and Budget Dashboard

An end-to-end data analytics project built using **Python (`pandas`)**, **Oracle SQL & PL/SQL**, and **Power BI**. The pipeline ingests raw expense logs, cleans missing categories and edge cases, validates monthly spending thresholds using PL/SQL, and delivers an interactive Power BI dashboard for budget monitoring.

---

## 1. Problem Statement & Objectives
Tracking personal expenses across multiple payment channels (`UPI`, `Card`, `Cash`, `Bank Transfer`) makes it difficult to spot category overspending or monthly budget breaches in real time. 

**Project Objectives:**
1. Clean and standardize raw transaction logs in Python, handling uncategorized entries, refunds, and month-end boundary dates.
2. Store structured expense records in an Oracle relational table, build summary views, and automate monthly budget breach alerts via PL/SQL.
3. Build an interactive Power BI dashboard with KPI cards, category breakdowns, monthly trends, and dynamic slicers.
4. Reconcile exact figures across CSV, Python, Oracle SQL, and Power BI.

---

## 2. KPI Definitions
* **Total Net Spend:** Sum of all transaction amounts (`Expenses` minus `Refunds`), reflecting actual net cash outflow.
* **Total Transactions:** Count of unique expense records (`COUNT(expense_id)`).
* **Refund Impact:** Total value of reversed/refunded entries (`amount < 0`), isolated using the `txn_type = 'Refund'` flag.
* **Monthly Budget Threshold:** Fixed monthly budget limit of **₹10,000**, evaluated programmatically in PL/SQL.

---

## 3. Database Schema
The Oracle database uses a single-table analytical structure (`EXPENSES`) designed for direct aggregation and reporting:

```text
+-----------------------------------+
|             EXPENSES              |
+-----------------------------------+
| PK  expense_id     NUMBER         |
|     expense_date   DATE           |
|     description    VARCHAR2(100)  |
|     category       VARCHAR2(50)   |
|     amount         NUMBER(10,2)   |
|     payment_mode   VARCHAR2(30)   |
|     expense_month  VARCHAR2(7)    |
|     txn_type       VARCHAR2(20)   |
+-----------------------------------+
```

---

## 4. Data-Quality Report & Test-Case Verification
During preprocessing (`clean_expenses.py`), three intentional edge cases were tested and verified:

| Test Case | Record ID(s) | Raw Data Issue | Resolution Applied | Verification Result |
| :--- | :---: | :--- | :--- | :--- |
| **Uncategorized Rows** | `106`, `112` | Blank (`NaN`) category field | Imputed with `'Uncategorized'` via `.fillna()` | 2 rows cleanly grouped under `Uncategorized` (₹749 total) |
| **Refund Entries** | `105` | Negative amount (`-2500`) | Preserved negative sign and tagged `txn_type = 'Refund'` | Offset `Shopping` spend (`+2500` and `-2500` = ₹0 net) |
| **Month-End Boundary** | `106` | Date on `2026-10-31` | Extracted `expense_month` via `dt.to_period('M')` | Correctly rolled into `2026-10` instead of `2026-11` |

---

## 5. Cross-Tool Reconciliation Table
All metrics were cross-checked across every stage of the pipeline to confirm 100% data accuracy:

| Period | Transactions | Raw CSV Sum | Python Cleaned Sum | Oracle SQL View (`vw_monthly_spend`) | Power BI Dashboard | Reconciliation Status |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **2026-10** | 6 | ₹3,100 | ₹3,100 | ₹3,100 | ~3.1K | Verified |
| **2026-11** | 6 | ₹11,099 | ₹11,099 | ₹11,099 | ~11.1K | Verified |
| **Overall** | **12** | **₹14,199** | **₹14,199** | **₹14,199** | **14K** | **Verified** |

---

## 6. Key Analytical Insights & PL/SQL Alert Output
* **Monthly Budget Breach (PL/SQL):** October remained well within the ₹10,000 budget (**₹3,100**), while November exceeded the limit (**₹11,099**), triggering the PL/SQL alert:
  ```text
  ALERT: November budget breached! Spent: 11099
  ```
* **Category Concentration:** `Bills` was the highest spending category at **₹9,800** (~69% of total net spend), driven by monthly rent (`₹8,000`) and electricity (`₹1,800`), followed by `Food` (**₹2,270**).
* **Payment Mode Preference:** `UPI` was the dominant transaction method across daily food, travel, and utility payments.

---

## 7. Repository Structure
```text
projectmee/
├── raw_expenses.csv          # Raw expense logs including edge-case records
├── clean_expenses.py         # Python (pandas) cleaning, imputation & refund flagging script
├── cleaned_expenses.csv      # Standardized output dataset for SQL and Power BI
├── oracle_expense.sql        # Oracle DDL, data inserts, summary view, queries & PL/SQL check
├── expense_dashboard.pbix    # Interactive Power BI report (KPI cards, charts & slicers)
└── README.md                 # Project documentation, data-quality report & reconciliation
```

---

## 8. How to Run
1. **Python Cleaning:**
   ```bash
   pip install pandas
   python clean_expenses.py
   ```
2. **Oracle SQL & PL/SQL:**
   Execute `oracle_expense.sql` in Oracle SQL Developer, Oracle Live SQL, or OneCompiler Oracle (`SET SERVEROUTPUT ON` enabled) to create the `EXPENSES` table, query `vw_monthly_spend`, and view the PL/SQL budget check output.
3. **Power BI Dashboard:**
   Open `expense_dashboard.pbix` in Power BI Desktop and use the `expense_month` and `payment_mode` slicers to filter KPIs and visuals dynamically.