/*==============================================================================
  Script Name : Bronze Layer - Table Creation
  Layer       : Bronze
  Purpose     : Create all raw staging tables for the CRM and ERP source systems.

  Description:
  This script performs the following tasks:

  1. Drops existing Bronze tables (if they exist) to enable clean recreation.
  2. Creates raw staging tables for CRM data:
       - Customer Information
       - Product Information
       - Sales Details
  3. Creates raw staging tables for ERP data.
  4. Defines the initial table schema using appropriate data types.
  5. These tables are intended to store raw source data before any
     cleansing or transformation in the Silver layer.

  Source Systems:
     • CRM
     • ERP
==============================================================================*/


/*==============================================================================
    CRM TABLES
==============================================================================*/

-- Customer Information
DROP TABLE IF EXISTS bronze.crm_cst_info;

CREATE TABLE bronze.crm_cst_info (
    cst_id               INT,
    cst_key              VARCHAR(50),
    cst_firstname        VARCHAR(50),
    cst_lastname         VARCHAR(50),
    cst_marital_status   VARCHAR(50),
    cst_gndr             VARCHAR(50),
    cst_create_date      DATE
);


-- Product Information
DROP TABLE IF EXISTS bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id               INT,
    prd_key              VARCHAR(50),
    prd_nm               VARCHAR(50),
    prd_cost             INT,
    prd_line             VARCHAR(50),
    prd_start_dt         DATE,
    prd_end_dt           DATE
);


-- Sales Details
DROP TABLE IF EXISTS bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num          VARCHAR(50),
    sls_prd_key          VARCHAR(50),
    sls_cust_id          INT,
    sls_order_dt         INT,
    sls_ship_dt          INT,
    sls_due_dt           INT,
    sls_sales            INT,
    sls_quantity         INT,
    sls_price            INT
);



/*==============================================================================
    ERP TABLES
==============================================================================*/

-- Customer Information
DROP TABLE IF EXISTS bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
    cid                  VARCHAR(50),
    bdate                DATE,
    gen                  VARCHAR(50)
);


-- Customer Location
DROP TABLE IF EXISTS bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
    cid                  VARCHAR(50),
    cntry                VARCHAR(50)
);


-- Product Category
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id                   VARCHAR(50),
    cat                  VARCHAR(50),
    subcat               VARCHAR(50),
    maintenance          VARCHAR(50)
);
