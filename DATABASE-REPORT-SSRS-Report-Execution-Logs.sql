USE [ReportServer] 

declare @Since Date = '2024-10-01'
declare @RdlName varchar(100) = '%card%'

SELECT top 100 c.[name] as reportName 
       ,e.username as userExec 
       ,e.TimeStart 
       ,e.TimeEnd 
       ,DATEDIFF(ss,e.TimeStart,e.TimeEnd) as TimeInSeconds 
       ,e.Parameters 
       ,c.ModifiedDate as ReportLastModified 
       ,u.username as userCreated 
FROM catalog c 
       INNER JOIN executionlogstorage e on c.itemid = e.reportid 
       INNER JOIN users u on c.modifiedbyid = u.userid 
WHERE e.TimeStart >= @Since
       AND c.[name] like ISNULL( @RdlName, c.[name])
	   and cast(TimeStart as time) > '22:00:00.000'
ORDER BY 
--	c.name,
	timestart DESC

return 

SELECT top 100 c.[name] as reportName 
       ,e.username as userExec 
       ,e.TimeStart 
       ,e.TimeEnd 
       ,DATEDIFF(ss,e.TimeStart,e.TimeEnd) as TimeInSeconds 
       ,e.Parameters 
       ,c.ModifiedDate as ReportLastModified 
       ,u.username as userCreated 
FROM catalog c 
       INNER JOIN executionlogstorage e on c.itemid = e.reportid 
       INNER JOIN users u on c.modifiedbyid = u.userid 
WHERE e.TimeStart >= @Since
       AND c.[name] like ISNULL( @RdlName, c.[name])
ORDER BY 
	--c.name,
	timestart DESC



use smtr
select top 1000 1, cast(Execution_Time as date) edate, cast(execution_time as time) etime, * from ctrl.Stored_Procedure_Tracking_Detail 
where Execution_Time between '2024-10-09 23:00:00.000' and '2024-10-10 02:00:00.000'
and Stored_Proc_Name like '%card%' 
or db = 'ElectrumWarehouse'
--UNION 
select top 1000 2, cast(Execution_Time as date) edate, cast(execution_time as time) etime, * from ctrl.Stored_Procedure_Tracking_Detail 
where Execution_Time between '2024-10-08 23:00:00.000' and '2024-10-09 02:00:00.000'
and Stored_Proc_Name like '%card%' 
or db = 'ElectrumWarehouse'
--UNION 
select top 1000 3, cast(Execution_Time as date) edate, cast(execution_time as time) etime, * from ctrl.Stored_Procedure_Tracking_Detail 
where Execution_Time between '2024-10-02 23:00:00.000' and '2024-10-09 03:00:00.000'
and Stored_Proc_Name like '%card%' 
or db = 'ElectrumWarehouse'
order by Execution_Time desc 



select top 1000 * from ElectrumWarehouse.fact.PrivateReportCardMainFacts where As_Of_Date = '2023-12-31' 
order by EffectiveDate desc 
