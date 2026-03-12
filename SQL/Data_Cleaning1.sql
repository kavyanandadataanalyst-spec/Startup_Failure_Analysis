-- Creating a database, using it and checking for number of rows and columns in the raw data

CREATE DATABASE STARTUP;
USE STARTUP;

SELECT TOP 100 * FROM dbo.startup_failure_dataset AS Startup_Data;
SELECT 
    (SELECT COUNT(*) FROM dbo.startup_failure_dataset) AS total_rows,
    (SELECT COUNT(*) 
     FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_NAME = 'startup_failure_dataset') AS total_columns; 
     -- Total Rows: 20000, Total Columns : 28
------------------------------------------------------------------------

------------ Data cleaning:

---- Checking for Duplicates:

SELECT startup_name, COUNT(*) AS duplicate_count
FROM dbo.startup_failure_dataset
GROUP BY startup_name
HAVING COUNT(*) > 1;

-- No duplicates found

----- Handling Null Values:
-- 1] identifying columns with null values : Data Profiling

SELECT
COUNT(*) - COUNT(startup_name) AS startup_name_nulls,
COUNT(*) - COUNT(industry) AS industry_nulls,
COUNT(*) - COUNT(country) AS country_nulls,
COUNT(*) - COUNT(funding_rounds) AS funding_rounds_nulls,
COUNT(*) - COUNT(total_funding_usd) AS funding_nulls,
COUNT(*) - COUNT(investor_count) AS investor_count,
COUNT(*) - COUNT(has_vc) AS has_vc,
COUNT(*) - COUNT(employees) AS employee_nulls,
COUNT(*) - COUNT(annual_revenue_usd) AS revenue_nulls,
COUNT(*) - COUNT(customer_count) AS customer_nulls,
COUNT(*) - COUNT(churn_rate_percent) AS churn_rate_percent,
COUNT(*) - COUNT(valuation_usd) AS valuation_nulls,
COUNT(*) - COUNT(age_first_funding_year) AS age_first_funding_year,
COUNT(*) - COUNT(closure_reason) AS closure_reason
FROM dbo.startup_failure_dataset;

-- funding_rounds_nulls :4124, funding_nulls :2311, investor_count: 5458, has_vc:1948, employee_nulls:1960, revenue_nulls:3991, customer_nulls:3131
--churn_rate_percent 5413, valuation_nulls: 3867, age_first_funding_year :3947, closure_reason:9055

-- Data cleaning:

--1] Handlinng Funding round nulls
UPDATE dbo.startup_failure_dataset
SET funding_rounds = 0
WHERE funding_rounds IS NULL;

--2] Handlinng Funding nulls

-- Check distributiom
SELECT 
MIN(total_funding_usd) AS min_funding,
MAX(total_funding_usd) AS max_funding,
AVG(total_funding_usd) AS avg_funding
FROM dbo.startup_failure_dataset;

-- Calculate Median:

SELECT 
PERCENTILE_CONT(0.5) 
WITHIN GROUP (ORDER BY total_funding_usd) 
OVER () AS median_funding
FROM dbo.startup_failure_dataset;


-- Replacing nulls

UPDATE dbo.startup_failure_dataset
SET total_funding_usd =
(
SELECT DISTINCT 
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY total_funding_usd)
OVER ()
FROM dbo.startup_failure_dataset
)
WHERE total_funding_usd IS NULL;

--3. Replacing Investor count:

UPDATE dbo.startup_failure_dataset
SET investor_count = 0
WHERE investor_count IS NULL;

-- 4. Replace VCinfo

UPDATE dbo.startup_failure_dataset
SET has_vc = 0
WHERE has_vc IS NULL;

-- 5.Employee_nulls

SELECT 
MIN(employees) AS min_emp,
MAX(employees) AS max_emp,
AVG(employees) AS avg_emp
FROM dbo.startup_failure_dataset;

-- Find Median :

SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY employees)
OVER () AS median_employees
FROM dbo.startup_failure_dataset
WHERE employees IS NOT NULL;

-- Replace with median

