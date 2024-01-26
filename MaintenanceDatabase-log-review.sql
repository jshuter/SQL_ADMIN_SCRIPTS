
SELECT 
X.*, 
datediff(minute,X.minstarttime, X.maxendtime) minmaxspread 
FROM (
select DatabaseName, MIN(StartTime) as minstarttime, MAX(EndTime) as maxendtime, DATEDIFF(MINUTE, MIN(StartTime), MAX(EndTime)) ddiff
from [Maintenance].[dbo].[CommandLog] --order by endtime desc
WHERE
StartTime > '2021-11-10'
and DatabaseName in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
Group BY DatabaseName, DAY(StartTime), DATEPART(HOUR, StartTime)
) X
WHERE datediff(minute,X.minstarttime, X.maxendtime) <> X.ddiff
order by
DatabaseName, MINStartTime desc 


-------------------------

select DatabaseName, MIN(StartTime), MAX(EndTime), DATEDIFF(MINUTE, MIN(StartTime), MAX(EndTime))
from [Maintenance].[dbo].[CommandLog] --order by endtime desc
WHERE
StartTime > '2021-11-10'
and DatabaseName = 'SMTR' --in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
Group BY DatabaseName, DAY(StartTime), DATEPART(HOUR, StartTime)
order by
DatabaseName, MIN(StartTime) desc 

select DatabaseName, MIN(StartTime), MAX(EndTime), DATEDIFF(MINUTE, MIN(StartTime), MAX(EndTime))
from [Maintenance].[dbo].[CommandLog] --order by endtime desc
WHERE
StartTime > '2021-11-10'
and DatabaseName = 'SMTR_Audit' --in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
Group BY DatabaseName, DAY(StartTime), DATEPART(HOUR, StartTime)
order by
DatabaseName, MIN(StartTime) desc


select DatabaseName, MIN(StartTime), MAX(EndTime), DATEDIFF(MINUTE, MIN(StartTime), MAX(EndTime))
from [Maintenance].[dbo].[CommandLog] --order by endtime desc
WHERE
StartTime > '2021-11-10'
and DatabaseName = 'SMTR_Staging' --in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
Group BY DatabaseName, DAY(StartTime), DATEPART(HOUR, StartTime)
order by
DatabaseName, MIN(StartTime) desc 


select DatabaseName, MIN(StartTime), MAX(EndTime), DATEDIFF(MINUTE, MIN(StartTime), MAX(EndTime))
from [Maintenance].[dbo].[CommandLog] --order by endtime desc
WHERE
StartTime > '2021-11-10'
and DatabaseName = 'Investments_Dw' --in ('SMTR', 'SMTR_AUDIT', 'SMTR_Staging', 'Investments_Dw')
Group BY DatabaseName, DAY(StartTime), DATEPART(HOUR, StartTime)
order by
DatabaseName, MIN(StartTime) desc 
