USE MASTER 
GO 


SELECT name, physical_name [File_Name], size File_Size, 
CAST(size as decimal(24,0))  * 8192 as kbs,

	CASE WHEN max_size <> -1 
		THEN CAST(max_size as decimal(24,0)) * 8192 
		ELSE -1 END 		as MAX_kbs,
* FROM Sys.master_files
order by size desc



