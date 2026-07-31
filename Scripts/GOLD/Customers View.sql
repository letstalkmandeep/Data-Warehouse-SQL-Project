-- CREATE VIEW Customers

create view gold.dim_customers as
select
	row_number() over(order by e.cntry) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	e.cntry as country,
	ci.cst_marital_status as marital_status,
	case
		when ci.cst_gndr != 'N/A' then ci.cst_gndr
		else coalesce(ca.gen,'N/A')
	end as gender,
	ca.bdate as birth_date,
	ci.cst_create_date as created_date
from silver.crm_cst_info as ci
left join silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 as e
on ci.cst_key = e.cid
;