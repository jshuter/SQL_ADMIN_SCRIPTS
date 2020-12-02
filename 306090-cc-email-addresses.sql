
SELECT  cc.cst_eml_address_dn, ixo.ixo_org_cst_key,  ixo.ixo_ind_cst_key,  ixo.ixo_rlt_code,
cc.cst_sort_name_dn,
coe.org_hierarchy_hash_ext AS H_SRC , 
(CASE WHEN len(coe.org_hierarchy_hash_ext) < 11 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 11 ) END) h1, -- SCOUTS 
(CASE WHEN len(coe.org_hierarchy_hash_ext) < 22 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 22 ) END) h2, -- COUNCILs
(CASE WHEN len(coe.org_hierarchy_hash_ext) < 33 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 33 ) END) h3, -- AREAs
(CASE WHEN len(coe.org_hierarchy_hash_ext) < 44 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 44 ) END) h4, -- Groups
(CASE WHEN len(coe.org_hierarchy_hash_ext) < 55 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 55 ) END) h5  -- Commitees 
from co_individual_x_organization ixo
 inner join co_individual_x_organization_ext ixoe on ixoe.ixo_key_ext = ixo.ixo_key
 inner join co_organization_ext coe on coe.org_cst_key_ext = ixo.ixo_org_cst_key
 inner join co_customer cc on cc.cst_key = ixo.ixo_ind_cst_key
 where	  cc.cst_eml_address_dn is not null 
 and	  		ixoe.ixo_status_ext = 'Active' 
AND	(	ixo.ixo_rlt_code like '%Support Manager%' 
	OR	ixo.ixo_rlt_code = 'Group Commissioner' 
	OR	ixo.ixo_rlt_code = 'Area Commissioner') 
 AND   (ixo.ixo_delete_flag = 0 or ixo.ixo_delete_flag is null) 
 AND  ixo.ixo_start_date between '09-01-'+(cast((2015) as varchar(4))) AND '08-31-'+(cast(2016 as varchar(4)))
--order by cst_eml_address_dn
order by  h1, h2, h3, h4, h5 
---000010229O-000007007O-000005162O-000001253O

/*
select * from co_customer where cst_recno = 000010229
select * from co_customer where cst_recno = 000002654
select * from co_customer where cst_recno = 000001162
select * from co_customer where cst_recno = 000002086
select * from co_customer where cst_recno = 000001959
*/
    