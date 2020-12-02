
ALTER proc client_scouts_remove_member_account_dup(@hide_key as varchar(50), @keep_key as varchar(50)) 
AS 
BEGIN 
	IF exists(
		select * from client_scouts_member_account a
		join co_customer c	on a.z11_ind_cst_key = c.cst_key
		where c.cst_key = @keep_key 
		and (c.cst_delete_flag = 0 OR c.cst_delete_flag is NULL) ) 
	BEGIN 
		-- SOFT DELETE ROW FROM OLD 
		UPDATE client_scouts_member_account
		SET client_scouts_member_account.z11_delete_flag = 1
		where client_scouts_member_account.z11_ind_cst_key in ( 
			select cst_key from co_customer C 
			where C.cst_key = @hide_key
			and (C.cst_delete_flag = 0 OR C.cst_delete_flag is NULL) 
		) 
	END 
END
GO 

-- ====================================================================================

alter proc client_scouts_merge_helper(@hide_key as varchar(50), @keep_key as varchar(50), @reason as varchar(50)) 
AS 
BEGIN 

	declare @hide_recno int 
	declare @keep_recno int 
	declare @akey varchar(50) 
	declare @reason2 varchar(50) 
	
	-- get recno for OLD key 
	select @hide_recno = cst_recno from co_customer where cst_key = @hide_key 
	if @@ROWCOUNT <> 1 begin 
		exec client_scouts_generic_log_insert 'MERGE LOG: Could not locate co_customer for HIDE cst_key',@hide_key 
		return 
	end 

	-- get recno for NEW key 
	select @keep_recno = cst_recno from co_customer where cst_key = @keep_key 
	if @@ROWCOUNT <> 1 begin 
		exec client_scouts_generic_log_insert 'MERGE LOG: Could not locate co_customer for KEEP cst_key',@hide_key 
		return 
	end 

	exec client_scouts_generic_log_insert  'MERGE LOG: begining merge. data is [old_cst_key, old_member_number, new_cst_key, new_member_number]',@reason,'dbo.client_scouts_generic_log',@hide_key, @hide_recno, @keep_key, @keep_recno 


	---------------------------------------------------------------------------------
	--- LOG all records from OLD and NEW CST_KEYs
	---------------------------------------------------------------------------------


	-- BEGIN Trace for selected TABLES from md_dup_tables 
	-- done once for old key - and once for new key 

	declare @i smallint = 0 
	set @i=0

	while @i < 2 BEGIN 
	
		set @i = @i + 1 
		if @i = 1 begin 
			set @akey = @hide_key 
			set @REASON2 = @reason + ' FROM CST TO HIDE:'
		end else  begin 
			set @akey = @keep_key
			set @REASON2 = @reason + ' FROM CST TO KEEP:'
		end 

		-- 33 rows 		

		exec client_scouts_merging_log_insert 'client_scouts_activity_x_co_customer','z56_cst_key','z56_key'					, @reason, @akey 		
		exec client_scouts_merging_log_insert 'client_scouts_approval_record','z26_cst_key','z26_key'							, @reason, @akey
		exec client_scouts_merging_log_insert 'client_scouts_approval_record','z26_ind_cst_key','z26_key'						, @reason, @akey
		exec client_scouts_merging_log_insert 'client_scouts_co_individual_x_participation','a13_ind_cst_key','a13_key'			, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_code_of_conduct_x_co_individual','z24_entry_ind_cst_key','z24_key'	, @reason2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_code_of_conduct_x_co_individual','z24_ind_cst_key','z24_key'		, @reason2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_course_catalogue_x_co_customer','z03_cst_key','z03_key'			, @reason2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_emergency_contact_info','a11_ind_cst_key','a11_key'				, @reason, @akey
		exec client_scouts_merging_log_insert 'client_scouts_equipment_x_co_customer','z57_cst_key','z57_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_experimental_registration','x13_ind_cst_key_1','x13_key'			, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_experimental_registration','x13_org_cst_key','x13_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_experimental_registration','x13_ind_cst_key_2','x13_key'			, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_external_volunteer_screening','z25_ind_cst_key','z25_key'			, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_individual_x_reference','a16_ind_cst_key','a16_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_individual_x_volunteer_program','a15_ind_cst_key','a15_key'		, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_member_account','z11_ind_cst_key','z11_key'						, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_member_registration','a17_ind_cst_key','a17_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_member_registration','a17_group_org_cst_key','a17_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_member_registration','a17_pg2_ind_cst_key','a17_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_member_registration','a17_section_org_cst_key','a17_key'			, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_member_registration','a17_pg1_ind_cst_key','a17_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_online_transaction_error_log','z70_ind_cst_key','z70_key'			, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_online_user_exception_log','z71_cst_key','z71_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_online_user_exception_log','z71_ind_cst_key','z71_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_org_fee_x_date','a03_org_cst_key','a03_key'						, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_org_merge_history','a05_to_org_cst_key','a05_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_org_merge_history','a05_from_org_cst_key','a05_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_police_records_check','a18_ind_cst_key','a18_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_recognition_list_x_co_customer','z05_cst_key','z05_key'			, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_service_x_co_customer','z55_cst_key','z55_key'						, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_volunteer_screening','z21_ind_cst_key_1','z21_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_volunteer_screening','z21_ind_cst_key_2','z21_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_volunteer_screening','z21_ind_cst_key_3','z21_key'					, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_volunteer_screening_reference','z22_cst_key','z22_key'				, @REASON2, @akey
		exec client_scouts_merging_log_insert 'client_scouts_volunteer_screening_reference','z22_ind_cst_key','z22_key'			, @REASON2, @akey

		-- THESE ARE THE 4 TABLES THAT GET HIDDEN AFTER MERGE -- 
		exec client_scouts_merging_log_insert 'co_customer','cst_key','cst_key'													, @REASON2, @akey
		exec client_scouts_merging_log_insert 'co_individual','ind_cst_key','ind_cst_key'										, @REASON2, @akey
		exec client_scouts_merging_log_insert 'co_organization','org_cst_key','org_cst_key'										, @REASON2, @akey
		exec client_scouts_merging_log_insert 'co_chapter','chp_cst_key','chp_cst_key'											, @REASON2, @akey
	 END 
	 


	-- REMOVE DUPLICATE MEMBER_ACCOUNT RECORDS - which does not allow duplicate FK's 
	 
 	if @reason = 'BEFORE' begin 
		
		exec dbo.client_scouts_remove_member_account_dup @hide_key, @keep_key
	
	end 

	 
	 
