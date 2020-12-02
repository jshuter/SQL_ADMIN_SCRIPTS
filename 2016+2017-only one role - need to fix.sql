-- 

select * from client_scouts_experimental_registration 
where x13_type = '2016+2017' 
order by x13_progress 


select top 100 ixo.ixo_key,  ixo.ixo_start_date, ixo.ixo_end_date, x13_key , x13_type, x13_progress from client_scouts_experimental_registration r
 join co_individual_x_organization ixo on r.x13_ixo_key = ixo.ixo_key
where x13_type  = '2016+2017' and x13_progress = 'Confirmation' 


select top 100 c.cst_name_cp, c.cst_recno, o.org_name,  ixo.ixo_key,  ixo.ixo_start_date, ixo.ixo_end_date, x13_key , x13_type, x13_progress from client_scouts_experimental_registration r
 join co_individual_x_organization ixo on r.x13_ixo_key = ixo.ixo_key
join co_customer c on ixo.ixo_ind_cst_key = c.cst_key 
join co_organization o on ixo.ixo_org_cst_key = o.org_cst_key
where x13_type  = '2016+2017' and x13_progress = 'Confirmation' 


select * from co_customer 
where cst_key  in ('EBB97AFC-2B6B-421D-B9AA-2AB352AAA2D6','AD275877-552C-4426-BAEF-71ED70BDA356') 


select * from client_scouts_registrat