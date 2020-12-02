select * 
from co_individual_x_organization_ext join 
co_individual_x_organization on ixo_key = ixo_key_ext 
 where ixo_add_date > '2016-03-16'
order by ixo_add_date desc 


select co_individual_x_organization_ext.* 
from co_customer_x_customer 
	join co_individual a on cxc_cst_key_2=ind_cst_key
	join co_customer on a.ind_cst_key=cst_key
	left join co_individual_x_organization on ixo_key =cst_ixo_key
	left join co_organization c on ixo_org_cst_key = c.org_cst_key
	left join co_organization_ext cext (nolock) on cext.org_cst_key_ext=c.org_cst_key
	left join co_individual_x_organization_ext on ixo_key=ixo_key_ext
	left join co_customer org on c.org_cst_key= org.cst_key
	left join co_organization p on org.cst_parent_cst_key=p.org_cst_key
	left join co_organization_ext pext on p.org_cst_key=pext.org_cst_key_ext
where (cxc_cst_key_1='3999E32D-2DC0-4BAB-B94C-A8E514A9113D') 

--	and (ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' or ixo_status_ext = 'Not Renewed'  or ixo_status_ext = 'Inactive')

