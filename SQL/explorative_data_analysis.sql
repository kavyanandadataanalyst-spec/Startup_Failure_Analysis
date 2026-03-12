USE STARTUP;

-- Data Validation:

-- Check total rows
SELECT COUNT(*) FROM startup_failure_dataset; --- Result:20000

-- Check duplicate companies
SELECT startup_name, COUNT(*)
FROM startup_failure_dataset
GROUP BY startup_name
HAVING COUNT(*) > 1; 

-- Result: No duplicates found

-- Check negative values
SELECT *
FROM startup_failure_dataset
WHERE total_funding_usd < 0;

-- Result: No negative values



------ Startup Ecosystem Insights ------
--1. Total number of Startups

SELECT industry, COUNT(*) AS startup_count
FROM startup_failure_dataset
GROUP BY industry
ORDER BY startup_count DESC;

-- TravelTech	1739, Fintech	1714, AI	1701, Cybersecurity	1687,ClimateTech	1674 , EdTech	1669, HealthTech	1663, Gaming	1660, SaaS	1653, Ecommerce	1652, FoodTech	1635, Logistics	1553


--2. Country with the most Startups

SELECT 
    country,
    COUNT(startup_id) AS total_startups
FROM startup_failure_dataset
GROUP BY country
ORDER BY total_startups DESC;

-- Netherlands	1707, Canada	1707, Australia	1694, UK	1681, Singapore	1667, Germany	1666, France	1662, UAE	1658, Israel	1657,Brazil	1640, India	1637, USA	1624

-- 3. Fast growing industry

--a] Startups per industry per year

SELECT
    industry,
    founded_year,
    COUNT(startup_id) AS startups_founded
FROM startup_failure_dataset
GROUP BY industry, founded_year
ORDER BY industry, founded_year;

--b] Total startups per industry

SELECT
    industry,
    COUNT(startup_id) AS total_startups
FROM startup_failure_dataset
GROUP BY industry
ORDER BY total_startups DESC;


--c] Startups by city tier

SELECT 
    city_tier,
    COUNT(startup_id) AS total_startups
FROM startup_failure_dataset
GROUP BY city_tier
ORDER BY total_startups DESC;

-- Tier1	12060 ,Tier2	5955, Tier3	1985

--4. Funding by City Tier

SELECT 
    city_tier,
    SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY city_tier
ORDER BY total_funding DESC;

--5. Average Funding per Startup by City Tier

SELECT 
    city_tier,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY city_tier
ORDER BY avg_funding DESC;

---------------------------------------------


------ Funding Insights ------



--1. Average funding per startup

SELECT 
    AVG(total_funding_usd) AS avg_funding_per_startup
FROM startup_failure_dataset;

SELECT 
    industry,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY industry
ORDER BY avg_funding DESC;

--2. Total funding by industry

SELECT industry,
SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY industry
ORDER BY total_funding DESC;

--3. Total funding by country

SELECT 
    country,
    SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY country
ORDER BY total_funding DESC;

--4. Funding vs number of rounds

--a] Average funding by number of rounds

SELECT 
    funding_rounds,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE funding_rounds IS NOT NULL
GROUP BY funding_rounds
ORDER BY funding_rounds;

--b] Total funding by number of rounds

SELECT 
    funding_rounds,
    SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY funding_rounds
ORDER BY funding_rounds;

--c] Number of Startups by Funding rounds

SELECT 
    funding_rounds,
    COUNT(startup_id) AS startup_count
FROM startup_failure_dataset
GROUP BY funding_rounds
ORDER BY funding_rounds;



--5. Top 10 funded startups

SELECT TOP 10
    startup_id,
    industry,
    country,
    funding_rounds,
    valuation_usd,
    total_funding_usd
FROM startup_failure_dataset
WHERE total_funding_usd IS NOT NULL
ORDER BY total_funding_usd DESC;

--6. Industry with highest funding per startup

SELECT 
    industry,
    AVG(total_funding_usd) AS avg_funding_per_startup
FROM startup_failure_dataset
WHERE total_funding_usd IS NOT NULL
GROUP BY industry
ORDER BY avg_funding_per_startup DESC;

--7. Average funding rounds per startup

--a] Average funding per startup

SELECT 
    AVG(funding_rounds) AS avg_funding_rounds
FROM startup_failure_dataset
WHERE funding_rounds IS NOT NULL;

--b] Funding rounds by industry

SELECT 
    industry,
    AVG(funding_rounds) AS avg_rounds
FROM startup_failure_dataset
GROUP BY industry
ORDER BY avg_rounds DESC;

--c] Funding rounds by country

SELECT 
    country,
    AVG(funding_rounds) AS avg_rounds
FROM startup_failure_dataset
GROUP BY country
ORDER BY avg_rounds DESC;

--8. Average funding per country per industry

SELECT 
    country,
    industry,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE total_funding_usd IS NOT NULL
GROUP BY country, industry
ORDER BY country, avg_funding DESC;

--9. Funding vs Profitability:

SELECT 
    profitability,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY profitability;


---------------------------------------------


------ Founder Insights ------

--1. Startups with female founders

SELECT 
    female_founder,
    COUNT(*) AS startup_count
FROM startup_failure_dataset
GROUP BY female_founder;

--2. Average funding for female vs male founders

