USE STARTUP;

----- Funding Efficiency-----

SELECT 
    industry,
    AVG(valuation_usd * 1.0 / total_funding_usd) AS valuation_efficiency
FROM startup_failure_dataset
WHERE total_funding_usd > 0
GROUP BY industry
ORDER BY valuation_efficiency DESC;

------- Startup failure despite high funding------

SELECT 
    industry,
    AVG(valuation_usd * 1.0 / total_funding_usd) AS valuation_efficiency
FROM startup_failure_dataset
WHERE total_funding_usd > 0
GROUP BY industry
ORDER BY valuation_efficiency DESC;


-------Capital Efficiency ------

SELECT 
    industry,
    AVG(annual_revenue_usd * 1.0 / total_funding_usd) AS capital_efficiency
FROM startup_failure_dataset
WHERE total_funding_usd > 0
GROUP BY industry
ORDER BY capital_efficiency DESC;

-------Innovation vs Funding ------

SELECT 
    patents_count,
    AVG(total_funding_usd) AS avg_funding
FROM startup_failure_dataset
GROUP BY patents_count
ORDER BY patents_count;


-------Innovation vs Startup Survival ------

SELECT 
    patents_count,
    AVG(CASE WHEN status='Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY patents_count
ORDER BY patents_count;

------ Burn rate sustainability ------

SELECT 
    AVG(burn_rate_usd_monthly * 1.0 / annual_revenue_usd) AS burn_to_revenue_ratio
FROM startup_failure_dataset
WHERE annual_revenue_usd > 0;


------ Founder Team Strength ------

SELECT 
    founders_count,
    AVG(CASE WHEN status='Operating' THEN 1.0 ELSE 0 END) AS survival_rate
FROM startup_failure_dataset
GROUP BY founders_count
ORDER BY founders_count;


------ Customer Base vs Valuation ------

SELECT 
    AVG(customer_count) AS avg_customers,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset;

------ Investor Confidence Indicator ------

SELECT 
    investor_count,
    AVG(valuation_usd) AS avg_valuation
FROM startup_failure_dataset
GROUP BY investor_count
ORDER BY investor_count;

------ Market Risk Analysis ------

SELECT 
    industry,
    AVG(CASE WHEN status='Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY industry
ORDER BY failure_rate DESC;

------ Closure Reason Deepdive ------

SELECT 
closure_reason,
AVG(total_funding_usd) AS avg_funding_before_closure,
COUNT(*) AS startups
FROM startup_failure_dataset
WHERE status='Closed'
GROUP BY closure_reason
ORDER BY startups DESC;


------ Burnrate Risk ------

SELECT 
CASE 
    WHEN burn_rate_usd_monthly < 500000 THEN 'Low Burn'
    WHEN burn_rate_usd_monthly BETWEEN 500000 AND 2000000 THEN 'Medium Burn'
    ELSE 'High Burn'
END AS burn_category,
AVG(CASE WHEN status='Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN burn_rate_usd_monthly < 500000 THEN 'Low Burn'
    WHEN burn_rate_usd_monthly BETWEEN 500000 AND 2000000 THEN 'Medium Burn'
    ELSE 'High Burn'
END;

------ Revenue vs Survival ------

SELECT 
CASE 
    WHEN annual_revenue_usd < 1000000 THEN 'Low Revenue'
    WHEN annual_revenue_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Revenue'
    ELSE 'High Revenue'
END AS revenue_category,
COUNT(*) AS startups,
AVG(CASE WHEN status = 'Operating' THEN 1.0 ELSE 0 END) AS survival_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN annual_revenue_usd < 1000000 THEN 'Low Revenue'
    WHEN annual_revenue_usd BETWEEN 1000000 AND 10000000 THEN 'Medium Revenue'
    ELSE 'High Revenue'
END;

------ Churn vs Failure Rate ------

SELECT 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END AS churn_category,
AVG(CASE WHEN status='Closed' THEN 1.0 ELSE 0 END) AS failure_rate
FROM startup_failure_dataset
GROUP BY 
CASE 
    WHEN churn_rate_percent < 5 THEN 'Low Churn'
    WHEN churn_rate_percent BETWEEN 5 AND 15 THEN 'Medium Churn'
    ELSE 'High Churn'
END;
