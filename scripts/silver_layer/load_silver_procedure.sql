/*
=========================================
INGESTING DATA INTO SILVER LAYER TABLES
=========================================

SCRIPT PURPOSE:
This stored procedure executes the ETL (Extract, Transform, Load) process to populate the Silver schema tables 
from Bronze layer.

Actions Performed:
Extract: Retrieves raw data from the Bronze tables.
Transform: Cleanses, deduplicates, and structures the data for analytical use.
Load: Truncates existing Silver tables and inserts the transformed data.
This ensures that the Silver schema contains high-quality, structured data for further processing and analysis.
it also records the duration of each step and handles errors if they occur.

PARAMETERS:
	This stored procedure does not accept any parameters or return any values.

*/
USE DataWarehouse;
GO


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @DurationInSeconds INT, @BatchStartTime DATETIME, @BatchEndTime DATETIME;
	SET @BatchStartTime = GETDATE();
	BEGIN TRY
		PRINT'==================================================';
		PRINT'LOADING SILVER LAYER';
		PRINT'==================================================';

		PRINT'==================================================';
		PRINT'LOADING CRM TABLES';
		PRINT'==================================================';

		SET @start_time = GETDATE();
		PRINT'Truncating Table: silver.crm_customer_info';
		TRUNCATE TABLE silver.crm_customer_info;

		PRINT'Inserting Data Into: silver.crm_customer_info';
		INSERT INTO silver.crm_customer_info 
		(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status,  cst_gndr, cst_create_date)
						SELECT 
							cst_id,
							cst_key,
							TRIM(cst_firstname) AS cst_firstname, 
							TRIM(cst_lastname) AS cst_lastname, 
							CASE
								WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
								WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
								ELSE 'Unknown'
							END AS cst_marital_status,
							CASE
								WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
								WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
								ELSE 'Unknown'			  
							END AS cst_gndr, 
							cst_create_date
							FROM (
							SELECT *,
							ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS latest_record
							FROM bronze.crm_customer_info
							WHERE cst_id IS NOT NULL
						)AS T WHERE latest_record = 1;
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'-> Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' second'

		PRINT'==================================================';


		SET @start_time = GETDATE();
		PRINT'Truncating Table: silver.crm_product_info';
		TRUNCATE TABLE silver.crm_product_info;

		PRINT'Inserting Data Into: silver.crm_product_info';
		INSERT INTO silver.crm_product_info (prd_id,
											 cat_id,
											 prd_key,
											 prd_nm,
											 prd_cost,
											 prd_line,
											 prd_start_dt,
											 prd_end_dt)
		SELECT prd_id,
			   REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
			   SUBSTRING(prd_key, 7, 1000) AS prd_key,
			   prd_nm,
			   ISNULL(prd_cost, 0) AS prd_cost,
			   CASE UPPER(TRIM(prd_line))
					WHEN 'M' THEN 'Mountain'
					WHEN 'R' THEN 'Road'
					WHEN 'S' THEN 'Other Sales'
					WHEN 'T' THEN 'Touring'
					ELSE 'Unknown'
				END AS prd_line,
				CAST(prd_start_dt AS DATE) AS prd_start_dt,
				CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt
		FROM bronze.crm_product_info;
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'-> Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds'

		PRINT'==================================================';

		SET @start_time = GETDATE();
		PRINT'Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;

		PRINT'Inserting Data Into: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(sls_ord_num,
											 sls_prd_key,
											 sls_cust_id,
											 sls_order_dt,
											 sls_ship_dt,
											 sls_due_dt,
											 sls_sales,
											 sls_quantity,
											 sls_price)
		SELECT sls_ord_num,
			   sls_prd_key,
			   sls_cust_id,
			   CASE
					WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			   END AS sls_order_dt,
			   CASE 
					WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
			   END AS sls_ship_dt,
			   CASE
					WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			   END AS sls_due_dt,
			   CASE
					WHEN sls_sales <= 0 OR sls_sales IS NULL OR 
					sls_sales != sls_quantity * ABS(sls_price)  THEN sls_quantity * ABS(sls_price)
					ELSE sls_sales
			   END AS new_sls_sales,
			   sls_quantity,
			   CASE 
					WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
					ELSE sls_price
			   END AS new_sls_price
		FROM bronze.crm_sales_details;
		SET @BatchEndTime = GETDATE();
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'-> Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' Seconds';

		PRINT'==================================================';
		SET @DurationInSeconds = DATEDIFF(SECOND, @BatchStarTtime, @BatchEndTime);
		PRINT '-> CRM Tables Load Duration: ' + CAST(@DurationInSeconds AS VARCHAR) + ' Seconds';
		PRINT'==================================================';








		SET @BatchStartTime = GETDATE();
		PRINT'==================================================';
		PRINT'LOADING ERP TABLES';
		PRINT'==================================================';

		SET @start_time = GETDATE();
		PRINT'Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;

		PRINT'Inserting Data Into: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
		SELECT  
				CASE
					WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
					ELSE cid
				END AS cid,
				CASE 
					WHEN bdate > GETDATE() THEN NULL
					ELSE bdate
				END AS bdate,
				CASE
					WHEN gen IS NULL OR gen = '' THEN 'Unknown'
					WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
					WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
					ELSE gen
				END AS gen
		FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'-> Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' Seconds';

		PRINT'==================================================';					

		SET @start_time = GETDATE();
		PRINT'Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;

		PRINT'Inserting Data Into: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (cid, cntry)
		SELECT 
			REPLACE(cid, '-', '') AS cid,
			CASE
				WHEN cntry IS NULL OR cntry = '' THEN 'Unknown'
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) = 'US' OR TRIM(cntry) = 'USA' THEN 'United States'
				ELSE TRIM(cntry)
			END AS cntry
		FROM bronze.erp_loc_a101;

		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'-> Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' Seconds';

		PRINT'==================================================';

		SET @start_time = GETDATE();
		PRINT'Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;

		PRINT'Inserting Data Into: silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
		SELECT
			id,
			TRIM(cat) AS cat,
			TRIM(subcat) AS subcat,
			TRIM(maintenance) AS maintenance
		FROM bronze.erp_px_cat_g1v2;
		
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'-> Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' Seconds';

		PRINT'==================================================';
		SET @BatchEndTime = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @BatchStartTime, @BatchStartTime);
		PRINT'-> ERP TABLE LOAD DURATION: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' Seconds';
		PRINT'==================================================';

	END TRY
	BEGIN CATCH
		PRINT'+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+';
		PRINT'ERROR OCCURED WHILE LOADING SILVER LAYER';
		PRINT'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT'ERROR MESSAGE: ' + CAST(ERROR_NUMBER() AS NVARCHAR) ;
		PRINT'ERROR MESSAGE: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'ERROR MESSAGE: ' + CAST(ERROR_LINE()AS NVARCHAR);
		PRINT'+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+';
	END CATCH
END;
