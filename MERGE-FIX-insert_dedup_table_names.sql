-- testing !!!!

USE netForumSCOUTSTest

go 

/* 
SELECT * 
FROM md_dedup_table(NOLOCK)
WHERE dup_delete_flag = 0
ORDER BY dup_order
	,dup_file_group
	,dup_mdt_name
	,dup_cst_key_column
*/

/*

FOR REVIEW !!!!  field with CST_KEY - that were not being managed - 

1 - client_scouts_activity_x_co_customer

*/
-- rollback 

begin transaction 

declare @row_total smallint = 0 
-- insure not a single ROW that we insert below is already there 

select * from md_dedup_table where dup_mdt_name = 'client_scouts_activity_x_co_customer'		and dup_cst_key_column = 'z56_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_co_individual_x_participation'	and dup_cst_key_column = 'a13_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_emergency_contact_info'		and dup_cst_key_column = 'a11_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_equipment_x_co_customer'		and dup_cst_key_column = 'z57_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_experimental_registration'		and dup_cst_key_column = 'x13_ind_cst_key_1'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_experimental_registration'		and dup_cst_key_column = 'x13_ind_cst_key_2'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_experimental_registration'		and dup_cst_key_column = 'x13_org_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_individual_x_reference'		and dup_cst_key_column = 'a16_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_individual_x_volunteer_program' and dup_cst_key_column = 'a15_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_group_org_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_section_org_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_pg1_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_pg2_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_org_fee_x_date'				and dup_cst_key_column = 'a03_org_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_org_merge_history'				and dup_cst_key_column = 'a05_to_org_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_org_merge_history'				and dup_cst_key_column = 'a05_from_org_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_police_records_check'			and dup_cst_key_column = 'a18_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_service_x_co_customer'			and dup_cst_key_column = 'z55_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_online_user_exception_log'		and dup_cst_key_column = 'z71_ind_cst_key'
set @row_total = @row_total + @@ROWCOUNT
select * from md_dedup_table where dup_mdt_name = 'client_scouts_online_user_exception_log'		and dup_cst_key_column = 'z71_cst_key'
set @row_total = @row_total + @@ROWCOUNT


select @row_total
if @row_total > 0  begin 
	print '*** WARNING *** table already inserted into md_dedup_table !'
	return 
end 


INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999200,'client_scouts_activity_x_co_customer','z56_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999201,'client_scouts_co_individual_x_participation','a13_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999202,'client_scouts_emergency_contact_info','a11_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999203,'client_scouts_equipment_x_co_customer','z57_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999204,'client_scouts_experimental_registration','x13_ind_cst_key_1') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999205,'client_scouts_experimental_registration','x13_ind_cst_key_2') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999206,'client_scouts_experimental_registration','x13_org_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999207,'client_scouts_individual_x_reference','a16_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999208,'client_scouts_individual_x_volunteer_program','a15_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999209,'client_scouts_member_registration','a17_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999210,'client_scouts_member_registration','a17_group_org_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999211,'client_scouts_member_registration','a17_section_org_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999212,'client_scouts_member_registration','a17_pg1_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999213,'client_scouts_member_registration','a17_pg2_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999214,'client_scouts_org_fee_x_date','a03_org_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999215,'client_scouts_org_merge_history','a05_to_org_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999216,'client_scouts_org_merge_history','a05_from_org_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999217,'client_scouts_police_records_check','a18_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999218,'client_scouts_service_x_co_customer','z55_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999219,'client_scouts_online_user_exception_log','z71_ind_cst_key') 
INSERT INTO md_dedup_table (dup_file_group,dup_order,dup_mdt_name,dup_cst_key_column) values ('merge-fix',999220,'client_scouts_online_user_exception_log','z71_cst_key')


--------------------------------------------------------
-- New trigger AT END of process 
--------------------------------------------------------


-- THIS IS AN INSERT OF HELPER PROC - as FIRST THING THAT SHOULD HAPPEN ...

UPDATE md_dedup_table 
set dup_sql_before = 'dbo.client_scouts_merge_helper {cst_key_from},{cst_key_to},''BEFORE'''
WHERE dup_mdt_name = 'client_scouts_member_account'
AND dup_cst_key_column = 'z11_ind_cst_key' 


-- INSERT OF HELPER PRC - as LAST THING THAT SHOULD HAPPEN ...

UPDATE md_dedup_table 
set dup_sql_after = 'dbo.client_scouts_merge_helper {cst_key_from},{cst_key_to},''AFTER'''
WHERE dup_mdt_name = 'client_scouts_code_of_conduct_x_co_individual'
AND dup_cst_key_column = 'z24_ind_cst_key' 


-- 'dbo.client_scouts_remove_member_account_dup {cst_key_from},{cst_key_to}'

-- select * from dbo.client_Scouts_generic_log 
-- rollback 

