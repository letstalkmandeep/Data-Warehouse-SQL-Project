/*==============================================================================
  Script Name : Silver Layer - Data Load Procedure
  Object      : silver.load_silver()
  Layer       : Silver

  Purpose:
  Load, cleanse, standardize, and transform raw data from the Bronze layer
  into the Silver layer of the Data Warehouse.

  Description:
  This procedure performs the following operations:

  1. Records the procedure start time and execution duration.
  2. Displays execution progress using RAISE NOTICE.
  3. Truncates all Silver tables before loading fresh data.
  4. Cleans and standardizes CRM data:
       • Removes duplicate customer records.
       • Trims leading/trailing spaces.
       • Standardizes marital status and gender values.
       • Splits product keys into Category ID and Sales Product Key.
       • Replaces NULL product costs with 0.
       • Converts product line codes into descriptive values.
       • Calculates product end dates using LEAD().
       • Converts integer date fields into DATE.
       • Validates sales amounts and prices.
  5. Cleans and standardizes ERP data:
       • Removes unwanted customer ID prefixes.
       • Validates future birth dates.
       • Standardizes gender values.
       • Cleans customer IDs.
       • Converts country codes into country names.
       • Removes unnecessary whitespace from category fields.
  6. Loads the transformed data into the Silver tables.
  7. Displays execution completion messages and total runtime.

  Source Layer:
      • Bronze

  Target Layer:
      • Silver

  Tables Loaded:
      CRM
      - silver.crm_cst_info
      - silver.crm_prd_info
      - silver.crm_sales_details

      ERP
      - silver.erp_cust_az12
      - silver.erp_loc_a101
      - silver.erp_px_cat_g1v2

  Notes:
      • Existing data is removed using TRUNCATE before every load.
      • This procedure performs data quality checks and business rule
        transformations before loading into the Silver layer.
      • The Silver layer serves as the foundation for the Gold layer.
==============================================================================*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
	start_time timestamp;
	end_time timestamp;
BEGIN
	start_time:= clock_timestamp();
	RAISE NOTICE 'STARTED AT: %',start_time;
	RAISE NOTICE '=========================================================';
	RAISE NOTICE '--------------------LOADING CRM TABLES-------------------';
	RAISE NOTICE '=========================================================';
	RAISE NOTICE '           >>>>>TRUNCAING - TABLE CST_INFO<<<<<          ';
	
	truncate table silver.crm_cst_info; 
	
	RAISE NOTICE '            >>>>>LOADING - TABLE CST_INFO<<<<<<<         ';
	
	insert into silver.crm_cst_info
	select
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case cst_marital_status
		when 'M' then 'Married'
		when 'S' then 'Single'
		else 'N/A'
		end as cst_marital_status,
		Case cst_gndr
		when 'M' then 'Male'
		when 'F' then 'Female'
		else 'N/A'
		end as cst_gndr,
		cst_create_date
	from (
		select 
		*,
		row_number() over(partition by cst_id order by cst_create_date desc) as latest
		from bronze.crm_cst_info
	)
	where latest = 1;
	
	
	
	-- Table 2
				 	
	RAISE NOTICE '---------------------------------------------------------';
	RAISE NOTICE '          >>>>>TRUNCAING - TABLE PRD_INFO<<<<<           ';

	TRUNCATE TABLE silver.crm_prd_info;
	
	RAISE NOTICE '          >>>>>LOADING - TABLE PRD_INFO<<<<<<<           ';

	
	insert into silver.crm_prd_info
	select
		prd_id,
		prd_key,
		replace(left(prd_key,5),'-','_') as Cat_id,
		substring(prd_key,7,length(prd_key)) as sls_prd_key,
		prd_nm,
		coalesce(prd_cost,0) as prd_cost,
		case upper(trim(prd_line))
			when 'M' then 'Mountain'
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'T' then 'Touring'
			else 'N/A'
		end as prd_line,
		prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - interval '1 day' as date) as prd_end_dt
	from bronze.crm_prd_info
	order by prd_id asc
	;
	
	-- Table 3

	RAISE NOTICE '---------------------------------------------------------';
	RAISE NOTICE '        >>>>>TRUNCAING - TABLE SALES_DEATILS<<<<<        ';

	TRUNCATE TABLE silver.crm_sales_details;
	
	RAISE NOTICE '        >>>>>LOADING - TABLE SALES_DETAILS<<<<<<<        ';
	
	insert into silver.crm_sales_details
	select
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case 
			when sls_order_dt = 0 then null
			when sls_order_dt < 20101229 then null
			else cast(cast(sls_order_dt as varchar) as date) 
			end as sls_order_dt,
		cast(cast(sls_ship_dt as varchar) as date) as sls_ship_dt,
		cast(cast(sls_due_dt as varchar) as date) as sls_due_dt,
		case 
			when coalesce(abs(sls_sales),0) != sls_quantity*sls_price then abs(sls_quantity*sls_price)
			else coalesce(abs(sls_sales),0) end as sls_sales,
		sls_quantity,
		case
			when sls_price is null then sls_sales/sls_quantity
			else abs(sls_price)
		end as sls_price
	from bronze.crm_sales_details
	;
	
	
	
	-- Table 4

	RAISE NOTICE '=========================================================';
	RAISE NOTICE '------------------LOADING ERP TABLES---------------------';
	RAISE NOTICE '=========================================================';
	RAISE NOTICE '---------------------------------------------------------';
	RAISE NOTICE '        >>>>>TRUNCAING - TABLE CUST_AZ12<<<<<            ';

	TRUNCATE TABLE silver.ERP_CUST_AZ12;
	
	RAISE NOTICE '         >>>>>LOADING - TABLE CUST_AZ12<<<<<<<           ';
	
	insert into silver.erp_cust_az12
	select
		case when cid like 'NAS%' then substring(cid,4,length(cid))
		else cid end as cid,
		case when bdate > cast(current_timestamp as date) then null
		else bdate end as bdate,
		case 
			when trim(gen) = 'M' then 'Male'
			when trim(gen) = 'F' then 'Female'
			when trim(gen) = '' then 'N/A'
			when gen is null then 'N/A'
			else trim(gen)
		end as gen
	from bronze.erp_cust_az12;
	
	-- Table 5

	RAISE NOTICE '---------------------------------------------------------';
	RAISE NOTICE '         >>>>>TRUNCAING - TABLE LOC_A101<<<<<            ';

	TRUNCATE TABLE silver.ERP_LOC_A101;
	
	RAISE NOTICE '         >>>>>LOADING - TABLE LOC_A101<<<<<<<            ';
	
	insert into silver.erp_loc_a101
	select
		replace(cid,'-','') as cid,
		case trim(cntry)
			when 'US' then 'United States'
			when 'USA' then 'United States'
			when 'DE' then 'Germany'
			when '' then 'N/A'
			else coalesce(trim(cntry),'N/A')
		end as cntry
	from bronze.erp_loc_a101;
	
	-- Table 6
	
	RAISE NOTICE '---------------------------------------------------------';
	RAISE NOTICE '          >>>>>TRUNCAING - TABLE PX_CAT_G1V2<<<<<        ';

	TRUNCATE TABLE silver.ERP_PX_CAT_G1V2;
	
	RAISE NOTICE '          >>>>>LOADING - TABLE PX_CAT_G1V2<<<<<<<        ';
	
	insert into silver.erp_px_cat_g1v2
	select
		id,
		trim(cat) as cat,
		trim(subcat) as subcat,
		maintenance
	from bronze.erp_px_cat_g1v2;

	RAISE NOTICE '============================================================';
	RAISE NOTICE '---------- SUCCESSFULLY LOADED CRM & ERP TABLES ------------';
	RAISE NOTICE '============================================================';
	end_time:= clock_timestamp();
	RAISE NOTICE 'ENDED AT: %',end_time;
	RAISE NOTICE 'TOTAL DIRATION: %', end_time - start_time;

END;
$$;
