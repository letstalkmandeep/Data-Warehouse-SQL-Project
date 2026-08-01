/*==============================================================================
  Script Name : Gold Layer - Data Quality Validation
  Layer       : Gold

  Purpose:
  Validate the integrity and quality of the Gold layer after the ETL process
  has completed successfully.

  Description:
  This script performs the following data quality checks:

  1. Customer Dimension Validation
     • Identifies duplicate surrogate keys in the Customer Dimension.

  2. Product Dimension Validation
     • Identifies duplicate surrogate keys in the Product Dimension.

  3. Referential Integrity Validation
     • Ensures every record in the Sales Fact view has a valid
       Customer Dimension and Product Dimension reference.
     • Detects orphan fact records caused by missing dimension keys.

  Expected Result:
     • Duplicate checks should return zero rows.
     • Referential integrity check should return zero rows.
     • Any returned records indicate data quality issues that should be
       investigated before reporting or analytics.

  Source Layer:
      • Gold

  Objects Validated:
      • gold.dim_customers
      • gold.dim_products
      • gold.fact_sales
==============================================================================*/


/*==============================================================================
    DATA QUALITY CHECK 1
    Validate Duplicate Customer Keys
==============================================================================*/

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;



/*==============================================================================
    DATA QUALITY CHECK 2
    Validate Duplicate Product Keys
==============================================================================*/

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;



/*==============================================================================
    DATA QUALITY CHECK 3
    Validate Referential Integrity
==============================================================================*/

SELECT
    *
FROM gold.fact_sales AS s

LEFT JOIN gold.dim_customers AS c
       ON c.customer_key = s.customer_key

LEFT JOIN gold.dim_products AS p
       ON p.product_key = s.product_key

WHERE p.product_key IS NULL
   OR c.customer_key IS NULL;