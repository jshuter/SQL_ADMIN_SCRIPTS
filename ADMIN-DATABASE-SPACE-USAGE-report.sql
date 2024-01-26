-- testing foreach 

drop table if exists #tmp1
use smtr 
create table #tmp1 ( 	
	dbname varchar(100), 
	dbsize varchar(100), 
	unallocated_space varchar(100), 
	reserved varchar(100), 
	data_space varchar(100), 
	index_size varchar(100), 
	unused varchar(100)
) 

-- get diskspace for each db 
declare @cmd varchar(500)  
set @cmd='USE ?;insert into #tmp1 exec sp_spaceused @OneResultSet=1;'  
EXECUTE sp_msforeachdb @cmd 
;

TOP1:

INSERT INTO ElectrumWarehouse.FACT.DatabaseSpaceReport
SELECT	
	CAST(getdate() AS DATE) AsOfDate, 
	*,
	TOOLS.ParseSize(dbsize) DatabaseSize,
	TOOLS.ParseSize(unallocated_space) UnallocatedSize,
	TOOLS.ParseSize(reserved) ReservedSize, 
	TOOLS.ParseSize(data_space) DataSize, 
	TOOLS.ParseSize(index_size) IndexSize,
	TOOLS.ParseSize(unused) UnusedSize, 
	getdate() as EffectiveDate
FROM #tmp1
ORDER BY DatabaseSize DESC

-- SELECT * from #tmp1
select * from ElectrumWarehouse.FACT.DatabaseSpaceReport