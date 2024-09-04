with 

my_orgs as (
	select * from co_individual_x_organization i 
	join co_individual_x_organization_ext ie on i.ixo_key = ie.ixo_key_ext 
	where i.ixo_ind_cst_key = 'AEDDB7B9-4ED7-4BC4-9707-3EEA2369772B'
	and i.ixo_start_date < GETDATE()
	and i.ixo_delete_flag = 0 
	and ie.ixo_status_ext = 'Active' 
	and ixo_rlt_code in ('Area Registrar','Group Registrar','Council Registrar') 
) 
,

orgtree(parent_key, org_key, org_name, h, org_ogt_code ) as 
( 
	select c.cst_parent_cst_key as parent_key , org_cst_key, org_name, orgext1.org_hierarchy_hash_ext as h , org_ogt_code 
	from co_organization org1 
		join co_organization_ext orgext1 on org1.org_cst_key = org_cst_key_ext 
		join co_customer c on c.cst_key = org1.org_cst_key 
		join my_orgs on my_orgs.ixo_org_cst_key = org1.org_cst_key 
	where org1.org_delete_flag = 0 
	and orgext1.org_status_ext = 'Active'
	
	UNION all
	
	select c.cst_parent_cst_key as parent_key , org2.org_cst_key, org2.org_name, orgext2.org_hierarchy_hash_ext as h , org2.org_ogt_code 
	from co_organization org2
		join co_organization_ext orgext2 on org2.org_cst_key = org_cst_key_ext 
		join co_customer c on c.cst_key = org2.org_cst_key 
		join orgtree parent on parent.org_key = c.cst_parent_cst_key
	where org2.org_delete_flag = 0 
	and orgext2.org_status_ext = 'Active'
	
)

select distinct h,org_key, org_name , org_ogt_code  from orgtree

order by org_ogt_code 





