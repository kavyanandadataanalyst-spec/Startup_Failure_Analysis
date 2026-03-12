
# Startup Failure Analysis 📊

### Project Overview:

Startups operate in highly uncertain environments, and a significant percentage fail within their first few years. This project analyzes a large dataset of startups to understand key factors influencing startup success and failure, including funding patterns, operational performance, and market dynamics.
The goal of this analysis is to uncover data-driven insights that help explain why some startups succeed while others fail.
This project demonstrates the use of SQL for data cleaning and analysis and Google Sheets for dashboard visualization.
---
### Problem Statement:

Startup ecosystems attract significant venture capital investment, yet failure rates remain high. Understanding the underlying drivers of startup success and failure is essential for founders, investors, and policymakers.
This project aims to answer questions such as:

- Which industries receive the most startup funding?
- Do startups with more funding have lower failure rates?
- What are the most common reasons for startup closures?
- How do operational metrics like churn, burn rate, and revenue impact startup survival?
- Does innovation (patents) or team composition influence funding and valuation?
---
### Dataset Description:

The dataset contains detailed information about startups across multiple industries and regions.
Key Features in the Dataset:

- Startup name
- Country
- City tier
- Industry
- Founder count
- Female founder indicator
- Total funding raised
- Number of funding rounds
- Investor count
- Annual revenue
- Employee count
- Customer count
- Burn rate
- Churn rate
- Valuation
- Patents count
- Milestones achieved
- Market size
- Startup status (Operating / Closed)
- Closure reason
The dataset also includes missing values and data inconsistencies, which were addressed during the data cleaning process.
---
### Tools & Technologies Used:

- SQL (SSMS)
- Data cleaning
- Handling null values
- Removing duplicates
- Exploratory data analysis
- Business insight queries
- Google Sheets
- Data visualization
- Interactive dashboard creation
---
### Data Cleaning Steps:

The dataset required extensive preprocessing before analysis.
Key steps included:

- Removing duplicate records
- Identifying and handling missing values
- Converting incorrect data types
- Replacing null values with appropriate statistical values (mean/median where applicable)
- Ensuring numerical fields were suitable for analysis
These steps ensured that the dataset was reliable for generating insights.
---
### Exploratory Data Analysis:

Initial analysis was conducted to understand the startup ecosystem and funding landscape.
Key areas explored include:

- Startup Ecosystem
- Distribution of startups by country
- Industry distribution
- Startups by city tier
- Funding Landscape
- Total funding by country
- Average funding per startup
- Funding vs number of rounds
- Top funded startups
- Startup Performance
- Revenue vs customer base
- Revenue vs valuation
- Revenue per employee by industry
--- 
### Failure Analysis:

A core objective of this project was to identify the drivers of startup failure.
Key insights include:

- Most common startup closure reasons
- Relationship between churn rate and failure
- Burn rate vs startup closure
- Industry-level failure rates
These insights highlight operational risks and financial pressures that contribute to startup failure.
---
### Success Drivers:

The project also explores factors associated with successful startups.
Key areas analyzed:

- Patents vs funding
- Founder count vs funding
- Investor count vs valuation
- Innovation and startup survival
---
### Dashboard:

A Startup Failure Analysis Dashboard was built in Google Sheets to present key insights visually.
The dashboard includes:
- KPI summary metrics
- Startup ecosystem overview
- Funding distribution analysis
- Startup performance metrics
- Failure analysis insights
- Innovation and founder analysis
This dashboard allows users to quickly understand the major patterns within the startup ecosystem.
---
### Dashboard Preview:

#### Dashboard Preview:
![Dashboard Preview](docs/dashboard_preview.png)

#### Live Dashboard:
 [View Interactive Dashboard](Support_Tickets_SQL)
--- 
### Key Insights:

Some important findings from the analysis include:
- Lack of funding is one of the most common reasons for startup failure.
- Startups with higher customer churn tend to have higher failure rates.
- SaaS and FinTech industries dominate the startup ecosystem.
- Startups with larger founding teams tend to raise more funding.
- Innovation (measured by patents) is positively correlated with investor funding.
---
### Future Improvements:

Potential future enhancements for this project include:
Building an interactive dashboard using Power BI or Tableau
Applying machine learning models to predict startup failure
Incorporating additional external datasets for deeper analysis
---
### Author:
Kavyananda K
Data Analyst | SQL | Python | Data Visualization
This project was created as part of my data analytics portfolio to demonstrate practical skills in data cleaning, SQL analysis, and dashboard development.
---