/* 
select * from md_dedup_table where dup_mdt_name like 'client_scouts%'
order by dup_mdt_name
*/


/* removing  the rows !
								*** CAREFUL ! *** 

DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_activity_x_co_customer' 		AND dup_cst_key_column='z56_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_co_individual_x_participation' AND dup_cst_key_column='a13_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_emergency_contact_info' 		AND dup_cst_key_column='a11_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_equipment_x_co_customer' 		AND dup_cst_key_column='z57_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_experimental_registration' 	AND dup_cst_key_column='x13_ind_cst_key_1'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_experimental_registration' 	AND dup_cst_key_column='x13_ind_cst_key_2'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_experimental_registration' 	AND dup_cst_key_column='x13_org_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_individual_x_reference' 		AND dup_cst_key_column='a16_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_individual_x_volunteer_program' AND dup_cst_key_column='a15_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_member_registration' 			AND dup_cst_key_column='a17_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_member_registration' 			AND dup_cst_key_column='a17_group_org_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_member_registration' 			AND dup_cst_key_column='a17_section_org_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_member_registration' 			AND dup_cst_key_column='a17_pg1_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_member_registration' 			AND dup_cst_key_column='a17_pg2_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_org_fee_x_date' 				AND dup_cst_key_column='a03_org_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_org_merge_history' 			AND dup_cst_key_column='a05_to_org_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_org_merge_history' 			AND dup_cst_key_column='a05_from_org_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_police_records_check' 		AND dup_cst_key_column='a18_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_service_x_co_customer' 		AND dup_cst_key_column='z55_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_online_user_exception_log' 	AND dup_cst_key_column='z71_ind_cst_key'
DELETE FROM  md_dedup_table WHERE dup_mdt_name='client_scouts_online_user_exception_log' 	AND dup_cst_key_column='z71_cst_key'


--commit 
-- or 
--rollback

*/

-- commit 

/* testing 

** CURRENT - EXISTING ENTRIES - DO NOT REMOVED ! all ok ** 

select * from md_dedup_table where dup_mdt_name = 'client_scouts_approval_record' and dup_cst_key_column = 'z26_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_approval_record' and dup_cst_key_column = 'z26_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_code_of_conduct_x_co_individual' and dup_cst_key_column = 'z24_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_code_of_conduct_x_co_individual' and dup_cst_key_column = 'z24_entry_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_course_catalogue_x_co_customer' and dup_cst_key_column = 'z03_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_external_volunteer_screening' 	and dup_cst_key_column = 'z25_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_account'		and dup_cst_key_column = 'z11_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_recognition_list_x_co_customer' and dup_cst_key_column = 'z05_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_volunteer_screening' 		and dup_cst_key_column = 'z21_ind_cst_key_1'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_volunteer_screening' 		and dup_cst_key_column = 'z21_ind_cst_key_2'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_volunteer_screening' 		and dup_cst_key_column = 'z21_ind_cst_key_3'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_volunteer_screening_reference' 	and dup_cst_key_column = 'z22_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_volunteer_screening_reference' 	and dup_cst_key_column = 'z22_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_online_transaction_error_log'	and dup_cst_key_column = 'z70_ind_cst_key'


========================================================================================

*** MISSING **** NEEDS TO BE ADDED **** 

select * from md_dedup_table where dup_mdt_name = 'client_scouts_activity_x_co_customer'		and dup_cst_key_column = 'z56_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_co_individual_x_participation'	and dup_cst_key_column = 'a13_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_emergency_contact_info'		and dup_cst_key_column = 'a11_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_equipment_x_co_customer'		and dup_cst_key_column = 'z57_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_experimental_registration'		and dup_cst_key_column = 'x13_ind_cst_key_1'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_experimental_registration'		and dup_cst_key_column = 'x13_ind_cst_key_2'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_experimental_registration'		and dup_cst_key_column = 'x13_org_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_individual_x_reference'		and dup_cst_key_column = 'a16_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_individual_x_volunteer_program' and dup_cst_key_column = 'a15_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_group_org_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_section_org_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_pg1_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_member_registration'			and dup_cst_key_column = 'a17_pg2_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_org_fee_x_date'				and dup_cst_key_column = 'a03_org_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_org_merge_history'				and dup_cst_key_column = 'a05_to_org_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_org_merge_history'				and dup_cst_key_column = 'a05_from_org_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_police_records_check'			and dup_cst_key_column = 'a18_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_service_x_co_customer'			and dup_cst_key_column = 'z55_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_online_user_exception_log'		and dup_cst_key_column = 'z71_ind_cst_key'
select * from md_dedup_table where dup_mdt_name = 'client_scouts_online_user_exception_log'		and dup_cst_key_column = 'z71_cst_key'

-- COMMIT 
*/




select * from dbo.client_scouts_generic_log
