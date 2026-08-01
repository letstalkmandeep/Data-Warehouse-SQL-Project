/*==============================================================================
  Script Name : Silver Layer - Table Creation
  Layer       : Silver

  Purpose:
  Create all Silver layer tables used to store cleaned, standardized,
  and transformed data from the Bronze layer.

  Description:
  This script performs the following tasks:

  1. Drops existing Silver tables (if they exist) for clean recreation.
  2. Creates refined tables for CRM and ERP source systems.
  3. Introduces additional business-ready columns where required.
     - Product Category ID (cat_id)
     - Sales Product Key (sls_prd_key)
  4. Converts appropriate data types from the Bronze layer
     (e.g., integer date fields to DATE).
  5. Adds an audit column (dwh_created_date) to record when each row
     is loaded into the Silver layer.

  Source Systems:
      • CRM
      • ERP

  Notes:
      • Silver tables contain cleansed and standardized data.
      • These tables serve as the source for the Gold layer.
      • dwh_created_date is automatically populated using
        CURRENT_TIMESTAMP.
==============================================================================*/


/*==============================================================================
    CRM TABLES
==============================================================================*/

-- Customer Information
DROP TABLE IF EXISTS silver.crm_cst_info;

CREATE TABLE silver.crm_cst_info (
    cst_id               INT,
    cst_key              VARCHAR(50),
    cst_firstname        VARCHAR(50),
    cst_lastname         VARCHAR(50),
    cst_marital_status   VARCHAR(50),
    cst_gndr             VARCHAR(50),
    cst_create_date      DATE,
    dwh_created_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Product Information
DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id               INT,
    prd_key              VARCHAR(50),
    cat_id               VARCHAR(50),
    sls_prd_key          VARCHAR(50),
    prd_nm               VARCHAR(50),
    prd_cost             INT,
    prd_line             VARCHAR(50),
    prd_start_dt         DATE,
    prd_end_dt           DATE,
    dwh_created_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Sales Details
DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
    sls_ord_num          VARCHAR(50),
    sls_prd_key          VARCHAR(50),
    sls_cust_id          INT,
    sls_order_dt         DATE,
    sls_ship_dt          DATE,
    sls_due_dt           DATE,
    sls_sales            INT,
    sls_quantity         INT,
    sls_price            INT,
    dwh_created_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



/*==============================================================================
    ERP TABLES
==============================================================================*/

-- Customer Information
DROP TABLE IF EXISTS silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
    cid                  VARCHAR(50),
    bdate                DATE,
    gen                  VARCHAR(50),
    dwh_created_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Customer Location
DROP TABLE IF EXISTS silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
    cid                  VARCHAR(50),
    cntry                VARCHAR(50),
    dwh_created_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Product Category
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2 (
    id                   VARCHAR(50),
    cat                  VARCHAR(50),
    subcat               VARCHAR(50),
    maintenance          VARCHAR(50),
    dwh_created_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
