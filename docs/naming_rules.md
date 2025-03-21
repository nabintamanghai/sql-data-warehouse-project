# Naming Rules

This document outlines the naming rules for schemas, tables, views, columns, and other objects in the data warehouse.

## Table of Contents

- [General Principles](#general-principles)
- [Table Naming Rules](#table-naming-rules)
  - [Bronze Rules](#bronze-rules)
  - [Silver Rules](#silver-rules)
  - [Gold Rules](#gold-rules)
- [Column Naming Rules](#column-naming-rules)
  - [Surrogate Keys](#surrogate-keys)
  - [Technical Columns](#technical-columns)
- [Stored Procedure](#stored-procedure)

## General Principles

- **Naming**: Use snake_case (lowercase letters and underscores(`_`) to seperate words).
- **Language**: English.
- **Reserved Words**: Avoid SQL Keywords.

## Table Naming Rules

### Bronze Rules

- Names must start with the source system followed by the original table name.
- `<sourcesystem>_<entity>`
  - `<sourcesystem>`: Source system name (e.g. `crm`, `erp`).
  - `<entity>`: Original table Name from the source system.
- **Example**:
- `crm_customer_info`: Customer information from the CRM system.

### Silver Rules

- Same as Bronze rules.
- `<sourcesystem>_<entity>`
- **Example**:
- `crm_customer_info`.: Customer information from the CRM system.

### Gold Rules

- Use business-aligned names with category prefixes.
- `<category>_<entity>`
  - `<category>`: Table type (e.g. `dim`, `fact`).
  - `<entity>`: Descriptive business name (e.g. `customers`, `products`, `sales`).
- **Example**:
- `dim_customers`: Dimension table for customer data.
- `fact_sales`: Fact table containing sales transactions. 

#### Category Glossary

| Pattern  | Meaning         | Example                |
| -------- | --------------- | -------------------------- |
| `dim_`    | Dimension table | `dim_customer, dim_product` |
| `fact_`  | Fact table      | `fact_sales`              |
| `report_` | Report table    | `report_sales_monthly`      |

## Column Naming Rules

### Surrogate Keys

- All Primary keys in dimension tables end with `_key`.
- `<table_name>_key`
- `<table_name>` name of the table the key belongs to.
- `_key`: A suffix indicating that this column is a surrogate key.
- **Example**: `customer_key`.

### Technical Columns
- `dwh_<column_name>`
- Prefix with `dwh_` for system-generated metadata.
- `<column_name>` column name should indicate the column's purpose
- **Example**: `dwh_load_date`

## Stored Procedure

- Naming pattern for loading data:
  - `load_<layer>`
    - `<layer>`: Data layer (e.g. bronze, silver, gold).
- **Example**: `<load_bronze>`, `<load_silver>`.
