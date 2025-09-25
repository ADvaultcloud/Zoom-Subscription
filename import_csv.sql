-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    signup_date DATE
);

-- Plans Table
CREATE TABLE Plans (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    monthly_cost DECIMAL(5,2),
    features TEXT
);

-- Subscription Table
CREATE TABLE Subscription (
    subscription_id INT PRIMARY KEY,
    user_id INT,
    plan_id INT,
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (plan_id) REFERENCES Plans(plan_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    plan_id INT,
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (plan_id) REFERENCES Plans(plan_id)
);

-- Churn Table
CREATE TABLE Churn (
    user_id INT,
    churn_date DATE,
    reason VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- Enable loading from CSV (requires correct permissions)
COPY Users(user_id, name, email, signup_date)
FROM '/home/user/users.csv'
DELIMITER ',' CSV HEADER;

COPY Plans(plan_id, plan_name, monthly_cost, features)
FROM '/home/user/plans.csv'
DELIMITER ',' CSV HEADER;

COPY Subscription(subscription_id, user_id, plan_id, start_date, end_date, is_active)
FROM '/home/user/subscription.csv'
DELIMITER ',' CSV HEADER;

COPY Payments(payment_id, user_id, amount, payment_date, plan_id, status)
FROM '/home/user/payments.csv'
DELIMITER ',' CSV HEADER;

COPY Churn(user_id, churn_date, reason)
FROM '/home/user/churn.csv'
DELIMITER ',' CSV HEADER;

--accessing the data
Select * From Users;
Select * From Subscriptions;
Select * From Plans;
Select * From Payments;
Select * From Churn
