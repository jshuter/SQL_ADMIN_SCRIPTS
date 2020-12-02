-- re-CREATED QUERY PLAN FOR PARENTAL REPORT WITH 
-- bad plan caused huge overhead and delay -- 10 minutes for rpt that should take 15 seconds !!

-- so we need to 1 - find plans 2 - delete plans 

---------------------
--- Find Plan ID's 
---------------------

SELECT plan_handle, st.text  
FROM sys.dm_exec_cached_plans   
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st  
WHERE text LIKE N'%client_scouts_rpt_parental_involvement%';  

--------------------
-- delete plan with    DBCC FREEPROCCACHE (id) 
--------------------
-- example of the 3 plans found for rpt 

DBCC FREEPROCCACHE (0x06000700E58A151540611EC6000000000000000000000000);  
GO  
DBCC FREEPROCCACHE (0x05000700403E77664001C607010000000000000000000000); 
go 
DBCC FREEPROCCACHE (0x05000700403E776640C1F5D4000000000000000000000000); 
GO 


