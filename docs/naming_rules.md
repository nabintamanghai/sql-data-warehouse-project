Naming Rules
This document outlines the naming rules for schemas, tables, views, columns, and other objects in the data warehouse.

Table of Contents
General Principles
Table Naming Rules
Bronze Rules
Silver Rules
Gold Rules
Column Naming Rules
Surrogate Keys
Technical Columns
Stored Procedure
General Principles
Naming: Use snake*case (lowercase letters and underscores).
Language: English.
Reserved Words: Avoid SQL Keywords.
Table Naming Rules
Bronze Rules
Name starts with the source system followed by the original table name.
<sourcesystem>*<entity>
<sourcesystem>: Source system name (e.g. crm, erp).
<entity>: Original table Name.
Example: crm*customer_info.
Silver Rules
Same as Bronze rules.
<sourcesystem>*<entity>
Example: crm*customer_info.
Gold Rules
Use business-aligned names with category prefixes.
<category>*<entity>
<category>: Table type (e.g. dim, fact).
<entity>: Descriptive business name.
Example: dim*customers, fact_sales.
Category Glossary
Pattern Meaning Example(s)
dim* Dimension table dim*customer, dim_product
fact* Fact table fact*sales
report* Report table report\*sales_monthly
Column Naming Rules
Surrogate Keys
Primary keys in dimension tables end with \_key.
<table_name>\_key
Example: customer_key.
Technical Columns
Prefix with dwh\* for system-generated metadata.
dwh\*<column_name>
Example: dwh_load_date.
Stored Procedure
Naming pattern for loading data:
load\*<layer>
<layer>: Data layer (e.g. bronze, silver, gold).
Example: load_bronze, load_silver.