SELECT 
    female_founder,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY female_founder;

--3. Funding vs number of founders

--a] Average Funding by Number of founders

SELECT 
    founders_count,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE founders_count IS NOT NULL
GROUP BY founders_count
ORDER BY founders_count;

--b] Total Funding by Founder Count

SELECT 
    founders_count,
    SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY founders_count
ORDER BY founders_count;

--c] Number of Startups by founder count

SELECT 
    founders_count,
    COUNT(*) AS startup_count
FROM startup_failure_dataset
GROUP BY founders_count
ORDER BY founders_count;

--d] Funding vs employee count

SELECT 
    employees,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY employees
ORDER BY employees;

--4. Do female-led startups have better profitability?

--a] Average profitability by Founder Gender


SELECT DISTINCT profitability
FROM startup_failure_dataset;

-- As profitability is categorical, below logic is used:

SELECT 
CASE 
    WHEN female_founder = 1 THEN 'Female-led'
    ELSE 'Non-Female-led'
END AS founder_type,
COUNT(*) AS startup_count,
AVG(
        CASE profitability
            WHEN 'Profitable' THEN 1
            WHEN 'Break-even' THEN 0.5
            WHEN 'Not Profitable' THEN 0
        END
    ) AS avg_profitability
    FROM startup_failure_dataset
WHERE profitability IS NOT NULL
GROUP BY female_founder;

--5. Average funding for female founder startups

SELECT female_founder,
AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY female_founder;

--6. Funding distribution by industry and female founders

SELECT 
    industry,
    female_founder,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY industry, female_founder;

SELECT 
CASE 
    WHEN female_founder = 1 THEN 'Female Founder'
    ELSE 'No Female Founder'
END AS founder_type,
COUNT(*) AS startups
FROM startup_failure_dataset
GROUP BY female_founder;

---------------------------------------------


------ Investment Type Insights ------

--1. Average funding for VC-backed startups:

--a] Average funding on VC backed startups:

SELECT 
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE has_vc = 1;  

--b] Average funding on VC backed startups by country:

SELECT 
    country,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE has_vc = 1
GROUP BY country
ORDER BY avg_funding DESC;

--c] Average funding on VC backed startups by industry:

SELECT 
    industry,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE has_vc = 1
GROUP BY industry
ORDER BY avg_funding DESC;


--2. Angel vs VC success rate

