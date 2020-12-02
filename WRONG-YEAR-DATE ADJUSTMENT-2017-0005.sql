--- 1 --- TEST LIST OF DATA 
--- IFFFF OK -- same select used below -- but selects just IXO_KEY !!!
-- 1111111111111111111

select cst_key, ixo.ixo_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type,
	ixo.ixo_start_date sd, ixo.ixo_end_date, x13_source
	, x13_progress,ixo_rlt_code,ixo_add_user, x13_add_date --, *
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key

	join ac_invoice on inv_key = x13_inv_key 
	
where xr.x13_add_date > '2016-05-02 00:00:00'
and x13_type='2017' and ixo_start_date < '2016-08-31 23:59:59'
and ixo_status_ext = 'Active'
and ixo_delete_flag = 0 
and inv_delete_flag = 0 

order by x13_add_date

-->>> 
-->>> THIS IS THE ET TO BE FIXED -- WHERE 2nd IXO is still NULL -- ie - reg'd and payed for next year - but role is in last year !!!
-->>>
-- 11111 BBBBBBBBBBBB
-- look for same role in proper year (but not on this reg record) -- maybe added manually - or another reg ? ? 

select ixo.ixo_add_date, ixo.ixo_org_cst_key , ixo.ixo_ind_cst_key, ixo.ixo_start_date , ixo.ixo_end_date, 
		ixo2.ixo_org_cst_key , ixo2.ixo_ind_cst_key, ixo2.ixo_start_date , ixo2.ixo_end_date, ixo2.* 

from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
	
	join ac_invoice on inv_key = x13_inv_key 

left outer join co_individual_x_organization IXO2 on ixo2.ixo_org_cst_key = ixo.ixo_org_cst_key  and ixo2.ixo_ind_cst_key = ixo.ixo_ind_cst_key AND ixo2.ixo_start_date > '2016-08-31'

where xr.x13_add_date > '2016-05-02 00:00:00'
and x13_type='2017' and ixo.ixo_start_date < '2016-08-31 23:59:59'
and ixo_status_ext = 'Active'
and ixo.ixo_delete_flag = 0 
and ixo2.ixo_key is NULL 

and inv_delete_flag = 0 

order by ixo2.ixo_start_date, x13_add_date


/* 2222222222222222222
check invoices 
* 
-- OLD 
select d.* 
from client_scouts_experimental_registration
join ac_invoice on x13_inv_key = inv_key 
join ac_invoice_detail d on d.ivd_inv_key = inv_key 
where  x13_ixo_key in (
	select ixo.ixo_key
	from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
	where xr.x13_add_date > '2016-05-02 00:00:00'
	and x13_type='2017' and ixo_start_date < '2016-08-31 23:59:59'
	and ixo_status_ext = 'Active'
	)
	
and ivd_prc_key = 'F24C18AB-E143-4DB4-B694-112C77385E46'
order by ivd_price 

------------

-- NEW 

select d.* 
from client_scouts_experimental_registration
join ac_invoice on x13_inv_key = inv_key 
join ac_invoice_detail d on d.ivd_inv_key = inv_key 

where  x13_ixo_key in (
	select ixo.ixo_key
	from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key

	left outer join co_individual_x_organization IXO2 on ixo2.ixo_org_cst_key = ixo.ixo_org_cst_key  and ixo2.ixo_ind_cst_key = ixo.ixo_ind_cst_key AND ixo2.ixo_start_date > '2016-08-31'

	where xr.x13_add_date > '2016-06-14 00:00:00'
	and x13_type='2017' and ixo.ixo_start_date < '2016-08-31 23:59:59'
	and ixo_status_ext = 'Active'
	and ixo.ixo_delete_flag = 0 
	and ixo2.ixo_key is NULL 
)
	
and ivd_prc_key = 'F24C18AB-E143-4DB4-B694-112C77385E46'
order by ivd_price 


*
*/ 

/* DISPLAY START & END DATES 
==========================================================
-- 333333333333333333333333333333

select ixo_start_date , ixo_end_date 
from  co_individual_x_organization 
where  ixo_key in (
	select ixo.ixo_key
	from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key
	where xr.x13_add_date > '2016-06-14 00:00:00'
	and x13_type='2017' and ixo_start_date < '2016-08-31 23:59:59'
	and ixo_status_ext = 'Active'
	and ixo_delete_flag = 0 
	)
order by ixo_end_date 

*/

/* 

-- 4444444444444444444444444444444444444444

begin  transaction 

update co_individual_x_organization 
set ixo_start_date = '2016-09-01' , ixo_end_date = '2017-08-31'
where  ixo_key in (

-- seee 111111 BBBBBBBBBBBBBB

	select ixo.ixo_key

	from client_scouts_experimental_registration xr 
		join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
		join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
		join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key

		join ac_invoice on inv_key = x13_inv_key 
		
	left outer join co_individual_x_organization IXO2 on ixo2.ixo_org_cst_key = ixo.ixo_org_cst_key  and ixo2.ixo_ind_cst_key = ixo.ixo_ind_cst_key AND ixo2.ixo_start_date > '2016-08-31'

	where xr.x13_add_date > '2016-06-14 00:00:00'
	and x13_type='2017' and ixo.ixo_start_date < '2016-08-31 23:59:59'
	and ixo_status_ext = 'Active'
	and ixo2.ixo_key is NULL 
	and inv_delete_flag=0 
	
)




*/

-- commit 
-- rollback 
