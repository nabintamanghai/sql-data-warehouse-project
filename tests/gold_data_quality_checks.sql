/*
===============================================================================
Quality Checks
===============================================================================
Purpose:
    - To validate integrity, consistency, and accuracy of the Gold Layer.
    - Ensures:
        - Unique surrogate keys in dimension tables.
        - Referential integrity between fact and dimension tables.
        - Correct relationships in the data model.
===============================================================================
*/
USE DataWarehouse;
GO

--================================================
-- QUALITY TEST IN gold.dim_customers TABLE
--================================================
-- checking for any duplicates values
SELECT customer_number, COUNT(*) AS row_count FROM gold.dim_customers
GROUP BY customer_number
HAVING count(*) > 1;

-- identifying consistency in these columns (gender, marital_status, country)
SELECT DISTINCT gender FROM gold.dim_customers;
SELECT DISTINCT marital_status FROM gold.dim_customers;
SELECT DISTINCT country FROM gold.dim_customers;


--================================================
-- QUALITY TEST IN gold.dim_products TABLE
--================================================
-- checking for any duplicate rows
SELECT product_number, COUNT(*) AS row_count
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1;

-- identifying consistency in these columns (category, maintenance, sub_category, product_line)
SELECT DISTINCT category FROM gold.dim_products;
SELECT DISTINCT maintenance FROM gold.dim_products;
SELECT DISTINCT sub_category FROM gold.dim_products;
SELECT DISTINCT product_line FROM gold.dim_products;


--================================================
-- QUALITY TEST IN gold.fact_sales TABLE
--================================================
-- checking relationships between fact and dimension tables 

-- fs = fact_sales (gold.fact_sales)
-- dc = dimension_customers (gold.dim_customers)
-- dp = dimension_products (gold.dim_products)
SELECT * 
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
	ON fs.customer_number = dc.customer_number
LEFT JOIN gold.dim_products AS dp
	ON fs.product_number = dp.product_number
WHERE dc.customer_number IS NULL OR dp.product_number IS NULL;