-- Success rate for VC-backed startups
SELECT 
    'VC' AS funding_type,
    COUNT(*) AS total_startups,
    SUM(CASE WHEN profitability IN ('Profitable', 'Break-even') THEN 1 ELSE 0 END) AS successful_startups,
    CAST(SUM(CASE WHEN profitability IN ('Profitable', 'Break-even') THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100 AS success_rate_percentage
FROM startup_failure_dataset
WHERE has_vc = 1

UNION ALL

-- Success rate for Angel-backed startups
SELECT 
    'Angel' AS funding_type,
    COUNT(*) AS total_startups,
    SUM(CASE WHEN profitability IN ('Profitable', 'Break-even') THEN 1 ELSE 0 END) AS successful_startups,
    CAST(SUM(CASE WHEN profitability IN ('Profitable', 'Break-even') THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100 AS success_rate_percentage
FROM startup_failure_dataset
WHERE has_angel = 1;

--3. Investor count vs funding amount

-- a] Investor count per startup:

SELECT 
    investor_count,
    COUNT(*) AS num_startups,
    AVG(total_funding_usd) AS avg_funding,
    SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY investor_count
ORDER BY investor_count;


--b] Investor count vs Key metrices

SELECT 
    investor_count,
    COUNT(*) AS num_startups,
    AVG(total_funding_usd) AS avg_funding,
    SUM(total_funding_usd) AS total_funding,
    MIN(total_funding_usd) AS min_funding,
    MAX(total_funding_usd) AS max_funding
FROM startup_failure_dataset
GROUP BY investor_count
ORDER BY investor_count;

--4. Are VC-backed startups more profitable?

SELECT 
    has_vc,
    COUNT(*) AS total_startups,
    SUM(CASE WHEN profitability IN ('Profitable', 'Break-even') THEN 1 ELSE 0 END) AS successful_startups,
    CAST(SUM(CASE WHEN profitability IN ('Profitable', 'Break-even') THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100 AS success_rate_percentage,
    AVG(
        CASE profitability
            WHEN 'Profitable' THEN 1
            WHEN 'Break-even' THEN 0.5
            WHEN 'Not Profitable' THEN 0
        END
    ) AS avg_profitability_score
FROM startup_failure_dataset
GROUP BY has_vc;

---------------------------------------------


------ Growth Insights ------

-- 1.Funding vs employee count:

SELECT 
    employees,
    COUNT(*) AS num_startups,
    AVG(total_funding_usd) AS avg_funding,
    SUM(total_funding_usd) AS total_funding,
    MIN(total_funding_usd) AS min_funding,
    MAX(total_funding_usd) AS max_funding
FROM startup_failure_dataset
GROUP BY employees
ORDER BY employees;

-- By employee range:
SELECT 
    CASE 
        WHEN employees BETWEEN 0 AND 10 THEN '0-10'
        WHEN employees BETWEEN 11 AND 50 THEN '11-50'
        WHEN employees BETWEEN 51 AND 200 THEN '51-200'
        WHEN employees BETWEEN 201 AND 500 THEN '201-500'
        ELSE '500+' 
    END AS employee_range,
    COUNT(*) AS num_startups,
    AVG(total_funding_usd) AS avg_funding,
    SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY 
    CASE 
        WHEN employees BETWEEN 0 AND 10 THEN '0-10'
        WHEN employees BETWEEN 11 AND 50 THEN '11-50'
        WHEN employees BETWEEN 51 AND 200 THEN '51-200'
        WHEN employees BETWEEN 201 AND 500 THEN '201-500'
        ELSE '500+' 
    END
ORDER BY employee_range;

-- With investor type
SELECT
    CASE 
        WHEN employees BETWEEN 0 AND 10 THEN '0-10'
        WHEN employees BETWEEN 11 AND 50 THEN '11-50'
        WHEN employees BETWEEN 51 AND 200 THEN '51-200'
        WHEN employees BETWEEN 201 AND 500 THEN '201-500'
        ELSE '500+' 
    END AS employee_range,
    -- investor type
    CASE 
        WHEN has_vc = 1 AND has_angel = 1 THEN 'VC + Angel'
        WHEN has_vc = 1 THEN 'VC only'
        WHEN has_angel = 1 THEN 'Angel only'
        ELSE 'No external funding'
    END AS investor_type,
    COUNT(*) AS num_startups,
    AVG(total_funding_usd) AS avg_funding,
    SUM(total_funding_usd) AS total_funding
FROM startup_failure_dataset
GROUP BY 
    CASE 
        WHEN employees BETWEEN 0 AND 10 THEN '0-10'
        WHEN employees BETWEEN 11 AND 50 THEN '11-50'
        WHEN employees BETWEEN 51 AND 200 THEN '51-200'
        WHEN employees BETWEEN 201 AND 500 THEN '201-500'
        ELSE '500+' 
    END,
    CASE 
        WHEN has_vc = 1 AND has_angel = 1 THEN 'VC + Angel'
        WHEN has_vc = 1 THEN 'VC only'
        WHEN has_angel = 1 THEN 'Angel only'
        ELSE 'No external funding'
    END
ORDER BY employee_range, investor_type;


-- 2.Revenue vs employees:

--a] Employee count based:

SELECT 
    employees,
    COUNT(*) AS num_startups,
    AVG(annual_revenue_usd) AS avg_revenue,
    SUM(annual_revenue_usd) AS total_revenue,
    MIN(annual_revenue_usd) AS min_revenue,
    MAX(annual_revenue_usd) AS max_revenue
FROM startup_failure_dataset
GROUP BY employees
ORDER BY employees;


--b] based on employee buckets:

SELECT 
    CASE 
        WHEN employees BETWEEN 0 AND 10 THEN '0-10'
        WHEN employees BETWEEN 11 AND 50 THEN '11-50'
        WHEN employees BETWEEN 51 AND 200 THEN '51-200'
        WHEN employees BETWEEN 201 AND 500 THEN '201-500'
        ELSE '500+' 
    END AS employee_range,
    COUNT(*) AS num_startups,
    AVG(annual_revenue_usd) AS avg_revenue,
    SUM(annual_revenue_usd) AS total_revenue,
    MIN(annual_revenue_usd) AS min_revenue,
    MAX(annual_revenue_usd) AS max_revenue
FROM startup_failure_dataset
GROUP BY 
    CASE 
        WHEN employees BETWEEN 0 AND 10 THEN '0-10'
        WHEN employees BETWEEN 11 AND 50 THEN '11-50'
        WHEN employees BETWEEN 51 AND 200 THEN '51-200'
        WHEN employees BETWEEN 201 AND 500 THEN '201-500'
        ELSE '500+' 
    END
ORDER BY employee_range;

-- 3.Burn rate vs revenue:

-- basic metrices:

SELECT
    COUNT(*) AS num_startups,
    AVG(annual_revenue_usd) AS avg_revenue,
    AVG(burn_rate_usd_monthly) AS avg_burn_rate,
    SUM(annual_revenue_usd) AS total_revenue,
    SUM(burn_rate_usd_monthly) AS total_burn,
    MIN(annual_revenue_usd) AS min_revenue,
    MAX(annual_revenue_usd) AS max_revenue,
    MIN(burn_rate_usd_monthly) AS min_burn_rate,
    MAX(burn_rate_usd_monthly) AS max_burn_rate
FROM startup_failure_dataset;

-- Group by revenue averages

SELECT
    CASE
        WHEN annual_revenue_usd BETWEEN 0 AND 100000 THEN '0-100k'
        WHEN annual_revenue_usd BETWEEN 100001 AND 500000 THEN '100k-500k'
        WHEN annual_revenue_usd BETWEEN 500001 AND 1000000 THEN '500k-1M'
        WHEN annual_revenue_usd BETWEEN 1000001 AND 5000000 THEN '1M-5M'
        ELSE '5M+' 
    END AS revenue_range,
    COUNT(*) AS num_startups,
    AVG(burn_rate_usd_monthly) AS avg_burn_rate,
    SUM(burn_rate_usd_monthly) AS total_burn
FROM startup_failure_dataset
GROUP BY
    CASE
        WHEN annual_revenue_usd BETWEEN 0 AND 100000 THEN '0-100k'
        WHEN annual_revenue_usd BETWEEN 100001 AND 500000 THEN '100k-500k'
        WHEN annual_revenue_usd BETWEEN 500001 AND 1000000 THEN '500k-1M'
        WHEN annual_revenue_usd BETWEEN 1000001 AND 5000000 THEN '1M-5M'
        ELSE '5M+' 
    END
ORDER BY revenue_range;

-- 4.Which industries have largest teams

SELECT 
    industry,
    COUNT(*) AS num_startups,
    AVG(employees) AS avg_team_size,
    SUM(employees) AS total_employees,
    MAX(employees) AS largest_team
FROM startup_failure_dataset
GROUP BY industry
ORDER BY avg_team_size DESC;


--5. Revenue per employee

--a] Revenue per employee per startup

SELECT
    startup_name,
    annual_revenue_usd,
    employees,
    CASE 
        WHEN employees> 0 THEN annual_revenue_usd * 1.0 / employees
        ELSE NULL
    END AS revenue_per_employee
FROM startup_failure_dataset;


--b] Average Reveue per employee per industry

