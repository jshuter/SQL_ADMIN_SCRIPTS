
-- SET KEYS TO NULL 
BEGIN TRANSACTION 
update client_scouts_experimental_registration 
set x13_inv_key = NULL, x13_z70_key = NULL 
where x13_key like  'AAAAAA%'
-- commit 

-- REMOVE LOGS if they exists 
BEGIN TRANSACTION 
delete client_scouts_online_transaction_error_log 
where z70_x13_key like  'AAAAAA%'
--commit 

-- REMOVE DISCOUTS if they exist 
BEGIN TRANSACTION 
delete client_scouts_discount 
where z80_experimental_registration_key like 'AAAAAA%'
--commit 
 

-- COMPLETE RENAME OF ALL TEST X13 KEYS to have AAAAAAAA...000000## format 

-- THEN UPDATE the X13' as desired 
begin transaction 
update client_scouts_experimental_registration 
set x13_progress = 'Terms' 
	, x13_type = '2018' 
	, x13_ind_cst_key_1 = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D' -- me 
	, x13_ind_cst_key_2 = '40827192-FABE-4F4B-9317-440A2E5B9FA5' -- my kid 
	, x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT 
	, x13_registration_terms_agreement_flag = 1
	, x13_privacy_agreement_flag = 1 
	, x13_medical_agreement_flag = 1 
	, x13_participant_agreement_flag = 1 
	, x13_org_cst_key = '725A3F0F-92E3-4B30-AF8B-4FCD308DBC95' -- 1st EXP Colony  
	, x13_ixo_key = NULL -- remove any old KEYS 
	, x13_delete_flag = 0
where x13_key like 'AAAAAAAA%' 
-- commit 



-- 2 dor LDS TESTING 
----- KEEP LAST 2 for LDS Section COLONY ------- 
-- select * from co_organization where org_name like 'Test LDS%%'
begin transaction 
update client_scouts_experimental_registration 
set x13_progress = 'Terms' 
	, x13_type = '2018' 
	, x13_ind_cst_key_1 = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D' -- me 
	, x13_ind_cst_key_2 = '40827192-FABE-4F4B-9317-440A2E5B9FA5' -- my kid 
	, x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT 
	, x13_registration_terms_agreement_flag = 1
	, x13_privacy_agreement_flag = 1 
	, x13_medical_agreement_flag = 1 
	, x13_participant_agreement_flag = 1 
	, x13_org_cst_key = '3EE46E25-71BA-475C-8C93-DACB043DD2E9' -- LDS TEST COLONY
	, x13_ixo_key = NULL -- remove any old KEYS 
	, x13_delete_flag = 0
where x13_key like 'AAAAAAAA%00017' or x13_key like 'AAAAAAAA%00018'
-- commit 




----- KEEP LAST 2 for ROVERS ------- 
-- select * from co_organization where org_name like '1st exp%'
begin transaction 
update client_scouts_experimental_registration 
set x13_progress = 'Terms' 
	, x13_type = '2018' 
	, x13_ind_cst_key_1 = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D' -- me 
	, x13_ind_cst_key_2 = '40827192-FABE-4F4B-9317-440A2E5B9FA5' -- my kid 
	, x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT 
	, x13_registration_terms_agreement_flag = 1
	, x13_privacy_agreement_flag = 1 
	, x13_medical_agreement_flag = 1 
	, x13_participant_agreement_flag = 1 
	, x13_org_cst_key = '21EA746E-EDB5-435A-8E2D-2BBE8E9AF382' -- 1st EXP CREW  
	, x13_ixo_key = NULL -- remove any old KEYS 
	, x13_delete_flag = 0
where x13_key like 'AAAAAAAA%00019' or x13_key like 'AAAAAAAA%00020'
-- commit 

 




-- THEN UPDATE the X13' as desired 

------------------------------------------------
--- CAN LOOP THRU HERE WHILE x13_ixo_key is NULL 
--- LIMIT max 20 etc to avoid enles loop 

-- DISPLAY THE TEST DATA 
select * from client_scouts_experimental_registration where x13_key like 'AAAAAAAA%'

-- BEGIN STEP - INSERT ROLE 

	-- Create a ROLE IXO for the REG 
	declare @x13_key uniqueidentifier 
	declare @org_key uniqueidentifier 
	declare @ind_key uniqueidentifier 
	declare @ixo_key uniqueidentifier 
	 
	select top 1 @x13_key = x13_key, @org_key = x13_org_cst_key, @ind_key = x13_ind_cst_key_2 
		 from client_scouts_experimental_registration 
		 where x13_key like 'AAAAAAAA%' and x13_ixo_key is null

	-- create a new IXO -- 
	exec client_scouts_create_participant_ixo_xweb 	@x13_key, '2017-01-01', '2018-08-31' --, @debug=1 

	-- show it - assume it was created 
	select * 
		from co_individual_x_organization LEFT join client_scouts_experimental_registration on x13_ixo_key = ixo_key 
		where ixo_org_cst_key = @org_key and ixo_ind_cst_key = @ind_key
		and ixo_add_date > cast(getdate() as DATE) 
		and x13_key is NULL 

	-- Find It - assume it was created 
	select @ixo_key = ixo_key 
		from co_individual_x_organization LEFT join client_scouts_experimental_registration on x13_ixo_key = ixo_key 
		where ixo_org_cst_key = @org_key and ixo_ind_cst_key = @ind_key
		and ixo_add_date > cast(getdate() as DATE) 
		and x13_key is NULL 

	-- Insert the new ixo_key into the x13_record
	if(@ixo_key is not null) begin 
		update client_scouts_experimental_registration set x13_ixo_key = @ixo_key where x13_key = @x13_key 
	end 

-- END OF LOOP 

-- END OF STEP -- 


-- AFTER TEST BEGINS
select * from client_scouts_experimental_registration where x13_key like 'AAAAAAAA%'

select * from client_scouts_online_transaction_error_log where z70_x13_key like 'AAAAAA%' order by z70_add_date desc 



