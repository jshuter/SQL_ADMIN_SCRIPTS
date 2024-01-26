USE SMTR 
GO 

with DATA as (
SELECT stats.last_execution_time as last_ran_at,
total_worker_time/execution_count AS Avg_CPU_Time
  ,execution_count as times_run
  , total_rows/execution_count as AVG_ROWS
  , cast( CAST(total_elapsed_time/execution_count AS NUMERIC(20,2)) / 1000000 as numeric(10,2) ) as 'AVG_Run_Time(sec)'
  , (SELECT object_name(objectid)  FROM sys.dm_exec_sql_text(sql_handle) ) AS obname
  ,(SELECT SUBSTRING(text,statement_start_offset/2,(CASE
                                                       WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 
                                                       ELSE statement_end_offset 
                                                       END -statement_start_offset)/2
                   ) FROM sys.dm_exec_sql_text(sql_handle)
         ) AS query_text 
  , STATS.* 
FROM sys.dm_exec_query_stats STATS
) 
SELECT top 100 * 
FROM DATA 
WHERE execution_count > 1 
and obname is not null 

--pick your criteria
--order by last_execution_time desc 

ORDER BY 'AVG_Run_Time(sec)' DESC

