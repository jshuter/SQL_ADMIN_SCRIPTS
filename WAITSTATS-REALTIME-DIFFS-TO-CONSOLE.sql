USE ElectrumPersistent
GO

/*
this should
a - record baseline stats perhaps every hour 
and also report stats for a 10 second period hourly 
and perhaps report exceptions -- ie when avgs over time start to trend towards worse performance
-- need daily stats 
-- and just monitor daily averages --
-- much like avgs calculated below - but using 1 row per day (max asofdate per day) 

select * from sys.dm_os_wait_stats

select * from sys.dm_exec_session_wait_stats

*/

--init 

-- These wait types are almost 100% never a problem and so they are
-- filtered out to avoid them skewing the results. Click on the URL
-- for more information.

declare @WaitTypeExceptions TABLE(wait_type_name nvarchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS) --  -- ] NOT IN (

INSERT INTO @WaitTypeExceptions
VALUES(N'BROKER_EVENTHANDLER'), -- https://www.sqlskills.com/help/waits/BROKER_EVENTHANDLER
(N'BROKER_RECEIVE_WAITFOR'), -- https://www.sqlskills.com/help/waits/BROKER_RECEIVE_WAITFOR
(N'BROKER_TASK_STOP'), -- https://www.sqlskills.com/help/waits/BROKER_TASK_STOP
(N'BROKER_TO_FLUSH'), -- https://www.sqlskills.com/help/waits/BROKER_TO_FLUSH
(N'BROKER_TRANSMITTER'), -- https://www.sqlskills.com/help/waits/BROKER_TRANSMITTER
(N'CHECKPOINT_QUEUE'), -- https://www.sqlskills.com/help/waits/CHECKPOINT_QUEUE
(N'CHKPT'), -- https://www.sqlskills.com/help/waits/CHKPT
(N'CLR_AUTO_EVENT'), -- https://www.sqlskills.com/help/waits/CLR_AUTO_EVENT
(N'CLR_MANUAL_EVENT'), -- https://www.sqlskills.com/help/waits/CLR_MANUAL_EVENT
(N'CLR_SEMAPHORE'), -- https://www.sqlskills.com/help/waits/CLR_SEMAPHORE

-- Maybe comment this out if you have parallelism issues
(N'CXCONSUMER'), -- https://www.sqlskills.com/help/waits/CXCONSUMER

-- Maybe comment these four out if you have mirroring issues
(N'DBMIRROR_DBM_EVENT'), -- https://www.sqlskills.com/help/waits/DBMIRROR_DBM_EVENT
(N'DBMIRROR_EVENTS_QUEUE'), -- https://www.sqlskills.com/help/waits/DBMIRROR_EVENTS_QUEUE
(N'DBMIRROR_WORKER_QUEUE'), -- https://www.sqlskills.com/help/waits/DBMIRROR_WORKER_QUEUE
(N'DBMIRRORING_CMD'), -- https://www.sqlskills.com/help/waits/DBMIRRORING_CMD
(N'DIRTY_PAGE_POLL'), -- https://www.sqlskills.com/help/waits/DIRTY_PAGE_POLL
(N'DISPATCHER_QUEUE_SEMAPHORE'), -- https://www.sqlskills.com/help/waits/DISPATCHER_QUEUE_SEMAPHORE
(N'EXECSYNC'), -- https://www.sqlskills.com/help/waits/EXECSYNC
(N'FSAGENT'), -- https://www.sqlskills.com/help/waits/FSAGENT
(N'FT_IFTS_SCHEDULER_IDLE_WAIT'), -- https://www.sqlskills.com/help/waits/FT_IFTS_SCHEDULER_IDLE_WAIT
(N'FT_IFTSHC_MUTEX'), -- https://www.sqlskills.com/help/waits/FT_IFTSHC_MUTEX
 
      -- Maybe comment these six out if you have AG issues
(N'HADR_CLUSAPI_CALL'), -- https://www.sqlskills.com/help/waits/HADR_CLUSAPI_CALL
(N'HADR_FILESTREAM_IOMGR_IOCOMPLETION'), -- https://www.sqlskills.com/help/waits/HADR_FILESTREAM_IOMGR_IOCOMPLETION
(N'HADR_LOGCAPTURE_WAIT'), -- https://www.sqlskills.com/help/waits/HADR_LOGCAPTURE_WAIT
(N'HADR_NOTIFICATION_DEQUEUE'), -- https://www.sqlskills.com/help/waits/HADR_NOTIFICATION_DEQUEUE
(N'HADR_TIMER_TASK'), -- https://www.sqlskills.com/help/waits/HADR_TIMER_TASK
(N'HADR_WORK_QUEUE'), -- https://www.sqlskills.com/help/waits/HADR_WORK_QUEUE

(N'KSOURCE_WAKEUP'), -- https://www.sqlskills.com/help/waits/KSOURCE_WAKEUP
(N'LAZYWRITER_SLEEP'), -- https://www.sqlskills.com/help/waits/LAZYWRITER_SLEEP
(N'LOGMGR_QUEUE'), -- https://www.sqlskills.com/help/waits/LOGMGR_QUEUE
(N'MEMORY_ALLOCATION_EXT'), -- https://www.sqlskills.com/help/waits/MEMORY_ALLOCATION_EXT
(N'ONDEMAND_TASK_QUEUE'), -- https://www.sqlskills.com/help/waits/ONDEMAND_TASK_QUEUE
(N'PARALLEL_REDO_DRAIN_WORKER'), -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_DRAIN_WORKER
(N'PARALLEL_REDO_LOG_CACHE'), -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_LOG_CACHE
(N'PARALLEL_REDO_TRAN_LIST'), -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_TRAN_LIST
(N'PARALLEL_REDO_WORKER_SYNC'), -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_SYNC
(N'PARALLEL_REDO_WORKER_WAIT_WORK'), -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_WAIT_WORK
(N'PREEMPTIVE_OS_FLUSHFILEBUFFERS'), -- https://www.sqlskills.com/help/waits/PREEMPTIVE_OS_FLUSHFILEBUFFERS
(N'PREEMPTIVE_XE_GETTARGETSTATE'), -- https://www.sqlskills.com/help/waits/PREEMPTIVE_XE_GETTARGETSTATE
(N'PVS_PREALLOCATE'), -- https://www.sqlskills.com/help/waits/PVS_PREALLOCATE
(N'PWAIT_ALL_COMPONENTS_INITIALIZED'), -- https://www.sqlskills.com/help/waits/PWAIT_ALL_COMPONENTS_INITIALIZED
(N'PWAIT_DIRECTLOGCONSUMER_GETNEXT'), -- https://www.sqlskills.com/help/waits/PWAIT_DIRECTLOGCONSUMER_GETNEXT
(N'PWAIT_EXTENSIBILITY_CLEANUP_TASK'), -- https://www.sqlskills.com/help/waits/PWAIT_EXTENSIBILITY_CLEANUP_TASK
(N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP'), -- https://www.sqlskills.com/help/waits/QDS_PERSIST_TASK_MAIN_LOOP_SLEEP
(N'QDS_ASYNC_QUEUE'), -- https://www.sqlskills.com/help/waits/QDS_ASYNC_QUEUE
(N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP'), -- https://www.sqlskills.com/help/waits/QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP
(N'QDS_SHUTDOWN_QUEUE'), -- https://www.sqlskills.com/help/waits/QDS_SHUTDOWN_QUEUE
(N'REDO_THREAD_PENDING_WORK'), -- https://www.sqlskills.com/help/waits/REDO_THREAD_PENDING_WORK
(N'REQUEST_FOR_DEADLOCK_SEARCH'), -- https://www.sqlskills.com/help/waits/REQUEST_FOR_DEADLOCK_SEARCH
(N'RESOURCE_QUEUE'), -- https://www.sqlskills.com/help/waits/RESOURCE_QUEUE
(N'SERVER_IDLE_CHECK'), -- https://www.sqlskills.com/help/waits/SERVER_IDLE_CHECK
(N'SLEEP_BPOOL_FLUSH'), -- https://www.sqlskills.com/help/waits/SLEEP_BPOOL_FLUSH
(N'SLEEP_DBSTARTUP'), -- https://www.sqlskills.com/help/waits/SLEEP_DBSTARTUP
(N'SLEEP_DCOMSTARTUP'), -- https://www.sqlskills.com/help/waits/SLEEP_DCOMSTARTUP
(N'SLEEP_MASTERDBREADY'), -- https://www.sqlskills.com/help/waits/SLEEP_MASTERDBREADY
(N'SLEEP_MASTERMDREADY'), -- https://www.sqlskills.com/help/waits/SLEEP_MASTERMDREADY
(N'SLEEP_MASTERUPGRADED'), -- https://www.sqlskills.com/help/waits/SLEEP_MASTERUPGRADED
(N'SLEEP_MSDBSTARTUP'), -- https://www.sqlskills.com/help/waits/SLEEP_MSDBSTARTUP
(N'SLEEP_SYSTEMTASK'), -- https://www.sqlskills.com/help/waits/SLEEP_SYSTEMTASK
(N'SLEEP_TASK'), -- https://www.sqlskills.com/help/waits/SLEEP_TASK
(N'SLEEP_TEMPDBSTARTUP'), -- https://www.sqlskills.com/help/waits/SLEEP_TEMPDBSTARTUP
(N'SNI_HTTP_ACCEPT'), -- https://www.sqlskills.com/help/waits/SNI_HTTP_ACCEPT
(N'SOS_WORK_DISPATCHER'), -- https://www.sqlskills.com/help/waits/SOS_WORK_DISPATCHER
(N'SP_SERVER_DIAGNOSTICS_SLEEP'), -- https://www.sqlskills.com/help/waits/SP_SERVER_DIAGNOSTICS_SLEEP
(N'SQLTRACE_BUFFER_FLUSH'), -- https://www.sqlskills.com/help/waits/SQLTRACE_BUFFER_FLUSH
(N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP'), -- https://www.sqlskills.com/help/waits/SQLTRACE_INCREMENTAL_FLUSH_SLEEP
(N'SQLTRACE_WAIT_ENTRIES'), -- https://www.sqlskills.com/help/waits/SQLTRACE_WAIT_ENTRIES
(N'VDI_CLIENT_OTHER'), -- https://www.sqlskills.com/help/waits/VDI_CLIENT_OTHER
(N'WAIT_FOR_RESULTS'), -- https://www.sqlskills.com/help/waits/WAIT_FOR_RESULTS
(N'WAITFOR'), -- https://www.sqlskills.com/help/waits/WAITFOR
(N'WAITFOR_TASKSHUTDOWN'), -- https://www.sqlskills.com/help/waits/WAITFOR_TASKSHUTDOWN
(N'WAIT_XTP_RECOVERY'), -- https://www.sqlskills.com/help/waits/WAIT_XTP_RECOVERY
(N'WAIT_XTP_HOST_WAIT'), -- https://www.sqlskills.com/help/waits/WAIT_XTP_HOST_WAIT
(N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG'), -- https://www.sqlskills.com/help/waits/WAIT_XTP_OFFLINE_CKPT_NEW_LOG
(N'WAIT_XTP_CKPT_CLOSE'), -- https://www.sqlskills.com/help/waits/WAIT_XTP_CKPT_CLOSE
(N'XE_DISPATCHER_JOIN'), -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_JOIN
(N'XE_DISPATCHER_WAIT'), -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_WAIT
(N'XE_TIMER_EVENT') -- https://www.sqlskills.com/help/waits/XE_TIMER_EVENT
     
--select * from #tmpPriorStats where wait_type in (select wait_type_name from @WaitTypeExceptions)
--return 

drop table if exists #tmpPriorStats
drop table if exists #tmpCurrentStats

-- prime tmp1 & tmp2 
select * 
into #tmpPriorStats
from sys.dm_os_wait_stats 

select * 
into #tmpCurrentStats
from sys.dm_os_wait_stats 

-- init temp table if it does not exists
IF OBJECT_ID('LOG.OsWaitStats') IS NULL
select 
	getdate() as asofdate,
	t1.* , 
	0 as diff_Wait_Count,
	0 as diff_Wait_time,
	0 as diff_Max_Wait_time,
	0 as diff_signal_time,
	0 avg_wait_time
into LOG.OsWaitStats 
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
		select -- the wait stat that has changed since last check 
			t1.* , 
			t2.waiting_tasks_count - t1.waiting_tasks_count task_Count_Delta,
			t2.wait_time_ms-t1.wait_time_ms wait_time_Delta,
			t2.max_wait_time_ms-t1.max_wait_time_ms max_wait_time_Delta,
			t2.signal_wait_time_ms-t1.signal_wait_time_ms signal_time_Delta,
			cast(t1.wait_time_ms as decimal(20,2)) / cast(t1.waiting_tasks_count as decimal(20,2)) as avg_wait_time
	from 
		#tmpPriorStats t1 
		join #tmpCurrentStats t2 on t2.wait_type = t1.wait_type
	where 
		(t2.waiting_tasks_count <> 0 or t2.wait_time_ms <> 0 or t2.max_wait_time_ms <> 0 or t2.signal_wait_time_ms <> 0 ) 
	) 
	insert into LOG.OsWaitStats	select getdate() , * 
	from x where task_Count_Delta + wait_time_Delta + max_wait_time_Delta + signal_time_Delta <> 0 

	-- move new to cache	
	delete #tmpPriorStats

	insert into #tmpPriorStats select * from #tmpCurrentStats order by wait_time_ms desc

    set @counter = @counter+1

end


-- final results

;
WITH ReportData as ( 
	select *,
	ROW_NUMBER() OVER (PARTITION BY WAIT_TYPE ORDER BY ASOFDATE ASC) AS FLAG_FIRST, 
	ROW_NUMBER() OVER (PARTITION BY WAIT_TYPE ORDER BY ASOFDATE ASC) AS FLAG_LAST
	from LOG.OsWaitStats 
	--where wait_type like 'Laz%'
)
select 
	IIF(Ignorable.wait_type_name IS NULL, '', 'IGNORABLE') as IGNORABLE,
	ReportData.*,
	cast(case 
			when diff_wait_count > 0 
			then cast(diff_wait_time as decimal(20,2)) / cast(diff_wait_count as decimal(20,2)) end 
		as decimal(20,2)) as new_avg_wait_time_ms,
	case 
		when avg_wait_time > 0 AND diff_wait_count > 0
		then ( cast(diff_wait_time as decimal(20,2)) / cast(diff_wait_count as decimal(20,2)) 	) / cast(avg_wait_time as decimal(20,2))  
	end as RateOfChange
from 
	ReportData 
	LEFT JOIN @WaitTypeExceptions Ignorable ON ReportData.wait_type = Ignorable.wait_type_name
where -- something changed 	
	(diff_wait_count > 0 
	AND (diff_wait_time > 0 or diff_max_wait_time > 0 or diff_signal_time <> 0))
	-- AND (FLAG_FIRST=1 or FLAG_LAST = 1 OR FLAG_FIRST=2 OR FLAG_LAST=2) -- wip!
	AND Ignorable.wait_type_name IS NULL 

order by	
	wait_type, 
	asofdate
	
--
--==================================================
return 

select * from sys.dm_os_wait_stats
select 
	[session_id] --of the session associated with the suspended thread.
	--, [execution_context_id] --of the task associated with the suspended thread. If there
		--is more than one execution_context_id associated with a single session_id
		--then SQL Server has parallelized the task.
	, wait_type --– the current wait type for the suspended thread.
	, wait_duration_ms --– length of time, in ms, that the suspended thread has waited
		--for the current wait type.
	, blocking_session_id --– reveals the session_id associated with the blocking
			--thread, if a thread is suspended due to blocking, for example because it is waiting to
			--acquire a lock.
	, resource_description --– for some types of resource, a description
from sys.dm_os_waiting_tasks 
order by 2


exec sp_who2

-- wait times and types for currently blocked requests also appear in 
select * from sys.dm_exec_requests

-- blocking :
SELECT blocking.session_id AS blocking_session_id ,
blocked.session_id AS blocked_session_id ,
waitstats.wait_type AS blocking_resource ,
waitstats.wait_duration_ms ,
waitstats.resource_description ,
blocked_cache.text AS blocked_text ,
blocking_cache.text AS blocking_text
FROM sys.dm_exec_connections AS blocking
INNER JOIN sys.dm_exec_requests blocked
ON blocking.session_id = blocked.blocking_session_id
CROSS APPLY sys.dm_exec_sql_text(blocked.sql_handle)
blocked_cache
CROSS APPLY sys.dm_exec_sql_text(blocking.most_recent_sql_handle)
blocking_cache
INNER JOIN sys.dm_os_waiting_tasks waitstats
ON waitstats.session_id = blocked.session_id


-- cpu UNDER PRESSURE ? - CHECK 
SELECT SUM(signal_wait_time_ms) AS TotalSignalWaitTime ,
( SUM(CAST(signal_wait_time_ms AS NUMERIC(20, 2)))
/ SUM(CAST(wait_time_ms AS NUMERIC(20, 2))) * 100 )
AS PercentageSignalWaitsOfTotalTime
FROM sys.dm_os_wait_stats

-- DRILL DOWN TO THE VARIOUS sqlos sCHEDULERS (1 PER CPU) 
SELECT scheduler_id ,
current_tasks_count ,
runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255