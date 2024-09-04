select top 100 cst_org_name_dn , o.org_name, ind_status_ext, ixo_add_date, r.* 
from  co_customer c join co_individual_x_organization r on c.cst_ixo_key = r.ixo_key 
join co_organization o on r.ixo_org_cst_key = o.org_cst_key 
join co_individual_ext on ind_cst_key_ext = c.cst_key  
where ind_status_ext = 'Active' 
and cst_org_name_dn <>  o.org_name



