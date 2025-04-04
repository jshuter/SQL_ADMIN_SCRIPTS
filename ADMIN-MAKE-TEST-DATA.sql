/* 
--- MY KIDS ---- 
select ind_first_name, ind_last_name , cst_ind_full_name_dn, * 
FROM         co_customer
join co_individual on cst_key = ind_cst_key 
WHERE     (cst_key IN ('AD463002-C880-4237-8593-F13190AEDDA3', 'EFAE566C-27E1-43C6-9A91-CD97DA19C6E4', 'ACB67021-AFCE-4349-B23A-3E90EAA9ABDC', 
                      '67A47EBC-918B-4CA6-A1FA-91E033FCADEE', 'FC4B6785-4D31-4A66-94A9-9A55BF3FCB33', 'ADFEBF17-03DE-4702-B37A-D61002B2BC70', 
                      'C2033ACC-8143-4C3C-8AB5-19C46648087B', 'ADB2447F-46AD-4F04-82B9-43A9012C8D64', '2C88A1B6-101A-4D92-8100-82FF3809C17C', 
                      'E2A84413-5DC5-4E68-821D-9AF46E5E1714', '8F9DC61F-1ACE-45F8-A21C-D6D67EAB8A05'))
ORDER BY cst_sort_name_dn
*/

/* 

-- SUMMARY IXO REG DATA 

select x13_type, x13_progress, x13_inv_key,x13_ixo_key, * 
from client_scouts_experimental_registration where x13_add_date > '2016-03-18' 
and x13_type = '2016+2017'
order by x13_add_date desc 

select x13_type, x13_progress, x13_inv_key,x13_ixo_key, * 
from client_scouts_experimental_registration where x13_add_date > '2016-03-18' 
order by x13_add_date desc 

select ixo_key, ixo_key_ext, * from co_individual_x_organization 
left join co_individual_x_organization_ext on ixo_key = ixo_key_ext 
where ixo_add_date > '2016-03-18' 
order by ixo_add_date desc 

*/


/* 
-- ================= DELETE ALL IXO's for a single INDIVIDUAL by CST_KEY ============

declare @cst_key as uniqueidentifier = 'E2A84413-5DC5-4E68-821D-9AF46E5E1714'
-- FK on EXP_REG 
update client_scouts_experimental_registration set x13_ixo_key = NULL where x13_ixo_key in (select ixo_key from co_individual_x_organization where ixo_ind_cst_key = @cst_key ) 
-- REMOVE PRIMARY ROLES TOO 
update co_customer set cst_ixo_key = NULL where cst_ixo_key in (select ixo_key from co_individual_x_organization where ixo_ind_cst_key = @cst_key ) 
-- ext record 
delete from co_individual_x_organization_ext where ixo_key_ext in (select ixo_key from co_individual_x_organization where ixo_ind_cst_key = @cst_key  )  -- Kid 001 
-- main record
delete  from co_individual_x_organization where ixo_ind_cst_key = @cst_key   -- Kid 001 
--

--======================================================================================
*/
--- IXO SUMMARY 
select ind_first_name, ind_last_name , cst_ind_full_name_dn
, (select count(*) as x from co_individual_x_organization where cst_key = ixo_ind_cst_key) as ixo_all 
, (select count(*) as x from co_individual_x_organization where cst_key = ixo_ind_cst_key and  ixo_start_date 
	between (select scouting_start_date from client_scouts_get_scouting_DATE_RANGE())
		AND (select scouting_END_date from client_scouts_get_scouting_DATE_RANGE()) ) as ixo_current
, (select count(*) as x from co_individual_x_organization where cst_key = ixo_ind_cst_key and  ixo_start_date 
	> (select scouting_END_date from client_scouts_get_scouting_DATE_RANGE() )) AS  IXO_FUTURE

