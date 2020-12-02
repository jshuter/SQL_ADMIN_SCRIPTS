USE investments_dw

--- GET REPORT ON ALL INDEXES !!!!!
SELECT OBJECT_NAME(object_id) as OBNAME, page_count PageCount, avg_fragmentation_in_percent pctFrag, * 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
order by 
page_count desc,
avg_fragmentation_in_percent desc

--obname 

set statistics IO ON 
set statistics TIME ON 

SELECT COUNT(*) from fact.PrivateReportCardChartFacts

ALTER INDEX ALL ON stg.holding_master REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!


-- TRANS DETAIL 
SELECT OBJECT_NAME(object_id) as OBNAME, * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('op.transaction_detail'), NULL, NULL, NULL) indexstats 
SELECT COUNT(*) from OP.Transaction_Detail 
ALTER INDEX ALL ON OP.Transaction_Detail  REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
SELECT OBJECT_NAME(object_id) as OBNAME, * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('op.transaction_detail'), NULL, NULL, NULL) indexstats 
SELECT COUNT(*) from OP.Transaction_Detail 


-- 100,000 ROWS 

----------------------
-- TRANS MASTER 

SELECT OBJECT_NAME(object_id) as OBNAME, * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('op.transaction_master'), NULL, NULL, NULL) indexstats 
SELECT COUNT(*) from OP.transaction_master 
ALTER INDEX ALL ON OP.transaction_master  REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
ALTER INDEX ALL ON OP.transaction_master  REBUILD -- WITH (ONLINE = ON) 
SELECT OBJECT_NAME(object_id) as OBNAME, * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('op.transaction_master'), NULL, NULL, NULL) indexstats 
SELECT COUNT(*) from OP.transaction_master 



SELECT OBJECT_NAME(object_id) as OBNAME, * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('op.account_master'), NULL, NULL, NULL) indexstats 
SELECT COUNT(*) from OP.account_master 
ALTER INDEX ALL ON OP.account_master  REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
ALTER INDEX ALL ON OP.account_master  REBUILD WITH (ONLINE = ON) 
SELECT OBJECT_NAME(object_id) as OBNAME, * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('op.account_master'), NULL, NULL, NULL) indexstats 
SELECT COUNT(*) from OP.account_master 


SELECT COUNT(*) FROM client_scouts_external_volunteer_screening
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID( 'client_scouts_external_volunteer_screening'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.client_scouts_external_volunteer_screening REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

-- DONE 

----------------------

-- 29,000 rows 
select COUNT(*) from co_organization_ext
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID( 'co_organization_ext'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_organization_ext REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
-- DONE -- 
----------------------------

SELECT COUNT(*) FROM client_scouts_member_account
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('client_scouts_member_account'), NULL, NULL, NULL) indexstats 
-- 284,000 ROWS 
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

-- DONE -- 

---------------------------------------------------------'
--1,500,000 rows 
--10 indexes 

select COUNT(*) from co_individual
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_individual'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_individual REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

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


-- OCT 2016 -- redoing for highly fragmented tables !

/* 
-- 380,000 rows 

select COUNT(*) from client_scouts_experimental_registration 
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('client_scouts_experimental_registration'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.client_scouts_experimental_registration REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!

*/

/* 
-- 1,604,371
select COUNT(*) from co_individual  
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_individual'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_individual REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
*/

/* 
-- 2,241,000
select COUNT(*) from co_individual_x_organization  
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('co_individual_x_organization'), NULL, NULL, NULL) indexstats 
ALTER INDEX ALL ON DBO.co_individual_x_organization REORGANIZE ;  --- RECOMPUTE OUT OF DATE STATS !!!
*/