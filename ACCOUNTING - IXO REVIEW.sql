select i.inv_code, ixo2.ixo_key 
, ixo2.ixo_add_date, ixo2.ixo_start_date , ixo2.ixo_rlt_code , R.x13_ind_cst_key_2
, * from ac_invoice I 
join client_scouts_experimental_registration R on R.x13_inv_key = I.inv_key 
LEFT join co_individual_x_organization ixo2 on ixo2.ixo_ind_cst_key = R.x13_ind_cst_key_2 
where I.inv_code =520228
order by ixo2.ixo_add_date 
----
select i.inv_code, ixo_key
, ixo2.ixo_add_date, ixo2.ixo_start_date , ixo2.ixo_rlt_code , R.x13_ind_cst_key_2
, * from ac_invoice I 
join client_scouts_experimental_registration R on R.x13_inv_key = I.inv_key 
LEFT join co_individual_x_organization ixo2 on ixo2.ixo_ind_cst_key = R.x13_ind_cst_key_2 

where I.inv_code = 520585
order by ixo2.ixo_add_date 

------------

select ixo_key, x13_progress, ixo_status_ext
, c1.cst_name_cp BY_name, c1.cst_recno BY_recno
, c2.cst_name_cp BY_name, c2.cst_recno FOR_recno 
, x13_add_date, ixo_add_date, ixo_add_user, ixo_change_date, ixo_change_user, ixo_start_date, cr.cst_recno, cr.cst_name_cp
, inv_add_date, inv_code, inv_key
 from 
co_individual_x_organization x
join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
join co_customer cr on cr.cst_key = ixo_ind_cst_key
LEFT join  client_scouts_experimental_registration on ixo_key = x13_ixo_key
LEFT JOIN ac_invoice on inv_key = x13_inv_key 
left join co_customer c1 on x13_ind_cst_key_1 = c1.cst_key 
left join co_customer c2 on x13_ind_cst_key_2 = c2.cst_key 

where ixo_key in ( 
	select  ixo_key
	from ac_invoice I 
	join client_scouts_experimental_registration R on R.x13_inv_key = I.inv_key 
	LEFT join co_individual_x_organization ixo2 on ixo2.ixo_ind_cst_key = R.x13_ind_cst_key_2 
	where I.inv_code in ( 520585, 520228) 
) 
ORDER BY ixo_ind_cst_key, ixo_add_date

