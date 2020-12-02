


select * from client_scouts_generic_log left join client_scouts_postal_long_lat on z77_f1 = a20_post_code where z77_reason = 'postal code'



select * from client_scouts_generic_log left join client_scouts_postal_long_lat on z77_f1 = a20_post_code 
where z77_description like  'postal code is missing%'
AND z77_add_date > '2017-12-16'
order by z77_add_date


select DISTINCT z77_f1 from client_scouts_generic_log 
left join client_scouts_postal_long_lat 
on z77_f1 = a20_post_code 
where z77_description like  'postal code is missing%'  

--AND a20_key IS NULL 
AND z77_f1 LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'



