declare @key char(50);

-- select @key = cst_key from co_customer where cst_recno = 10204489 - 10209939 -- ME DEV/PROD

-- 10152538 and 10108903

select @key = cst_key from co_customer where cst_recno = 10108903   -- 903 is CURRENT/KEEPER 
select @key = cst_key from co_customer where cst_recno = 10152538   -- OLD SOFT DELETED KEY !

select 'CST_KEY:',@key 

/* 
--- NEEDED TO RESET co_individual_x_organization_ext to ACTIVE !!!!!  ?? retest - may be trigger ?
--- WHY did it change 
--- NOW - although ORG displays and is active - leaders and youth are still missing !!

UPDATE  co_individual_x_organization_ext
set ixo_status_ext = 'Active'
where ixo_key_ext = '1B81985D-9AB9-4A25-8BBD-8E6628C0B180'
*/

--===============================================================================================================================
--  this is code from FORM 
--	EXEC client_scouts_my_organizations_child_form '2A7B9F02-215A-42E2-A4E1-1EE8DB238D03' -- NEW 
 
/*
SELECT	    
co_individual_x_organization_ext.* 
-- ixo_key,	ixo_org_cst_key,	[Org Name]=org_name,	[Primary Org]=	case when cst_ixo_key=ixo_key 	then '<img src="../images/img_chkmk.gif" border="0"></img>' 
-- 			else 				'' 			end,    [Org Type]=org_ogt_code,	[Org Sub-Type]=a01_ogt_sub_type,	[Role]=ixoa.ixo_rlt_code,	[Status]=isnull(ixo_status_ext,'No Value'),	[Start Date]=ixoa.ixo_start_date,	[End Date]=ixoa.ixo_end_date
FROM 
	co_individual_x_organization ixoa (nolock)     
	JOIN co_customer on cst_key=@key
	JOIN co_individual_x_organization_ext  (nolock) on ixoa.ixo_key=ixo_key_ext
	JOIN co_organization on ixo_org_cst_key=org_cst_key
	JOIN co_organization_ext on org_cst_key_ext=org_cst_key
	LEFT JOIN client_scouts_organization_sub_type on org_a01_key_ext=a01_key
WHERE 
	--ixo_delete_flag=0 and 
	ixoa.ixo_ind_cst_key=@key
	--and (ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' or ixo_status_ext = 'Not Renewed')
ORDER BY org_name
*/

 
 
--===============================================================================================================================
-- for from list of leaders 

-- exec client_scouts_my_leaders_child_form '2A7B9F02-215A-42E2-A4E1-1EE8DB238D03' -- NEW 
-- exec client_scouts_my_leaders_child_form 'A8086E1B-CEB6-4CAB-BA79-8C0A2609F8C3' --OLD SOFT DELETED 

/*
select c.cst_change_date, * from co_customer c where c.cst_key = @key 
SELECT	* from 	co_individual_x_organization x where x.ixo_change_date = '2015-02-16'
SELECT	* from 	co_customer  x where x.cst_change_date = '2015-02-16'
--SELECT	* from 	co_individual_x_organization_ext  x where x. = '2015-02-16'
SELECT	* from 	co_organization  x where x.org_change_date = '2015-02-16'
--SELECT	* from 	co_organization_ext  x where x. = '2015-02-16'
SELECT	* from 	client_scouts_organization_sub_type  x where x.a01_change_date = '2015-02-16'
*/






RETURN 


/* 
--OLD: a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3
SELECT 'co_individual_x_organization' ,* FROM co_individual_x_organization IXO WHERE IXO.ixo_ind_cst_key is null 
--NEW: 2a7b9f02-215a-42e2-a4e1-1ee8db238d03
SELECT 'co_individual_x_organization' ,* FROM co_individual_x_organization IXO WHERE IXO.ixo_ind_cst_key = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
*/


SELECT 	'co_cistomer:' , CST_RECNO, CST_KEY, cst_ixo_key, cst_delete_flag
FROM co_customer
WHERE cst_key = @KEY 


SELECT 'co_individual:', ind_cst_key, ind_ixo_key  FROM co_individual 
WHERE co_individual.ind_cst_key = @KEY 


SELECT 'co_individual_x_organization' ,* FROM co_individual_x_organization IXO 
WHERE IXO.ixo_ind_cst_key = @key 


RETURN 

/*

	MEMNUM		CST_KEY									CST_IXO_KEY								DELETE_FLAG
new	10108903	2A7B9F02-215A-42E2-A4E1-1EE8DB238D03	1B81985D-9AB9-4A25-8BBD-8E6628C0B180	0
OLD	10152538	A8086E1B-CEB6-4CAB-BA79-8C0A2609F8C3	NULL									1

              

client_scouts_member_registration 
ev_event_faculty		fac_ixo_key
mb_membership_proxy		mpr_ixo_key
ev_registrant			reg_ixo_key
client_scouts_experimental_registration	x13_ixo_key

*/

