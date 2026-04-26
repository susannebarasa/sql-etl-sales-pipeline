CREATE DATABASE Salesprojects;

USE Salesproject;

CREATE TABLE raw_sales (
   sales_iD  VARCHAR (10),
   customer_name	VARCHAR (100),
   products  VARCHAR (100),
   category VARCHAR (50),
   quantity VARCHAR (10),
   unit_price VARCHAR (10),
   sale_date VARCHAR (20),
   region VARCHAR (50),
   status VARCHAR (20),
);

INSERT INTO raw_sales VALUES
('S001', 'alice',     'Laptop',   'Electronics', '2',   '800.00',  '2024-01-05', 'Nairobi',  'completed'),
('S002', 'BOB  ',     'Mouse',    'accessories', '5',   '15.00',   '2024/01/06', 'Mombasa',  'Completed'),
('S003', NULL,        'Keyboard', 'Accessories', '1',   '45.00',   '2024-01-07', 'nairobi',  'completed'),
('S004', 'Alice',     'Laptop',   'Electronics', '2',   '800.00',  '2024-01-05', 'Nairobi',  'completed'),
('S005', 'carol',     'Monitor',  'Electronics', 'abc', '200.00',  '2024-01-08', NULL,       'completed'),
('S006', 'david',     'Mouse',    'Accessories', '3',   NULL,      '2024-01-09', 'Kisumu',   'pending'),
('S007', '  Eve  ',   'Laptop',   'Electronics', '1',   '800.00',  '2024-01-10', 'Nairobi',  'COMPLETED'),
('S008', 'Frank',     'Desk',     'Furniture',   '1',   '250.00',  '2024-01-11', 'Nakuru',   'completed'),
('S009', 'grace',     'Chair',    'furniture',   '4',   '75.00',   '2024-01-12', 'Nairobi',  'completed'),
('S010', 'Frank',     'Desk',     'Furniture',   '1',   '250.00',  '2024-01-11', 'Nakuru',   'completed');


SELECT * FROM raw_sales;

SELECT COUNT (*) AS total_rows FROM raw_sales;

SELECT * FROM raw_sales
WHERE customer_name IS NULL
OR unit_price IS NULL
OR region IS NULL;

SELECT * FROM raw_sales
WHERE ISNUMERIC (quantity) = 0;

SELECT DISTINCT status FROM raw_sales;

SELECT DISTINCT category FROM raw_sales;

SELECT customer_name,products,sale_date, COUNT (*) AS cnt
FROM raw_sales
GROUP BY customer_name,products,sale_date
Having COUNT(*) > 1 ;

SELECT DISTINCT status,COUNT(*) AS Occcurence
FROM raw_sales
GROUP BY status;

SELECT DISTINCT category ,COUNT(*) AS Occurence
FROM raw_sales
GROUP BY category;

SELECT sales_iD,customer_name,
		LEN(customer_name) AS original_length,
		LEN (TRIM(customer_name)) as trimmed_length
FROM raw_sales
WHERE LEN (customer_name) != LEN (TRIM(customer_name));


CREATE TABLE clean_sales (
    sales_iD       VARCHAR(10)     PRIMARY KEY,
    customer_name VARCHAR(100)    NOT NULL,
    productS       VARCHAR(100)    NOT NULL,
    category      VARCHAR(50)     NOT NULL,
    quantity      INT             NOT NULL,
    unit_price    DECIMAL(10,2)   NOT NULL,
    total_amount  DECIMAL(10,2)   NOT NULL,
    sale_date     DATE            NOT NULL,
    region        VARCHAR(50)     NOT NULL,
    status        VARCHAR(20)     NOT NULL
);

SELECT * FROM raw_sales;
SELECT * FROM clean_sales;

SELECT COUNT(*) AS clean_rows FROM clean_sales;


SELECT * FROM clean_sales
WHERE customer_name IS NULL
   OR unit_price IS NULL
   OR region IS NULL;