SELECT
    industry,
    COUNT(*) AS num_startups,
    AVG(CASE WHEN employees > 0 THEN annual_revenue_usd * 1.0 / employees ELSE NULL END) AS avg_revenue_per_employee,
    MIN(CASE WHEN employees > 0 THEN annual_revenue_usd * 1.0 / employees ELSE NULL END) AS min_revenue_per_employee,
    MAX(CASE WHEN employees > 0 THEN annual_revenue_usd * 1.0 / employees ELSE NULL END) AS max_revenue_per_employee
FROM startup_failure_dataset
GROUP BY industry
ORDER BY avg_revenue_per_employee DESC;

--c] Revenue per enmployee by investor type:

SELECT
    CASE 
        WHEN has_vc = 1 AND has_angel = 1 THEN 'VC + Angel'
        WHEN has_vc = 1 THEN 'VC only'
        WHEN has_angel = 1 THEN 'Angel only'
        ELSE 'No external funding'
    END AS investor_type,
    COUNT(*) AS num_startups,
    AVG(CASE WHEN employees > 0 THEN annual_revenue_usd * 1.0 / employees ELSE NULL END) AS avg_revenue_per_employee
FROM startup_failure_dataset
GROUP BY 
    CASE 
        WHEN has_vc = 1 AND has_angel = 1 THEN 'VC + Angel'
        WHEN has_vc = 1 THEN 'VC only'
        WHEN has_angel = 1 THEN 'Angel only'
        ELSE 'No external funding'
    END
ORDER BY avg_revenue_per_employee DESC;


---------------------------------------------


------ Profitability Insights ------

--1. Profitable vs non-profitable startups

--a] Count of Profitable vs non-progitable startups:

SELECT 
    profitability,
    COUNT(*) AS startup_count
FROM startup_failure_dataset
GROUP BY profitability
ORDER BY startup_count DESC;

--b] Profitability percentage

SELECT 
    profitability,
    COUNT(*) AS startup_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS percentage
FROM startup_failure_dataset
GROUP BY profitability
ORDER BY percentage DESC;

--c] Profitable vs Non-Profitable

SELECT 
    CASE 
        WHEN profitability = 'Not Profitable' THEN 'Non-Profitable'
        ELSE 'Profitable / Break-even'
    END AS profitability_group,
    COUNT(*) AS startup_count
FROM startup_failure_dataset
GROUP BY 
    CASE 
        WHEN profitability = 'Not Profitable' THEN 'Non-Profitable'
        ELSE 'Profitable / Break-even'
    END;

--2. Funding vs profitability

--a]Average funding by Profitability

SELECT 
    profitability,
    COUNT(*) AS num_startups,
    AVG(total_funding_usd) AS avg_funding,
    SUM(total_funding_usd) AS total_funding,
    MIN(total_funding_usd) AS min_funding,
    MAX(total_funding_usd) AS max_funding
FROM startup_failure_dataset
GROUP BY profitability
ORDER BY avg_funding DESC;

--b] Funding distribution by profitability

SELECT 
    profitability,
    CASE
        WHEN total_funding_usd < 1000000 THEN 'Under 1M'
        WHEN total_funding_usd BETWEEN 1000000 AND 5000000 THEN '1M-5M'
        WHEN total_funding_usd BETWEEN 5000001 AND 10000000 THEN '5M-10M'
        ELSE '10M+'
    END AS funding_range,
    COUNT(*) AS num_startups
FROM startup_failure_dataset
GROUP BY 
    profitability,
    CASE
        WHEN total_funding_usd < 1000000 THEN 'Under 1M'
        WHEN total_funding_usd BETWEEN 1000000 AND 5000000 THEN '1M-5M'
        WHEN total_funding_usd BETWEEN 5000001 AND 10000000 THEN '5M-10M'
        ELSE '10M+'
    END
ORDER BY profitability, num_startups DESC;

--c] Funding efficiency:

SELECT 
    profitability,
    AVG(annual_revenue_usd * 1.0 / NULLIF(total_funding_usd,0)) AS avg_funding_efficiency
