-- params from proc : 

declare	
	@org_cst_key uniqueidentifier,
	@all_child_org_flag_string varchar(max),
	@mb_status varchar(max) = 'Active,Pending,Not Renewed',
	@scouting_role varchar(max) = NULL,
	@primary_org_flag_string varchar(max) = 'All',
	@ind_cst_key uniqueidentifier = null

--- 

declare @mb_status_list varchar(100) = 'Active' 

set  @scouting_role = 'Volunteer' 
set  @org_cst_key  = '33220E44-D5AC-41BC-B99E-CC09CCFB6A0C' 

declare @org_hash_key varchar(100) = NULL 

-- alternate orgs - for testing 
set @org_cst_key = 'E87125F1-78AE-4C44-B4A3-39A406516C64' -- 1st exp gropup 


-- get org hash key -- to get all children orgs 
select @org_hash_key = org_hierarchy_hash_ext from co_organization_ext where org_cst_key_ext = @org_cst_key

-- decide if we include SUB GROUPS 
set @org_hash_key = @org_hash_key + '%'


-- select * from co_organization_ext where  org_cst_key_ext = '33220E44-D5AC-41BC-B99E-CC09CCFB6A0C' --  '-000010229O-000010231O-000010233O-000022426O-010078443O'

select org2.org_cst_key, org2.org_name as Name, org2ext.org_hierarchy_hash_ext, role.ixo_ind_cst_key , 

	sum(case when mbt.mbt_code='Volunteer' then 1 else 0 end) as Volunteer,    
	sum(case when mbt.mbt_code='Participant' then 1 else 0 end) as Participant,    
	sum(case when mbt.mbt_code='Employee' then 1 else 0 end) as Employee,    
	sum(case when mbt.mbt_code='Parent' then 1 else 0 end) as Parent,
	sum(case when mbt.mbt_code='Alumni' then 1 else 0 end) as Alumni,
	sum(case when mbt.mbt_code not in ('Parent','Participant','Volunteer','Employee','Alumni') then 1 else 0 end) as Other

from 

	co_organization(nolock) org1 -- top level org 
	inner join co_organization_ext (nolock) as org1ext on org1.org_cst_key = org1ext.org_cst_key_ext 
	-- all sub orgs if HASH includes % 
	inner join co_organization_ext (nolock) as org2ext on org2ext.org_hierarchy_hash_ext like @org_hash_key 
	inner join co_organization (nolock) as org2 on org2.org_cst_key = org2ext.org_cst_key_ext
	inner join co_customer (nolock) org2cst on org2cst.cst_key = org2ext.org_cst_key_ext 
	inner join co_individual_x_organization (nolock) role on role.ixo_org_cst_key = org2cst.cst_key -- all roles
	--inner join co_customer member on member.cst_ixo_key = role.ixo_key -- limits to Primary Role 
	inner join co_individual_x_organization_ext roleext on roleext.ixo_key_ext = role.ixo_key 
	inner join mb_member_type mbt on roleext.ixo_mbt_key_ext = mbt.mbt_key 
	
where 

	org1.org_cst_key = @org_cst_key			 -- user selected 
	and roleext.ixo_status_ext in ('Active') -- user selected 

	and org2ext.org_status_ext = 'Active' -- system 
	and GETDATE()  between role.ixo_start_date and role.ixo_end_date -- to ignore NEXT Years roles 

group by org2.org_cst_key, org2.org_name, org2ext.org_hierarchy_hash_ext , role.ixo_ind_cst_key 

order by org2ext.org_hierarchy_hash_ext
	

/*	
	inner join co_individual_x_organization (nolock) ixo on ixo.ixo_org_cst_key = C.cst_ixo_key -- Primary roles
	inner join co_individual_x_organization_ext (nolock) ixoext on ixo.ixo_key = ixoext.ixo_key_ext 
 	inner join co_individual_ext (nolock) indext on C.cst_key = indext.ind_cst_key_ext 
 	inner join mb_member_type (nolock) on ixoext.ixo_mbt_key_ext = mbt_key 
 WHERE 

  ind_mbt_code_ext = 'Volunteer' 
  and (ixo_rlt_code = @scouting_role OR @scouting_role is null) 
  and ((ind_confidential_status_ext IS Null) OR (ind_confidential_status_ext = 'N/A' )) 
  AND (ind_suspended_flag_ext = 0 OR ind_suspended_flag_ext IS NULL) 
  
	and org1.org_delete_flag = 0 
	and org1ext.org_inactive_flag_ext = 0  
	and org1.org_cst_key = @org_cst_key  
	
order by org1ext.org_hierarchy_hash_ext asc
 
 */


--select * from co_organization where org_name like '1st exp%'
