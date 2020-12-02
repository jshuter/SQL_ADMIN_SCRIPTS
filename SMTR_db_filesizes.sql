select @@SERVERNAME

select size, name collate SQL_Latin1_General_CP1_CI_AS, filename collate SQL_Latin1_General_CP1_CI_AS from smtr.sys.sysfiles
UNION select size, name collate SQL_Latin1_General_CP1_CI_AS, filename collate SQL_Latin1_General_CP1_CI_AS from smtr_audit.sys.sysfiles
UNION select size, name collate SQL_Latin1_General_CP1_CI_AS, filename collate SQL_Latin1_General_CP1_CI_AS from smtr_staging.sys.sysfiles
UNION select size, name collate SQL_Latin1_General_CP1_CI_AS, filename collate SQL_Latin1_General_CP1_CI_AS from INVESTMENTS_DW.sys.sysfiles
go 

EXEC MASTER..xp_fixeddrives
GO

select * from smtr_audit.sys.sysfiles


-- TESTING RESTORE 

SELECT @@Servername 