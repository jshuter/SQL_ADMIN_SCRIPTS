checkpoint 

-- select * from sys.database_files

DBCC SQLPERF(logspace)
DBCC SHRINKFILE(2) -- ID 2 >> ('D:\SQLLOGS\netforumscoutsdev.ldf')
DBCC SQLPERF(logspace)