SELECT DISTINCT status FROM clean_sales;
SELECT DISTINCT category FROM clean_sales;


SELECT sales_iD, quantity, unit_price,total_amount
FROM clean_sales;

USE Salesproject;
INSERT INTO clean_sales
SELECT 
sales_iD,
		UPPER(LEFT(TRIM(customer_name), 1)) 
        + LOWER(SUBSTRING(TRIM(customer_name), 2, LEN(TRIM(customer_name)))) 
                                        AS customer_name,
productS,
        UPPER(LEFT(TRIM(category), 1)) 
        + LOWER(SUBSTRING(TRIM(category), 2, LEN(TRIM(category)))) 
                                        AS category,
    CAST(quantity AS INT)               AS quantity,
    CAST(unit_price AS DECIMAL(10,2))   AS unit_price,
    CAST(quantity AS INT) 
        * CAST(unit_price AS DECIMAL(10,2)) AS total_amount,
    CAST(REPLACE(sale_date, '/', '-') AS DATE) AS sale_date,
    UPPER(LEFT(TRIM(region), 1)) 
        + LOWER(SUBSTRING(TRIM(region), 2, LEN(TRIM(region)))) 
                                        AS region,

   LOWER(TRIM(status))                 AS status

FROM raw_sales
WHERE 
customer_name IS NOT NULL 
AND unit_price IS NOT NULL 
AND region IS NOT NULL 
AND ISNUMERIC(quantity) = 1
AND sales_iD NOT IN (
        SELECT MAX(sales_iD)
        FROM raw_sales
        GROUP BY customer_name, productS, sale_date
        HAVING COUNT(*) > 1
    ); 

TRUNCATE TABLE clean_sales

USE Salesproject;
INSERT INTO clean_sales
SELECT 
sales_iD,
		UPPER(LEFT(TRIM(customer_name), 1)) 
        + LOWER(SUBSTRING(TRIM(customer_name), 2, LEN(TRIM(customer_name)))) 
                                        AS customer_name,
productS,
        UPPER(LEFT(TRIM(category), 1)) 
        + LOWER(SUBSTRING(TRIM(category), 2, LEN(TRIM(category)))) 
                                        AS category,
    CAST(quantity AS INT)               AS quantity,
    CAST(unit_price AS DECIMAL(10,2))   AS unit_price,
    CAST(quantity AS INT) 
        * CAST(unit_price AS DECIMAL(10,2)) AS total_amount,
    CAST(REPLACE(sale_date, '/', '-') AS DATE) AS sale_date,
    UPPER(LEFT(TRIM(region), 1)) 
        + LOWER(SUBSTRING(TRIM(region), 2, LEN(TRIM(region)))) 
                                        AS region,

   LOWER(TRIM(status))                 AS status

FROM raw_sales
WHERE 
customer_name IS NOT NULL 
AND unit_price IS NOT NULL 
AND region IS NOT NULL 
AND ISNUMERIC(quantity) = 1
AND LOWER(TRIM(status)) != 'pending'
AND sales_iD NOT IN (
        SELECT MAX(sales_iD)
        FROM raw_sales
        GROUP BY customer_name, productS, sale_date
        HAVING COUNT(*) > 1
    ); 

SELECT SUM(total_amount) as Total_Revenue
from clean_sales;

SELECT count(*) AS Total_orders
from clean_sales;

SELECT AVG(total_amount) AS Avg_order_value
from clean_sales;

SELECT 
        MAX(unit_price) as Highest_price,
        MIN(unit_price) as Lowest_price

from clean_sales;

SELECT 
    region,
    SUM(total_amount) as Total_Revenue
from clean_sales
GROUP BY region ;

SELECT 
    region,
    AVG(total_amount) AS Avg_order_value
from clean_sales
GROUP BY region;

SELECT
        category,
        SUM(total_amount) as Total_Revenue
