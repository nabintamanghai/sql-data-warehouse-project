/*

================================
DATABASE AND SCHEMAS CREATION
================================

following query creates a new database named "DataLakehouse" and also checks if there's
already a same database. If exists then it drops and lastly the query also creates 3 schemas
within the database: 'bronze', 'silver', 'gold'.

=========
WARNING:
=========
running this query will drop the enitre "DataLakehouse" databse if it exists and 
all the data in the database will be deleted permanentaly. 
make sure you know what you are doing and have backup before running this query

*/


-- SWITCHING TO MASTER DATABASE
USE MASTER;
GO

-- CHECKS THE SAME NAME DATABASE EXISTS OR NOT IF YES THEN DROPS IT
IF EXISTS (SELECT 1 FROM sys.databases WHERE name='DataLakehouse')
BEGIN
	ALTER DATABASE DataLakehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataLakehouse;
END;
GO


-- CREATES DATABASE NAMED "DataLakehouse"
CREATE DATABASE DataLakehouse;
GO


-- MAKES SURE WE'RE IN THE RIGHT DATABASE
USE DataLakehouse;
GO


-- CREATES SCHEMAS
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
