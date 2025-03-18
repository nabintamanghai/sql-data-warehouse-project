/*
========================================================
INGESTING DATA INTO BRONZE TABLES USING STORED PROCEDURE
========================================================

SCRIPT PURPOSE:
This stored procedure `bronze.load_bronze` loads data into the bronze layer schema of the DataWarehouse.  
It first truncates existing data in the bronze tables and then perform BULK INSERT operations to load data  
from CSV files located in the specified directory and it also records the duration of each step and handles  
errors if they occur.

PARAMETERS:
	This stored procedure does not accept any parameters or return any values.

*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
--SET NOCOUNT ON; -- USE THIS TO NOT SHOW COUNT OF AFFECTED ROWS
	DECLARE @start_time DATETIME, @end_time DATETIME, @DurationInSeconds INT, @BatchStartTime DATETIME, @BatchEndTime DATETIME;
	SET @BatchStartTime = GETDATE();
	BEGIN TRY
		PRINT'======================================';
		PRINT'LOADING BRONZE LAYER';
		PRINT'======================================';

		PRINT'---------------------------------------';
		PRINT'LOADING CRM TABLES';
		PRINT'---------------------------------------';

		SET @start_time = GETDATE();
		PRINT'TRUNCATING TABLE: bronze.crm_customer_info';
		TRUNCATE TABLE bronze.crm_customer_info;

		PRINT'INSERTING DATA INTO: bronze.crm_customer_info';
		BULK INSERT bronze.crm_customer_info
		FROM 'C:\SQL2022\datasets\source_crm\customer_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';
		PRINT'---------------------------------------';


		SET @start_time = GETDATE();
		PRINT'TRUNCATING TABLE: bronze.crm_product_info';
		TRUNCATE TABLE bronze.crm_product_info;

		PRINT'INSERTING DATA INTO: bronze.crm_product_info';
		BULK INSERT bronze.crm_product_info
		FROM 'C:\SQL2022\datasets\source_crm\product_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'-> Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';
		PRINT'---------------------------------------';


		SET @start_time = GETDATE();
		PRINT'TRUNCATING TABLE: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT'INSERTING DATA INTO: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\SQL2022\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';

		SET @BatchEndTime = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @BatchStartTime, @BatchEndTime);
		

		PRINT'---------------------------------------';
		PRINT'LOADING ERP TABLES';
		PRINT'---------------------------------------';

		SET @start_time = GETDATE();
		PRINT'TRUNCATING TABLE: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
 
		PRINT'INSERTING DATA INTO: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\SQL2022\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';
		PRINT'---------------------------------------';


		SET @start_time = GETDATE();
		PRINT'TRUNCATING TABLE: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT'INSERTING DATA INTO: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\SQL2022\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';
		PRINT'---------------------------------------';

		SET @start_time = GETDATE();
		PRINT'TRUNCATING TABLE: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT'INSERTING DATA INTO: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\SQL2022\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @start_time, @end_time);
		PRINT'Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';

		PRINT'---------------------------------------';
		SET @BatchEndTime = GETDATE();
		SET @DurationInSeconds = DATEDIFF(SECOND, @BatchStartTime, @BatchEndTime);
		PRINT'======================================';
		PRINT'--> Batch Load Duration: ' + CAST(@DurationInSeconds AS NVARCHAR(10)) + ' seconds';
		PRINT'======================================';

	END TRY
	BEGIN CATCH
		PRINT'+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+';
		PRINT'ERROR OCCURED WHILE LOADING BRONZE LAYER';
		PRINT'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'ERROR MESSAGE' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT'+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+';
	END CATCH
END;
