-- 15 GYC 
select top 100 z11_email,  cst.cst_eml_address_dn, cst_web_login, cst_web_login_disabled_flag, cst_web_password, 
ind_age_cp,  * 
from co_individual_x_organization a
join co_individual_x_organization_ext x on a.ixo_key = x.ixo_key_ext
join co_individual I on i.ind_cst_key = a.ixo_ind_cst_key
join co_customer cst on i.ind_cst_key = cst.cst_key
join client_scouts_member_account M on z11_ind_cst_key = i.ind_cst_key

where ixo_rlt_code like 'group youth%' and x.ixo_status_ext = 'Active' 
order by i.ind_age_cp

