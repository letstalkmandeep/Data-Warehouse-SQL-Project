CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
	start_time timestamp;
	end_time timestamp;
BEGIN
	start_time := clock_timestamp();
	RAISE NOTICE 'STARTED AT : %', start_time;
	RAISE NOTICE '===============================';
	RAISE NOTICE '------LOADING CRM TABLES-------';
	-- insert crm
	
	truncate table bronze.crm_cst_info; 
	copy bronze.crm_cst_info
	FROM 'C:\Temp\source_crm\cust_info.csv'
	DELIMITER ','
	CSV HEADER;
	
	truncate table bronze.crm_prd_info;
	copy bronze.crm_prd_info
	FROM 'C:\Temp\source_crm\prd_info.csv'
	DELIMITER ','
	CSV HEADER;
	
	truncate table bronze.crm_sales_details;
	copy bronze.crm_sales_details
	FROM 'C:\Temp\source_crm\sales_details.csv'
	DELIMITER ','
	CSV HEADER;

	RAISE NOTICE '===============================';
	RAISE NOTICE '------LOADED CRM TABLES-------';
	RAISE NOTICE '===============================';
	RAISE NOTICE '-----------------------------------------------------------';
	RAISE NOTICE '===============================';
	RAISE NOTICE '------LOADING ERP TABLES-------';
	
	
	-- ERP
	
	
	truncate table bronze.erp_cust_az12;
	copy bronze.erp_cust_az12
	FROM 'C:\Temp\source_erp\CUST_AZ12.csv'
	DELIMITER ','
	CSV HEADER;
	
	truncate table bronze.erp_loc_a101;
	copy bronze.erp_loc_a101
	FROM 'C:\Temp\source_erp\LOC_A101.csv'
	DELIMITER ','
	CSV HEADER;
	
	truncate table bronze.erp_px_cat_g1v2;
	copy bronze.erp_px_cat_g1v2
	FROM 'C:\Temp\source_erp\px_cat_g1v2.csv'
	DELIMITER ','
	CSV HEADER;

	RAISE NOTICE '===============================';
	RAISE NOTICE '------LOADED ERP TABLES-------';
	RAISE NOTICE '===============================';
	RAISE NOTICE '------------------------QUERY COMPLETED----------------------------';
	end_time:= clock_timestamp();
	RAISE NOTICE 'ENDED AT : %', end_time;
	RAISE NOTICE 'TOTAL DURATION : %', end_time - start_time;

END;
$$;