UPDATE dbo.startup_failure_dataset
SET employees =
(
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY employees)
OVER ()
FROM dbo.startup_failure_dataset
WHERE employees IS NOT NULL
)
WHERE employees IS NULL;

--6. Revenue Nulls:

-- Finding the range:

SELECT 
MIN(annual_revenue_usd) AS min_revenue,
MAX(annual_revenue_usd) AS max_revenue,
AVG(annual_revenue_usd) AS avg_revenue
FROM dbo.startup_failure_dataset;

-- Calculate Median:

SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY annual_revenue_usd)
OVER () AS median_revenue
FROM dbo.startup_failure_dataset
WHERE annual_revenue_usd IS NOT NULL;

-- Replace Null with Median:

UPDATE dbo.startup_failure_dataset
SET annual_revenue_usd =
(
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY annual_revenue_usd)
OVER ()
FROM dbo.startup_failure_dataset
WHERE annual_revenue_usd IS NOT NULL
)
WHERE annual_revenue_usd IS NULL;

-- 7. Customer Nulls:

-- Checking Customer distribution:

SELECT 
MIN(customer_count) AS min_customers,
MAX(customer_count) AS max_customers,
AVG(customer_count) AS avg_customers
FROM dbo.startup_failure_dataset;

-- Finding Median:

SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY customer_count)
OVER () AS median_customers
FROM dbo.startup_failure_dataset
WHERE customer_count IS NOT NULL;

-- Replacing NULL with Median:

UPDATE dbo.startup_failure_dataset
SET customer_count =
(
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY customer_count)
OVER ()
FROM dbo.startup_failure_dataset
WHERE customer_count IS NOT NULL
)
WHERE customer_count IS NULL;

--8. Churn Rate Percent Nulls:

-- Finding the distribution:

SELECT 
MIN(churn_rate_percent) AS min_churn,
MAX(churn_rate_percent) AS max_churn,
AVG(churn_rate_percent) AS avg_churn
FROM dbo.startup_failure_dataset;

-- Calculating the Median Churn:

SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY churn_rate_percent)
OVER () AS median_churn
FROM dbo.startup_failure_dataset
WHERE churn_rate_percent IS NOT NULL;

-- Replace with Median values:

UPDATE dbo.startup_failure_dataset
SET churn_rate_percent =
(
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY churn_rate_percent)
OVER ()
FROM dbo.startup_failure_dataset
WHERE churn_rate_percent IS NOT NULL
)
WHERE churn_rate_percent IS NULL;

-- 9. Handling valuation Nulls:

-- Finding the valuation distribution:

SELECT 
MIN(valuation_usd) AS min_valuation,
MAX(valuation_usd) AS max_valuation,
AVG(valuation_usd) AS avg_valuation
FROM dbo.startup_failure_dataset;

-- Calculating the Median value:

SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY valuation_usd)
OVER () AS median_valuation
FROM dbo.startup_failure_dataset
WHERE valuation_usd IS NOT NULL;

-- Replacing the values by median :

UPDATE dbo.startup_failure_dataset
SET valuation_usd =
(
SELECT DISTINCT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY valuation_usd)
OVER ()
FROM dbo.startup_failure_dataset
WHERE valuation_usd IS NOT NULL
)
WHERE valuation_usd IS NULL;

-- 10. Handling  age_first_funding_year nulls:
-- Calculating the Median:

SELECT PERCENTILE_CONT(0.5) 
WITHIN GROUP (ORDER BY age_first_funding_year) 
OVER ()
FROM dbo.startup_failure_dataset;

-- Replacing nulls with Medians

UPDATE dbo.startup_failure_dataset
SET age_first_funding_year =3
WHERE age_first_funding_year IS NULL;

--11. Handling closure_reason nulls

-- Checking NULL values
SELECT COUNT(*)
FROM dbo.startup_failure_dataset
WHERE closure_reason IS NULL;

-- Replacing NULL with 'Operating' assuming company is active
UPDATE dbo.startup_failure_dataset
SET closure_reason = 'Operating'
WHERE closure_reason IS NULL;

-- closure_reason NULL values replaced with 'Operating'
-- assuming companies without closure records are still active

SELECT * FROM dbo.startup_failure_dataset;