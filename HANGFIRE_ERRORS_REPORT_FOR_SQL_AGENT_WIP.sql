SELECT TOP (50) 'CI', 
	smtr.tools.UtcToLocal(MIN(createdAt)) FirstEasternDateTime, 
	smtr.tools.UtcToLocal(max(createdAt)) LastEasternDateTime, 
	COUNT(*) ErrorCount, 
	Reason, 
	CAST(min(createdAt) as date) FirstDate, 
	max(createdAt) LastDateTime, 
	SUBSTRING(DATA, PATINDEX('%ExceptionType%',Data), 1000) as Message
FROM 
	ci.[ElectrumPersistent].[HangFire].[State]
WHERE 
	CreatedAt > DATEADD(D, -7, getdate())
	and name = 'failed'
GROUP BY REASON, SUBSTRING(DATA, PATINDEX('%ExceptionType%',Data), 1000)
ORDER BY LastDateTime DESC 

SELECT TOP (50) 'UT', 
	smtr.tools.UtcToLocal(MIN(createdAt)) FirstEasternDateTime, 
	smtr.tools.UtcToLocal(max(createdAt)) LastEasternDateTime, 
	COUNT(*) ErrorCount, 
	Reason, 
	CAST(min(createdAt) as date) FirstDate, 
	max(createdAt) LastDateTime, 
	SUBSTRING(DATA, PATINDEX('%ExceptionType%',Data), 1000) as Message
FROM 
	UT.[ElectrumPersistent].[HangFire].[State]
WHERE 
	CreatedAt > DATEADD(D, -7, getdate())
	and name = 'failed'
GROUP BY REASON, SUBSTRING(DATA, PATINDEX('%ExceptionType%',Data), 1000)
ORDER BY LastDateTime DESC 


SELECT TOP (50) 'PR',
	smtr.tools.UtcToLocal(MIN(createdAt)) FirstEasternDateTime, 
	smtr.tools.UtcToLocal(max(createdAt)) LastEasternDateTime, 
	COUNT(*) ErrorCount, 
	Reason, 
	CAST(min(createdAt) as date) FirstDate, 
	max(createdAt) LastDateTime, 
	SUBSTRING(DATA, PATINDEX('%ExceptionType%',Data), 1000) as Message
FROM 
	PR.[ElectrumPersistent].[HangFire].[State]
WHERE 
	CreatedAt > DATEADD(D, -7, getdate())
	and name = 'failed'
GROUP BY REASON, SUBSTRING(DATA, PATINDEX('%ExceptionType%',Data), 1000)
ORDER BY LastDateTime DESC 


RETURN 


SELECT TOP (50) 'UT', smtr.tools.UtcToLocal(createdat) CreatedAt, substring(Data, 200, 1000),*
FROM 	UT.[ElectrumPersistent].[HangFire].[State]
WHERE	CreatedAt > DATEADD(D, -7, getdate())	and name = 'failed'
ORDER BY 3
