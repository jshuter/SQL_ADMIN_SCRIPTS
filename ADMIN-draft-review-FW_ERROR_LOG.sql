select COUNT(*) from fw_error_log


select COUNT(*), err_number  
from fw_error_log 
group by err_number 

select top 2 * from fw_error_log

-- very intersting how errors custer to what apears to be an individual user ...!!!!
select top 100 * from fw_error_log where err_number = -2147217900
and err_sql not like '%United States%'
and err_ip_address != '172.16.200.22'
order by err_add_date 

--> a few varieties of errors 
-- 1 quote in name 
-- missing/empty key 
   
13982	-2147217900

-----------------
-- TIME OUTS 
-- very intersting how errors custer to what apears to be an individual user ...!!!!

select top 100 * from fw_error_log where err_number = -2146232060
and err_sql like 'exec%'
order by err_add_date 

-- SERIOUS DEADLOCK ISSUES : exec client_scouts_my_leaders_child_form 'c76fd830-0371-4462-af6b-61bde58fc4b6'  

--- 
--- PHP TIMEOUTS 

select top 100 * from fw_error_log where err_number = -2146232060
and err_sql NOT like 'exec%'
order by err_add_date 


------

select  * from fw_error_log where err_number = -1
and err_ip_address = '172.16.200.22' 
order by err_add_date 


select  * from fw_error_log where err_sql like '%individual_x_organization%'


6	500
9	1000
34	-2147217913
3240	-1
