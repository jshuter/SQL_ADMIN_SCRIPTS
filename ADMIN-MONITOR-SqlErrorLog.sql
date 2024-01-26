-- KEEPER

-- set the LINKERD SERVER FOR CI, PR, or UT  

USE SMTR 
GO 
declare @enddate datetime = getdate()
declare @startdate datetime = dateadd(D , -14, @enddate)

;
WITH DATA AS ( 
	SELECT
		Level,
		count(*) [Count], 
		CAST(Logged as DATE) as LogDate,
		logger, 
		callsite
	FROM 
		CI.ElectrumPersistent.LOG.MessageLog 
	WHERE 
		logged BETWEEN @StartDate AND @EndDate
		AND Level not in ('Trace', 'Info', 'Debug')
	GROUP BY 
		Level, logger, callsite, CAST(Logged as DATE)
) 
SELECT * FROM TOOLS.GetDates(@startDate, @EndDate, 'd') D
JOIN DATA on DATA.LogDate = D.FullDate
ORDER BY D.FullDate desc, Level, logger, Callsite


--- details 

SELECT
	* 
FROM 
	CI.ElectrumPersistent.LOG.MessageLog 
WHERE 
	logged BETWEEN @StartDate AND @EndDate
	AND Level not in ('Trace', 'Info', 'Debug', 'Warn')
	AND exception like '%GtssTraderFolderJob%'



--Hangfire.Storage.DistributedLockTimeoutException: Timeout expired. The timeout elapsed prior to obtaining a distributed lock on the 'HangFire:GtssTraderFolderJob.Run' resource.     at Hangfire.SqlServer.SqlServerDistributedLock.Acquire(IDbConnection connection, String resource, TimeSpan timeout)     at Hangfire.SqlServer.SqlServerConnection.AcquireLock(String resource, TimeSpan timeout)     at Hangfire.SqlServer.SqlServerConnection.AcquireDistributedLock(String resource, TimeSpan timeout)     at Hangfire.DisableConcurrentExecutionAttribute.OnPerforming(PerformingContext filterContext)     at Hangfire.Profiling.ProfilerExtensions.InvokeAction[TInstance](InstanceAction`1 tuple)     at Hangfire.Profiling.SlowLogProfiler.InvokeMeasured[TInstance,TResult](TInstance instance, Func`2 action, String message)     at Hangfire.Profiling.ProfilerExtensions.InvokeMeasured[TInstance](IProfiler profiler, TInstance instance, Action`1 action, String message)     at Hangfire.Server.BackgroundJobPerformer.InvokePerformFilter(IServerFilter filter, PerformingContext preContext, Func`1 continuation)
