-- GET DATABASE BACKUP INFO 

use master; 
go

-- escaped '?' to display global unquoted literal string literal - DB_NAME
declare @cmd varchar(500)  
set @cmd='PRINT ''?'''  
EXECUTE sp_msforeachdb @cmd 

GO 

-- pass db_name as arg 
declare @cmd varchar(500)  
set @cmd='USE ?; PRINT DB_NAME();'  
EXECUTE sp_msforeachdb @cmd 

GO 

-- get diskspace for each db 
declare @cmd varchar(500)  
set @cmd='USE ?; exec sp_spaceused @OneResultSet=1;'  
EXECUTE sp_msforeachdb @cmd 




RETURN 


use msdb 

SELECT * FROM backupfile WHERE logical_name = 'SMTR' AND BACKUP_SIZE > 0 

SELECT TOP 1000 * FROM backupset WHERE database_name = 'SMTR' AND TYPE <> 'l' ORDER BY backup_start_date DESC 

