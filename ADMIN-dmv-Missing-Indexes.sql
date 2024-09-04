use netForumSCOUTSTest

--drop table #junk1
drop table #junk2
go 

select s.group_handle
,s.unique_compiles
,s.user_seeks
,s.last_user_seek
,s.avg_user_impact
,d.database_id
,d.object_id
,d.equality_columns
,d.inequality_columns
,d.included_columns 
,d.statement

INTO #JUNK2

 from sys.dm_db_missing_index_group_stats s
join sys.dm_db_missing_index_groups g on g.index_group_handle = s.group_handle
join sys.dm_db_missing_index_details D on g.index_handle = D.index_handle
-- order by user_seeks desc
order by last_user_seek desc 

select * from #junk1 order by last_user_seek desc 
select * from #junk2 order by last_user_seek desc 


-- LOGIN 
-- 17	12	92	0	2015-03-05 10:34:34.173	NULL	0.958759438267132	99.25	0	0	NULL	NULL	0	0	17	16	16	7	33512740	[c01_ind_cst_key]	NULL	NULL	[netForumSCOUTSTest].[dbo].[client_scouts_compliance_tracking]

-- SELECT SECTION 
/* 
9	4	18	0	2015-03-05 10:35:23.660	NULL	10.0410489469848	31.67	0	0	NULL	NULL	0	0	9	8	8	7	303417692	[x13_ind_cst_key_2], [x13_progress]	NULL	[x13_type]	[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
14	4	18	0	2015-03-05 10:35:23.660	NULL	10.0410489469848	31.7	0	0	NULL	NULL	0	0	14	13	13	7	303417692	[x13_ind_cst_key_2], [x13_progress]	NULL	NULL		[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
12	2	9	0	2015-03-05 10:35:23.660	NULL	10.0410489469848	30.72	0	0	NULL	NULL	0	0	12	11	11	7	303417692	[x13_ind_cst_key_2]	NULL	NULL						[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
17	12	92	0	2015-03-05 10:34:34.173	NULL	0.958759438267132	99.25	0	0	NULL	NULL	0	0	17	16	16	7	33512740	[c01_ind_cst_key]	NULL	NULL						[netForumSCOUTSTest].[dbo].[client_scouts_compliance_tracking]
*/

-- SELECT MEMBER 

-- NOTHING ADDED

-- group_handle	unique_compiles	user_seeks	user_scans	last_user_seek	last_user_scan	avg_total_user_cost	avg_user_impact	system_seeks	system_scans	last_system_seek	last_system_scan	avg_total_system_cost	avg_system_impact	index_group_handle	index_handle	index_handle	database_id	object_id	equality_columns	inequality_columns	included_columns	statement


/* ---
17	12	96	2015-03-05 11:18:28.060	99.25	7	33512740	[c01_ind_cst_key]	NULL	NULL	[netForumSCOUTSTest].[dbo].[client_scouts_compliance_tracking]
9	4	18	2015-03-05 10:35:23.660	31.67	7	303417692	[x13_ind_cst_key_2], [x13_progress]	NULL	[x13_type]	[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
12	2	9	2015-03-05 10:35:23.660	30.72	7	303417692	[x13_ind_cst_key_2]	NULL	NULL	[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
14	4	18	2015-03-05 10:35:23.660	31.7	7	303417692	[x13_ind_cst_key_2], [x13_progress]	NULL	NULL	[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
80	14	26	2015-03-04 14:35:40.390	45.59	7	1614654287	[obj_description]	NULL	NULL	[netForumSCOUTSTest].[dbo].[md_object]*/
-- */

go 

/* 
----------------------
-- LOOK FOR MISSING INCLUDES IN COLUMNS 
SELECT mig.*, statement AS table_name, column_id, column_name, column_usage
FROM sys.dm_db_missing_index_details AS mid
	CROSS APPLY sys.dm_db_missing_index_columns (mid.index_handle)
	INNER JOIN sys.dm_db_missing_index_groups AS mig ON mig.index_handle = mid.index_handle
ORDER BY mig.index_group_handle, mig.index_handle, column_id;
GO

*/

	
/* 

-- PART 2 - FIND A GROUP 

EQ  : [org_bank_account_received_flag_ext], [org_allow_online_reg_flag_ext]	
NE  : [org_closed_group_flag_ext]	
COL : [org_cst_key_ext], [org_hierarchy_hash_ext]	
TBL : [netForumSCOUTSTest].[dbo].[co_organization_ext]


EQ  : NULL 
NE  : [adr_latitude], [adr_longitude]	
COL : [adr_post_code]	
TBL : [netForumSCOUTSTest].[dbo].[co_address]

*/ 
