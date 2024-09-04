select physical_name pm,  * from sys.database_files
select physical_name pm,* from sys.master_files
select filename fn,  * from sys.sysaltfiles
select filename fn, * from sys.sysfiles

select 'db' file_type, physical_name pm from sys.database_files
union select 'master',  physical_name pm from sys.master_files
union select 'sysalt',  filename fn from sys.sysaltfiles
union select 'sys', filename fn from sys.sysfiles
order by 2, 1


;with x as ( 
select 'db' file_type, physical_name fullpathfilename from sys.database_files
union select 'master',  physical_name pm from sys.master_files
union select 'sysalt',  filename fn from sys.sysaltfiles
union select 'sys', filename fn from sys.sysfiles
) 
select distinct fullpathfilename  from x



