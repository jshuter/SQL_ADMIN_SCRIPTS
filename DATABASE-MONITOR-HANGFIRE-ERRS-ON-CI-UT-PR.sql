-- HANGFIRE ERROR MONITORING -- 

--select DATEPART(hour,logged) [Hour], min(logged) MinDate,max(logged) MaxDate, count(*) [Number Of Errors], Logger, callsite, left(exception, 100) 
--from CI.ElectrumPersistent.log.MessageLog 
--where level = 'Error'
--AND Logger like 'Hangfire%'
--AND Logged > dateadd(D, -10, getdate()) 
--group by Logger, callsite, left(exception, 100), DATEPART(hour,logged)
--order by 2 desc 

--DECLARE @Days INT = 0 -- 0 == Todays messages 
DECLARE @Days INT = 1 -- 1 == Todays and Yesterdays messages 

-- 
select * from CI.ElectrumPersistent.log.MessageLog 
where level = 'Error'
AND Logger like '%Hangfire%'
AND Logged > dateadd(D, -@Days, CAST(getdate() as DATE))
order by id desc


-- 
select * from UT.ElectrumPersistent.log.MessageLog 
where level = 'Error'
AND Logger like '%Hangfire%'
AND Logged > dateadd(D, -@Days, CAST(getdate() as DATE))
order by id desc


select * from PR.ElectrumPersistent.log.MessageLog 
where level = 'Error'
AND Logger like '%Hangfire%'
AND Logged > dateadd(D, -@Days, CAST(getdate() as DATE))
order by id desc 
