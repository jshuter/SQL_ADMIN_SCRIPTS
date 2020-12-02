---=========================================================================================================
-- *** THE MAIN PROBLEMS ARE LISTED HERE 
-- *****************************************
-- 91 problems 
-- 101 problems -- (from May 4) 
-- First fix made soon after Pauls email of May 22

-- 81 New issues since May 22
 -- 79 distinct members 
 
 -- JUNE 18 th - 
 
select ixo2.ixo_start_date, cst_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type,
	ixo.ixo_start_date sd, ixo.ixo_end_date, x13_source
	, x13_progress, ixo.ixo_rlt_code,ixo.ixo_add_user, x13_add_date --, *
--	, inv.inv_trx_date   
--select distinct cst_recno 
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
	join ac_invoice on x13_inv_key = inv_key 
	-- next years OR NULL 
	left outer join co_individual_x_organization ixo2 on ixo.ixo_ind_cst_key = ixo2.ixo_ind_cst_key 
		and ixo.ixo_org_cst_key = ixo2.ixo_org_cst_key and ixo2.ixo_start_date > '2016-08-31'
				
where xr.x13_add_date > '2016-05-01 19:00:00'
and x13_type='2017' 
and ixo.ixo_start_date < '2016-08-31 23:59:59'
and ixo_status_ext = 'Active'
and inv_delete_flag = 0 
and ixo.ixo_delete_flag = 0 

order by x13_add_date

---==================================

/** Good ones */

select 
ixo.ixo_start_date start_date, ixo.ixo_end_date, x13_source
	, x13_progress,ixo_rlt_code,ixo_add_user, x13_add_date
cst_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type
	 --, *
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key

where xr.x13_add_date > '2016-05-01 00:00:00'
and x13_type='2017' 
and ixo_start_date > '2016-08-31'
and ixo_status_ext = 'Active'
order by x13_add_date



--- REG STATS 
select 
count(*), cast(x13_add_date AS DATE) AS XD
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key

where xr.x13_add_date > '2016-05-01 00:00:00'
and x13_type='2017' 
and ixo_start_date > '2016-08-31'
and ixo_status_ext = 'Active'
group by cast(x13_add_date AS DATE)  
order by XD




