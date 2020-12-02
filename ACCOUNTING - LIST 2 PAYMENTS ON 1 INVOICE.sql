-- Report for problems until resolved 

--RAN Again on July 6th

-- FIND MISSING REG RECORDS 
;
with missing as (
	select z70_x13_key --, * 
	from 
	client_scouts_online_transaction_error_log 
	left join client_scouts_experimental_registration on x13_z70_key = z70_key 
	left join ac_invoice on inv_key = x13_inv_key
	where z70_add_date > '2018-02-01'
	and x13_key is null  
	and NOT ( z70_auth_code in ('null','000000') -- NOT DECLINED 
				OR	z70_auth_code like 'referer=%'
				OR	z70_message like 'DECLINE%'
				OR	z70_message like 'Invalid%'
				OR	z70_auth_code like 'Browser=%'
			
			 ) 
) 
select  

case when reg.x13_z70_key = l.z70_key 
then 'GOOD PAYMENT' 
else 'EXTRA PAYMENT' 
end as 'status' 

, INV_CODE, x13_add_user    ,x13_add_date,    x13_add_date    ,x13_delete_flag,    z70_trans_date,    z70_trans_time,    z70_auth_code,    z70_add_user    ,z70_add_date    ,z70_add_date
, z70_order_id, x13_key
, z70_message

from  missing join client_scouts_experimental_registration reg on missing.z70_x13_key = reg.x13_key 
join client_scouts_online_transaction_error_log l on l.z70_x13_key = missing.z70_x13_key 
left join ac_invoice on inv_key = x13_inv_key



order by l.z70_add_date 