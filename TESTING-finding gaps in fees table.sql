--select dbo.client_scouts_find_missing_fees('2015','F7F9370D-11E4-44CD-960F-001B7C864E75') 


with missing_fees as ( 
select  dbo.client_scouts_find_missing_fees('2015', O.org_cst_key, getdate(), 10) as missing_day_count, o.org_name, o.org_cst_key
	from  co_organization as O 
	join co_organization_ext OE on o.org_cst_key = OE.org_cst_key_ext 
	where OE.org_status_ext = 'Active' 
	and O.org_ogt_code = 'Group'
	and org_allow_online_reg_flag_ext = 1 
	and org_delete_flag = 0 
	and dbo.client_scouts_find_missing_fees('2015', O.org_cst_key, getdate(), 10) > 0 
) 

select fxd.a03_from_date, fxd.a03_to_date, mf.org_name, mf.org_cst_key, missing_day_count
from client_scouts_org_fee_x_date fxd
join missing_fees mf on mf.org_cst_key = fxd.a03_org_cst_key
where fxd.a03_registration_year = '2016'
order by a03_org_cst_key, a03_from_date



----------------------------------------


--select dbo.client_scouts_find_missing_fees('2015','F7F9370D-11E4-44CD-960F-001B7C864E75') 

-- listing ROLES attached to the groups with missing FEES 

-- only Volunteer roles are included, but no Participant Roles -- this is good 

with missing_fees as ( 
select  dbo.client_scouts_find_missing_fees('2015', O.org_cst_key, getdate(), 100) as missing_day_count, o.org_name, o.org_cst_key
	from  co_organization as O 
	join co_organization_ext OE on o.org_cst_key = OE.org_cst_key_ext 
	where OE.org_status_ext = 'Active' 
	and O.org_ogt_code = 'Group'
	and org_allow_online_reg_flag_ext = 1 
	and org_delete_flag = 0 
	and dbo.client_scouts_find_missing_fees('2015', O.org_cst_key, getdate(), 100) > 0 
), 
reg_invoices as (
select reg.x13_inv_key, reg.x13_org_cst_key  from client_scouts_experimental_registration reg 
where  x13_type = '2016' 
and x13_inv_key is not NULL 
) 
, 
reg_roles as (
select reg.x13_inv_key, reg.x13_org_cst_key , i.ixo_start_date, e.ixo_status_ext, m.mbt_code
	from client_scouts_experimental_registration reg 
		join co_individual_x_organization i on  i.ixo_key = reg.x13_ixo_key 
		join co_individual_x_organization_ext e on i.ixo_key = e.ixo_key_ext
		join mb_member_type m on m.mbt_key = e.ixo_mbt_key_ext
where  x13_type = '2016' 
and x13_ixo_key is not NULL 
) 


select mf.org_name, mf.org_cst_key, missing_day_count, reg_roles.* 
--select fxd.a03_from_date, fxd.a03_to_date, mf.org_name, mf.org_cst_key, missing_day_count
from client_scouts_org_fee_x_date fxd
join missing_fees mf on mf.org_cst_key = fxd.a03_org_cst_key
join reg_roles on reg_roles.x13_org_cst_key = mf.org_cst_key 
where fxd.a03_registration_year = '2016'
--order by a03_org_cst_key, a03_from_date

/* 
select distinct mf.org_name, mf.org_cst_key, missing_day_count
--select fxd.a03_from_date, fxd.a03_to_date, mf.org_name, mf.org_cst_key, missing_day_count
from client_scouts_org_fee_x_date fxd
join missing_fees mf on mf.org_cst_key = fxd.a03_org_cst_key
join reg_invoices on reg_invoices.x13_org_cst_key = mf.org_cst_key 
where fxd.a03_registration_year = '2016'
--order by a03_org_cst_key, a03_from_date
*/