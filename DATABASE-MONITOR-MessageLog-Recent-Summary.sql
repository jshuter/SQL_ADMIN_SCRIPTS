-- SUMMARY ERROR COUNTS OVER RECENT 20 DAYS 

		--SELECT level L, count(*) C, cast(logged as date) D
		--from ElectrumPersistent.LOG.MessageLog
		--where --message not like 'Failed to load prices%'
		----AND 
		--Logged > dateadd(D, -10, getdate()) 
		--group by level , cast(logged as date) 

-- 'Debug','Error','Info','Trace','Warn'

; WITH DATA AS ( 
	SELECT *
	FROM (
		SELECT *, cast(logged as date) D
		from ElectrumPersistent.LOG.MessageLog
		where 
		--message not like 'Failed to load prices%' AND 
		Logged > dateadd(D, -10, getdate()) 
	) AS SourceTable
	PIVOT (
		COUNT(Level) 
		FOR Level IN (
			[Debug],[Error],[Info],[Trace],[Warn]
		)
	) AS PivotTable
) SELECT 
	D LoggedDate, 
	SUM(Error) as Error, 
	SUM(Warn) as Warn, 
	SUM(Info) as Info, 
	SUM(Trace) as Trace,
	SUM(Debug) as Debug
FROM DATA
GROUP BY D
ORDER BY D DESC 


select * from ElectrumPersistent.LOG.MessageLog 
where level = 'error' and logged > dateadd(D, -30, getdate())
AND message not like 'Failed to load prices%' 
AND message not like 'Failed to process the job%'
--and logger not like 'hang%'
order by logged desc 
