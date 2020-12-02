-- Script to test performance on co_individual last_name (98 % fragmented ) 

-- restructure the index - and retest perf

set statistics io on 
set statistics time on 

select count(*) from  co_individual -- 1,460,409 rows 
select * from co_individual where ind_last_name like 'b_langer'
select * from co_individual where ind_last_name = 'bélanger'

set statistics io off
set statistics time off 



/* before rebuild : 
-----------
1460409

(1 row(s) affected)

Table 'co_individual'. Scan count 5, logical reads 4909, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 125 ms,  elapsed time = 31 ms.





ind_cst_key                          ind_prf_code         ind_first_name                 ind_last_name                  ind_mid_name                   ind_sfx_code         ind_designation                                    ind_int_code                                       ind_dob                 ind_age_cp  ind_gender ind_marital_status ind_salary            ind_spouse_name                                                                                      ind_maiden_name                ind_ssn                                                                          ind_ethnicity                                      ind_badge_name                 ind_license_number   ind_entered_field_date  ind_num_years_in_field_cp ind_political_party  ind_deceased_flag ind_full_name_cp                                                                                                                                                                            ind_salutation_cp                                   ind_ixo_key                          ind_popup                                                                                                                                                                                                                                                        ind_add_date            ind_add_user                                                     ind_change_date         ind_change_user                                                  ind_delete_flag ind_grad_date           ind_entity_key                       ind_cst_passcode_ext ind_sample_multi     ind_progress_ext
------------------------------------ -------------------- ------------------------------ ------------------------------ ------------------------------ -------------------- -------------------------------------------------- -------------------------------------------------- ----------------------- ----------- ---------- ------------------ --------------------- ---------------------------------------------------------------------------------------------------- ------------------------------ -------------------------------------------------------------------------------- -------------------------------------------------- ------------------------------ -------------------- ----------------------- ------------------------- -------------------- ----------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------------------------------------------------- ------------------------------------ ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- --------------- ----------------------- ------------------------------------ -------------------- -------------------- ------------------------------
B5C04BB1-9403-45EB-BA36-F0524416B44E Mr.                  Jacob                          Bélanger                       NULL                           NULL                 NULL                                               NULL                                               1998-05-07 00:00:00.000 16          Male       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Mr. Jacob Bélanger                                                                                                                                                                          Mr. Bélanger                                        NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-27 09:40:00     SCOUTS_Conversion                                                NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL
57466A22-E8A1-4127-B45D-F4C4E2558F5D NULL                 Chantale                       Bélanger                       NULL                           NULL                 NULL                                               NULL                                               NULL                    NULL        NULL       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Chantale Bélanger                                                                                                                                                                           Chantale                                            NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-28 01:26:00     SCOUTS_Conversion_PG                                             NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL
...
(512 row(s) affected)

Table 'co_individual'. Scan count 1, logical reads 2302, physical reads 0, read-ahead reads 0
, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 62 ms,  elapsed time = 110 ms.

SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.



ind_cst_key                          ind_prf_code         ind_first_name                 ind_last_name                  ind_mid_name                   ind_sfx_code         ind_designation                                    ind_int_code                                       ind_dob                 ind_age_cp  ind_gender ind_marital_status ind_salary            ind_spouse_name                                                                                      ind_maiden_name                ind_ssn                                                                          ind_ethnicity                                      ind_badge_name                 ind_license_number   ind_entered_field_date  ind_num_years_in_field_cp ind_political_party  ind_deceased_flag ind_full_name_cp                                                                                                                                                                            ind_salutation_cp                                   ind_ixo_key                          ind_popup                                                                                                                                                                                                                                                        ind_add_date            ind_add_user                                                     ind_change_date         ind_change_user                                                  ind_delete_flag ind_grad_date           ind_entity_key                       ind_cst_passcode_ext ind_sample_multi     ind_progress_ext
------------------------------------ -------------------- ------------------------------ ------------------------------ ------------------------------ -------------------- -------------------------------------------------- -------------------------------------------------- ----------------------- ----------- ---------- ------------------ --------------------- ---------------------------------------------------------------------------------------------------- ------------------------------ -------------------------------------------------------------------------------- -------------------------------------------------- ------------------------------ -------------------- ----------------------- ------------------------- -------------------- ----------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------------------------------------------------- ------------------------------------ ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- --------------- ----------------------- ------------------------------------ -------------------- -------------------- ------------------------------
12621BA9-463D-4B5C-BA99-C1CCBE1B1A3D NULL                 Alain                          Bélanger                       NULL                           NULL                 NULL                                               NULL                                               NULL                    NULL        NULL       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Alain Bélanger                                                                                                                                                                              Alain                                               NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-28 01:26:00     SCOUTS_Conversion_PG                                             NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL
7487C594-1D58-4DB8-8617-85FB96CD4E91 NULL                 Casey                          Bélanger                       NULL                           NULL                 NULL                                               NULL                                               1997-06-03 00:00:00.000 17          Male       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Casey Bélanger                                                                                                                                                                              Casey                                               NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-27 09:40:00     SCOUTS_Conversion                                                NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL
...

(36 row(s) affected)

Table 'co_individual'. Scan count 1, logical reads 123, physical reads 0, read-ahead reads 0
, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 50 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

*/

