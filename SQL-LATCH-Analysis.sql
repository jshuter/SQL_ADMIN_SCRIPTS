use smtr 

/*
*******************************************************************
* QUERY * WAITING TASKS ordered by session_id
*******************************************************************
*/

SELECT wt.session_id, wt.wait_type
, er.last_wait_type AS last_wait_type
, wt.wait_duration_ms
, wt.blocking_session_id, wt.blocking_exec_context_id, resource_description
FROM sys.dm_os_waiting_tasks wt
JOIN sys.dm_exec_sessions es ON wt.session_id = es.session_id
JOIN sys.dm_exec_requests er ON wt.session_id = er.session_id
WHERE es.is_user_process = 1
AND wt.wait_type <> 'SLEEP_TASK'
ORDER BY wt.wait_duration_ms desc

/*
*******************************************************************
WAITING TASKS ordered by wait_duration_ms
******************************************************************
*/

SELECT wt.session_id, wt.wait_type
, er.last_wait_type AS last_wait_type
, wt.wait_duration_ms
, wt.blocking_session_id, wt.blocking_exec_context_id, resource_description
FROM sys.dm_os_waiting_tasks wt
JOIN sys.dm_exec_sessions es ON wt.session_id = es.session_id
JOIN sys.dm_exec_requests er ON wt.session_id = er.session_id
WHERE es.is_user_process = 1
AND wt.wait_type <> 'SLEEP_TASK'
ORDER BY wt.wait_duration_ms desc

--


/* 
*******************************************************************
-- Snapshot the current wait stats and store so that this can be compared over a time period
-- Return the statistics between this point in time and the last collection point in time.
-- **This data is maintained in tempdb so the connection must persist between each execution**
-- **alternatively this could be modified to use a persisted table in tempdb. if that
-- is changed code should be included to clean up the table at some point.**
*******************************************************************
*/

use tempdb
go

declare @current_snap_time datetime
declare @previous_snap_time datetime
set @current_snap_time = GETDATE()

if not exists(select name from tempdb.sys.sysobjects where name like '#_wait_stats%')
create table #_wait_stats
(wait_type varchar(128),waiting_tasks_count bigint,wait_time_ms bigint,avg_wait_time_ms int,max_wait_time_ms bigint,signal_wait_time_ms bigint
,avg_signal_wait_time int,snap_time datetime)

insert into #_wait_stats (	wait_type	,waiting_tasks_count	,wait_time_ms	,max_wait_time_ms	,signal_wait_time_ms	,snap_time)
select	wait_type	,waiting_tasks_count	,wait_time_ms	,max_wait_time_ms	,signal_wait_time_ms	,getdate()
from sys.dm_os_wait_stats

