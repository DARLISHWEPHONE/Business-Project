# Retail Business Analysis with MySQL Workbench

**Exploring retail sales, customer behavior, product performance, store performance, and inventory using SQL.**

`MySQL` · `MySQL Workbench` · `Exploratory Data Analysis` · `Retail Analytics`

---

## Contents

- [Project Overview](#project-overview)
- [Business Objectives That I Defined](#business-objectives-that-i-defined)
- [SQL Tools and Techniques That I Used](#sql-tools-and-techniques-that-i-used)
- [Key Findings That I Found](#key-findings-that-i-found)
- [Inventory Assumption](#inventory-assumption)
- [Project Files](#project-files)
- [What I known](#what-i-known)

## Project Overview

This project began with XLSX files containing retail business data. My goal was to load the data into a relational database, ask business questions, and answer them using SQL.

### How I prepared my Data in MySQL Workbench

1. **Prepare the data:** Convert the original XLSX files into CSV files.
2. **Build the database:** Create the schema in MySQL Workbench and define the tables, columns, and appropriate data types.
3. **Load the data:** Use `LOAD DATA LOCAL INFILE` instead of the Import Wizard for faster loading.
4. **Connect the tables:** Join the sales table with the customers, products, and stores tables.
5. **Analyze performance:** Calculate total sales, revenue after discounts, and total profit to explore trends and compare customers, products, and stores.

## Business Objectives That I Defined

| Area | Objective |
| :--- | :--- |
| Sales and profitability | Analyze annual and monthly sales, revenue, and profit. |
| Customers | Identify high-spending customers and explore purchasing patterns. |
| Products | Compare products by total sales, revenue, and profit. |
| Stores | Rank stores and explore differences in performance. |
| Inventory | Estimate remaining stock using an explicit inventory assumption. |

## SQL Tools and Techniques That I Used

**Tools:** MySQL and MySQL Workbench

| Technique | SQL Features Used |
| :--- | :--- |
| Combining and structuring queries | Joins, CTEs, subqueries, stored procedures |
| Filtering and organizing results | `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT` |
| Aggregation and aliases | `SUM`, `AVG`, `MAX`, `MIN`, `COUNT`, `AS` |
| Conditional logic | `CASE` |
| Text-based date extraction | `SUBSTRING_INDEX` to split date strings into year, month, and day |
| Window functions and ranking | `OVER`, `PARTITION BY`, `ROW_NUMBER`, `RANK`, `DENSE_RANK` |

## Key Findings That I Found 

### 1. Overall Revenue and Yearly Financials

**2020 recorded the highest overall revenue and profit.**

| Metric | 2020 Result |
| :--- | ---: |
| Revenue | $75,809,027.50 |
| Profit | $21,306,339.62 |

The strongest revenue-generating months identified for each year were:

| Year | Strongest Month |
| :--- | :--- |
| 2020 | January |
| 2021 | October |
| 2022 | April |
| 2023 | March |

### 2. Store and Management Performance

| Performance Measure | Store | Manager | Year | Result |
| :--- | :--- | :--- | :--- | ---: |
| Highest reported annual store revenue | Young Inc | Jeffrey Gray | 2022 | $548,088.44 |
| Highest annual store profit | Brown-Meyer | Kristina Jones | 2022 | $143,502.84 |

### 3. Product and Category Insights

| Finding | Result |
| :--- | :--- |
| Best-selling product overall | **Mother**, which also led revenue and profit across multiple years |
| Lowest total revenue | **Position** — Product ID `1241`, with revenue of **$2,047.01** |
| Leading category | **Sports**, with **Mother** as its top revenue-generating item |

### 4. Customer and Inventory Insights

| Metric | Result |
| :--- | :--- |
| Average spending per customer | **$6,159.35** |
| Highest-spending customer | **Alisha Johnson** |
| Highest calculated remaining stock | Product ID `56` — **11,299 units** |
| Largest calculated inventory deficit | Product ID `177` — **−338 units** |

## Inventory Assumption

Remaining stock was estimated using the following calculation:

```text
Remaining Stock = Total Stock − Total Quantity Sold
```

> **Interpretation:** This calculation assumes that total stock and total quantity sold cover a comparable period and scope. A negative result indicates a calculated inventory deficit under this assumption; it does not, by itself, confirm an actual stockout. Stock timing, replenishment, and data completeness should be checked before drawing operational conclusions.

## Project Files

| File or Folder | Description |
| :--- | :--- |
| `Table Data Local Infile Business_Project.sql` | Database setup and CSV import |
| `Eda.Process For Business_Datasets.sql` | Data preparation and analysis queries |
| `Business_Project_CSV/` | Source CSV files |
| `Business_Project_Excel/` | Original workbook |
| `business_project EER diagram and Table_Images/` | EER diagram and query results |

## What I Known

This project strengthened my ability to combine relational data, write multi-step SQL queries, and turn query results into business insights.

My main takeaways were:

- **Distinguish sales from revenue:** Revenue accounts for discounts, so it should be interpreted separately from total sales before discounts.
- **Check data coverage before comparing periods:** Confirm which years and months are included before interpreting differences in performance.
- **Document assumptions:** Inventory estimates depend on how stock and sales quantities are defined and aligned.
- **Connect SQL results to business questions:** Use aggregations, joins, and rankings to explain customer, product, and store performance.