, * 
FROM         co_customer
join co_individual on cst_key = ind_cst_key 
WHERE     (cst_key IN ('AD463002-C880-4237-8593-F13190AEDDA3', 'EFAE566C-27E1-43C6-9A91-CD97DA19C6E4', 'ACB67021-AFCE-4349-B23A-3E90EAA9ABDC', 
                      '67A47EBC-918B-4CA6-A1FA-91E033FCADEE', 'FC4B6785-4D31-4A66-94A9-9A55BF3FCB33', 'ADFEBF17-03DE-4702-B37A-D61002B2BC70', 
                      'C2033ACC-8143-4C3C-8AB5-19C46648087B', 'ADB2447F-46AD-4F04-82B9-43A9012C8D64', '2C88A1B6-101A-4D92-8100-82FF3809C17C', 
                      'E2A84413-5DC5-4E68-821D-9AF46E5E1714', '8F9DC61F-1ACE-45F8-A21C-D6D67EAB8A05'))
ORDER BY cst_sort_name_dn


-- REVIEW FOR ONE CST_KEY 
select * from   dbo.client_scouts_participant_roles_summary(  'EFAE566C-27E1-43C6-9A91-CD97DA19C6E4') 



SELECT IXO_STATUS_EXT  , IXO_START_DATE SD, * FROM CO_INDIVIDUAL_X_ORGANIZATION  
join CO_INDIVIDUAL_X_ORGANIZATION_EXT ON IXO_KEY = IXO_KEY_EXT 
WHERE IXO_IND_CST_KEY = 'EFAE566C-27E1-43C6-9A91-CD97DA19C6E4' ORDER BY IXO_START_DATE 


DELETe CO_INDIVIDUAL_X_ORGANIZATION_EXT WHERE IXO_KEY_EXT = '31DC0624-9CDE-4E66-B594-6C5AD677D74F'
DELETe CO_INDIVIDUAL_X_ORGANIZATION WHERE IXO_KEY = '31DC0624-9CDE-4E66-B594-6C5AD677D74F'

--- script CREATE ROLES / CLEAR ROLES / CHANGE STATUS ON ROLES -- for all my children !!!
--- create data for testing ---

-- DELETE MY CHILRENDS ROLES !
DELETE from co_individual_x_organization 
where ixo_ind_cst_key in ('AD463002-C880-4237-8593-F13190AEDDA3', 'EFAE566C-27E1-43C6-9A91-CD97DA19C6E4', 'ACB67021-AFCE-4349-B23A-3E90EAA9ABDC', 
                      '67A47EBC-918B-4CA6-A1FA-91E033FCADEE', 'FC4B6785-4D31-4A66-94A9-9A55BF3FCB33', 'ADFEBF17-03DE-4702-B37A-D61002B2BC70', 
                      'C2033ACC-8143-4C3C-8AB5-19C46648087B', 'ADB2447F-46AD-4F04-82B9-43A9012C8D64', '2C88A1B6-101A-4D92-8100-82FF3809C17C', 
                      'E2A84413-5DC5-4E68-821D-9AF46E5E1714', '8F9DC61F-1ACE-45F8-A21C-D6D67EAB8A05')

; 
*/


/* DELETE !!!!!!!!!!!!! 
;

declare @kids as table(k varchar(100)) ; 

insert into @kids values('AD463002-C880-4237-8593-F13190AEDDA3') 
insert into @kids values('EFAE566C-27E1-43C6-9A91-CD97DA19C6E4')
insert into @kids values('ACB67021-AFCE-4349-B23A-3E90EAA9ABDC') 
insert into @kids values('67A47EBC-918B-4CA6-A1FA-91E033FCADEE')
insert into @kids values('FC4B6785-4D31-4A66-94A9-9A55BF3FCB33')
insert into @kids values('ADFEBF17-03DE-4702-B37A-D61002B2BC70')  
insert into @kids values( 'C2033ACC-8143-4C3C-8AB5-19C46648087B')
insert into @kids values('ADB2447F-46AD-4F04-82B9-43A9012C8D64') 
insert into @kids values('2C88A1B6-101A-4D92-8100-82FF3809C17C')
insert into @kids values('E2A84413-5DC5-4E68-821D-9AF46E5E1714')
insert into @kids values('8F9DC61F-1ACE-45F8-A21C-D6D67EAB8A05')


-- STEP ONE - unlink IXO from X13 
with kidskeys as ( 
select k as cstkey from @kids
) 
update client_scouts_experimental_registration 
set x13_ixo_key = NULL 
where x13_ind_cst_key_1 in (select cstkey from kidskeys) -- assuming we can then delete all IXO's 
   or x13_ind_cst_key_2 in (select cstkey from kidskeys) 

;
--- delete ixo_ext's
with ixokeys as (select ixo_key from co_individual_x_organization join @kids ks on ks.k = ixo_ind_cst_key) 
delete co_individual_x_organization_ext where ixo_key_ext in (select ixo_key from ixokeys) 

;
-- delete ixo's
with ixokeys as (select ixo_key from co_individual_x_organization join @kids ks on ks.k = ixo_ind_cst_key) 
delete co_individual_x_organization where ixo_ind_cst_key in (select ixo_key from ixokeys) 


--commit 

*/

