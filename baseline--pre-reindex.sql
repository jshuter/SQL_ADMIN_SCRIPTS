
select a.org_name, a.org_cst_key from co_organization(nolock) 
as a inner join co_organization_ext(nolock) as b on a.org_cst_key = b.org_cst_key_ext
 where (0 = CASE WHEN ((select COUNT(ixo_key)
  from (co_individual_x_organization(nolock) inner join co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext) 
  inner join co_organization_ext(nolock) on ixo_org_cst_key = org_cst_key_ext 
 where (ixo_ind_cst_key in 
(select top 100 ixo_ind_cst_key from co_individual_x_organization)  
  -- @ind_cst_key 
	and ixo_status_ext = 'Active') 
	and (select org_hierarchy_hash_ext from co_organization_ext(nolock) 
 where org_cst_key_ext = a.org_cst_key) like org_hierarchy_hash_ext + '%' ) = 0) THEN 1 ELSE 0 END)
  and org_status_ext = 'Active' order by org_name 

/* 
(3 row(s) affected)
Table 'co_organization_ext'. Scan count 1, logical reads 148634, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_individual_x_organization_ext'. Scan count 0, logical reads 3131942, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_individual_x_organization'. Scan count 194812, logical reads 4804822, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'co_organization'. Scan count 1, logical reads 320, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
*/

set statistics io ON 
