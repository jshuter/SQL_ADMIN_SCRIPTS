with 

Councils as (
	select o.org_cst_key,  oe.org_hierarchy_friendly_ext, org_name,  oe.org_allow_online_reg_flag_ext, oe.org_bank_account_received_flag_ext
	from co_organization o 
	join co_organization_ext oe on o.org_cst_key = oe.org_cst_key_ext
	where org_ogt_code = 'Council' 
	and org_delete_flag = 0 
	and org_status_ext = 'Active' 
) 

SELECT councils.org_name 
	,	
	(select COUNT(*) 
	from co_organization o 
	join co_organization_ext oe on o.org_cst_key = oe.org_cst_key_ext
	join Councils C on oe.org_hierarchy_friendly_ext like C.org_hierarchy_friendly_ext + '%'
	where 
	O.org_ogt_code = 'Group' 
	and org_delete_flag = 0 
	and org_status_ext = 'Active'
	AND (OE.org_allow_online_reg_flag_ext = 1 AND OE.org_bank_account_received_flag_ext = 1) 
	and councils.org_name = c.org_name 
	group by c.org_name 
	)
	as ONLINE_YES

	,	
	(select COUNT(*) 
	from co_organization o 
	join co_organization_ext oe on o.org_cst_key = oe.org_cst_key_ext
	join Councils C on oe.org_hierarchy_friendly_ext like C.org_hierarchy_friendly_ext + '%'
	where 
	O.org_ogt_code = 'Group' 
	and org_delete_flag = 0 
	and org_status_ext = 'Active'
	AND (OE.org_allow_online_reg_flag_ext <> 1 
			or OE.org_bank_account_received_flag_ext <>1
			or OE.org_allow_online_reg_flag_ext IS NULL 
			or OE.org_bank_account_received_flag_ext IS NULL) 
	and councils.org_name = c.org_name 
	group by c.org_name 
	)
	as ONLINE_NO 

	, 
	(select COUNT(*) 
	from co_organization o 
	join co_organization_ext oe on o.org_cst_key = oe.org_cst_key_ext
	join Councils C on oe.org_hierarchy_friendly_ext like C.org_hierarchy_friendly_ext + '%'
	where 
	O.org_ogt_code = 'Group' 
	and org_delete_flag = 0 
	and org_status_ext = 'Active'
	and councils.org_name = c.org_name 
	group by c.org_name
	) 
	as total

FROM Councils

order by councils.org_name
--group by Councils.org_name

