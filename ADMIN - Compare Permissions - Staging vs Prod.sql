---========================================================
-- ROLE PERMISSION - FORMS 
---========================================================

select top 10 'PROD HAS:' , f1.* 
from [scoutssql02.tpca.ld].nfscouts.dbo.client_scouts_role_x_forms f1
LEFT JOIN nfscoutstest.dbo.client_scouts_role_x_forms f2
on f1.a21_dyn_key = f2.a21_dyn_key and f1.a21_rlt_code = f2.a21_rlt_code
where f1.a21_key IS NULL OR f2.a21_key IS NULL 

select top 10 'DEV HAS:', f2.* 
from [scoutssql02.tpca.ld].nfscouts.dbo.client_scouts_role_x_forms f1
RIGHT JOIN nfscoutstest.dbo.client_scouts_role_x_forms f2
on f1.a21_dyn_key = f2.a21_dyn_key and f1.a21_rlt_code = f2.a21_rlt_code
where f1.a21_key IS NULL OR f2.a21_key IS NULL 

---========================================================
-- REPORTS 
---========================================================

select top 10 'DEV HAS:' , DEV.* 
from [scoutssql02.tpca.ld].nfscouts.dbo.client_scouts_role_x_reports PROD
LEFT JOIN nfscoutstest.dbo.client_scouts_role_x_reports DEV
on PROD.a36_report_name = DEV.a36_report_name and PROD.a36_rlt_code = DEV.a36_rlt_code 
where DEV.a36_key IS NULL OR PROD.a36_key IS NULL 


select top 10 'PROD HAS:' , PROD.* 
from [scoutssql02.tpca.ld].nfscouts.dbo.client_scouts_role_x_reports PROD
RIGHT JOIN nfscoutstest.dbo.client_scouts_role_x_reports DEV
on PROD.a36_report_name = DEV.a36_report_name and PROD.a36_rlt_code = DEV.a36_rlt_code 
where DEV.a36_key IS NULL OR PROD.a36_key IS NULL 

---========================================================
-- WEB METHODS  
---========================================================

-----------------------------------------------------------------------------------------------------
--- ITEMS IN PROD THAT ARE NOT DEV ?? Unexpected --- 
-----------------------------------------------------------------------------------------------------
;
with PROD as ( 
	select * from [scoutssql02.tpca.ld].nfscouts.dbo.client_scouts_role_x_execute_methods a
	join [scoutssql02.tpca.ld].nfscouts.dbo.ws_web_service_method b on a.a22_wxm_key = b.wxm_key 
) , 
DEV as ( 
	select * from nfscoutstest.dbo.client_scouts_role_x_execute_methods 
	join nfscoutstest.dbo.ws_web_service_method on wxm_key = a22_wxm_key 
) 

select * from PROD 
LEFT join DEV on DEV.a22_rlt_code = PROD.a22_rlt_code AND DEV.wxm_web_method = PROD.wxm_web_method
where DEV.a22_key  IS NULL OR PROD.a22_key  IS NULL

-----------------------------------------------------------------------------------------------------
--- ITEMS IN DEV THAT ARE NOT YET IN PROD -- some are expected 
-----------------------------------------------------------------------------------------------------
;
with PROD as ( 
	select * from [scoutssql02.tpca.ld].nfscouts.dbo.client_scouts_role_x_execute_methods a
	join [scoutssql02.tpca.ld].nfscouts.dbo.ws_web_service_method b on a.a22_wxm_key = b.wxm_key 
) , 
DEV as ( 
	select * from nfscoutstest.dbo.client_scouts_role_x_execute_methods 
	join nfscoutstest.dbo.ws_web_service_method on wxm_key = a22_wxm_key 
) 

select DEV.* from PROD
RIGHT join DEV on DEV.a22_rlt_code = PROD.a22_rlt_code AND DEV.wxm_web_method = PROD.wxm_web_method
where (DEV.a22_key  IS NULL OR PROD.a22_key  IS NULL)
and DEV.a22_delete_flag = 0 


