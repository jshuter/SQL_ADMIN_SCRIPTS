-- list all backups from preior week 
DECLARE @Days int = 10
DECLARE @AsOfDate datetime = getdate()

;
USE MSDB 
; 
WITH DATA AS ( 
	SELECT 
	   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
	   msdb.dbo.backupset.database_name, 
	   msdb.dbo.backupset.backup_start_date, 
	   msdb.dbo.backupset.backup_finish_date, 
	   DATEDIFF(D,msdb.dbo.backupset.backup_finish_date, @AsOfDate) DDIFF,
	   msdb.dbo.backupset.expiration_date, 
	   CASE msdb..backupset.type 
		  WHEN 'D' THEN 'Database' 
		  WHEN 'L' THEN 'Log' 
		  END AS backup_type, 
	   msdb.dbo.backupset.backup_size, 
	   msdb.dbo.backupmediafamily.logical_device_name, 
	   msdb.dbo.backupmediafamily.physical_device_name, 
	   msdb.dbo.backupset.name AS backupset_name, 
	   msdb.dbo.backupset.description 
	FROM 
	   msdb.dbo.backupmediafamily 
	   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
	WHERE 
	   (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= @AsOfDate -1 * @days) 
	   AND msdb..backupset.type = 'D'
), 
SERIES as ( 
	SELECT server,database_name, cast(backup_finish_date as DATE) bkp_date, DDIFF, backup_size , 
	backup_size - lag(backup_size, 1) over (partition by database_name order by backup_finish_date) growth 
	FROM DATA 
) 
SELECT * ,  CAST(growth/backup_size as decimal(10,4)) growth_rate  
FROM SERIES 
-- order by 7 desc -- database_name
order by database_name, ddiff