FROM startup_failure_dataset
GROUP BY profitability
ORDER BY avg_funding_efficiency DESC;

--3. Revenue vs profitability

--a] Average revenue by Profitability

SELECT 
    profitability,
    COUNT(*) AS num_startups,
    AVG(annual_revenue_usd) AS avg_revenue,
    SUM(annual_revenue_usd) AS total_revenue,
    MIN(annual_revenue_usd) AS min_revenue,
    MAX(annual_revenue_usd) AS max_revenue
FROM startup_failure_dataset
GROUP BY profitability
ORDER BY avg_revenue DESC;

--b] Revenue distribution across profitability groups

SELECT 
    profitability,
    CASE
        WHEN annual_revenue_usd < 100000 THEN 'Under 100K'
        WHEN annual_revenue_usd BETWEEN 100000 AND 500000 THEN '100K-500K'
        WHEN annual_revenue_usd BETWEEN 500001 AND 1000000 THEN '500K-1M'
        WHEN annual_revenue_usd BETWEEN 1000001 AND 5000000 THEN '1M-5M'
        ELSE '5M+'
    END AS revenue_range,
    COUNT(*) AS num_startups
FROM startup_failure_dataset
GROUP BY 
    profitability,
    CASE
        WHEN annual_revenue_usd < 100000 THEN 'Under 100K'
        WHEN annual_revenue_usd BETWEEN 100000 AND 500000 THEN '100K-500K'
        WHEN annual_revenue_usd BETWEEN 500001 AND 1000000 THEN '500K-1M'
        WHEN annual_revenue_usd BETWEEN 1000001 AND 5000000 THEN '1M-5M'
        ELSE '5M+'
    END
ORDER BY profitability, num_startups DESC;

--c] Revenue efficiency

SELECT 
    profitability,
    AVG(annual_revenue_usd) AS avg_revenue,
    AVG(burn_rate_usd_monthly) AS avg_burn_rate,
    AVG(annual_revenue_usd - burn_rate_usd_monthly) AS avg_net_position
FROM startup_failure_dataset
GROUP BY profitability
ORDER BY avg_net_position DESC;


--4. Are profitable startups raising less funding?


--a] Profitable vs Non Profitable

    SELECT 
    CASE 
        WHEN profitability = 'Profitable' THEN 'Profitable'
        ELSE 'Non-Profitable / Break-even'
    END AS profitability_group,
    COUNT(*) AS num_startups,
    AVG(total_funding_usd) AS avg_funding
FROM  startup_failure_dataset
GROUP BY 
    CASE 
        WHEN profitability = 'Profitable' THEN 'Profitable'
        ELSE 'Non-Profitable / Break-even'
    END;

------------------------------------------------


------ Customer & Market Insights ------

--1. Customer count vs revenue

--a] Average Revenue by Customer Count

SELECT 
    customer_count,
    AVG(annual_revenue_usd) AS avg_revenue
FROM startup_failure_dataset
WHERE customer_count IS NOT NULL
AND annual_revenue_usd IS NOT NULL
GROUP BY customer_count
ORDER BY customer_count;

--b] Revenue per Customer

SELECT 
    AVG(annual_revenue_usd * 1.0 / customer_count) AS revenue_per_customer
FROM startup_failure_dataset
WHERE customer_count > 0;

--c] Revenue vs Customer Segments

SELECT 
CASE 
    WHEN customer_count < 1000 THEN 'Small Customer Base'
    WHEN customer_count BETWEEN 1000 AND 10000 THEN 'Medium Customer Base'
    ELSE 'Large Customer Base'
END AS customer_segment,
AVG(annual_revenue_usd) AS avg_revenue
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN customer_count < 1000 THEN 'Small Customer Base'
    WHEN customer_count BETWEEN 1000 AND 10000 THEN 'Medium Customer Base'
    ELSE 'Large Customer Base'
END;

--2. Market size vs funding

--a] Average Funding by Market Size

SELECT 
    market_size_usd,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE market_size_usd IS NOT NULL
AND total_funding_usd IS NOT NULL
GROUP BY market_size_usd
ORDER BY market_size_usd;

--b] Market Size Segmentation

SELECT 
CASE 
    WHEN market_size_usd < 100000000 THEN 'Small Market'
    WHEN market_size_usd BETWEEN 100000000 AND 1000000000 THEN 'Medium Market'
    ELSE 'Large Market'
END AS market_segment,
AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN market_size_usd < 100000000 THEN 'Small Market'
    WHEN market_size_usd BETWEEN 100000000 AND 1000000000 THEN 'Medium Market'
    ELSE 'Large Market'
END;


--c] Funding Efficiency by Market Size

SELECT 
    AVG(total_funding_usd * 1.0 / market_size_usd) AS funding_to_market_ratio
FROM startup_failure_dataset
WHERE market_size_usd > 0;


--3. Market size vs valuation

--a] Market Size vs Valuation

SELECT 
    market_size_usd,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
GROUP BY market_size_usd
ORDER BY market_size_usd;

--b] Average Valuation by Market Size

SELECT 
    market_size_usd,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE market_size_usd IS NOT NULL
AND valuation_usd IS NOT NULL
GROUP BY market_size_usd
ORDER BY market_size_usd;

--c] Market Size Segmentation