--======================================================================================
--- insert NEW ixos !!!
--========================================================================================

CREATE PROCEDURE #TMP_MAKE_TESTDATA_IXO( 
	  @ind_cst_key  uniqueidentifier = '67A47EBC-918B-4CA6-A1FA-91E033FCADEE'
	 ,@org_cst_key  uniqueidentifier = '725A3F0F-92E3-4B30-AF8B-4FCD308DBC95'
	 ,@year varchar(4) = NULL
	 ,@rlt_code varchar(100) = 'Beaver Scout'
	 ,@status varchar(12) = 'Active'
	 ,@mbt_code varchar(20) = 'Participant' -- DEFAULT PARTICIPANT 
	 ,@primary bit = 0 
)

AS

BEGIN  

	-- set required values 
	declare @start_date varchar(10) 
	declare @end_date  varchar(10)  
	declare @mbt_key uniqueidentifier  
	declare @new_key uniqueidentifier = newid() 

	set @start_date   = @year + '-01-01'
	set @end_date     = @year + '-08-31'
	set @mbt_key      = (select mbt_key from mb_member_type where mbt_code = @mbt_code) 
	if @year is NULL	set @year = year(getdate())

	INSERT co_individual_x_organization(ixo_key,ixo_rlt_code ,ixo_start_date ,ixo_end_date ,ixo_ind_cst_key ,ixo_org_cst_key) 	   
	values(@new_key,@rlt_code,@start_date,@end_date,@ind_cst_key,@org_cst_key) 

	INSERT co_individual_x_organization_ext(ixo_key_ext,ixo_mbt_key_ext,ixo_status_ext) 
	values(@new_key,@mbt_key,@status)
	
	-- AND SET AS primary role -- iff ...
	
	if (@primary = 1) begin 
		update co_customer set cst_ixo_key = @new_key where cst_key = @ind_cst_key
	end 

END 





/* TEST ----------------------------*/

declare @kids as table(k varchar(100)) ; 

insert into @kids values('AD463002-C880-4237-8593-F13190AEDDA3') 
insert into @kids values('EFAE566C-27E1-43C6-9A91-CD97DA19C6E4')
insert into @kids values('ACB67021-AFCE-4349-B23A-3E90EAA9ABDC') 
insert into @kids values('67A47EBC-918B-4CA6-A1FA-91E033FCADEE')
insert into @kids values('FC4B6785-4D31-4A66-94A9-9A55BF3FCB33')
insert into @kids values('ADFEBF17-03DE-4702-B37A-D61002B2BC70')  
insert into @kids values( 'C2033ACC-8143-4C3C-8AB5-19C46648087B')
insert into @kids values('ADB2447F-46AD-4F04-82B9-43A9012C8D64') 
insert into @kids values('2C88A1B6-101A-4D92-8100-82FF3809C17C')
insert into @kids values('E2A84413-5DC5-4E68-821D-9AF46E5E1714')
insert into @kids values('8F9DC61F-1ACE-45F8-A21C-D6D67EAB8A05')
insert into @kids values('3999E32D-2DC0-4BAB-B94C-A8E514A9113D') 
	select K, c.cst_ind_full_name_dn , 
	[ShowRenewButton-old] = (select dbo.client_scouts_user_eligible_for_renewal(k, 'E87125F1-78AE-4C44-B4A3-39A406516C64')),

    [ShowRenewButton-sum] =	(SELECT sum(role_count_next_year) 
						FROM client_scouts_participant_roles_summary(k) 
						WHERE ixo_status_ext in ('Active', 'Not Renewed')),

    [ShowRenewButton-new] =	(SELECT case when sum(role_count_next_year) < 1 then 1 else 0 end 
						FROM client_scouts_participant_roles_summary(k) 
						WHERE ixo_status_ext in ('Active', 'Not Renewed'))


    ,[ShowRenewButton-NotRenewed] = (SELECT case when sum(role_count_next_year) < 1 then 1 else 0 end 
						FROM client_scouts_participant_roles_summary(k) 
						WHERE ixo_status_ext in ('Not Renewed'))

