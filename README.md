# sql-etl-sales-pipeline
End-to-end ETL pipeline and analytics layer built in SQL Server using T-SQL

# Sales Data ETL Pipeline — SQL Server

## Project Overview
An end-to-end ETL pipeline built in Microsoft SQL Server using T-SQL, 
designed to ingest raw sales data, investigate and resolve data quality 
issues, and produce a clean, analytics-ready reporting layer.

## Business Context
A sales team exports monthly transaction data that arrives messy — 
containing nulls, duplicates, inconsistent formatting, and invalid values. 
This pipeline automates the cleaning and loading process, ensuring reliable 
data for business reporting.

## Pipeline Architecture
raw_sales (staging) → clean_sales (production) → Analytics Views (reporting)

## Data Quality Issues Identified & Resolved
- NULL values in customer, price and region columns
- Duplicate records identified using GROUP BY and HAVING
- Invalid quantity values (non-numeric) detected and excluded
- Inconsistent casing in status and category columns
- Extra whitespace in customer names
- Mixed date formats standardised
- Pending orders excluded via explicit business rule

## Technical Skills Demonstrated
- Database and table design with appropriate data types and constraints
- Staging table pattern for raw data ingestion
- Data quality investigation using DISTINCT, IS NULL, ISNUMERIC, GROUP BY
- Root cause analysis and business rule documentation
- T-SQL transformations — TRIM, UPPER, LOWER, CAST, REPLACE, ISNULL
- Duplicate removal using subquery with MIN and GROUP BY
- Derived column calculation — total_amount from quantity x unit_price
- Date standardisation using STR_TO_DATE and REPLACE
- Post-load validation queries
- Analytics views using SUM, COUNT, AVG, GROUP BY, ORDER BY
- CASE WHEN for conditional aggregation and custom categorisation
- Date functions — DATEPART, DATENAME, DATEDIFF, GETDATE

## Database Objects Created
| Object | Type | Description |
|---|---|---|
| raw_sales | Table | Staging table for raw incoming data |
| clean_sales | Table | Cleaned production table |
| vw_regional_performance | View | Revenue and orders by region |
| vw_product_performance | View | Sales by product and category |
| vw_customer_summary | View | Customer spend and order history |
| vw_monthly_revenue | View | Monthly revenue trend |

## Tools Used
- Microsoft SQL Server Developer Edition
- SQL Server Management Studio (SSMS)
- T-SQL

## Key Learnings
- Importance of staging tables in ETL — never transform source data directly
- Business rules must be explicitly defined before applying any fix
- Validation queries are as important as the transformation itself
- Views create a reusable reporting layer that feeds BI tools like Power BI