/* AFTER INDEX REBUILD : 


-----------
1460409

(1 row(s) affected)

Table 'co_individual'. Scan count 5, logical reads 4909, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 109 ms,  elapsed time = 33 ms.
ind_cst_key                          ind_prf_code         ind_first_name                 ind_last_name                  ind_mid_name                   ind_sfx_code         ind_designation                                    ind_int_code                                       ind_dob                 ind_age_cp  ind_gender ind_marital_status ind_salary            ind_spouse_name                                                                                      ind_maiden_name                ind_ssn                                                                          ind_ethnicity                                      ind_badge_name                 ind_license_number   ind_entered_field_date  ind_num_years_in_field_cp ind_political_party  ind_deceased_flag ind_full_name_cp                                                                                                                                                                            ind_salutation_cp                                   ind_ixo_key                          ind_popup                                                                                                                                                                                                                                                        ind_add_date            ind_add_user                                                     ind_change_date         ind_change_user                                                  ind_delete_flag ind_grad_date           ind_entity_key                       ind_cst_passcode_ext ind_sample_multi     ind_progress_ext
------------------------------------ -------------------- ------------------------------ ------------------------------ ------------------------------ -------------------- -------------------------------------------------- -------------------------------------------------- ----------------------- ----------- ---------- ------------------ --------------------- ---------------------------------------------------------------------------------------------------- ------------------------------ -------------------------------------------------------------------------------- -------------------------------------------------- ------------------------------ -------------------- ----------------------- ------------------------- -------------------- ----------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------------------------------------------------- ------------------------------------ ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- --------------- ----------------------- ------------------------------------ -------------------- -------------------- ------------------------------
A39113A9-4EAD-4FEC-9F92-E4CA9C5F1555 NULL                 Justin                         Balanger                       NULL                           NULL                 NULL                                               NULL                                               1981-05-28 00:00:00.000 33          Male       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Justin Balanger                                                                                                                                                                             Justin                                              NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-27 09:40:00     SCOUTS_Conversion                                                NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL
17000DF9-E1B9-4A47-8550-0034BB4EC336 NULL                 Sandra                         Belanger                       NULL                           NULL                 NULL                                               NULL                                               NULL                    NULL        NULL       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Sandra Belanger                                                                                                                                                                             Sandra                                              NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-28 01:26:00     SCOUTS_Conversion_PG                                             NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL
C6C60AC8-8401-44DD-9F65-F53DA24CDAEF NULL                 Zachary                        Bélanger                       NULL                           NULL                 NULL                                               NULL                                               1994-01-12 00:00:00.000 21          Male       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Zachary Bélanger                                                                                                                                                                            Zachary                                             NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-27 09:40:00     SCOUTS_Conversion                                                NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL
AD65CB31-B566-4D5B-AEC2-EEE9FAC74DD6 NULL                 Paula                          Bulanger                       NULL                           NULL                 NULL                                               NULL                                               1968-03-15 00:00:00.000 46          Male       NULL               NULL                  NULL                                                                                                 NULL                           NULL                                                                             NULL                                               NULL                           NULL                 NULL                    NULL                      NULL                 0                 Paula Bulanger                                                                                                                                                                              Paula                                               NULL                                 NULL                                                                                                                                                                                                                                                             2012-02-27 09:40:00     SCOUTS_Conversion                                                NULL                    NULL                                                             0               NULL                    NULL                                 NULL                 NULL                 NULL

(512 row(s) affected)

Table 'co_individual'. Scan count 1, logical reads 2300, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
SQL Server Execution Times:			CPU time = 62 ms,  elapsed time = 125 ms.
SQL Server parse and compile time:  CPU time = 0 ms, elapsed time = 0 ms.

Table 'co_individual'. Scan count 1, logical reads 123, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
SQL Server Execution Times:   CPU time = 0 ms,  elapsed time = 88 ms.
SQL Server Execution Times:   CPU time = 0 ms,  elapsed time = 0 ms.


*/





