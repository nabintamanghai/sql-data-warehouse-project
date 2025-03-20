/*
===============================================================================
GOLD SCHEME VIEW CREATIONS  
===============================================================================

this query creates a view inside the 'gold' schema and it also checks whether a view with the same 
name already exists, if it does then it drops it.

Purpose:
    - Represents final dimension and fact tables (Star Schema).
    - Transforms and combines data from the Silver layer.
    - Produces a clean, business-ready dataset.

Usage:
    - Used for analytics and reporting.
===============================================================================
*/

-- making sure we're creating view in the right database
USE DataWarehouse;
GO


--==================================================================
-- CREATING DIMENSION TABLE FOR GOLD LAYER: gold.dim_customers
--==================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
		DROP VIEW gold.dim_customers;
GO
-- (ci) = customer_info (crm_customer_info)
-- (cd) = customer_details (erp_cust_az12)
-- (cl) = cusomter_location (erp_loc_a101)
CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_number, -- surrogate key
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_key,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	CASE
		  WHEN ci.cst_gndr = 'Unknown' THEN ci.cst_gndr -- using gender column from crm source
		  ELSE COALESCE(cd.gen, 'Unknown')              -- (crm is the primary source for gender)
	END AS gender,
	ci.cst_marital_status AS marital_status,
	cd.bdate AS birthdate
FROM silver.crm_customer_info AS ci
LEFT JOIN silver.erp_cust_az12 AS cd
  ON ci.cst_key=cd.cid
LEFT JOIN silver.erp_loc_a101 AS cl
  ON ci.cst_key=cl.cid;
GO


--==================================================================
-- CREATING DIMENSION TABLE FOR GOLD LAYER: gold.dim_customers
--==================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
		DROP VIEW gold.dim_products;
GO
-- p = product_info (silver.crm_product_info)
-- pc = product_category (silver.erp_px_cat_g1v2)
CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY p.prd_key) AS product_number, -- surrogate key
	p.prd_id AS product_id,
	p.prd_key AS product_key,
	p.prd_nm AS product_name,
	p.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS sub_category,
	pc.maintenance AS maintenance,
	p.prd_cost AS product_cost,
	p.prd_line AS product_line,
	p.prd_start_dt AS start_date
FROM silver.crm_product_info AS p
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
  ON p.cat_id=pc.id
WHERE p.prd_end_dt IS NULL; -- filters out all historical data
GO

--==================================================================
-- CREATING DIMENSION TABLE FOR GOLD LAYER: gold.dim_customers
--==================================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO
-- sd = sales_details (silver.crm_sales_details)
-- dc = dimension_customer (gold.dim_customers)
-- dp = dimension_product (gold.dim_products)
CREATE VIEW gold.fact_sales	AS
SELECT
	sd.sls_ord_num AS order_number,
	dp.product_number,
	dc.customer_number,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_customers AS dc
  ON sd.sls_cust_id = dc.customer_id
LEFT JOIN gold.dim_products AS dp
  ON sd.sls_prd_key = dp.product_key;
GO
