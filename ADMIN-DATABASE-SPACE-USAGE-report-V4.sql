
 DBCC SQLPERF (LOGSPACE) -- Extra space report for all db LOGs

--------------------------------------------------------------------------------- 
--Database Backups for all databases For Previous X Weeks
--------------------------------------------------------------------------------- 
DECLARE @Weeks int = 52 
DECLARE @dbname varchar(100) -- = 'smtr' 

SELECT 
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name, 
   datepart(day,msdb.dbo.backupset.backup_start_date) start_day, 
   msdb.dbo.backupset.backup_start_date, 
   msdb.dbo.backupset.backup_finish_date, 
   msdb.dbo.backupset.expiration_date, 
   CASE msdb..backupset.type 
      WHEN 'D' THEN 'Database' 
      WHEN 'L' THEN 'Log' 
      END AS backup_type, 
   msdb.dbo.backupset.backup_size, 
   msdb.dbo.backupset.compressed_backup_size,
   msdb.dbo.backupmediafamily.logical_device_name, 
   msdb.dbo.backupmediafamily.physical_device_name, 
   msdb.dbo.backupset.name AS backupset_name, 
   msdb.dbo.backupset.description, 
   msdb.dbo.backupmediafamily.*
FROM 
   msdb.dbo.backupmediafamily 
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE 
   (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - (7 * @Weeks)) 
   AND type = 'D'
   AND msdb.dbo.backupset.database_name = ISNULL(@dbname,  msdb.dbo.backupset.database_name)
   AND datepart(day,msdb.dbo.backupset.backup_start_date) = 1
ORDER BY 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_finish_date 
