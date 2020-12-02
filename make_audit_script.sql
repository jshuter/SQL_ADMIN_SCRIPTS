use smtr_audit 

declare @sid varchar(100) = '1B643692771D512D78C613C00AFFB1E8'


;with alltables as ( 
	select table_schema as schema_name, table_name, COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME = 'SessionID'
) 


select ' if exists (SELECT * from ' + alltables.schema_name + '.' + alltables.table_name + ' WHERE SESSIONID = @sid ' + ' ) '  + 
			' SELECT * from ' + alltables.schema_name + '.' + alltables.table_name + ' WHERE SESSIONID =  @sid  '  
from alltables 
