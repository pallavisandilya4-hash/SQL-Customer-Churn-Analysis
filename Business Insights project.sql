CREATE DATABASE CUSTOMER_CHURN_PROJECT;
SELECT * FROM CUSTOMERS;
DESC CUSTOMERS;
#PHASE1:- Basic SQL Analysis & Customer Insights
# Total Customers
SELECT COUNT(*) AS TOTAL_CUSTOMERS
FROM CUSTOMERS;
-- Total customers:-7032
# Total Revenue
SELECT 
ROUND(SUM(TotalCharges),2) AS total_revenue
FROM customers;
-- Total Revenue:-16056168.7
# Average Revenue Per Customer
ALTER TABLE CUSTOMERS
ADD total_charges_decimal DECIMAL(10,2);
UPDATE CUSTOMERS 
SET total_charges_decimal=TOTALCHARGES;
DESC CUSTOMERS;
SELECT 
ROUND(AVG(total_charges_decimal),2) AS avg_customer_revenue
FROM customers;
-- A average customers company ko 2283.30 revenue deta hai 
# CHURN RATE ANALYSIS
SELECT 
ROUND(
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),
2
) AS churn_rate
FROM customers;
-- 58 % CUSTOMERS ARE LEAVING COMPANY
#Churned v/s Retained customers
SELECT 
Churn,
COUNT(*) AS customer_count
FROM customers
GROUP BY Churn;
-- 1869 customers are leaving and 5163 customers are getting retained
# Contract type analysis
SELECT 
Contract,
COUNT(*) AS total_customers
FROM customers
GROUP BY Contract;
-- Month to month :-3875, One year:-1472,Two year:-1685 
-- This states month to month is most popular plan 
#Contract type vs churn
SELECT 
Contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customers
GROUP BY Contract;
-- Month to Month customers have highest churn
# Revenue by internet Service
SELECT
InternetService,
ROUND(SUM(total_charges_decimal),2) AS revenue
FROM customers
GROUP BY InternetService
ORDER BY revenue DESC;
-- Fiber optic generated highest revenue 
-- Top 10 high value customers
SELECT
customerID,
total_charges_decimal
FROM customers
ORDER BY total_charges_decimal DESC
LIMIT 10;
-- Identified pevenue generating customers to help understand premium customer segments and improve retention high_value customers
#Customer retention
SELECT
CASE
WHEN tenure < 12 THEN 'New Customers'
WHEN tenure BETWEEN 12 AND 24 THEN 'Mid-Term Customers'
ELSE 'Long-Term Customers'
END AS customer_segment,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment;
-- New customers:2058,Long term customers:3833, Mid term customers:1141
# PHASE2:-JOINS & ADVANCED INSIGHTS
-- New Table Payment
CREATE TABLE payments AS
SELECT
customerID,
PaymentMethod,
MonthlyCharges
FROM customers;
SELECT * FROM payments;
# Join Query
SELECT
c.customerID,
c.Contract,
p.PaymentMethod,
c.total_charges_decimal
FROM customers c
JOIN payments p
ON c.customerID = p.customerID;
-- Joined customer contract,payment method and revenue data to provide unified view of customer payment behavior and revenue contribution
#Revenue by Payment Method
SELECT
p.PaymentMethod,
ROUND(SUM(c.total_charges_decimal),2) AS total_revenue
FROM customers c
JOIN payments p
ON c.customerID = p.customerID
GROUP BY p.PaymentMethod
ORDER BY total_revenue DESC;
-- Electronic check generates highest revenue
# Churn by Payment method
SELECT
p.PaymentMethod,
COUNT(*) AS total_customers,
SUM(CASE WHEN c.Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customers c
JOIN payments p
ON c.customerID = p.customerID
GROUP BY p.PaymentMethod
ORDER BY churned_customers DESC;
-- Customers using Electronic Check payment method showed highest churn rate indicating potential area for customer retention improvment
# PHASE3: SUBQUERIES
-- Above average revenue customers
SELECT
customerID,
total_charges_decimal
FROM customers
WHERE total_charges_decimal >
(
SELECT AVG(total_charges_decimal)
FROM customers
);
-- identified customer generating above average revenue,helping business recognize high-value customers for targeted retention and marketing strategies
# Highest reveue contract type
SELECT
Contract,
ROUND(SUM(total_charges_decimal),2) AS revenue
FROM customers
GROUP BY Contract
ORDER BY revenue DESC
LIMIT 1;
-- Two year contract generates highest revenue
#Long term loyal customers
SELECT
customerID,
tenure,
total_charges_decimal
FROM customers
WHERE tenure > 60
ORDER BY total_charges_decimal DESC;
-- Identified long term customers with high tenure and revenue contribution, indicating strong customer loyalty and high business values
#Customer segemntation by revenue
SELECT
CASE
WHEN total_charges_decimal < 2000 THEN 'Low Value'
WHEN total_charges_decimal BETWEEN 2000 AND 5000 THEN 'Medium Value'
ELSE 'High Value'
END AS customer_category,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_category;
-- Majority of customers fall under low value category
