import pandas as pd

# 1. Load data
df = pd.read_csv("raw_expenses.csv")

# 2. Handle test cases: uncategorized rows & date formatting
df["category"] = df["category"].fillna("Uncategorized")
df["expense_date"] = pd.to_datetime(df["expense_date"])
df["expense_month"] = df["expense_date"].dt.to_period("M").astype(str)

# 3. Flag refunds (negative amounts)
df["txn_type"] = df["amount"].apply(lambda x: "Refund" if x < 0 else "Expense")

# 4. Save cleaned output & print check totals
df.to_csv("cleaned_expenses.csv", index=False)
print("Cleaned rows:", len(df))
print("\nMonthly Net Spend:\n", df.groupby("expense_month")["amount"].sum())