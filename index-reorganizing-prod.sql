
-- 39,000 ROWS 
SELECT COUNT(*) FROM client_scouts_external_volunteer_screening
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID( 'client_scouts_external_volunteer_screening'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.client_scouts_external_volunteer_screening REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
-- DONE 
/* 
* before
database_id	object_id	index_id	partition_number	index_type_desc	alloc_unit_type_desc	index_depth	index_level	avg_fragmentation_in_percent	fragment_count	avg_fragment_size_in_pages	page_count	avg_page_space_used_in_percent	record_count	ghost_record_count	version_ghost_record_count	min_record_size_in_bytes	max_record_size_in_bytes	avg_record_size_in_bytes	forwarded_record_count	compressed_page_count
11	2105136082	1	1	CLUSTERED INDEX	IN_ROW_DATA	3	0	86.0385528705126	12455	1.14957848253713	14318	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
11	2105136082	8	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	95.323658143285	4187	1.0367805111058	4341	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
* 
* after 
database_id	object_id	index_id	partition_number	index_type_desc	alloc_unit_type_desc	index_depth	index_level	avg_fragmentation_in_percent	fragment_count	avg_fragment_size_in_pages	page_count	avg_page_space_used_in_percent	record_count	ghost_record_count	version_ghost_record_count	min_record_size_in_bytes	max_record_size_in_bytes	avg_record_size_in_bytes	forwarded_record_count	compressed_page_count
11	2105136082	1	1	CLUSTERED INDEX	IN_ROW_DATA	3	0	0.735116895637503	729	11.3827160493827	8298	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
11	2105136082	8	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	0.434971726837756	252	9.12301587301587	2299	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
*/ 
----------------------

-- 29,000 rows 
select COUNT(*) from co_organization_ext
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID( 'co_organization_ext'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_organization_ext REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
-- DONE -- 
----------------------------

-- 288,000 ROWS 
SELECT COUNT(*) FROM client_scouts_member_account
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('client_scouts_member_account'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.client_scouts_member_account REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
-- DONE -- 

---------------------------------------------------------'

--150,000 ROWS 
-- many indexes 
select COUNT(*) from co_customer
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_customer'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_customer REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

-- DONE -- 

---------------------------------------------------------'
-- 412,000 rows - 10 indexes 

select COUNT(*) from co_customer_x_phone
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_customer_x_phone'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_customer_x_phone REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

/* 
7	1237995887	1	1	CLUSTERED INDEX	IN_ROW_DATA	4		0	99.0869649679466	15443	1	15443	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	2	1	NONCLUSTERED INDEX	IN_ROW_DATA	4	0	99.1250397709195	6284	1.00031826861871	6286	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	11	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.3666877770741	3158	1	3158	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	12	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.2099322799097	2658	1	2658	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	13	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	98.9806320081549	2943	1	2943	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	14	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.0866035182679	2956	1	2956	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	15	1	NONCLUSTERED INDEX	IN_ROW_DATA	4	0	99.1801110817244	3781	1	3781	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	20	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.0258523791682	2669	1	2669	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1237995887	21	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.184505606524		2943	1	2943	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
*/

-- DONE -- 

---------------------------------------------------------'
--1,500,000 rows 
--10 indexes 

select COUNT(*) from co_individual
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_individual'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_individual REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

/* 
7	1558986072	1	1	CLUSTERED INDEX	IN_ROW_DATA	3	0	98.7382813947456	53698	1.00513985623301	53974	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	2	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	98.2068797267626	8116	1.01010349926072	8198	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	3	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	97.2514387775352	9887	1.01931829675331	10078	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	4	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	98.2803543512246	9511	1.00883187887709	9595	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	5	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.023680930619	4814	1	4814	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	6	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	97.8782367714558	11403	1.01262825572218	11547	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	7	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.2072072072072	8325	1	8325	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	8	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.3273273273273	8325	1	8325	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	20	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.044935024268	6387	1	6387	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
7	1558986072	22	1	NONCLUSTERED INDEX	IN_ROW_DATA	3	0	99.1185500643756	10097	1	10097	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
*/
-- DONE -- 

---------------------------------------------------------'
SELECT COUNT(*) FROM co_individual_ext
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_individual_ext'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_individual_ext REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

-- DONE -- 


--------------------------------------------------------'
-- REORG - YES - DONE 
SELECT COUNT(*) FROM co_individual_x_organization
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_individual_x_organization'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_individual_x_organization REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

-- DONE -- 

---------------------------------------------------------'
SELECT COUNT(*) FROM co_individual_x_organization_ext
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_individual_x_organization_ext'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_individual_x_organization_ext REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

-- DONE -- 

---------------------------------------------------------'
-- REORG - DONE 

SELECT COUNT(*) FROM co_organization
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_organization'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_organization REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

-- DONE -- 

--29,000 rows 
--6 indexes 

------------------------------------------

