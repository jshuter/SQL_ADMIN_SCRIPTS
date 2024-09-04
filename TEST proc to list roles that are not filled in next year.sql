
declare @ind_cst_key as uniqueidentifier 
select  @ind_cst_key = cst_key  from co_customer where cst_eml_address_dn like 'jeffrey.shuter%' 
select @ind_cst_key = 'ACB67021-AFCE-4349-B23A-3E90EAA9ABDC'

; 

WITH section_info  as ( 

	select 
		current_roles.ixo_org_cst_key AS 'TY_section_key',
		current_org.org_name as 'TY_section_name', 
		current_roles.ixo_start_date as 'TY_start_date',
		current_org_cst.cst_parent_cst_key as 'TY_section_parent_key' , 
		next_org_cst.cst_parent_cst_key as 'NY_parent_key' , 
		next_roles.ixo_start_date as 'NY_start_date'

		-- ,current_org.*
		--, next_org.*

	from co_customer cst -- limited to 1 MEMBER in where 
	
		-- IXO FOR CURRENT YEAR 
		join co_individual_x_organization current_roles -- get all roles in CURRENT YEAR
			on current_roles.ixo_ind_cst_key = cst.cst_key 
				and current_roles.ixo_start_date between (select scouting_start_date from dbo.client_scouts_get_scouting_date_range()) 
															AND (select scouting_start_date from dbo.client_scouts_get_scouting_date_range())  
			join co_individual_x_organization_ext current_roles_ext on current_roles.ixo_key = current_roles_ext.ixo_key_ext
		
		join co_customer as current_org_cst 		on current_org_cst.cst_key = current_roles.ixo_org_cst_key 
		join co_organization as current_org 		on current_org.org_cst_key = current_roles.ixo_org_cst_key 
		join mb_member_type as mbt 
			on mbt.mbt_key = current_roles_ext.ixo_mbt_key_ext

		-- AND LINK TO NEXT YEAR -- IF EXISTS 		
		left outer join co_individual_x_organization next_roles 
			on next_roles.ixo_ind_cst_key = cst.cst_key 
				and next_roles.ixo_start_date > (select scouting_end_date from dbo.client_scouts_get_scouting_date_range())



		left outer join co_individual_x_organization next_roles_ext on next_roles.ixo_key = next_roles_ext.ixo_key
		left outer join co_customer as next_org_cst on next_org_cst.cst_key = next_roles.ixo_org_cst_key

	where cst.cst_key = @ind_cst_key 

		and current_org.org_ogt_code = 'Section'
		and current_roles.ixo_end_date < '2016-09-01'
		and current_roles_ext.ixo_status_ext = 'Active' -- ignore Pending and Not-Renewed
		and mbt.mbt_code = 'Participant' 
		and (next_roles.ixo_end_date >= '2016-09-01' or next_roles.ixo_end_date is null) 
		and ( (next_org_cst.cst_parent_cst_key = current_org_cst.cst_parent_cst_key) or (next_org_cst.cst_parent_cst_key is NULL)) 

		and current_roles.ixo_delete_flag = 0 
		and ISNULL(next_roles.ixo_delete_flag, 0) = 0

	) 
	
	select * from section_info


/* 
CANNOT DO !	outer apply 

may need to do separate call for each active Section within same group !

select * from (client_scouts_confirm_valid_registration_potential_xweb   
		@org_cst_key = 'DFC2F827-CAFB-4E86-97BB-07D816FEB46B'	-- orgKey 
		, @year = 'yes'											-- year (canRenew ?)	
		, @isRegistrar = '0'									-- isReg ? 
		, @xml=0 -- FORMAT										-- 1=xml 0=table 
		) as x
		
*/	

	
/* 
select * from co_individual_x_organization where ixo_ind_cst_key = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D'

begin transaction 
update co_individual_x_organization
set ixo_end_date = '2017-08-31' 
,ixo_start_date = '2016-09-01' 
, ixo_delete_flag=0
where ixo_key = 'EFB45BA0-B3AD-465C-AFEB-BB01785FD01D' 
commit 

sp_help co_individual_x_organization
*/