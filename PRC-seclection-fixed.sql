-- 4187 for 180 dayes -- approx 2 to 3 per day 
-- 3878 (where R=1) 
-- SETTINGS FOR EXPIRATION WARNINGS 

declare @status varchar(10) = 'Passed' 
declare @expiry_date datetime = dateadd(DAY,180, getdate())   -- EXPIRY DATE LIMIT 

;

with PRC_INFO as ( 
	select ROW_NUMBER() OVER(PARTITION BY cust.cst_key ORDER BY screen.z25_expiration_date DESC) as R
		, cust.cst_key as CUST_KEY
		, cust.cst_recno as MEMBER_NUMBER
		, screen.z25_expiration_date as EXP_DATE
		, screen.z25_key as PRC_KEY
	from 
		co_customer cust
			join client_scouts_external_volunteer_screening screen 
				on cust.cst_key = screen.z25_ind_cst_key 
	where screen.z25_type='PRC' 
		and screen.z25_expiration_date is not NULL 
) 

-- SELECT EXPIRING IN NEXT 180 days 
select distinct  z25_type, z25_expiration_date, cust.cst_recno, cust.cst_eml_address_dn, screen.z25_status

from PRC_INFO
	join co_customer cust on CUST_KEY = cust.cst_key
	join client_scouts_external_volunteer_screening screen on screen.z25_key = PRC_KEY
	join co_individual_ext ext on cust.cst_key = ext.ind_cst_key_ext 		
	join co_individual_x_organization role on role.ixo_ind_cst_key = cust.cst_key and role.ixo_end_date > getdate() 
	join co_individual_x_organization_ext roleExt on role.ixo_key = roleExt.ixo_key_ext and roleext.ixo_status_ext = 'Active'
where
	R=1 
	and ext.ind_status_ext in ('Active','Pending','Not-Renewed') 
	and (ext.ind_mbt_code_ext = 'Volunteer' or ind_mbt_code_ext = 'Employee') 
	and screen.z25_status = @status  
	and screen.z25_expiration_date < @expiry_date 
	and cust.cst_eml_address_dn IS NOT NULL
	and isnull(cust.cst_no_email_flag,0) = 0
	and isnull(ext.ind_do_not_contact_flag_ext,0) = 0
	and isnull(cust.cst_delete_flag,0) = 0
order by z25_expiration_date --desc		





-----
--- LIST ALL EXPIRED - BUT ACTIVE 
----
;

with PRC_INFO as ( 
	select ROW_NUMBER() OVER(PARTITION BY cust.cst_key ORDER BY screen.z25_expiration_date DESC) as R
		, cust.cst_key as CUST_KEY
		, cust.cst_recno as MEMBER_NUMBER
		, screen.z25_expiration_date as EXP_DATE
		, screen.z25_key as PRC_KEY
	from 
		co_customer cust
			join client_scouts_external_volunteer_screening screen 
				on cust.cst_key = screen.z25_ind_cst_key 
	where screen.z25_type='PRC' 
		and screen.z25_expiration_date is not NULL 
) 

-- SELECT EXPIRING IN NEXT 180 days 

select distinct  z25_type, z25_expiration_date, cust.cst_recno, cust.cst_eml_address_dn, screen.z25_status

from PRC_INFO 
	join co_customer cust on CUST_KEY = cust.cst_key
	join client_scouts_external_volunteer_screening screen on screen.z25_key = PRC_KEY
	join co_individual_ext ext on cust.cst_key = ext.ind_cst_key_ext 		
	join co_individual_x_organization role on role.ixo_ind_cst_key = cust.cst_key and role.ixo_end_date > getdate() 
	join co_individual_x_organization_ext roleExt on role.ixo_key = roleExt.ixo_key_ext and roleext.ixo_status_ext = 'Active'
where
	R=1  -- most recent PRC is on top of list  
	and ext.ind_status_ext in ('Active','Pending','Not-Renewed') 
	and (ext.ind_mbt_code_ext = 'Volunteer' or ind_mbt_code_ext = 'Employee') 
	and screen.z25_status =			'Expired' --** 
--	and screen.z25_expiration_date < getdate() --** 
	and cust.cst_eml_address_dn IS NOT NULL
	and isnull(cust.cst_no_email_flag,0) = 0
	and isnull(ext.ind_do_not_contact_flag_ext,0) = 0
	and isnull(cust.cst_delete_flag,0) = 0