SELECT 
CASE 
    WHEN market_size_usd < 100000000 THEN 'Small Market'
    WHEN market_size_usd BETWEEN 100000000 AND 1000000000 THEN 'Medium Market'
    ELSE 'Large Market'
END AS market_segment,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE valuation_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN market_size_usd < 100000000 THEN 'Small Market'
    WHEN market_size_usd BETWEEN 100000000 AND 1000000000 THEN 'Medium Market'
    ELSE 'Large Market'
END;


--d] Valuation Multiple

SELECT 
AVG(valuation_usd * 1.0 / market_size_usd) AS valuation_to_market_ratio
FROM startup_failure_dataset
WHERE market_size_usd > 0;


--e] Revenue vs valuation

SELECT 
    annual_revenue_usd,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
GROUP BY annual_revenue_usd
ORDER BY annual_revenue_usd;

--4. Market Size vs Startup Failure Rate

SELECT 
CASE 
    WHEN market_size_usd < 100000000 THEN 'Small Market'
    WHEN market_size_usd BETWEEN 100000000 AND 1000000000 THEN 'Medium Market'
    ELSE 'Large Market'
END AS market_segment,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN market_size_usd < 100000000 THEN 'Small Market'
    WHEN market_size_usd BETWEEN 100000000 AND 1000000000 THEN 'Medium Market'
    ELSE 'Large Market'
END;

------------------------------------------------


------ Risk & Failure Insights ------

--1. Top closure reasons

--a] Top Closure Reasons

SELECT 
    closure_reason,
    COUNT(*) AS startup_count
FROM startup_failure_dataset
WHERE closure_reason IS NOT NULL
GROUP BY closure_reason
ORDER BY startup_count DESC;

--b] Closure reason by industry

SELECT 
    industry,
    closure_reason,
    COUNT(*) AS failures
FROM startup_failure_dataset
WHERE closure_reason IS NOT NULL
GROUP BY industry, closure_reason
ORDER BY failures DESC;

--2. Funding vs closure

--a] Average Funding by Startup Status

SELECT 
    status,
    COUNT(*) AS startup_count,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE total_funding_usd IS NOT NULL
GROUP BY status;

--b] Failure Rate by Funding Range

SELECT 
CASE 
    WHEN total_funding_usd < 1000000 THEN 'Low Funding'
    WHEN total_funding_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Funding'
    ELSE 'High Funding'
END AS funding_category,
COUNT(*) AS startup_count
FROM startup_failure_dataset
WHERE status = 'Closed'
GROUP BY 
CASE 
    WHEN total_funding_usd < 1000000 THEN 'Low Funding'
    WHEN total_funding_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Funding'
    ELSE 'High Funding'
END
ORDER BY startup_count DESC;


--3. Burn rate vs closure

--a] Average Burn Rate by Startup Status

SELECT 
    status,
    COUNT(*) AS startup_count,
    AVG(burn_rate_usd_monthly) AS avg_burn_rate
FROM startup_failure_dataset
WHERE burn_rate_usd_monthly IS NOT NULL
GROUP BY status;

--b] Average Closed startups by Burn rate category

SELECT 
CASE 
    WHEN burn_rate_usd_monthly < 50000 THEN 'Low Burn Rate'
    WHEN burn_rate_usd_monthly BETWEEN 50000 AND 200000 THEN 'Medium Burn Rate'
    ELSE 'High Burn Rate'
END AS burn_rate_category,
COUNT(*) AS closed_startups
FROM startup_failure_dataset
WHERE status = 'Closed'
GROUP BY 
CASE 
    WHEN burn_rate_usd_monthly < 50000 THEN 'Low Burn Rate'
    WHEN burn_rate_usd_monthly BETWEEN 50000 AND 200000 THEN 'Medium Burn Rate'
    ELSE 'High Burn Rate'
END
ORDER BY closed_startups DESC;

--c] Burn Rate vs Failure Rate

SELECT 
CASE 
    WHEN burn_rate_usd_monthly < 50000 THEN 'Low Burn'
    WHEN burn_rate_usd_monthly BETWEEN 50000 AND 200000 THEN 'Medium Burn'
    ELSE 'High Burn'
END AS burn_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN burn_rate_usd_monthly < 50000 THEN 'Low Burn'
    WHEN burn_rate_usd_monthly BETWEEN 50000 AND 200000 THEN 'Medium Burn'
    ELSE 'High Burn'
END;

--d] Runway vs Closure

--a] Calualting Runway for each startup


SELECT 
    startup_name,
    total_funding_usd,
    burn_rate_usd_monthly,
    total_funding_usd / NULLIF(burn_rate_usd_monthly,0) AS runway_months
FROM startup_failure_dataset;

--b] Runway vs Closure

SELECT 
    status,
    AVG(total_funding_usd / NULLIF(burn_rate_usd_monthly,0)) AS avg_runway_months
FROM startup_failure_dataset
WHERE burn_rate_usd_monthly IS NOT NULL
AND total_funding_usd IS NOT NULL
GROUP BY status;

--c] Failure Rate by Runway Category

SELECT 
CASE 
    WHEN total_funding_usd / NULLIF(burn_rate_usd_monthly,0) < 12 THEN 'Low Runway'
    WHEN total_funding_usd / NULLIF(burn_rate_usd_monthly,0) BETWEEN 12 AND 24 THEN 'Medium Runway'
    ELSE 'High Runway'
