drop table if exists #tmp1
drop table if exists #tmp2


-- include vs exclude 
select * 
into #tmp1
from sys.dm_os_wait_stats 
where 
(waiting_tasks_count <> 0 or wait_time_ms <> 0 or max_wait_time_ms <> 0 or  signal_wait_time_ms <> 0 ) 
order by waiting_tasks_count desc 

select * 
from sys.dm_os_wait_stats 
where 
wait_type like '%CX%'
AND ( waiting_tasks_count <> 0 or wait_time_ms <> 0 or max_wait_time_ms <> 0 or  signal_wait_time_ms <> 0 ) 
order by waiting_tasks_count desc 

select 1
waitfor delay '00:00:05'
select 2

select * 
into #tmp2
from sys.dm_os_wait_stats 
where 
--wait_type like '%CX%' AND 
(waiting_tasks_count <> 0 or wait_time_ms <> 0 or max_wait_time_ms <> 0 or  signal_wait_time_ms <> 0 ) 
order by waiting_tasks_count desc 


--select * from sys.dm_exec_session_wait_stats order by 4 desc 
--select * from sys.dm_os_waiting_tasks order by 4 desc 
--select * from sys.dm_pal_wait_stats
--select * from sys.query_store_wait_stats


select * from #tmp1 
except
select * from #tmp2

select * from #tmp2
except
select * from #tmp1

