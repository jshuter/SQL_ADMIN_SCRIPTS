USE SMTR 
GO 

	SELECT 	
		Level,
		DateName(MONTH,EOMONTH(logged)) AS LogMonthDate,	
		CAST(MIN(logged) AS DATE) FirstLogDate,	
		CAST(MAX(logged) AS DATE) LastLogDate,	
		COUNT(*) Occurances, 	
		message,
		COUNT(*)/(DATEDIFF(D, CAST(MIN(logged) AS DATE),CAST(MAX(logged) AS DATE)) + 1) as AveragePerDay 
	FROM 
		PR.ElectrumPersistent.log.MessageLog 
	WHERE
		logged > dateadd(D, -2, getdate())
		and level not in ('debug', 'info', 'trace')
	GROUP BY 
		source, level, message , logger, callsite, EOMONTH(logged)
	ORDER BY 
		3 desc -- Last Logged Date



	SELECT 	
*	FROM 
		PR.ElectrumPersistent.log.MessageLog 
	WHERE
		logged > dateadd(D, -2, getdate())
		and level not in ('debug', 'info', 'trace')
	ORDER BY 
		4 desc -- Last Logged Date
