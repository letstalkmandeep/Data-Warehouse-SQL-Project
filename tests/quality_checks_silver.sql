/*==============================================================================
  Script Name : Silver Layer - Data Quality Validation
  Layer       : Silver

  Purpose:
  Validate the quality, consistency, and integrity of data loaded into the
  Silver layer after the ETL transformation process.

  Description:
  This script performs a comprehensive set of data quality checks across all
  Silver layer tables to ensure that the transformed data meets business and
  technical quality standards before being promoted to the Gold layer.

  Validation Checks Performed:

  CRM Customer Information
      • Detect duplicate or NULL primary keys.
      • Identify unwanted leading or trailing spaces.
      • Validate standardized marital status values.

  CRM Product Information
      • Detect duplicate or NULL primary keys.
      • Identify unwanted leading or trailing spaces.
      • Validate product cost values.
      • Validate standardized product line values.
      • Detect invalid product date ranges.

  CRM Sales Details
      • Validate source date values.
      • Detect invalid order, shipping, and due date sequences.
      • Verify Sales = Quantity × Price.
      • Detect NULL, negative, or invalid numeric values.

  ERP Customer Information
      • Detect future birth dates.
      • Validate standardized gender values.

  ERP Customer Location
      • Validate standardized country values.

  ERP Product Category
      • Detect unwanted leading or trailing spaces.
      • Validate standardized maintenance values.

  Expected Results:
      • Duplicate and NULL key checks should return zero rows.
      • Data validation queries should return zero invalid records.
      • DISTINCT queries should contain only standardized business values.
      • Any returned records indicate data quality issues requiring
        investigation before loading the Gold layer.

  Source Layer:
      • Silver
      • Bronze (used for source date validation)

  Tables Validated:
      CRM
      - silver.crm_cst_info
      - silver.crm_prd_info
      - silver.crm_sales_details

      ERP
      - silver.erp_cust_az12
      - silver.erp_loc_a101
      - silver.erp_px_cat_g1v2

  Notes:
      • Execute this script immediately after loading the Silver layer.
      • Resolve any identified issues before creating Gold layer views.
==============================================================================*/


/*==============================================================================
    CRM CUSTOMER INFORMATION VALIDATION
==============================================================================*/

-- Check for NULL or Duplicate Primary Keys
-- Expected Result: No rows returned

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cst_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;


-- Check for Leading or Trailing Spaces
-- Expected Result: No rows returned

SELECT
    cst_key
FROM silver.crm_cst_info
WHERE cst_key <> TRIM(cst_key);


-- Validate Standardized Marital Status Values

SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cst_info;



/*==============================================================================
    CRM PRODUCT INFORMATION VALIDATION
==============================================================================*/

-- Check for NULL or Duplicate Primary Keys

SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;


-- Check for Leading or Trailing Spaces

SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);


-- Check for NULL or Negative Product Costs

SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0
   OR prd_cost IS NULL;


-- Validate Product Line Values

SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;


-- Validate Product Date Range

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;



/*==============================================================================
    CRM SALES VALIDATION
==============================================================================*/

-- Validate Source Date Values

SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LENGTH(CAST(sls_due_dt AS VARCHAR(50))) <> 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;


-- Validate Order Date Sequence

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


-- Validate Sales Amount Calculation

SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;



/*==============================================================================
    ERP CUSTOMER VALIDATION
==============================================================================*/

-- Validate Birth Dates

SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate > CURRENT_TIMESTAMP;


-- Validate Gender Values

SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;



/*==============================================================================
    ERP CUSTOMER LOCATION VALIDATION
==============================================================================*/

-- Validate Country Values

SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;



/*==============================================================================
    ERP PRODUCT CATEGORY VALIDATION
==============================================================================*/

-- Check for Leading or Trailing Spaces

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);


-- Validate Maintenance Values

SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;