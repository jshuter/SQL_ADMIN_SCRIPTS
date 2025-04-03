


use ReportServer

select * from Catalog where itemid = '4A41221D-0A35-4BBF-9919-97A82EAC813E'

select * from Catalog C JOIN 
dbo.ExecutionLog L on L.ReportID = C.ItemID
Where C.Name in ('Private Portfolio Detail','Private Portfolio Summary','Public Portfolio Detail','Private Portfolio Summary')


select name, cast(min(timestart) as date) ,cast (max(timestart) as date) , count(*) executions from Catalog C JOIN 
dbo.ExecutionLog L on L.ReportID = C.ItemID
Where 
C.Name LIKE '%Private Portfolio %'	OR 
C.Name LIKE '%Public Portfolio %' OR
C.Name LIKE '%CMPA%'	
group by name
order by 1


