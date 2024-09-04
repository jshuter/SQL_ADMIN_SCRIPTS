USE smtr_staging
; 
WITH CompressionCheck
AS
(
    SELECT DISTINCT
        SCHEMA_NAME(o.schema_id) AS SchemaName,
        OBJECT_NAME(o.object_id) AS BaseTableName,
        SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(o.object_id) AS TableName,
        i.name AS IndexName,
        ps.reserved_page_count AS PageCount
    FROM sys.partitions p
    INNER JOIN sys.objects o ON
        p.object_id = o.object_id
    JOIN sys.indexes i ON
        p.object_id = i.object_id
        AND i.index_id = p.index_id
    INNER JOIN sys.dm_db_partition_stats ps ON
        i.object_id = ps.object_id
        AND ps.index_id = i.index_id
    WHERE p.data_compression_desc = 'NONE'
        AND SCHEMA_NAME(o.schema_id) <> 'SYS'
)
SELECT *
      , IIF(IndexName IS NULL, REPLACE(CONCAT_WS(' ', 'EXEC sp_estimate_data_compression_savings', '''' + SchemaName + ''',', '''' + BaseTableName + ''',', '''NULL'', ', '''NULL'', ', '''PAGE'''), '''NULL''', 'NULL'), '') AS CheckTableSavingsSQL
    , IIF(IndexName IS NULL, CONCAT_WS(' ', 'ALTER TABLE', TableName, 'REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);'), CONCAT_WS(' ', 'ALTER INDEX', IndexName, 'ON', TableName,  'REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);')) AS CompressionSQL
FROM CompressionCheck
ORDER BY PageCount DESC


--EXEC sp_estimate_data_compression_savings 'FACT', 'PrivateReportCardValuationFacts', NULL,  NULL,  'PAGE'
--EXEC sp_estimate_data_compression_savings 'FACT', 'PrivateReportCardChartFacts', NULL,  NULL,  'PAGE'
--EXEC sp_estimate_data_compression_savings 'FACT', 'PrivateReportCardDistributionsFacts', NULL,  NULL,  'PAGE'
--EXEC sp_estimate_data_compression_savings 'FACT', 'PrivateReportCardCompanyFacts', NULL,  NULL,  'PAGE'
GO 

USE ElectrumWarehouse 
GO 

;
WITH CompressionCheck AS
(
SELECT DISTINCT
SCHEMA_NAME(o.schema_id) AS SchemaName,
OBJECT_NAME(o.object_id) AS BaseTableName,
SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(o.object_id) AS TableName,
i.name AS IndexName,
ps.reserved_page_count AS PageCount
FROM sys.partitions p
INNER JOIN sys.objects o ON
p.object_id = o.object_id
JOIN sys.indexes i ON
p.object_id = i.object_id
AND i.index_id = p.index_id
INNER JOIN sys.dm_db_partition_stats ps ON
i.object_id = ps.object_id
AND ps.index_id = i.index_id
WHERE p.data_compression_desc = 'NONE'
AND SCHEMA_NAME(o.schema_id) <> 'SYS'
)
SELECT *
, IIF(IndexName IS NULL, REPLACE(CONCAT_WS(' ', 'EXEC sp_estimate_data_compression_savings', '''' + SchemaName + ''',', '''' + BaseTableName + ''',', '''NULL'', ', '''NULL'', ', '''PAGE'''), '''NULL''', 'NULL'), '') AS CheckTableSavingsSQL
, IIF(IndexName IS NULL, CONCAT_WS(' ', 'ALTER TABLE', TableName, 'REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);'), CONCAT_WS(' ', 'ALTER INDEX', IndexName, 'ON', TableName, 'REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);')) AS CompressionSQL

FROM CompressionCheck
ORDER BY PageCount desc 
