--Subscription Plan Popularity
SELECT p.plan_name, COUNT(*) AS total_subscriptions
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY total_subscriptions DESC;


--Revenue by Plan
SELECT p.plan_name, ROUND(SUM(pay.amount), 2) AS total_revenue
FROM payments pay
JOIN plans p ON pay.plan_id = p.plan_id
WHERE pay.status = 'successful'
GROUP BY p.plan_name
ORDER BY total_revenue DESC;


--Failed Payment Rate by Plan
SELECT p.plan_name,
       COUNT(*) FILTER (WHERE pay.status = 'failed') AS failed,
       COUNT(*) FILTER (WHERE pay.status = 'successful') AS successful,
       ROUND(100.0 * COUNT(*) FILTER (WHERE pay.status = 'failed') / COUNT(*), 2) AS failure_rate
FROM payments pay
JOIN plans p ON pay.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY failure_rate DESC;


--Active Users per Plan
SELECT p.plan_name, COUNT(DISTINCT s.user_id) AS active_users
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.is_active = true
GROUP BY p.plan_name
ORDER BY active_users DESC;


--Monthly Recurring Revenue (MRR) Trend
WITH monthly_mrr AS (
  SELECT DATE_TRUNC('month', pay.payment_date) AS month,
         SUM(pay.amount) AS mrr
  FROM payments pay
  WHERE pay.status = 'successful'
  GROUP BY month
)
SELECT * FROM monthly_mrr ORDER BY month;



--Retention by Signup Cohort
WITH cohort AS (
  SELECT user_id, DATE_TRUNC('month', signup_date) AS cohort_month
  FROM users
),
activity AS (
  SELECT u.user_id, c.cohort_month, DATE_TRUNC('month', p.payment_date) AS active_month
  FROM cohort c
  JOIN users u ON u.user_id = c.user_id
  JOIN payments p ON u.user_id = p.user_id
  WHERE p.status = 'successful'
),
retention AS (
  SELECT cohort_month, active_month, COUNT(DISTINCT user_id) AS active_users
  FROM activity
  GROUP BY cohort_month, active_month
)
SELECT * FROM retention ORDER BY cohort_month, active_month;


--Churned Users by Plan
SELECT p.plan_name, COUNT(*) AS churned_users
FROM churn c
JOIN subscriptions s ON c.user_id = s.user_id
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY churned_users DESC;


--Churn Rate by Cohort
WITH cohort_churn AS (
  SELECT DATE_TRUNC('month', u.signup_date) AS cohort_month, COUNT(DISTINCT u.user_id) AS total_users,
         COUNT(DISTINCT c.user_id) AS churned_users
  FROM users u
  LEFT JOIN churn c ON u.user_id = c.user_id
  GROUP BY cohort_month
)
SELECT *, ROUND(100.0 * churned_users / total_users, 2) AS churn_rate
FROM cohort_churn
ORDER BY cohort_month;



--Total LTV by Cohort
WITH user_cohorts AS (
  SELECT user_id, DATE_TRUNC('month', signup_date) AS cohort_month
  FROM users
),
ltv AS (
  SELECT uc.cohort_month, SUM(p.amount) AS total_revenue
  FROM user_cohorts uc
  JOIN payments p ON uc.user_id = p.user_id
  WHERE p.status = 'successful'
  GROUP BY uc.cohort_month
)
SELECT cohort_month, ROUND(total_revenue, 2) AS total_ltv FROM ltv ORDER BY cohort_month;



--Conversion Rate from Trial to Paid
WITH trials AS (
  SELECT DISTINCT user_id
  FROM subscriptions
  WHERE plan_id = (SELECT plan_id FROM plans WHERE plan_name = 'Free Trial')
),
paid AS (
  SELECT DISTINCT user_id
  FROM subscriptions
  WHERE plan_id != (SELECT plan_id FROM plans WHERE plan_name = 'Free Trial')
)
SELECT
  (SELECT COUNT(*) FROM trials) AS total_trial_users,
  (SELECT COUNT(*) FROM paid WHERE user_id IN (SELECT user_id FROM trials)) AS converted_to_paid,
  ROUND(100.0 * (SELECT COUNT(*) FROM paid WHERE user_id IN (SELECT user_id FROM trials)) / 
                 (SELECT COUNT(*) FROM trials), 2) AS conversion_rate;



--Top Paying Users
SELECT u.name, u.email, ROUND(SUM(p.amount), 2) AS total_spent
FROM payments p
JOIN users u ON p.user_id = u.user_id
WHERE p.status = 'successful'
GROUP BY u.name, u.email
ORDER BY total_spent DESC
LIMIT 10;



--Payment Status Breakdown
SELECT status, COUNT(*) AS count, ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM payments), 2) AS percentage
FROM payments
GROUP BY status;



--One-Time vs Recurring Plans Revenue
SELECT
  CASE WHEN p.plan_name IN ('Lifetime', 'Free Trial') THEN 'One-Time'
       ELSE 'Recurring' END AS plan_type,
  ROUND(SUM(pay.amount), 2) AS total_revenue
FROM payments pay
JOIN plans p ON pay.plan_id = p.plan_id
WHERE pay.status = 'successful'
GROUP BY plan_type;



--Average Subscription Duration (in months)
SELECT ROUND(AVG(( end_date - start_date) / 30.0), 2) AS avg_duration_months
FROM subscriptions;



--Failed Payments Trend Over Time
SELECT DATE_TRUNC('month', payment_date) AS month, COUNT(*) AS failed_payments
FROM payments
WHERE status = 'failed'
GROUP BY month
ORDER BY month;



--Most Churned Reasons
SELECT reason, COUNT(*) AS total
FROM churn
GROUP BY reason
ORDER BY total DESC;



--Total Revenue per User (LTV)
SELECT u.user_id, u.name, ROUND(SUM(p.amount), 2) AS ltv
FROM payments p
JOIN users u ON p.user_id = u.user_id
WHERE p.status = 'successful'
GROUP BY u.user_id, u.name
ORDER BY ltv DESC
LIMIT 10;



--Active Subscriptions by Month
SELECT DATE_TRUNC('month', start_date) AS start_month, COUNT(*) AS new_subscriptions
FROM subscriptions
GROUP BY start_month
ORDER BY start_month;



--Avg Monthly Revenue per User (ARPU)
WITH mrr AS (
  SELECT DATE_TRUNC('month', payment_date) AS month, SUM(amount) AS total_revenue
  FROM payments
  WHERE status = 'successful'
  GROUP BY month
),
active_users AS (
  SELECT DATE_TRUNC('month', signup_date) AS month, COUNT(*) AS new_users
  FROM users
  GROUP BY month
)
SELECT
  m.month,
  ROUND(m.total_revenue / NULLIF(a.new_users, 0), 2) AS arpu
FROM mrr m
JOIN active_users a ON m.month = a.month
ORDER BY m.month;



--Subscriptions with Most Failures
SELECT s.user_id, COUNT(*) AS failed_payments
FROM payments p
JOIN subscriptions s ON p.user_id = s.user_id
WHERE p.status = 'failed'
GROUP BY s.user_id
ORDER BY failed_payments DESC
LIMIT 10;










