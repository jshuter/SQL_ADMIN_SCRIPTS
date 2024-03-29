
-- default settings for long term list of all 
declare @previousXminutes int = -5000  -- 600 = 10 hours  
declare @cpu_time_threshold int = 0 -- 0 for ALL -- 1 for slow 


-- normal setting for current problems 
set @previousXminutes = -10 
set @cpu_time_threshold = 1

;
with HIGHCPU as (
SELECT TOP 100
	object_name(st.objectid) as OBJECT, 
	cast( CAST(total_worker_time/execution_count AS NUMERIC(20,2) ) / 1000000 as numeric(10,2) )  AS [Avg CPU Time],
	cast( CAST(total_elapsed_time/execution_count AS NUMERIC(20,2) ) / 1000000 as numeric(10,2) ) AS [Avg ELAPSED Time]
	, qs.execution_count as xcount, qs.last_execution_time as last_exec,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS statement_text
         , *
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
where last_execution_time > DATEADD(MINUTE,@previousXminutes,getdate()) 
ORDER BY total_worker_time/execution_count DESC
) 
select * from HIGHCPU 
where [Avg CPU Time] >= @cpu_time_threshold
order by last_execution_time desc


--select GETDATE()


-- after clearing cache ... wait-times seem to get worse !!
-- DBCC FREEPROCCACHE (0x05000700087C871D40A19EE5010000000000000000000000); 

-- see DBCC SHOW_STATISTICS (Transact-SQL).
-- UPDATE STATISTICS 

/* checking stats on table ... 
 SELECT name AS stats_name, STATS_DATE(object_id, stats_id) AS statistics_update_date  
 FROM sys.stats   
 WHERE object_id = OBJECT_ID('dbo.client_scouts_experimental_registration');  
*/ 
