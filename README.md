# 📊 Subscription Analytics SQL Project

This project showcases a complete SQL workflow for analyzing subscription-based business models. It spans from **database schema creation** and **CSV data import**, to executing **analytical SQL queries** that yield powerful business insights.

---

## 📁 Project Structure

├── import_csv.sql # SQL for creating tables and importing CSV data
├── analytical_queries.sql # Common analytical queries for metrics & insights
├── /data/ # Folder containing CSV files (users.csv, plans.csv, etc.)
└── README.md # Project documentation
---

## 🧱 1. Database Schema & Table Creation

The `import_csv.sql` file defines the schema with the following tables:

### Tables:

- **Users** – Stores user information.
- **Plans** – Contains subscription plan details.
- **Subscriptions** – Tracks user-to-plan subscriptions.
- **Payments** – Records all user payments.
- **Churn** – Logs churned users with reasons.

### Example: Create `Users` Table

```sql
CREATE TABLE Users (
    userid INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    signupdate DATE
);

Similar definitions exist for Plans, Subscriptions, Payments, and Churn tables.
📥 2. Importing CSV Data

Each main entity can be populated using CSV files via the COPY command.
Example:

COPY Users(userid, name, email, signupdate)
FROM '/home/user/users.csv' DELIMITER ',' CSV HEADER;

COPY Plans(planid, planname, monthlycost, features)
FROM '/home/user/plans.csv' DELIMITER ',' CSV HEADER;

    ⚠️ You may need to adjust file paths and set proper permissions for server-side file access.

Repeat similar commands for:

    subscriptions.csv

    payments.csv

    churn.csv

📊 3. Analytical SQL Queries

The analytical_queries.sql file includes common business queries such as:
Sample Metrics:

    📈 Plan Popularity – Active subscribers per plan.

    💰 Revenue by Plan – Total revenue earned per subscription plan.

    ⚠️ Payment Success/Failure Rates

    👤 Active Users per Plan

    📆 Monthly Recurring Revenue (MRR) Trends

    📉 Churn and Retention Metrics

    💡 Lifetime Value (LTV), ARPU

    🔥 Top Paying Customers

    🛑 Churn Reasons & Conversion Rates

    📊 Usage Trends & Subscription Duration

Example Query: Revenue by Plan

SELECT p.planname, ROUND(SUM(pay.amount), 2) AS totalrevenue
FROM payments pay
JOIN plans p ON pay.planid = p.planid
WHERE pay.status = 'successful'
GROUP BY p.planname
ORDER BY totalrevenue DESC;

📌 4. Business Questions Answered

This project enables you to answer essential product and growth questions:

    ✅ What plans are most popular and profitable?

    🔄 What is the current churn rate and why do users leave?

    💎 Who are the top paying or most loyal customers?

    📉 How is MRR trending month-over-month?

    🧮 What’s the average LTV, ARPU, and conversion rate?

🚀 Usage Instructions

    Run Schema & Import Script
    Execute import_csv.sql to create tables and load data from CSVs.

    Explore Data with Analytical Queries
    Use analytical_queries.sql to extract metrics and generate insights.

    Customize as Needed
    Tailor queries to suit your specific business questions or reporting needs.

📌 Notes

    This project assumes PostgreSQL, but SQL syntax can be adapted for MySQL, SQLite, etc.

    Make sure to update file paths in the COPY commands.

    For local development, use a tool like pgAdmin, DBeaver, or psql CLI.
