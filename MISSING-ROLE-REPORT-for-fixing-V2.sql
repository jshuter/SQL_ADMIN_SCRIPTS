-- select COUNT(*) from client_scouts_experimental_registration where x13_add_date >= '2016-10-01' ;

WITH MISSING_ROLES AS (

	select r.x13_source, r.x13_progress
	, c1.cst_recno rn1, c1.cst_name_cp nm1
	, c2.cst_recno rn2, c2.cst_name_cp nm2
	, r.x13_add_date 
	, r.x13_org_cst_key 
	, r.x13_ind_cst_key_2 
	, r.x13_ixo_key
	, r.x13_inv_key
	, r.x13_z70_key

	from client_scouts_experimental_registration r

	left outer join co_customer c1 on c1.cst_key = r.x13_ind_cst_key_1
	left outer join co_customer c2 on c2.cst_key = r.x13_ind_cst_key_2 
	left outer join client_scouts_online_transaction_error_log l on l.z70_key = r.x13_z70_key 

	where x13_inv_key IS NOT NULL and x13_ixo_key IS NULL 
		and x13_add_date > '2016-09-01' 
	) 

select 

MISSING_ROLES.x13_add_date as 'Initial Reg'
, MISSING_ROLES.x13_ixo_key as 'Initial ixokey' 
, ixo_add_date as 'rs ixo_add_date'
, r2.x13_add_date as 'r2 x13_add_date' 
, r2.x13_add_date as 'r2 add'
, r2.x13_source 'r2 source'
, r2.x13_progress as 'r2 progress'
, r2.x13_inv_key as 'r2 inv' 
, r2.x13_z70_key as 'r2 log' 
, r2.x13_ixo_key  as 'r2 ixokey'
, role.ixo_start_date
, role.ixo_key as 'role-ixo-key'
, role.ixo_rlt_code as 'role-rlt'
, '<-- OK IF EXISTS / PROBLEM X13 DATA --> ',  * 

from MISSING_ROLES 
	LEFT OUTER join co_individual_x_organization ROLE 
		on ROLE.ixo_org_cst_key = MISSING_ROLES.x13_org_cst_key 
			AND ROLE.ixo_ind_cst_key = MISSING_ROLES.x13_ind_cst_key_2 
			AND ROLE.ixo_start_date >= '2016-09-01' 

	LEFT OUTER JOIN client_scouts_experimental_registration R2 ON R2.x13_ixo_key = ROLE.ixo_key 
	
where ROLE.ixo_start_date IS NULL 
OR 
( ROLE.ixo_start_date >= '2016-09-01'
	and ROLE.ixo_rlt_code not like '%scout%' ) 

 
-- and x13_key is not null 
ORDER BY MISSING_ROLES.x13_add_date desc 



/* 

select * -- x13_type,  x13_add_date, x13_inv_key
from client_scouts_experimental_registration r

join co_individual_x_organization  i 
on i.ixo_org_cst_key = r.x13_org_cst_key and i.ixo_ind_cst_key = r.x13_ind_cst_key_2 

where r.x13_ixo_key is NULL 
and x13_delete_flag = 0 
and x13_progress = 'Confirmation' 
and x13_type ='2017'
and i.ixo_start_date > '2016-08-31' 
-- and x13_mbt_key ='2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
order by x13_type, x13_add_date desc 

*/



/* 
select * from co_individual where ind_last_name like 'wipf%'
select * from client_scouts_experimental_registration 
where x13_ind_cst_key_1 = '27593254-7117-416E-BB6F-3EC215BF7023' 
or x13_ind_cst_key_2 = '27593254-7117-416E-BB6F-3EC215BF7023' 
*/


select * from co_individual_x_organization where ixo_key = 'DE555BFD-72A6-40BD-8FCB-A6043FD7C01B'