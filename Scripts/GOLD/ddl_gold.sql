/*==============================================================================
  Script Name : Gold Layer - Dimension & Fact Views
  Layer       : Gold

  Purpose:
  Create business-ready analytical views for reporting, dashboards,
  and business intelligence by transforming the Silver layer into a
  dimensional model.

  Description:
  This script performs the following tasks:

  1. Drops existing Gold views (if they exist) to allow clean recreation.
  2. Creates the Customer Dimension (dim_customers) by:
       • Combining CRM and ERP customer data.
       • Generating a surrogate customer key.
       • Enriching customer records with country, gender, and birth date.
       • Applying business rules for gender standardization.
  3. Creates the Product Dimension (dim_products) by:
       • Combining CRM product data with ERP product categories.
       • Generating a surrogate product key.
       • Mapping category and subcategory information.
       • Returning only active/current products.
  4. Creates the Sales Fact (fact_sales) by:
       • Linking sales transactions with customer and product dimensions.
       • Producing a star schema for analytical reporting.
       • Including sales measures such as sales amount, quantity, and price.

  Source Layer:
      • Silver

  Target Layer:
      • Gold

  Objects Created:
      Dimensions
      - gold.dim_customers
      - gold.dim_products

      Fact
      - gold.fact_sales

  Notes:
      • Surrogate keys are generated using ROW_NUMBER().
      • LEFT JOINs preserve transactional data even when matching
        dimension records are unavailable.
      • The Gold layer is optimized for BI tools, dashboards,
        reporting, and business analysis.
==============================================================================*/


/*==============================================================================
    DROP EXISTING GOLD VIEWS
==============================================================================*/

DROP VIEW IF EXISTS gold.fact_sales;
DROP VIEW IF EXISTS gold.dim_products;
DROP VIEW IF EXISTS gold.dim_customers;



/*==============================================================================
    CUSTOMER DIMENSION
==============================================================================*/

CREATE VIEW gold.dim_customers AS

SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id                              AS customer_id,
    ci.cst_key                             AS customer_number,
    ci.cst_firstname                       AS first_name,
    ci.cst_lastname                        AS last_name,
    e.cntry                                AS country,
    ci.cst_marital_status                  AS marital_status,

    CASE
        WHEN ci.cst_gndr <> 'N/A' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'N/A')
    END                                    AS gender,

    ca.bdate                               AS birth_date,
    ci.cst_create_date                     AS created_date

FROM silver.crm_cst_info AS ci

LEFT JOIN silver.erp_cust_az12 AS ca
       ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 AS e
       ON ci.cst_key = e.cid;



/*==============================================================================
    PRODUCT DIMENSION
==============================================================================*/

CREATE VIEW gold.dim_products AS

SELECT
    ROW_NUMBER() OVER (ORDER BY pi.prd_id) AS product_key,
    pi.prd_id                              AS product_id,
    pi.sls_prd_key                         AS product_number,
    pi.prd_nm                              AS product_name,
    pi.cat_id                              AS category_id,
    px.cat                                 AS category,
    px.subcat                              AS subcategory,
    px.maintenance                         AS maintenance,
    pi.prd_cost                            AS cost,
    pi.prd_line                            AS product_line,
    pi.prd_start_dt                        AS start_date

FROM silver.crm_prd_info AS pi

LEFT JOIN silver.erp_px_cat_g1v2 AS px
       ON pi.cat_id = px.id

WHERE pi.prd_end_dt IS NULL;   -- Keep only active products



/*==============================================================================
    SALES FACT
==============================================================================*/

CREATE VIEW gold.fact_sales AS

SELECT
    s.sls_ord_num                          AS order_number,
    p.product_key,
    c.customer_key,
    s.sls_order_dt                         AS order_date,
    s.sls_ship_dt                          AS shipping_date,
    s.sls_due_dt                           AS due_date,
    s.sls_sales                            AS sales_amount,
    s.sls_quantity                         AS quantity,
    s.sls_price                            AS price

FROM silver.crm_sales_details AS s

LEFT JOIN gold.dim_customers AS c
       ON s.sls_cust_id = c.customer_id

LEFT JOIN gold.dim_products AS p
       ON s.sls_prd_key = p.product_number;