END 
GO 

--===============================================================================================================


alter  proc client_scouts_merging_log_insert( 
	@table_name as varchar(50), 
	@fk_column_name as varchar(50), 
	@pk_column_name as varchar(50),
	@reason as varchar(50), 
	@cst_key as varchar(50)  
 )
AS
BEGIN 
	-- declare @table_key  ... later if we need to track PK for each row returned ??
	declare @stmt as nvarchar(1000) 	
	declare @descr as varchar (400) 

	-- FOR TESTING 
	-- exec client_scouts_merging_log_insert 'client_scouts_activity_x_co_customer','z56_cst_key','z56_key', 'testing', '08884cb9-1b2f-4373-bf69-7ff52d917e9C'
		
	set @descr = 'MERGING-LOG: [table, FK-field, CST_KEY, PK-field, PK-value]'
	
	set @stmt = 'INSERT INTO CLIENT_SCOUTS_GENERIC_LOG (
		z77_description
		, z77_reason
		, z77_source
		, z77_f1
		, z77_f2
		, z77_f3
		, z77_f4) '	
	set @stmt += ' SELECT ' 
		+ '''' + @descr + ''',' 
		+ '''' + @reason + ''',' 
		+ '''' + @table_name + ''','
		+ '''' + @fk_column_name + ''',' 
		+ '''' + @cst_key + ''',' 
		+ '''' + @pk_column_name + ''',' 
		+ @pk_column_name
		+ ' from ' + @table_name + ' where ' + @fk_column_name + ' = ''' + @cst_key + '''' 
	
	exec sp_executesql @stmt 
	
END 

GO 


/* 

FOR TEST 

declare @k2 varchar(50) = '6b96de8a-d4b5-4199-9360-3e50e587b6b2' --AB
declare @k1 varchar(50) = 'b962e1b4-e59d-4455-872a-2791b70e3586' --9C
exec client_scouts_merge_helper @k1, @k2, 'BEFORE'


set  @k2   = '6b96de8a-d4b5-4199-9360-3e50e587b6b2' --AB
set  @k1   = 'b962e1b4-e59d-4455-872a-2791b70e3586' --9C
exec client_scouts_merge_helper @k1, @k2, 'AFTER'

*/
--=========================================
go 


/* 

truncate table client_scouts_generic_log

select * from client_scouts_generic_log



---- ERROR DURING MERGE ...
 
All file groups have been processed..

Errors were encounterd and all changes were rolled back..
The statement has been terminated. 

Cannot insert duplicate key row in object 'dbo.client_scouts_member_account' 
with unique index 'IX_client_scouts_member_account'. 
The duplicate key value is (570c7aef-34f8-4dd4-a262-225605ab219f).

	both members have an assigned WEB Account ! - Must remove one of them !
	-- OR SHOULD WE AUTOMATICALLY DELETE ONE -- 

*/