from clean_sales
GROUP BY category;

SELECT
        productS,
        SUM(quantity) as Total_quantity
From clean_sales
Group by productS;

SELECT 
        customer_name,
        count(*) AS Total_orders
from clean_sales
Group by customer_name;


SELECT 
    region,
    SUM(total_amount) as Total_Revenue
from clean_sales
GROUP BY region 
Order by Total_Revenue DESC;


SELECT
        productS,
        SUM(quantity) as Total_quantity
From clean_sales
Group by productS
ORDER BY Total_quantity ASC;

SELECT TOP 1
        productS,
        SUM(quantity) as Total_quantity
From clean_sales
Group by productS
ORDER BY Total_quantity ASC;

SELECT TOP 4
        customer_name,
        SUM(total_amount) AS Total_spent
From clean_sales
group by customer_name 
ORDER BY Total_spent DESC;

SELECT 
        region,
        Sum(quantity) as total_units_sold,
        SUM(total_amount) as Total_Revenue,
        count(*) AS Total_orders,
        AVG(total_amount) AS Avg_order_value
from clean_sales
Group by region
order by total_units_sold DESC;

SELECT 
    region,
    SUM(total_amount) as Total_Revenue
from clean_sales
GROUP BY region 
Having SUM(total_amount) >500;

SELECT 
        productS,
        COUNT(*)  AS items_sold
FROM clean_sales
GROUP BY productS
HAVING COUNT(*)>1;

SELECT
    customer_name,
    SUM(total_amount) AS total_spent
FROM clean_sales
Group by customer_name
HAVING SUM(total_amount) >300;

SELECT 
       sales_iD,customer_name,total_amount,
       CASE 
       WHEN total_amount >= 1000 then 'High value'
       WHEN total_amount >= 200 then 'mid value'
       else                           'low value' 
       
    END AS order_category
    FROM clean_sales;
    
SELECT
    sales_iD,region,total_amount,
    CASE
    when region = 'Nairobi' then 'local'
    else 'country side'
    end as region_type
From clean_sales;

SELECT 
       CASE 
       WHEN total_amount >= 1000 then 'High value'
       WHEN total_amount >= 200 then 'mid value'
       else                           'low value' 
       END AS order_category,

       COUNT(*) as total_orders,
       sum(total_amount)  as total_revenue 

from clean_sales
group by 
         CASE 
       WHEN total_amount >= 1000 then 'High value'
       WHEN total_amount >= 200 then 'mid value'
       else                           'low value' 
       END

Order by total_revenue DESC;

SELECT
    sales_iD,sale_date,
    DATEPART(MONTH ,sale_date) AS sale_month
FROM clean_sales;

SELECT 
    sales_iD,sale_date,
    Datename(month ,sale_date) as month_name

FROM clean_sales;

SELECT 
    sales_iD,sale_date,
    DATEPART(YEAR, sale_date)  as sale_year
FROM clean_sales;


SELECT 
    sales_iD,
    sale_date,
    DATEDIFF(DAY, sale_date, GETDATE()) AS days_ago
FROM clean_sales;


SELECT
    datepart(Year, sale_date) as sale_year,
    DATENAME(month , sale_date) as sale_month,

    COUNT(*)    AS total_orders,
    Sum(total_amount)  as Total_revenue

FROM clean_sales
  group by 
     datepart(Year, sale_date),
     DATENAME(month , sale_date)
    order by 
    datepart(Year, sale_date),
    DATEPART(MONTH, sale_date);

    SELECT 
    DATEPART(YEAR, sale_date)  AS sale_year,
    DATENAME(MONTH, sale_date) AS sale_month,
    COUNT(*)                   AS total_orders,
    SUM(total_amount)          AS total_revenue
FROM clean_sales
GROUP BY 
    DATEPART(YEAR, sale_date),
    DATENAME(MONTH, sale_date);
