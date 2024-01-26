USE smtr
GO

SELECT
   current_storage_size_mb,
   max_storage_size_mb,
   actual_state_desc,
   readonly_reason,
   stale_query_threshold_days,
   size_based_cleanup_mode_desc
FROM sys.database_query_store_options;
GO	

SELECT
   DB_NAME() as "Database Name",
   actual_state_desc as "Actual State",
   FORMAT(current_storage_size_mb, 'N0') as "Current Storage Size (MB)",
   FORMAT(max_storage_size_mb, 'N0') as "Max Storage Size (MB)",
   CAST(current_storage_size_mb AS FLOAT)/CAST(max_storage_size_mb AS FLOAT) "Storage utilization %",
   CASE
      WHEN readonly_reason = 1 THEN 'Database in read-only mode'
      WHEN readonly_reason = 2 THEN 'Database in single-user mode'
      WHEN readonly_reason = 4 THEN 'Database in emergency mode'
      WHEN readonly_reason = 8 THEN 'Database is secondary replica'
      WHEN readonly_reason = 65536 THEN 'Query Store has reached the size limit set by the MAX_STORAGE_SIZE_MB option'
      WHEN readonly_reason = 131072 THEN 'The number of different statements in Query Store has reached the internal memory limit'
      WHEN readonly_reason = 262144 THEN 'Size of in-memory items waiting to be persisted on disk has reached the internal memory limit'
      WHEN readonly_reason = 524288 THEN 'User database has reached disk size limit'
      ELSE 'N\A'
   END as "Read only Reason",
   stale_query_threshold_days as "Cleanup policy",
   size_based_cleanup_mode_desc as "Size based cleanup mode"
FROM sys.database_query_store_options
GO

USE Smtr_Staging
GO

SELECT
   DB_NAME() as "Database Name",
   actual_state_desc as "Actual State",
   FORMAT(current_storage_size_mb, 'N0') as "Current Storage Size (MB)",
   FORMAT(max_storage_size_mb, 'N0') as "Max Storage Size (MB)",
   CAST(current_storage_size_mb AS FLOAT)/CAST(max_storage_size_mb AS FLOAT) "Storage utilization %",
   CASE
      WHEN readonly_reason = 1 THEN 'Database in read-only mode'
      WHEN readonly_reason = 2 THEN 'Database in single-user mode'
      WHEN readonly_reason = 4 THEN 'Database in emergency mode'
      WHEN readonly_reason = 8 THEN 'Database is secondary replica'
      WHEN readonly_reason = 65536 THEN 'Query Store has reached the size limit set by the MAX_STORAGE_SIZE_MB option'
      WHEN readonly_reason = 131072 THEN 'The number of different statements in Query Store has reached the internal memory limit'
      WHEN readonly_reason = 262144 THEN 'Size of in-memory items waiting to be persisted on disk has reached the internal memory limit'
      WHEN readonly_reason = 524288 THEN 'User database has reached disk size limit'
      ELSE 'N\A'
   END as "Read only Reason",
   stale_query_threshold_days as "Cleanup policy",
   size_based_cleanup_mode_desc as "Size based cleanup mode"
FROM sys.database_query_store_options
GO

USE Smtr_Audit
GO

SELECT
   DB_NAME() as "Database Name",
   actual_state_desc as "Actual State",
   FORMAT(current_storage_size_mb, 'N0') as "Current Storage Size (MB)",
   FORMAT(max_storage_size_mb, 'N0') as "Max Storage Size (MB)",
   CAST(current_storage_size_mb AS FLOAT)/CAST(max_storage_size_mb AS FLOAT) "Storage utilization %",
   CASE
      WHEN readonly_reason = 1 THEN 'Database in read-only mode'
      WHEN readonly_reason = 2 THEN 'Database in single-user mode'
      WHEN readonly_reason = 4 THEN 'Database in emergency mode'
      WHEN readonly_reason = 8 THEN 'Database is secondary replica'
      WHEN readonly_reason = 65536 THEN 'Query Store has reached the size limit set by the MAX_STORAGE_SIZE_MB option'
      WHEN readonly_reason = 131072 THEN 'The number of different statements in Query Store has reached the internal memory limit'
      WHEN readonly_reason = 262144 THEN 'Size of in-memory items waiting to be persisted on disk has reached the internal memory limit'
      WHEN readonly_reason = 524288 THEN 'User database has reached disk size limit'
      ELSE 'N\A'
   END as "Read only Reason",
   stale_query_threshold_days as "Cleanup policy",
   size_based_cleanup_mode_desc as "Size based cleanup mode"
FROM sys.database_query_store_options
GO

USE Investments_DW
GO

SELECT
   DB_NAME() as "Database Name",
   actual_state_desc as "Actual State",
   FORMAT(current_storage_size_mb, 'N0') as "Current Storage Size (MB)",
   FORMAT(max_storage_size_mb, 'N0') as "Max Storage Size (MB)",
   CAST(current_storage_size_mb AS FLOAT)/CAST(max_storage_size_mb AS FLOAT) "Storage utilization %",
   CASE
      WHEN readonly_reason = 1 THEN 'Database in read-only mode'
      WHEN readonly_reason = 2 THEN 'Database in single-user mode'
      WHEN readonly_reason = 4 THEN 'Database in emergency mode'
      WHEN readonly_reason = 8 THEN 'Database is secondary replica'
      WHEN readonly_reason = 65536 THEN 'Query Store has reached the size limit set by the MAX_STORAGE_SIZE_MB option'
      WHEN readonly_reason = 131072 THEN 'The number of different statements in Query Store has reached the internal memory limit'
      WHEN readonly_reason = 262144 THEN 'Size of in-memory items waiting to be persisted on disk has reached the internal memory limit'
      WHEN readonly_reason = 524288 THEN 'User database has reached disk size limit'
      ELSE 'N\A'
   END as "Read only Reason",
   stale_query_threshold_days as "Cleanup policy",
   size_based_cleanup_mode_desc as "Size based cleanup mode"
FROM sys.database_query_store_options
GO