--get the previous collection point
select top 1 @previous_snap_time = snap_time 
	from #_wait_stats
	where snap_time < (select max(snap_time) from #_wait_stats)
	order by snap_time desc

waitfor delay '00:00:05' 

--get delta in the wait stats
select top 10
	s.wait_type
	, (e.waiting_tasks_count - s.waiting_tasks_count) as [waiting_tasks_count]
	, (e.wait_time_ms - s.wait_time_ms) as [wait_time_ms]
	, (e.wait_time_ms - s.wait_time_ms)/((e.waiting_tasks_count - s.waiting_tasks_count)) as [avg_wait_time_ms]
	, (e.max_wait_time_ms) as [max_wait_time_ms]
	, (e.signal_wait_time_ms - s.signal_wait_time_ms) as [signal_wait_time_ms]
	, (e.signal_wait_time_ms - s.signal_wait_time_ms)/((e.waiting_tasks_count - s.waiting_tasks_count)) as [avg_signal_time_ms]
	, s.snap_time as [start_time]
	, e.snap_time as [end_time]
	, DATEDIFF(ss, s.snap_time, e.snap_time) as [seconds_in_sample]
	from #_wait_stats e
		inner join (
		select * from #_wait_stats
		where snap_time = @previous_snap_time
		) s on (s.wait_type = e.wait_type)
		where
		e.snap_time = @current_snap_time
		and s.snap_time = @previous_snap_time
		and e.wait_time_ms > 0
		and (e.waiting_tasks_count - s.waiting_tasks_count) > 0
		and e.wait_type NOT IN ('LAZYWRITER_SLEEP', 'SQLTRACE_BUFFER_FLUSH'
		, 'SOS_SCHEDULER_YIELD','DBMIRRORING_CMD', 'BROKER_TASK_STOP'
		, 'CLR_AUTO_EVENT', 'BROKER_RECEIVE_WAITFOR', 'WAITFOR'
		, 'SLEEP_TASK', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT'
		, 'FT_IFTS_SCHEDULER_IDLE_WAIT', 'BROKER_TO_FLUSH', 'XE_DISPATCHER_WAIT'
		, 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP')

	order by (e.wait_time_ms - s.wait_time_ms) desc

--clean up table
	delete from #_wait_stats
	where snap_time = @previous_snap_time







----------------------------------------------------------------------------------------------------------------------------

/*
The following script queries buffer descriptors to determine which objects are associated with the longest latch wait times.
*/


IF EXISTS (SELECT * FROM tempdb.sys.objects WHERE [name] like '#WaitResources%') DROP TABLE #WaitResources;

CREATE TABLE #WaitResources (
	session_id INT, wait_type NVARCHAR(1000), wait_duration_ms INT,
	resource_description sysname NULL, db_name NVARCHAR(1000), schema_name NVARCHAR(1000),
	object_name NVARCHAR(1000), index_name NVARCHAR(1000));
GO


declare @WaitDelay varchar(16)
declare @Counter INT
declare @MaxCount INT
declare @Counter2 INT

SELECT @Counter = 0, @MaxCount = 600, @WaitDelay = '00:00:00.100' --> 600 x 00.1 = 60 seconds

SET NOCOUNT ON;

WHILE @Counter < @MaxCount BEGIN

	INSERT INTO #WaitResources(session_id, wait_type, wait_duration_ms, resource_description)--, db_name, schema_name, object_name, index_name)

	SELECT wt.session_id,
		wt.wait_type,
		wt.wait_duration_ms,
		wt.resource_description
		FROM sys.dm_os_waiting_tasks wt
		WHERE wt.wait_type LIKE 'PAGELATCH%' AND wt.session_id <> @@SPID

	--select * from sys.dm_os_buffer_descriptors
	SET @Counter = @Counter + 1;
	
	print '------------------------------'
	PRINT @waitdelay 
	print getdate()

	WAITFOR DELAY @WaitDelay;
	
END;

update #WaitResources
	set db_name = DB_NAME(bd.database_id),
		schema_name = s.name,
		object_name = o.name,
		index_name = i.name
	FROM #WaitResources wt JOIN sys.dm_os_buffer_descriptors bd
		ON bd.database_id = SUBSTRING(wt.resource_description, 0, CHARINDEX(':', wt.resource_description))
		AND bd.file_id = SUBSTRING(wt.resource_description, CHARINDEX(':', wt.resource_description) + 1, CHARINDEX(':', wt.resource_description, CHARINDEX(':', wt.resource_description) +1 ) - CHARINDEX(':', wt.resource_description) - 1)
		AND bd.page_id = SUBSTRING(wt.resource_description, CHARINDEX(':', wt.resource_description, CHARINDEX(':', wt.resource_description) +1 ) + 1, LEN(wt.resource_description) + 1)
		--AND wt.file_index > 0 AND wt.page_index > 0
		JOIN sys.allocation_units au ON bd.allocation_unit_id = AU.allocation_unit_id
		JOIN sys.partitions p ON au.container_id = p.partition_id
		JOIN sys.indexes i ON p.index_id = i.index_id AND p.object_id = i.object_id
		JOIN sys.objects o ON i.object_id = o.object_id
		JOIN sys.schemas s ON o.schema_id = s.schema_id
		select * from #WaitResources order by wait_duration_ms desc

GO


/*
--Other views of the same information
SELECT wait_type, db_name, schema_name, object_name, index_name, SUM(wait_duration_ms) [total_wait_duration_ms] FROM #WaitResources
GROUP BY wait_type, db_name, schema_name, object_name, index_name;
SELECT session_id, wait_type, db_name, schema_name, object_name, index_name, SUM(wait_duration_ms) [total_wait_duration_ms] FROM #WaitResources
GROUP BY session_id, wait_type, db_name, schema_name, object_name, index_name;
*/

-- SELECT * FROM #WaitResources

-- DROP TABLE #WaitResources;












-- NON BUFFER LATCHES 
select * from sys.dm_os_latch_stats 
where latch_class <> 'BUFFER' 
--and waiting_requests_count > 0 
and wait_time_ms > 500 
order by wait_time_ms desc 


-- Cumulative WAIT info 
-- PAGELATCH_* are ost common latches ... 

select * FROM sys.dm_os_wait_stats
where wait_type like 'PAGE%'
or wait_type like 'LATCH%' 

-- LATCH_EX & LATCH_SH >>> 
select * from sys.dm_os_latch_stats 


--
select * FROM sys.dm_os_waiting_tasks 
order by wait_type 

