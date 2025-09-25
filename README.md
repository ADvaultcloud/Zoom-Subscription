# Zoom-Subscription
# 🗂️ Subscription Analytics with SQL

This project demonstrates how to design, populate, and analyze a **subscription-based business database** using **pure SQL**.  
It covers the entire workflow – from **creating normalized tables**, **importing CSV data**, and running **analytical queries** to derive actionable business insights.

---

## 📑 Project Structure

- `create_tables.sql` → SQL script to create normalized database schema (`Users`, `Plans`, `Subscription`, `Payments`, `Churn`).
- `import_data.sql` → SQL script to bulk import data from CSV files into the database.
- `analytical_queries.sql` → Collection of queries for deriving insights, including:
  - Active users per plan  
  - Monthly revenue trend  
  - Churn analysis  
  - Customer lifetime value (CLV) insights  
  - Payment success rate  

---

## 🛠️ Tools & Technology

- **SQL** – Schema design, data import, and analytical queries  
- **Database** – Works with MySQL, PostgreSQL, or SQLite (scripts provided for MySQL/Postgres)  
- **CSV Data** – Used for initial dataset population  

---

## 🏗️ Steps to Reproduce

### 1️⃣ Create Database & Tables
Run the table creation script:

```sql
SOURCE create_tables.sql;



---

✅ This README clearly explains:
- **Purpose** of the project  
- **Steps** (create tables → import CSV → run queries)  
- **Deliverables** (insights & KPIs)  
- Is **professional & GitHub-friendly**  

Would you like me to also include **example SQL snippets** (like a sample query from `analytical_queries.sql` such as “Monthly Revenue Trend”) inside the README so viewers can preview your work before downloading?

