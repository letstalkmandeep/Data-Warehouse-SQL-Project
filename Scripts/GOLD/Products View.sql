create view gold.dim_products as 
SELECT
	row_number() over(order by pi.prd_id) as product_key,
	pi.prd_id as product_id,
	pi.sls_prd_key as product_number,
	pi.prd_nm as product_name,
	pi.cat_id as category_id,
	px.cat as category,
	px.subcat subcategory,
	px.maintenance as maintenance,
	pi.prd_cost as cost,
	pi.prd_line as product_line,
	pi.prd_start_dt as start_date
FROM silver.crm_prd_info as pi
left join silver.erp_px_cat_g1v2 as px
on pi.cat_id = px.id
where pi.prd_end_dt is null  -- filtering out all historical data
;