SELECT dbschemas.[name] as 'Schema', 
dbtables.[name] as 'Table', 
dbindexes.[name] as 'Index',
indexstats.avg_fragmentation_in_percent,
indexstats.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('co_individual'), NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID()
ORDER BY indexstats.avg_fragmentation_in_percent desc

/* result for co_individual ... BEFORE RESTRUCTURE ...

dbo	co_individual	IX_co_individual_ind_entity_key			99.327246516098		8324
dbo	co_individual	IX_co_individual_ind_ixo_key			99.2071119654013	8324
dbo	co_individual	missing_idx_RMOct__3_2012_co_individual	99.1069656677912	10078
dbo	co_individual	missing_idx_RMSep_10_2013_co_individual	99.044935024268		6387
dbo	co_individual	IX_co_individual_ind_designation		99.023680930619		4814
dbo	co_individual	PK_ind									98.7421500847884	53663
dbo	co_individual	IX_co_individual_ind_last_name			98.2022746728629	8177
dbo	co_individual	IX_co_individual_ind_dob				98.1998953427525	9555
dbo	co_individual	IX_co_individual_ind_first_name					97.2296960637768	10035
dbo	co_individual	IX_co_individual_ind_last_name_ind_first_name	97.8514265831594	11496
dbo	co_individual	IX_co_individual_ind_last_name					98.2022746728629	8177

AFTER REBUILD of INDEX

dbo	co_individual	IX_co_individual_ind_last_name_ind_first_name	1.01161154116819	11368
dbo	co_individual	IX_co_individual_ind_last_name					0.764299802761341	8112
dbo	co_individual	IX_co_individual_ind_entity_key	0.768861124459395	8324


The value for avg_fragmentation_in_percent should be as close to zero as possible for 
maximum performance. However, values from 0 percent through 10 percent may be acceptable.
All methods of reducing fragmentation, such as rebuilding, reorganizing, or re-creating, 
can be used to reduce these values. For more information about how to analyze the degree 
of fragmentation in an index, see "Reorganize and Rebuild Indexes".

Use ALTER INDEX REORGANIZE, the replacement for DBCC INDEXDEFRAG, to reorder the leaf level pages 
of the index in a logical order. Because this is an online operation, the index is available while 
the statement is running. The operation can also be interrupted without losing work already completed. 

The drawback in this method is that it does not do as good a job of reorganizing the data as an 
index rebuild operation, and it does not update statistics.

ref http://msdn.microsoft.com/en-us/library/ms188917.aspx

*/

ALTER INDEX IX_co_individual_ind_last_name ON dbo.co_individual REORGANIZE
GO 
ALTER INDEX IX_co_individual_ind_last_name_ind_first_name ON dbo.co_individual REORGANIZE
GO 

-- 10 seconds 