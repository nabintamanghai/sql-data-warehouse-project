/*
===============================
BRONZE SCHEMA TABLE CREATIONS
===============================

this query creates tables inside the 'bronze' schema and it also checks whether a table with the same 
name already exists, if it does then it drops it.

========
CAUTION:
========
running this query will delete all data within the existing tables, so ensure that you have backup 
before running this query.

============
EXPLINATION:
============
1. OBJECT_ID('bronze.table_name', 'U'): checks whether the table exists in the 'bronze' schema.
   'U' means that we are looking for user-defined tables (not views or stored procedures).

2. DROP TABLE: If a table already exists, it is dropped before creating a new one.

3. CREATE TABLE: The new table is created with the specified columns with datatype.

*/

-- MAKING SURE WE'RE CREATING TABLE IN THE RIGHT DATABASE
USE DataWarehouse;
GO


IF OBJECT_ID('bronze.crm_customer_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_customer_info;
GO

CREATE TABLE bronze.crm_customer_info (
	cst_id	INT,
	cst_key	NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),	
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);
GO


IF OBJECT_ID('bronze.crm_product_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_product_info;
GO

CREATE TABLE bronze.crm_product_info (
	prd_id	INT,
	prd_key	NVARCHAR(50),
	prd_nm	NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);
GO


IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO


IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);
GO


IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);
GO


IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
GO
  
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);
