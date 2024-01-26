if(1=2)
BEGIN 
	select 
		DatabaseName, 
		CAST(StartTime as DATE) [day], 
		DATEPART(HOUR, StartTime) [hour], 
		MIN(StartTime) Min_Start_Time, 
		MAX(EndTime) Max_End_Time, 
		DATEDIFF(MINUTE, MIN(StartTime), MAX(EndTime)) ddiff
	from [Maintenance].[dbo].[CommandLog] --order by endtime desc
	WHERE
	StartTime > '2021-10-10'
	and DatabaseName in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
	Group BY 
		DatabaseName, 
		CAST(StartTime as DATE),
		DATEPART(HOUR, StartTime)
	order by
	DatabaseName, 
	CAST(StartTime as DATE),
	MIN(StartTime)
END 




if(1=1)
BEGIN 
	select DatabaseName, StartTime, EndTime, 
	datediff(MINUTE, starttime, EndTime) LOG_BACKUP_Duration,
	CommandType, Command
	from [Maintenance].[dbo].[CommandLog] --order by endtime desc
	WHERE
	StartTime between '2021-07-22 06:00' AND '2021-11-22 14:00'
	and DatabaseName ='smtr_staging' --in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
	and CommandType = 'backup_log'
	order by StartTime
END 


select DatabaseName, MIN(StartTime), MAX(EndTime), DATEDIFF(MINUTE, MIN(StartTime), MAX(EndTime))
from [Maintenance].[dbo].[CommandLog] --order by endtime desc
WHERE
StartTime > '2021-11-10'
and DatabaseName = 'SMTR_Staging' --in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
Group BY DatabaseName, DAY(StartTime), DATEPART(HOUR, StartTime)
order by
DatabaseName, MIN(StartTime)
