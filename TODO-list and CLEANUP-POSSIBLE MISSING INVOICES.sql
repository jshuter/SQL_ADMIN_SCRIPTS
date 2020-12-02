select * from client_scouts_experimental_registration 
join co_individual_x_organization on x13_ixo_key = ixo_key 
where x13_add_date > '2016-01-01' 
and x13_progress = 'Confirmation' 
AND x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
and x13_inv_key is null 
and x13_add_user <> 'multiyear.split'
and ixo_rlt_code <> 'Rover Scout Participant'
and x13_delete_flag = 0 
and ixo_delete_flag = 0 
order by x13_add_date 
