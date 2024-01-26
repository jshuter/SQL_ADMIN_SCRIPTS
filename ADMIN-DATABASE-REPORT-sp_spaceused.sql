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










