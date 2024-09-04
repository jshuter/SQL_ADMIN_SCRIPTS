/* 
-- MUST LIMIT BY CST_KEY !!!!
with 
Groups as ( 
	select distinct cst_parent_cst_key, ixo_ind_cst_key 
		from co_individual_x_organization
		join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
		join co_organization on org_cst_key = ixo_org_cst_key 	
		join co_customer on cst_key = ixo_org_cst_key 
		where ixo_start_date >= (select scouting_start_date from dbo.client_scouts_get_scouting_date_range())
		and ixo_delete_flag = 0 
	)
select top 100 * from Groups 
where ixo_ind_cst_key = '5920CACD-5EA7-43D3-8149-5B9DE07AE0FD' 
*/


-- TESTING WITH CST 5920CACD-5EA7-43D3-8149-5B9DE07AE0FD

select cst_parent_cst_key, ixo_ind_cst_key , ixo_start_date, ixo_status_ext , 
	case 
		when (ixo_start_date > (select scouting_start_date from dbo.client_scouts_get_scouting_date_range())) 
		then 'CurrentYear' 
		else 'NextYear'
		end
	from co_individual_x_organization
		join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
		join co_organization on org_cst_key = ixo_org_cst_key 	
		join co_customer on cst_key = ixo_org_cst_key 
	where ixo_start_date >= (select scouting_start_date from dbo.client_scouts_get_scouting_date_range())
		and ixo_delete_flag = 0 
and ixo_ind_cst_key = '5920CACD-5EA7-43D3-8149-5B9DE07AE0FD' 



