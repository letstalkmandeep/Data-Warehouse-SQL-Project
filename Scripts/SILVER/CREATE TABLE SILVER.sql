-- CREATE TABLE CRM
-- CRM_cst_info

DROP TABLE if exists silver.crm_cst_info; 
create table silver.crm_cst_info (
	cst_id	int	,
	cst_key	varchar(50),	
	cst_firstname	varchar(50),		
	cst_lastname	varchar(50),		
	cst_marital_status	varchar(50),		
	cst_gndr	varchar(50),		
	cst_create_date	date,
	dwh_created_date timestamp default current_timestamp
);


-- pro_info

DROP TABLE if exists silver.crm_prd_info;
create table silver.crm_prd_info (
	prd_id	int	,
	prd_key	varchar(50),
	cat_id varchar(50),
	sls_prd_key varchar(50),
	prd_nm	varchar(50),		
	prd_cost	int,		
	prd_line	varchar(50),		
	prd_start_dt	date,		
	prd_end_dt	date,	
	dwh_created_date timestamp default current_timestamp
);



-- sales.details

DROP TABLE if exists silver.crm_sales_details;
create table silver.crm_sales_details(
	sls_ord_num	varchar(50)	,
	sls_prd_key	varchar(50),
	sls_cust_id	int,		
	sls_order_dt	date,		
	sls_ship_dt	date,		
	sls_due_dt	date,		
	sls_sales	int,		
	sls_quantity	int,		
	sls_price	int	,	
	dwh_created_date timestamp default current_timestamp
);

-- Create Table Erp
-- Cust_AZ12

DROP TABLE if exists silver.erp_cust_az12;
create table silver.erp_cust_az12 (
	CID	varchar(50)	,
	BDATE	date,		
	GEN	varchar(50),
	dwh_created_date timestamp default current_timestamp
);

-- LOC_A101

DROP TABLE if exists silver.erp_loc_a101;
create table silver.erp_LOC_A101 (
	CID varchar(50) ,
	CNTRY varchar(50),
	dwh_created_date timestamp default current_timestamp
);


-- PX_CAT_G1V2	

DROP TABLE if exists silver.erp_px_cat_g1v2;
create table silver.erp_PX_CAT_G1V2 (
	ID	varchar(50),
	CAT	varchar(50),
	SUBCAT	varchar(50),
	MAINTENANCE	varchar(50),
	dwh_created_date timestamp default current_timestamp
);

