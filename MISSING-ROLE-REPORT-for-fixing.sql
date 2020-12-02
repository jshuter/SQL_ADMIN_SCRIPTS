with PROBLEMS as ( 
select r.*, c2.*, o.* 
from client_scouts_experimental_registration r
left outer join co_customer c1 on c1.cst_key = r.x13_ind_cst_key_1
left outer join co_customer c2 on c2.cst_key = r.x13_ind_cst_key_2 
left outer join client_scouts_online_transaction_error_log l on l.z70_key = r.x13_z70_key 
left outer join co_organization o on r.x13_org_cst_key = o.org_cst_key
where x13_inv_key IS NOT NULL and x13_ixo_key IS NULL 
and x13_add_date > '2016-06-01' 
) 

Select role.ixo_key, ixo_start_date, ixo_end_date 
,   cst_recno, cst_name_cp 
,   x13_add_date as add_date
,	org_name 

from PROBLEMS 
left outer join co_individual_x_organization role on role.ixo_ind_cst_key = problems.x13_ind_cst_key_2 AND role.ixo_org_cst_key = problems.x13_org_cst_key
order by problems.x13_ind_cst_key_2, role.ixo_add_date 


/* 
select 
c1.cst_recno, c1.cst_name_cp
,   c2.cst_recno, c2.cst_name_cp 
,   r.x13_add_date as add_date
,	o.org_name 
,   l.*, r.*
from client_scouts_experimental_registration r
left outer join co_customer c1 on c1.cst_key = r.x13_ind_cst_key_1
left outer join co_customer c2 on c2.cst_key = r.x13_ind_cst_key_2 
left outer join client_scouts_online_transaction_error_log l on l.z70_key = r.x13_z70_key 
left outer join co_organization o on r.x13_org_cst_key = o.org_cst_key
where x13_inv_key IS NOT NULL and x13_ixo_key IS NULL 
and x13_add_date > '2016-06-01' 
*/
