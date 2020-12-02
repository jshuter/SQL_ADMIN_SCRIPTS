

exec  #cst_dump 908391
exec  #cst_dump 10190391

create procedure #CST_DUMP (@recno int ) 
as
BEGIN 

declare @key char(50);
select @key = cst_key from co_customer where cst_recno = @recno  

select 'memreg',* from client_scouts_member_registration			 	WHERE a17_group_org_cst_key=@key OR a17_ind_cst_key=@key OR a17_pg1_ind_cst_key=@key OR a17_pg2_ind_cst_key=@key OR a17_section_org_cst_key=@key; 
select 'expreg',* from client_scouts_experimental_registration			WHERE x13_ind_cst_key_1=@key OR x13_ind_cst_key_2=@key OR x13_org_cst_key=@key; 
select 'activityXcst', * from client_scouts_activity_x_co_customer 	WHERE z56_cst_key=@key; 
select 'catXcst',* from client_scouts_course_catalogue_x_co_customer	WHERE z03_cst_key=@key; 
select 'recXcst',* from client_scouts_recognition_list_x_co_customer	WHERE z05_cst_key=@key; 
select 'sXcst',* from client_scouts_service_x_co_customer				WHERE z55_cst_key=@key; 
select 'equipXcst',* from client_scouts_equipment_x_co_customer		 	WHERE z57_cst_key=@key; 
select 'approv',* from client_scouts_approval_record					WHERE z26_cst_key  =@key OR z26_ind_cst_key=@key; 
select 'iXp',* from client_scouts_co_individual_x_participation			WHERE a13_ind_cst_key=@key; 
select 'code',* from client_scouts_code_of_conduct_x_co_individual		WHERE z24_entry_ind_cst_key=@key OR z24_ind_cst_key=@key; 
select 'emerg_info',* from client_scouts_emergency_contact_info		 	WHERE a11_ind_cst_key=@key;
select 'volscreen',* from client_scouts_external_volunteer_screening	WHERE z25_ind_cst_key=@key; 
select 'indXref',* from client_scouts_individual_x_reference		 		WHERE a16_ind_cst_key=@key; 
select 'indXvp',* from client_scouts_individual_x_volunteer_program		WHERE a15_ind_cst_key=@key; 
select 'memacct',* from client_scouts_member_account		 			WHERE z11_ind_cst_key=@key;
select 'errlog',* from client_scouts_online_transaction_error_log		WHERE z70_ind_cst_key=@key; 
select 'exclog',* from client_scouts_online_user_exception_log			WHERE z71_ind_cst_key=@key OR z71_cst_key=@key; 
select 'orgfeeXdate',* from client_scouts_org_fee_x_date				WHERE a03_org_cst_key=@key; 
select 'mrghist',* from client_scouts_org_merge_history					WHERE a05_from_org_cst_key=@key OR a05_to_org_cst_key=@key; 
select 'prc',* from client_scouts_police_records_check					WHERE a18_ind_cst_key=@key; 
select 'vol_screen',* from client_scouts_volunteer_screening 		 	WHERE z21_ind_cst_key_1=@key OR z21_ind_cst_key_2=@key OR z21_ind_cst_key_3=@key; 
select 'screen_ref',* from client_scouts_volunteer_screening_reference 	WHERE z22_cst_key=@key OR z22_ind_cst_key=@key; 

select 'co_individual_x_organization',* from co_individual_x_organization  x WHERE x.ixo_ind_cst_key = @key; 
select 'co_individual',* from co_individual  x	WHERE x.ind_cst_key = @key; 
select 'co_organization' from co_organization x where x.org_cst_key = @key; 

END
GO 