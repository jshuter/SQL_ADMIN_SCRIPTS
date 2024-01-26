
-- LOG INTO PR to get PR data !!!
USE msdb

	declare @StartDate DateTime = dateadd(D, -5, getdate()) 

	EXEC xp_readerrorlog 0, 1 , N'Error', NULL, @startDate, NULL, 'DESC'

	EXEC xp_readerrorlog 0, 1 , N'Warning', NULL, @startDate, NULL, 'DESC'

USE smtr

	select 
		MachineName, Source, 
		min(logged) as MinLogDateTime, 
		max(LOgged) as MaxLogDateTime, 
		count(*) [Count], 
		logger, 
		callsite, 
		left(exception,300)+'...' as ExceptionMessage
	from 
		ElectrumPersistent.LOG.MessageLog 
	where level = 'error' and logged > @StartDate
	AND message not like 'Failed to load prices%' 
	group by 
		MachineName, Source, logger, callsite, left(exception,300)+'...'
	order by MaxLogDateTime desc 

return 

	select 
		level,
		MachineName, Source, 
		min(logged) as MinLogDateTime, 
		max(LOgged) as MaxLogDateTime, 
		count(*) [Count], 
		logger, 
		callsite, 
		left(exception,300)+'...' as ExceptionMessage
	from 
		ElectrumPersistent.LOG.MessageLog 
	where 
		logged > @StartDate
	AND message not like 'Failed to load prices%' 
	group by level,
		MachineName, Source, logger, callsite, left(exception,300)+'...'
	order by level, MaxLogDateTime desc 