END AS runway_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN total_funding_usd / NULLIF(burn_rate_usd_monthly,0) < 12 THEN 'Low Runway'
    WHEN total_funding_usd / NULLIF(burn_rate_usd_monthly,0) BETWEEN 12 AND 24 THEN 'Medium Runway'
    ELSE 'High Runway'
END;

--4. Churn rate vs closure

--a] Average Churn Rate by Startup Status

SELECT 
    status,
    COUNT(*) AS startup_count,
    AVG(churn_rate_percent) AS avg_churn_rate
FROM startup_failure_dataset
WHERE churn_rate_percent IS NOT NULL
GROUP BY status;

--b] Failure Count by Churn Category

SELECT 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END AS churn_category,
COUNT(*) AS closed_startups
FROM startup_failure_dataset
WHERE status = 'Closed'
GROUP BY 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END
ORDER BY closed_startups DESC;

--c] Failure Rate by Churn Category

SELECT 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END AS churn_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END;

--d] Revenue vs closure

SELECT 
    status,
    AVG(annual_revenue_usd) AS avg_revenue
FROM startup_failure_dataset
GROUP BY status;


--5. Do high burn rate startups fail more?

SELECT 
CASE 
    WHEN burn_rate_usd_monthly < 50000 THEN 'Low Burn Rate'
    WHEN burn_rate_usd_monthly BETWEEN 50000 AND 200000 THEN 'Medium Burn Rate'
    ELSE 'High Burn Rate'
END AS burn_rate_category,
COUNT(*) AS total_startups,
SUM(CASE WHEN status = 'Closed' THEN 1 ELSE 0 END) AS failed_startups,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
WHERE burn_rate_usd_monthly IS NOT NULL
GROUP BY 
CASE 
    WHEN burn_rate_usd_monthly < 50000 THEN 'Low Burn Rate'
    WHEN burn_rate_usd_monthly BETWEEN 50000 AND 200000 THEN 'Medium Burn Rate'
    ELSE 'High Burn Rate'
END
ORDER BY failure_rate DESC;

--5. Funding Efficiency vs Failure

SELECT 
AVG(total_funding_usd * 1.0 / burn_rate_usd_monthly) AS funding_efficiency,
status
FROM startup_failure_dataset
GROUP BY status;

------------------------------------------------


------ Product & Innovation Insights ------

--1. Patents vs funding

--a] Average Funding by Patent Count

SELECT 
    patents_count,
    COUNT(*) AS startup_count,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE patents_count IS NOT NULL
GROUP BY patents_count
ORDER BY patents_count;

--b] Patent Category vs Funding

SELECT 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END AS patent_category,
COUNT(*) AS startup_count,
AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END
ORDER BY avg_funding DESC;

--c] Patents vs Startup Failure

SELECT 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END AS patent_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END;

--2. Milestones vs valuation

--a] Average Valuation by Milestones

SELECT 
    milestones,
    COUNT(*) AS startup_count,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE milestones IS NOT NULL
AND valuation_usd IS NOT NULL
GROUP BY milestones
ORDER BY milestones;

--b] Milestone Categories vs Valuation

SELECT 
CASE 
    WHEN milestones <= 3 THEN 'Early Stage'
    WHEN milestones BETWEEN 4 AND 7 THEN 'Growth Stage'
    ELSE 'Advanced Stage'
END AS milestone_stage,
COUNT(*) AS startup_count,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE valuation_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN milestones <= 3 THEN 'Early Stage'
    WHEN milestones BETWEEN 4 AND 7 THEN 'Growth Stage'
    ELSE 'Advanced Stage'
END
ORDER BY avg_valuation DESC;

--c] Milestones vs Startup Closure

SELECT 
CASE 
    WHEN milestones <= 3 THEN 'Early Stage'
    WHEN milestones BETWEEN 4 AND 7 THEN 'Growth Stage'
    ELSE 'Advanced Stage'
END AS milestone_stage,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN milestones <= 3 THEN 'Early Stage'
    WHEN milestones BETWEEN 4 AND 7 THEN 'Growth Stage'
    ELSE 'Advanced Stage'
END;

--3. Patents vs revenue


--a] Average Revenue by Patent Count

SELECT 
    patents_count,
    COUNT(*) AS startup_count,
    AVG(annual_revenue_usd) AS avg_revenue
FROM startup_failure_dataset
WHERE patents_count IS NOT NULL
AND annual_revenue_usd IS NOT NULL
GROUP BY patents_count
ORDER BY patents_count;

--b] Patent Category vs Revenue

SELECT 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END AS patent_category,
COUNT(*) AS startup_count,
AVG(annual_revenue_usd) AS avg_revenue
FROM startup_failure_dataset
WHERE annual_revenue_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END
ORDER BY avg_revenue DESC;

--c] Patent Category vs Revenue

SELECT 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END AS patent_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END;
------------------------------------------------


------ Valuation Insights ------

--1. Funding vs valuation

--a] Average Valuation by Funding Level

SELECT 
    total_funding_usd,
    COUNT(*) AS startup_count,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE total_funding_usd IS NOT NULL
AND valuation_usd IS NOT NULL
GROUP BY total_funding_usd
ORDER BY total_funding_usd;

