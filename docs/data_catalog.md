# Gold Layer Catalog

## Overview
The Gold Layer consists of **business-ready views** designed for reporting, analytics, and decision-making. It follows the **Star Schema** approach, organizing data into **dimension and fact tables**. This layer transforms and combines data from the Silver Layer to ensure **clean, structured and efficient querying**.

---

## Schema & Views
### 1️⃣ **gold.dim_customers** (Dimension Table)
**Purpose:** Stores customer details from multiple sources to provide a unified customer view.

| Column Name         | Data Type  | Description |
|---------------------|-----------|-------------|
| customer_number    | BIGINT       | Surrogate key uniquely identifying each customer |
| customer_id        | INT       | Unique customer ID from CRM |
| customer_key       | NVARCHAR(50)   | Alternate customer identifier |
| first_name         | NVARCHAR(50)    | Customer's first name |
| last_name          | NVARCHAR(50)    | Customer's last name |
| country            | NVARCHAR(50)    | Country of the customer (e.g. United States, Germany)|
| gender             | NVARCHAR(50)    | Gender, prioritized from CRM (e.g. Male, Female)|
| marital_status     | NVARCHAR(50)    | Customer's marital status (e.g. Married, Single) |
| birthdate          | DATE      | Customer's birthdate, formatted as YYYY-MM-DD (e.g. 2001-04-16) |

**Source Tables:**
- `silver.crm_customer_info`
- `silver.erp_cust_az12`
- `silver.erp_loc_a101`

---

### 2️⃣ **gold.dim_products** (Dimension Table)
**Purpose:** Stores product details, including category and cost information.

| Column Name       | Data Type  | Description |
|------------------|-----------|-------------|
| product_number   | BIGINT       | Surrogate key uniquely identifying each product |
| product_id       | INT       | Unique product ID |
| product_key      | NVARCHAR(50)    | Alternate structured alphanumeric identifier, often used for categorization or inventory |
| product_name     | NVARCHAR(50)    | Name of the product with details such as type, color, and size |
| category_id      | NVARCHAR(50)        | A unique identifier for the product's category |
| category         | NVARCHAR(50)    | The category name of the product (e.g., Bikes, Components) to group similar items |
| sub_category     | NVARCHAR(50)    | A more specific classification of the product within its category, like its type |
| maintenance      | NVARCHAR(50)    | Maintenance status (e.g. Yes, No)|
| product_cost     | INT   | Cost of the product |
| product_line     | NVARCHAR(50)    | The specific product line or series to which the product belongs (e.g. Road, Mountain) |
| start_date       | DATE      | The date when the product became available for sale or use |

**Source Tables:**
- `silver.crm_product_info`
- `silver.erp_px_cat_g1v2`

---

### 3️⃣ **gold.fact_sales** (Fact Table)
**Purpose:** Stores sales transaction data, linking products and customers for analysis.

| Column Name       | Data Type  | Description |
|------------------|-----------|-------------|
| order_number     | NVARCHAR(50)        | A unique alphanumeric identifier for each sales order (e.g. 'SO43701') |
| product_number   | BIGINT       | Foreign key to `gold.dim_products` |
| customer_number  | BIGINT       | Foreign key to `gold.dim_customers` |
| order_date       | DATE      | Date when the order was placed |
| shipping_date    | DATE      | Date when the order was shipped to the customer |
| due_date         | DATE      | Due date for order fulfillment |
| sales_amount     | INT   | Total sales amount |
| quantity         | INT       | Quantity of products sold |
| price           | INT   | Price per unit |

**Source Tables:**
- `silver.crm_sales_details`
- `gold.dim_customers`
- `gold.dim_products`

---

## Business Use Cases
🔹**Customer Insights:** Track customer demographics and purchase behavior.
🔹**Product Analysis:** Identify top-selling products, pricing trends, and category performance.  
🔹**Sales Performance:** Analyze revenue, order patterns, and shipping efficiency.  
🔹**Market Trends:** Understand demand by region.

---

## Notes
- The Gold Layer follows **a Star Schema**, improving query performance for analytical workloads.
- The **fact table (`gold.fact_sales`)** joins with dimensions using **surrogate keys** for efficiency.
- The `gold.dim_customers` table prioritizes CRM data for gender and marital status.
- The `gold.dim_products` table excludes historical products (`prd_end_dt IS NULL`).

---

## Next Steps
🔹 Integrate these views with **Power BI, Tableau or SQL reporting tools** for visual analytics.  
🔹 Implement **indexing and performance tuning** to optimize query execution. 

---