from @kids join co_customer c on cst_key = k 
order by c.cst_ind_full_name_dn




SELECT case when sum(role_count_next_year) < 1 then 1 else 0 end 
	FROM client_scouts_participant_roles_summary('C2033ACC-8143-4C3C-8AB5-19C46648087B') 
	WHERE ixo_status_ext in ('Active', 'Not Renewed')  

SELECT * -- case when sum(role_count_next_year) < 1 then 1 else 0 end 
	FROM client_scouts_participant_roles_summary('C2033ACC-8143-4C3C-8AB5-19C46648087B') 
	WHERE ixo_status_ext in ('Not Renewed')  

-------------------

-- get early reg/pre reg status 

--select pre_early_registration_start_date , early_registration_end_date                    from client_scouts_get_registration_date_range() 
---- when both are positive - then we are in range !
--select datediff(DAY,pre_early_registration_start_date, GETDATE()) from client_scouts_get_registration_date_range() 
--select datediff(DAY,getdate(), early_registration_end_date)  from client_scouts_get_registration_date_range() 

-- ARE WE IN EARLY or PRE REG ?
declare @early_reg_enabled as int = -1 -- default is dont show 
select @early_reg_enabled = datediff(DAY,pre_early_registration_start_date, GETDATE()) * datediff(DAY,getdate(), early_registration_end_date) from client_scouts_get_registration_date_range() 
select @early_reg_enabled

------------------------------------------------
	(SELECT case when sum(role_count_next_year) < 1 
				then 1 
				else 0 end -- NULL becomes 0 
--  

select * 
	FROM client_scouts_participant_roles_summary('ADB2447F-46AD-4F04-82B9-43A9012C8D64') 
	WHERE ixo_status_ext in ('Active', 'Not Renewed')),
	CONVERT(varchar(10),ixo_start_date,101) as [StartDate],
	CONVERT(varchar(10),ixo_end_date,101) as [EndDate]


---

-- 1
'67A47EBC-918B-4CA6-A1FA-91E033FCADEE'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='67A47EBC-918B-4CA6-A1FA-91E033FCADEE', @primary = 1
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2017', @status = 'Active', @ind_cst_key='67A47EBC-918B-4CA6-A1FA-91E033FCADEE'
--2
'E2A84413-5DC5-4E68-821D-9AF46E5E1714'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='E2A84413-5DC5-4E68-821D-9AF46E5E1714', @primary = 1
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='E2A84413-5DC5-4E68-821D-9AF46E5E1714'

--3
'ADFEBF17-03DE-4702-B37A-D61002B2BC70'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='ADFEBF17-03DE-4702-B37A-D61002B2BC70'

--4
'ADB2447F-46AD-4F04-82B9-43A9012C8D64'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='ADB2447F-46AD-4F04-82B9-43A9012C8D64', @primary = 1
select * from dbo.client_scouts_participant_roles_summary('ADB2447F-46AD-4F04-82B9-43A9012C8D64') 

 -- test 004 for each section test case in the REG YEAR RANGE tests 
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='ADB2447F-46AD-4F04-82B9-43A9012C8D64', @org_cst_key = 'A145AD7E-C983-4AAE-9C83-5DC6185CF731'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='ADB2447F-46AD-4F04-82B9-43A9012C8D64', @org_cst_key = '7DE9CD32-8AB8-47B6-8E67-17C8D6DD4A89'			
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='ADB2447F-46AD-4F04-82B9-43A9012C8D64', @org_cst_key = 'BB509AC4-6A06-4068-A555-1A9F7BD0100F'				
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='ADB2447F-46AD-4F04-82B9-43A9012C8D64', @org_cst_key = 'D5609360-CC0D-483B-8B8E-57BA20480C1C'				

