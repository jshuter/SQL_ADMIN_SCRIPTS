/* 

exec [client_scouts_show_family_dropdown_xWeb] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D','F1B702C8-59CE-4F48-BF72-E26A1FD6565A'
exec [client_scouts_show_family_dropdown_xWeb] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D','6783A9D4-E81A-497A-8284-5D40E7B1342F'
exec [client_scouts_show_family_dropdown_xWeb] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D','63641B47-468D-490E-8E97-2B60DBFAAABE'
exec [client_scouts_show_family_dropdown_xWeb] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D','DFC2F827-CAFB-4E86-97BB-07D816FEB46B'
exec [client_scouts_show_family_dropdown_xWeb] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D','725A3F0F-92E3-4B30-AF8B-4FCD308DBC95'

*/


-- each IXO is a unique KEY - so these are valid ROLES 

-- MINE 

SELECT cxc.cxc_key, ixoe.ixo_key_ext,  section_cst.cst_key, group_org.org_name, group_org.org_cst_key, cxc.cxc_key, cxc.cxc_rlt_code2 AS relationship

FROM     co_customer_x_customer AS cxc

			INNER JOIN co_individual_x_organization AS ixo ON ixo.ixo_ind_cst_key = cxc.cxc_cst_key_2 -- All IXO's of other ind key
			join co_individual_x_organization_ext ixoe on ixoe.ixo_key_ext = ixo_key 
			INNER JOIN co_customer AS section_cst ON ixo.ixo_org_cst_key = section_cst.cst_key  -- Section of the IXO's 
			INNER JOIN co_organization AS group_org ON group_org.org_cst_key = section_cst.cst_parent_cst_key

WHERE     (cxc.cxc_cst_key_1 = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D') -- my children in key_2
			AND (group_org.org_cst_key = '8BE1B123-E3C1-4FCA-863E-F2A1557D6D7A') -- 
			AND (ixo.ixo_start_date < GETDATE()) 
			AND (ixo.ixo_end_date > GETDATE()) 
			AND (ixo.ixo_delete_flag = 0)   
			AND ixoe.ixo_status_ext = 'Active' 
			
order by cxc.cxc_key

-- OLD 
/* 
select * from (

		select * from co_customer_x_customer as cxc
			where (cxc.cxc_cst_key_1 = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D' 
				or cxc.cxc_cst_key_2 = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D')
			) as avail_orgs 
			join
				co_individual_x_organization as cxo on (avail_orgs.cxc_cst_key_1 = cxo.ixo_ind_cst_key 
													or avail_orgs.cxc_cst_key_2 = cxo.ixo_ind_cst_key) 
					join co_individual_x_organization_ext as cxo_ext on (cxo.ixo_key = cxo_ext.ixo_key_ext) 
					join co_organization as coo on (coo.org_cst_key = cxo.ixo_org_cst_key) 
					join mb_member_type as mbt on (mbt.mbt_key = cxo_ext.ixo_mbt_key_ext)
				where
					coo.org_ogt_code = 'Section' AND
					mbt.mbt_code = 'Participant' AND
					cxo_ext.ixo_status_ext = 'Active' AND
					coo.org_cst_key = 'F1B702C8-59CE-4F48-BF72-E26A1FD6565A' -- section key 
	
*/				
--- NEW 

--- FIX 

declare @cst_key as uniqueidentifier = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D'
declare @section_key as uniqueidentifier = 'F1B702C8-59CE-4F48-BF72-E26A1FD6565A' -- 72nd colony 
declare @group_key as uniqueidentifier = '8BE1B123-E3C1-4FCA-863E-F2A1557D6D7A' -- 72nd group 

select  cxc.cxc_cst_key_2 as CHILDS_CST_KEY
from co_customer_x_customer as cxc
	join co_individual_x_organization as cxo on cxc.cxc_cst_key_2 = cxo.ixo_ind_cst_key 
		join co_individual_x_organization_ext as cxo_ext on (cxo.ixo_key = cxo_ext.ixo_key_ext) 
		join mb_member_type as mbt on (mbt.mbt_key = cxo_ext.ixo_mbt_key_ext)
	join co_organization as coo on (coo.org_cst_key = cxo.ixo_org_cst_key) 
		join co_customer org on org.cst_key = cxo.ixo_org_cst_key 
	where cxc.cxc_cst_key_1 = @cst_key 
		and coo.org_ogt_code = 'Section' 
		and mbt.mbt_code = 'Participant' 
		and cxo_ext.ixo_status_ext = 'Active' 
		and org.cst_parent_cst_key = @group_key 
		and cxo.ixo_delete_flag = 0 			

UNION

select  cxc.cxc_cst_key_1 as CHILDS_CST_KEY
from co_customer_x_customer as cxc
	join co_individual_x_organization as cxo on cxc.cxc_cst_key_1 = cxo.ixo_ind_cst_key 
		join co_individual_x_organization_ext as cxo_ext on (cxo.ixo_key = cxo_ext.ixo_key_ext) 
		join mb_member_type as mbt on (mbt.mbt_key = cxo_ext.ixo_mbt_key_ext)
	join co_organization as coo on (coo.org_cst_key = cxo.ixo_org_cst_key) 
		join co_customer org on org.cst_key = cxo.ixo_org_cst_key 
	where cxc.cxc_cst_key_2 = @cst_key 
		and coo.org_ogt_code = 'Section' 
		and mbt.mbt_code = 'Participant' 
		and cxo_ext.ixo_status_ext = 'Active' 
		and org.cst_parent_cst_key = @group_key 
		and cxo.ixo_delete_flag = 0 			
