-- USE on each server 

--exec sys.sp_spaceused @mode='all', @oneresultset=1
use smtr
; 
with x as 
(
	SELECT DB_NAME(database_id) AS database_name, 
		name AS FileName, 
		CAST(size/128.0 AS DECIMAL(10,1)) AS CurrentSizeMB, 
		size Pagesx1000,
		* 
	FROM sys.master_files
) SElect * from x 
where x.database_name not in ('master', 'tempdb', 'model', 'msdb')
order by 3 desc


