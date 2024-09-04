-- 800 
select top 1000 a.cxc_key k, b.cxc_key, b.* , a.*
from co_customer_x_customer a 	join co_customer_x_customer b on a.cxc_cst_key_1 = b.cxc_cst_key_1 and a.cxc_key <> b.cxc_key  
where a.cxc_add_date > '2015-01-01' 
and (a.cxc_rlt_code = 'Child') 
and a.cxc_delete_flag = 0 
and b.cxc_delete_flag = 0 
and b.cxc_rlt_code = 'Parent/Guardian' 
order by a.cxc_cst_key_1 

-- 532 CST Keys where a 'CHILD' is also a PARENT 
select distinct b.cxc_cst_key_1 
from co_customer_x_customer a 	join co_customer_x_customer b on a.cxc_cst_key_1 = b.cxc_cst_key_1 and a.cxc_key <> b.cxc_key  
where a.cxc_add_date > '2015-01-01' 
and (a.cxc_rlt_code = 'Child') 
and a.cxc_delete_flag = 0 
and b.cxc_delete_flag = 0 
and b.cxc_rlt_code = 'Parent/Guardian' 


-- 275 DUPLICATE CX records 
-- look for DUPS !!!!
select * 
from co_customer_x_customer a 	join co_customer_x_customer b on a.cxc_cst_key_1 = b.cxc_cst_key_1 
																and a.cxc_cst_key_2 = b.cxc_cst_key_2
																and a.cxc_key <> b.cxc_key  
where a.cxc_add_date > '2015-01-01' 
and (a.cxc_rlt_code = 'Child' OR b.cxc_rlt_code = 'Child') 
and a.cxc_delete_flag = 0 
and b.cxc_delete_flag = 0 



select * from co_customer where cst_key = 'BA198472-7A6A-4143-A447-00478578308B'

union 
select * from co_customer_x_customer a 	join co_customer_x_customer b on a.cxc_cst_key_1 = b.cxc_cst_key_2 and a.cxc_key <> b.cxc_key  

select top 1000  b.cxc_key, a.* , b.* 
from co_customer_x_customer a 	join co_customer_x_customer b on a.cxc_cst_key_1 = b.cxc_cst_key_1 and a.cxc_key <> b.cxc_key  
where a.cxc_add_date > '2018-06-05' 
and (b.cxc_rlt_code = 'Child' or a.cxc_rlt_code = 'Child') 
order by a.cxc_cst_key_1 



select * from co_customer where cst_key in ('671312C2-DD4A-432B-B33E-FE7DEE5A6EAF','B61BC16D-70EF-4060-9557-05E85F636D15')
select * from co_customer_x_customer where cxc_add_date > '2018-06-05'