--5
'FC4B6785-4D31-4A66-94A9-9A55BF3FCB33'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='FC4B6785-4D31-4A66-94A9-9A55BF3FCB33'

--6
'ACB67021-AFCE-4349-B23A-3E90EAA9ABDC'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='ACB67021-AFCE-4349-B23A-3E90EAA9ABDC', @primary = 1
--7

'2C88A1B6-101A-4D92-8100-82FF3809C17C'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='2C88A1B6-101A-4D92-8100-82FF3809C17C', @primary = 1
select * from dbo.client_scouts_participant_roles_summary('2C88A1B6-101A-4D92-8100-82FF3809C17C') 

--8
'EFAE566C-27E1-43C6-9A91-CD97DA19C6E4'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='EFAE566C-27E1-43C6-9A91-CD97DA19C6E4', @primary = 1
select * from co_customer where cst_key = 'EFAE566C-27E1-43C6-9A91-CD97DA19C6E4'
select * from dbo.client_scouts_participant_roles_summary('EFAE566C-27E1-43C6-9A91-CD97DA19C6E4') 

SELECT case when sum(role_count_next_year) < 1 then 1 else 0 end 
						FROM client_scouts_participant_roles_summary('EFAE566C-27E1-43C6-9A91-CD97DA19C6E4') 
						WHERE ixo_status_ext in ('Active', 'Not Renewed')

exec [client_scouts_my_family_xWeb] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D' 

--9
-- 'C2033ACC-8143-4C3C-8AB5-19C46648087B'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2015', @status = 'Not Renewed', @ind_cst_key='C2033ACC-8143-4C3C-8AB5-19C46648087B',  @primary = 1


--10 - OLD ROLES - INACTIVE 
-- '8F9DC61F-1ACE-45F8-A21C-D6D67EAB8A05'
exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2015', @status = 'Not Renewed', @ind_cst_key='8F9DC61F-1ACE-45F8-A21C-D6D67EAB8A05', @primary = 1

--11 - NO ROLES 
'AD463002-C880-4237-8593-F13190AEDDA3'


exec dbo.#TMP_MAKE_TESTDATA_IXO  @year = '2016', @status = 'Active', @ind_cst_key='AD463002-C880-4237-8593-F13190AEDDA3' , @primary=1



-----------------------------------------------------------------------------
--- summary for 1 key 
-----------------------------------------------------------------------------

declare @key varchar(100) = 'ADB2447F-46AD-4F04-82B9-43A9012C8D64'
select * from dbo.client_scouts_participant_roles_summary(@key) 


SELECT * FROM client_scouts_participant_roles_summary(@key) 

SELECT * FROM client_scouts_participant_roles_summary(@key)  
WHERE ixo_status_ext in ('Active', 'Not Renewed')

SELECT sum(role_count_next_year) FROM client_scouts_participant_roles_summary(@key) 
WHERE ixo_status_ext in ('Active', 'Not Renewed')

SELECT case when sum(role_count_next_year) < 1 then 1 else 0 end 
	FROM client_scouts_participant_roles_summary(@key) 
	WHERE ixo_status_ext in ('Active', 'Not Renewed')

-- 1 field 
 select [X] = (SELECT case when sum(role_count_next_year) < 1 
									then 1 
									else 0 end -- TEST 10 
						FROM client_scouts_participant_roles_summary(@key) 
						WHERE ixo_status_ext in ('Active', 'Not Renewed'))
						
-- nested query - locks ? 
select cst_key, (select [X] = (SELECT case when sum(role_count_next_year) < 1 
									then 1 
									else 0 end -- TEST 10 
						FROM client_scouts_participant_roles_summary(@key) 
						WHERE ixo_status_ext in ('Active', 'Not Renewed'))
) 						
from co_customer where cst_key = @key 