--b] Funding Categories vs Valuation

SELECT 
CASE 
    WHEN total_funding_usd < 1000000 THEN 'Low Funding'
    WHEN total_funding_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Funding'
    ELSE 'High Funding'
END AS funding_category,
COUNT(*) AS startup_count,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE valuation_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN total_funding_usd < 1000000 THEN 'Low Funding'
    WHEN total_funding_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Funding'
    ELSE 'High Funding'
END
ORDER BY avg_valuation DESC;

--c] Valuation vs Startup failure

SELECT 
status,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
GROUP BY status;

--2. Revenue vs valuation

--a] Average Valuation by Revenue

SELECT 
    annual_revenue_usd,
    COUNT(*) AS startup_count,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE annual_revenue_usd IS NOT NULL
AND valuation_usd IS NOT NULL
GROUP BY annual_revenue_usd
ORDER BY annual_revenue_usd;


--b] Revenue Categories vs Valuation

SELECT 
CASE 
    WHEN annual_revenue_usd < 1000000 THEN 'Low Revenue'
    WHEN annual_revenue_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Revenue'
    ELSE 'High Revenue'
END AS revenue_category,
COUNT(*) AS startup_count,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE valuation_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN annual_revenue_usd < 1000000 THEN 'Low Revenue'
    WHEN annual_revenue_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Revenue'
    ELSE 'High Revenue'
END
ORDER BY avg_valuation DESC;

--3. Patents vs valuation

--a] Average Valuation by Patent Count

SELECT 
    patents_count,
    COUNT(*) AS startup_count,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE patents_count IS NOT NULL
AND valuation_usd IS NOT NULL
GROUP BY patents_count
ORDER BY patents_count;

--b] Patent Category vs Valuation

SELECT 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END AS patent_category,
COUNT(*) AS startup_count,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE valuation_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END
ORDER BY avg_valuation DESC;


--c] Patents vs Startup Closure

SELECT 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END AS patent_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN patents_count = 0 THEN 'No Patents'
    WHEN patents_count BETWEEN 1 AND 5 THEN 'Few Patents'
    ELSE 'Many Patents'
END;


--4. Investor count vs valuation

--a] Average Valuation by Investor Count

SELECT 
    investor_count,
    COUNT(*) AS startup_count,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE investor_count IS NOT NULL
AND valuation_usd IS NOT NULL
GROUP BY investor_count
ORDER BY investor_count;

--b] Investor Categories vs Valuation

SELECT 
CASE 
    WHEN investor_count <= 2 THEN 'Few Investors'
    WHEN investor_count BETWEEN 3 AND 7 THEN 'Moderate Investors'
    ELSE 'Many Investors'
END AS investor_category,
COUNT(*) AS startup_count,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
WHERE valuation_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN investor_count <= 2 THEN 'Few Investors'
    WHEN investor_count BETWEEN 3 AND 7 THEN 'Moderate Investors'
    ELSE 'Many Investors'
END
ORDER BY avg_valuation DESC;


--c] Investor count vs Startup failure

SELECT 
CASE 
    WHEN investor_count <= 2 THEN 'Few Investors'
    WHEN investor_count BETWEEN 3 AND 7 THEN 'Moderate Investors'
    ELSE 'Many Investors'
END AS investor_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN investor_count <= 2 THEN 'Few Investors'
    WHEN investor_count BETWEEN 3 AND 7 THEN 'Moderate Investors'
    ELSE 'Many Investors'
END;

------------------------------------------------


------ Retention & Customer Health Insights ------

--1. Industry with highest churn

SELECT 
    industry,
    COUNT(*) AS startup_count,
    AVG(churn_rate_percent) AS avg_churn_rate
FROM startup_failure_dataset
WHERE churn_rate_percent IS NOT NULL
GROUP BY industry
ORDER BY avg_churn_rate DESC;

--2. Churn vs revenue

--a] Average Revenue by Churn Rate

SELECT 
    churn_rate_percent,
    COUNT(*) AS startup_count,
    AVG(annual_revenue_usd) AS avg_revenue
FROM startup_failure_dataset
WHERE churn_rate_percent IS NOT NULL
AND annual_revenue_usd IS NOT NULL
GROUP BY churn_rate_percent
ORDER BY churn_rate_percent;

--b] Churn Categories vs Revenue

SELECT 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END AS churn_category,
COUNT(*) AS startup_count,
AVG(annual_revenue_usd) AS avg_revenue
FROM startup_failure_dataset
WHERE annual_revenue_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END
ORDER BY avg_revenue DESC;


--c] Churn vs Startup failure

SELECT 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END AS churn_category,
AVG(CASE WHEN status = 'Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END;


--3. Churn vs funding

--a] Average funding by Churn rate:

SELECT 
    churn_rate_percent,
    COUNT(*) AS startup_count,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE churn_rate_percent IS NOT NULL
AND total_funding_usd IS NOT NULL
GROUP BY churn_rate_percent
ORDER BY churn_rate_percent;


--b] Churn Categories vs Funding

SELECT 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END AS churn_category,
COUNT(*) AS startup_count,
AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
WHERE total_funding_usd IS NOT NULL
GROUP BY 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END
ORDER BY avg_funding DESC;

--c] Churn vs valuation

SELECT 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END AS churn_category,
AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END;