

-- FORM TITLE : Volunteer Screening Checklist   (displays as screening checklist) 
-- FORM DESCR : Volunteer Screening


select top 10 * from co_customer 
where cst_eml_address_dn like'jeffrey.shuter%'

select cst_key, cst_eml_address_dn
 from co_customer 
where cst_eml_address_dn like'anthony%'

-- me
exec client_scouts_get_ind_access '3E634364-A0C9-4A01-9581-51144777B2CB'

-- anthony slade 
--select top 10 * from co_customer where cst_eml_address_dn like'anthon%slade%'

exec client_scouts_get_ind_access  'E994D9BB-917E-4381-B67A-A28E0C7A4DBF'

---
select * from client_scouts_role_x_forms 
order by a21_rlt_code 


select * from client_scouts_role_x_forms 
where a21_dyn_key = '6972857c-e1f0-4e22-beb3-6fc1da9b4e08'
order by a21_rlt_code 


select * from client_scouts_role_x_forms 
where a21_rlt_code='Chief Commissioner' 
order by a21_rlt_code 


select * from client_scouts_role_x_forms 
where a21_rlt_code='Deputy Area Commissioner' 
order by a21_rlt_code 



---- This is the hierarchy of roles ... for a particular user 

declare @ind_cst_key varchar(100) = 'E994D9BB-917E-4381-B67A-A28E0C7A4DBF'
declare @today datetime
set @today = getdate()
	
if exists(
		select ind_cst_key_ext from co_individual_ext (nolock)
		where 	ind_cst_key_ext = @ind_cst_key 
			and	ind_status_ext = 'active'
		)
begin

select ixo_rlt_code
from
	co_individual_x_organization (nolock) 
	inner join	co_individual_x_organization_ext(nolock) on	ixo_key = ixo_key_ext
	where
		ixo_delete_flag = 0 and
		(ixo_status_ext = 'Active' AND 
			(ixo_end_date is null or ixo_end_date >= @today) 
			and	( (ixo_ind_cst_key = @ind_cst_key) 
				or (ixo_ind_cst_key 
					in (select ind_cst_key
							from co_customer_x_customer 
								join co_individual  on cxc_cst_key_2=ind_cst_key
							where (((cxc_cst_key_1= @ind_cst_key) 
								and  cxc_rlt_code2 = 'Child') 
								and ind_age_cp < 18))  
					)
				)
			)

end 



SELECT * FROM DBO