/* 
--============================================================================================
-------------- HIDE MEM REG -----------------
select * from client_scouts_member_registration m where m.a17_ind_cst_key = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_member_registration m where m.a17_ind_cst_key = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- OLD / returning tmp
begin  transaction 
update client_scouts_member_registration 
set a17_ind_cst_key = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3'  -- OLD KEY 
where a17_ind_cst_key = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03' -- NEW KEY 
-- commit 
select * from client_scouts_member_registration m where m.a17_ind_cst_key = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_member_registration m where m.a17_ind_cst_key = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- 03 > FF
-----------------------------------


--============================================================================================
-------------- HIDE EXP REG -----------------
select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- OLD / returning tmp

begin  transaction 
update client_scouts_experimental_registration 
set x13_ind_cst_key_2 = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3'  -- OLD KEY 
where x13_ind_cst_key_2 = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03' -- NEW KEY 

select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- OLD / returning tmp

-- commit 

-----------------------------------

--============================================================================================
-------------- BRING BACK MEM REG -----------------
select * from client_scouts_member_registration m where m.a17_ind_cst_key = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_member_registration m where m.a17_ind_cst_key = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- OLD / returning tmp
begin  transaction 
update client_scouts_member_registration 
set a17_ind_cst_key = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'  -- new KEY 
where a17_ind_cst_key = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3'  -- OLD KEY 
-- commit 
select * from client_scouts_member_registration m where m.a17_ind_cst_key = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_member_registration m where m.a17_ind_cst_key = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- 03 > FF
-----------------------------------

--============================================================================================
-------------- show EXP REG -----------------

select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- OLD / returning tmp

begin  transaction 
update client_scouts_experimental_registration 
set x13_ind_cst_key_2 = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03' -- NEW KEY 
where x13_ind_cst_key_2 = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3'  -- OLD KEY 

select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = '2a7b9f02-215a-42e2-a4e1-1ee8db238d03'
select * from client_scouts_experimental_registration m where m.x13_ind_cst_key_2 = 'a8086e1b-ceb6-4cab-ba79-8c0a2609f8c3' -- OLD / returning tmp

-- COMMIT 
-- client_scouts_member_registration <<< cHANGING THE ixo key !!!!

-- select * from client_scouts_generic_log 
*/




select 'mem_reg',* from client_scouts_member_registration			 	WHERE a17_group_org_cst_key=@key OR a17_ind_cst_key=@key OR a17_pg1_ind_cst_key=@key OR a17_pg2_ind_cst_key=@key OR a17_section_org_cst_key=@key; 
select 'exp_reg',* from client_scouts_experimental_registration			WHERE x13_ind_cst_key_1=@key OR x13_ind_cst_key_2=@key OR x13_org_cst_key=@key; 
select 'actXcst', * from client_scouts_activity_x_co_customer 	WHERE z56_cst_key=@key; 
select 'approv',* from client_scouts_approval_record					WHERE z26_cst_key  =@key OR z26_ind_cst_key=@key; 
select 'indXprt',* from client_scouts_co_individual_x_participation			WHERE a13_ind_cst_key=@key; 
select 'conduct',* from client_scouts_code_of_conduct_x_co_individual		WHERE z24_entry_ind_cst_key=@key OR z24_ind_cst_key=@key; 
select 'catXcst',* from client_scouts_course_catalogue_x_co_customer	WHERE z03_cst_key=@key; 
select 'emerg_info',* from client_scouts_emergency_contact_info		 	WHERE a11_ind_cst_key=@key;
select 'equipXcst',* from client_scouts_equipment_x_co_customer		 	WHERE z57_cst_key=@key; 
select 'volscreen',* from client_scouts_external_volunteer_screening	WHERE z25_ind_cst_key=@key; 
select 'iXref',* from client_scouts_individual_x_reference		 		WHERE a16_ind_cst_key=@key; 
select 'iXvp',* from client_scouts_individual_x_volunteer_program		WHERE a15_ind_cst_key=@key; 
select 'memacct',* from client_scouts_member_account		 			WHERE z11_ind_cst_key=@key;
select 'errlog',* from client_scouts_online_transaction_error_log		WHERE z70_ind_cst_key=@key; 
select 'xlog',* from client_scouts_online_user_exception_log			WHERE z71_ind_cst_key=@key OR z71_cst_key=@key; 
select 'orgfeeXdate',* from client_scouts_org_fee_x_date				WHERE a03_org_cst_key=@key; 
select 'mrghist',* from client_scouts_org_merge_history					WHERE a05_from_org_cst_key=@key OR a05_to_org_cst_key=@key; 
select 'prc',* from client_scouts_police_records_check					WHERE a18_ind_cst_key=@key; 
select 'recXcst',* from client_scouts_recognition_list_x_co_customer	WHERE z05_cst_key=@key; 
select 'sXcst',* from client_scouts_service_x_co_customer				WHERE z55_cst_key=@key; 
select 'vol_screen',* from client_scouts_volunteer_screening 		 	WHERE z21_ind_cst_key_1=@key OR z21_ind_cst_key_2=@key OR z21_ind_cst_key_3=@key; 
select 'screen_ref',* from client_scouts_volunteer_screening_reference 	WHERE z22_cst_key=@key OR z22_ind_cst_key=@key; 


select * from co_individual_x_organization x where x.ixo_change_date = '2015-02-26'