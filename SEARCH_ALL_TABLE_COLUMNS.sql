USE SMTR
GO 

DROP TABLE IF EXISTS ##TMP_JEFFS_REPORT

select 'COLUMN                                                                                                  ' as Column_Name, 0 as [Count] 
INTO ##TMP_JEFFS_REPORT

DECLARE db_cursor CURSOR 
FOR 
select 'INSERT INTO ##TMP_JEFFS_REPORT 
SELECT ''' + TABLE_SCHEMA + '.' + TABLE_NAME + '.' + COLUMN_NAME + ''' as C, COUNT(*) as N
FROM ' + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + ' WHERE ' + COLUMN_NAME + '=''FX Hedging''' 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE like '%char%'

declare @CMD nvarchar(2000) 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @CMD  

WHILE @@FETCH_STATUS = 0  
BEGIN 
	print @CMD
	EXEC sp_executeSql @CMD
    FETCH NEXT FROM db_cursor INTO @CMD
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

SELECT * FROM ##TMP_JEFFS_REPORT 
WHERE [COUNT] > 0 
ORDER BY COLUMN_NAME

DROP TABLE ##TMP_JEFFS_REPORT 