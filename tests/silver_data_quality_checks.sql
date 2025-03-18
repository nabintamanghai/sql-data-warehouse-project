/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    Perform data consistency, duplicate checks, date validation, and standardization
    across the 'silver' layer.
===============================================================================
*/


-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- identifying NULL or duplicates values in Primary Key
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_customer_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- checking for extra spaces in cst_key column
SELECT 
    cst_key 
FROM silver.crm_customer_info
WHERE cst_key != TRIM(cst_key);

-- checking consistency in marital_status column
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_customer_info;

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================
-- identifying for NULL or duplicates in Primary Key
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_product_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- checking for extra spaces in prd_nm column
SELECT 
    prd_nm 
FROM silver.crm_product_info
WHERE prd_nm != TRIM(prd_nm);

-- checking for invalid cost (Negative or NULL) in prd_cost column
SELECT 
    prd_cost 
FROM silver.crm_product_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- checking consistency in prd_line columbn 
SELECT DISTINCT 
    prd_line 
FROM silver.crm_product_info;

-- checking for invalid date ranges between prd_start_dt & prd_end_dt (start date cannot be greater than end date)
SELECT 
    * 
FROM silver.crm_product_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================
-- identifying invalid dates in sls_due_dt column
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101;

-- identifying invalid date in sls_order_dt column (order date cannot be greater than ship or due dates)
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- checking consistency in sls_sales column (sales price should be: Quantity * Price)
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================
-- checking birthdate range (cannot be future birth date)
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- checking gender consistency in 'gen' column
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================
-- checking country consistency in 'cntry' column
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;


-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- looking for extra spaces in 'cat', 'subcat', 'maintenance' column
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- checking consistency in maintenance column
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
