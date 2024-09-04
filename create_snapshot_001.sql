/* 
ALTER procedure #my_stats(@table_name varchar(40)) 
AS
BEGIN 
	
	SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
	ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
	indexstats.avg_fragmentation_in_percent 
	FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID(@table_name), NULL, NULL, NULL) indexstats 
	INNER JOIN sys.indexes ind  
	ON ind.object_id = indexstats.object_id 
	AND ind.index_id = indexstats.index_id 
	WHERE indexstats.avg_fragmentation_in_percent > 30 
	ORDER BY indexstats.avg_fragmentation_in_percent DESC
END 
*/

-- REPORT ON TABLES MOST FREQUENTL INLCUDED IN SLOW QUERIES !
SELECT COUNT(*) FROM client_scouts_external_volunteer_screening
exec #my_stats 'client_scouts_external_volunteer_screening'
SELECT COUNT(*) FROM client_scouts_member_account
exec #my_stats 'client_scouts_member_account' 
SELECT COUNT(*) FROM co_customer
exec #my_stats 'co_customer'
SELECT COUNT(*) FROM co_customer_x_phone
exec #my_stats 'co_customer_x_phone'
SELECT COUNT(*) FROM co_individual
exec #my_stats 'co_individual'	
SELECT COUNT(*) FROM co_individual_ext
exec #my_stats 'co_individual_ext'
SELECT COUNT(*) FROM 
exec #my_stats 'co_individual_x_organization'
SELECT COUNT(*) FROM 
exec #my_stats 'co_individual_x_organization_ext'
SELECT COUNT(*) FROM 
exec #my_stats 'co_organization'				
SELECT COUNT(*) FROM 
exec #my_stats 'co_organization_ext'
SELECT COUNT(*) FROM 
exec #my_stats 'co_phone'
SELECT COUNT(*) FROM 
exec #my_stats 'co_phone_type'
SELECT COUNT(*) FROM 
exec #my_stats 'mb_member_type'
SELECT COUNT(*) FROM 
exec #my_stats 'org_hierarchy_hash_ext'









SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_customer'), NULL, NULL, NULL) indexstats 

select OBJECT_ID('co_individual')

-----

SELECT  creation_time 
        ,last_execution_time
        ,total_physical_reads
        ,total_logical_reads 
        ,total_logical_writes
        , execution_count
        , total_worker_time
        , total_elapsed_time
        , total_elapsed_time / execution_count avg_elapsed_time
        ,SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
         ((CASE statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
          ELSE qs.statement_end_offset END
            - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY total_elapsed_time / execution_count DESC;



