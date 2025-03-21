# Data Warehouse &  Analytics Portfolio Project

Welcome to my **Data Analyst Portfolio** repository!  
This project showcases my passion for data analytics and highlights my journey toward becoming a proficient data analyst. The goal is not to demonstrate skills in data engineering, but to show how I approach solving real-world data challenges and transform raw data into meaningful insights. Throughout this repository, you'll find examples of how I approach solving real-world data challenges and how I transform raw data into meaningful insights. Throughout this project, I’ve leveraged industry best practices and tools, focusing on creating efficient workflows and scalable data models. 

---
## Project Overview

This project involves the creation of a **data analysis pipeline** where I applied my skills in SQL, data modeling, and ETL processes to gain valuable business insights.

**The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:**
1. Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. Gold Layer: Houses business-ready data modeled into a star schema required for reporting and analytics.

**Project involves following steps:**
- Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver and Gold layers.
- ETL Pipelines: Extracting, transforming and loading data from source systems into the warehouse.
- Data Modeling: Developing fact and dimension tables optimized for analytical queries.
- Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

---

**Business Use Cases**
- Customer Insights: Track customer demographics and purchase behavior. 
- Product Analysis: Identify top-selling products, pricing trends and category performance.
- Sales Performance: Analyze revenue, order patterns and shipping efficiency.
- Market Trends: Understand demand by region.

**Next Steps**
- Integrate these views with Power BI, Tableau or SQL reporting tools for visual analytics.
- Implement indexing and performance tuning to optimize query execution.


---
## 📂 Repository Structure
```
sql-data-warehouse-project/
│
|
├── datasets/                           # Raw datasets used for the project (source system - ERP and CRM)
│   ├── crm_source  
|         ├── customer_info.csv         # csv files containing data of customer
|         ├── product_info.csb          # csv file containing data abut product
|         ├── sales_details.csv         # csv file containing data about sales transaction
│   ├── erp_source                         
│         ├── CUST_AZ12.csv             # csv file containing more details about customers
|         ├── LOC_A101.csv              # csv file containing location info of customers
|         ├── PX_CAT_G1V2.csv           # csv file containing category data of products
|
|
├── docs/                               # Project documentation and architecture details
│   ├── ETL_Pipeline.png                # Visual representation of ETL techniques and methods used in the project
│   ├── data_catalog.md                 # Detailed gold layer catalog
│   ├── data_flow.png                   # Diagram illustrating the flow of data across different stages
│   ├── data_model.png                  # Diagram showcasing the data model, such as a star schema
│   ├── medallion_data_architecture.png # Diagram illustrating the Medallion Architecture (Bronze, Silver, Gold layers)
│   ├── naming_rules.md                 # Guidelines on naming conventions for tables, columns and files to maintain          |                                         consistency
│   ├── tables_relationship.png         # Diagram showing relationships between tables in the data warehouse
|
│
|
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
|
├── tests/                              # Test scripts and quality files
│
|
├── LICENSE                             # License information for the repository
├── README.md                           # Project Overview
|
|
```

---

## How to Use This Project

1. **Clone the repository**:  
   Clone this repository to your local machine to get started with the project.

2. **Set up SQL Server**:  
   Install SQL Server and SQL Server Management Studio (SSMS) to manage the database and run SQL scripts.

3. **Load the datasets**:  
   Import the raw CSV files into SQL Server.

4. **Run the ETL scripts**:  
   Navigate through the `scripts/bronze`, `scripts/silver`, and `scripts/gold` folders to run the transformation and analytical scripts.

5. **Analyze the results**:  
   Once the data is cleaned, transformed, and modeled, explore the results through reports and visualizations.
   
