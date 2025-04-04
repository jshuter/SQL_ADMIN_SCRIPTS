-- run as INNVEST_APP for monitor of Production 

use tempdb 

SELECT TBL.name AS ObjName 
      ,STAT.row_count AS StatRowCount 
      ,STAT.used_page_count * 8 AS UsedSizeKB 
      ,STAT.reserved_page_count * 8 AS RevervedSizeKB 
FROM tempdb.sys.partitions AS PART 
     INNER JOIN tempdb.sys.dm_db_partition_stats AS STAT 
         ON PART.partition_id = STAT.partition_id 
            AND PART.partition_number = STAT.partition_number 
     INNER JOIN tempdb.sys.tables AS TBL 
         ON STAT.object_id = TBL.object_id 
ORDER BY UsedSizeKB desc, TBL.name;

RETURN 

exec sp_tables_info_rowset2_64 @Table_Type = 'TABLE'