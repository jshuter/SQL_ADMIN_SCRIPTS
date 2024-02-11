/*
this should
a - record baseline stats perhaps every 3 hours 
and also report stats for a 10 second period hourly 
and perhaps report exceptions -- ie when avgs over time start to trend towards worse performance
-- need daily stats 
-- and just monitor daily averages --
-- much like avgs calculated below - but using 1 row per day (max asofdate per day) 

*/

--init 

drop table if exists #tmpPriorStats
drop table if exists #tmpCurrentStats
--drop table if exists #tmpReportData 


-- prime tmp1 & 2 
select * 
into #tmpPriorStats
from sys.dm_os_wait_stats 

select * 
into #tmpCurrentStats
from sys.dm_os_wait_stats 

-- init temp table if it does not exists
IF OBJECT_ID('tempdb..#tmpReportData') IS NULL
select 
	getdate() as asofdate,
	t1.* , 
	0 as diff_Wait_Count,
	0 as diff_Wait_time,
	0 as diff_Max_Wait_time,
	0 as diff_signal_time,
	0 avg_wait_time
into #tmpReportData 
from #tmpPriorStats t1 
	
--select 'dbg 0', * from #tmpReportData

----------------------------------------------------

declare @counter int = 0 

-- loop report +++

while @counter < 10
begin 

print '...'

	waitfor delay '00:00:01'

	-- refresh stats
	DELETE from #tmpCurrentStats
	insert into #tmpCurrentStats select * from sys.dm_os_wait_stats 

	;
	with x as (
		select 
			t1.* , 
			t2.waiting_tasks_count - t1.waiting_tasks_count d1_task_count,
			t2.wait_time_ms-t1.wait_time_ms d2_wait_time,
			t2.max_wait_time_ms-t1.max_wait_time_ms d3_max_wait_time,
			t2.signal_wait_time_ms-t1.signal_wait_time_ms d4_signal_time,
			cast(t1.wait_time_ms as decimal(20,2)) / cast(t1.waiting_tasks_count as decimal(20,2)) as avg_wait_time
	from 
		#tmpPriorStats t1 
		join #tmpCurrentStats t2 on t2.wait_type = t1.wait_type
	where 
		(t2.waiting_tasks_count <> 0 or t2.wait_time_ms <> 0 or t2.max_wait_time_ms <> 0 or  t2.signal_wait_time_ms <> 0 ) 
	) 
	insert into #tmpReportData	select getdate() , * from x where d1_task_count <> 0 or d2_wait_time <> 0 or d3_max_wait_time <> 0 or d4_signal_time <>0 

	-- move new to cache	
	delete #tmpPriorStats

	insert into #tmpPriorStats select * from #tmpCurrentStats order by wait_time_ms desc
    set @counter = @counter+1

end

select 
	*,
	cast(case when diff_wait_count > 0 then cast(diff_wait_time as decimal(20,2))/cast(diff_wait_count as decimal(20,2)) end as decimal(20,2)) as new_avg_wait_time_ms,
	case when avg_wait_time > 0 then
	((case when diff_wait_count > 0 then cast(diff_wait_time as decimal(20,2))/cast(diff_wait_count as decimal(20,2)) end)/ cast(avg_wait_time as decimal(20,2)))  end as test
from 
	#tmpReportData 
where 	diff_wait_count <>0 or diff_wait_time <>0 or diff_max_wait_time <> 0 or diff_signal_time <> 0
order by	
--test,
	wait_type, 
	asofdate
	
--select * from sys.dm_exec_session_wait_stats
