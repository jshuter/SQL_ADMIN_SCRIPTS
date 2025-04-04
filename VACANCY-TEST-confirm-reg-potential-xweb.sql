USE [netForumSCOUTSTest]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST]    Script Date: 03/06/2015 09:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--	MCharette
-- Create date: 06/14/2012
-- Description:	Perform a series of checks to confirm a section is fit for online registration and has vacancy

-- TODO 

 --- adjust use of delete_flag ! only in final select ? or NULL XOR 0 !
 --- use = 'Active','Pending' -- dont use != 'Inactive' 


-- =============================================
ALTER PROCEDURE [dbo].[client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST] 

	@org_cst_key		uniqueidentifier,			  
	@parent_org_cst_key	uniqueidentifier = null,      
	@year				varchar(4),					  -- HOW IS THIS SET since may of 2014 ? has been set as 2015 / and nextyear = 2016
	@isRegistrar		varchar(1) = null,             -- HOW IS THIS SET 
	@debug				smallint = 1

AS
BEGIN

--<MINE

-- WHEN DOES ORG_VOL/YOUTH_CAPACITY.... values change ???
-- DO THEY NEED TO COMPLY WITH  PARTICIPANT/LEADER RATIOS  ???

-- WHAT HAPPENS AFTER MAY 1 ... VIS A VIS REGISTRATION ... 

	-- AFFECTS QUESTIONS - what year value should be used 


-- SHOULD WE set to 0 if number is negative ?

-- @YEAR is passed by Drupal COde ? - does it need to be passed ??
-- @NEXTYEAR is @YEAR + 1 !!! 

-- SHOULD YEAR JUST BE CALCULATED ...

  
/*
declare 	@org_cst_key		uniqueidentifier = 'FDACD997-6BFF-4553-92BC-FE1A9FC41228',
			@parent_org_cst_key	uniqueidentifier = '5DC483F7-A0B2-4851-82BB-ADE1CD257433',
			@year				varchar(4) = '2015',
			@isRegistrar		varchar(1) = '0'
*/

-- select * from MB_MEMBER_TYPE 

-- NOTE -- The @YEAR param  is passed into here, but is set as follows from the calling function
--				IFF current-MONTH is before SEPT (9), - use current-YEAR
--				OTHERWISE - add 1 to YEAR 

-- THEREFORE YEAR is PASSED as the END YEAR of the SCOUTING YEAR (NOT BEGINNING, AND NOT CURRENT) 

-- @NEXTYEAR 

	SET NOCOUNT ON;	

	declare @nextYear varchar(4) = convert(int, @year) + 1;

	With ParticipantsThisYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'   -- PARTICIPANT -- JOINS ON ... WHERE  mbt_code = 'Participant' 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() between ixo_start_date and ixo_end_date)
		AND				ixo_status_ext in ('Active','Pending')
	), ParticipantsNextYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT --JOINS ON ... WHERE  mbt_code = 'Participant' 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() > convert(datetime, @year + '-05-01 00:00:00') and ixo_start_date >= convert(datetime, @nextYear + '-09-01 00:00:00'))
		AND				ixo_status_ext in ('Active','Pending')
	), VolunteersThisYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		like 'A%'         -- <<< IMPLIES VOLUNTEER -- !!! 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() between ixo_start_date and ixo_end_date)
		AND				ixo_status_ext in ('Active','Pending')
	), VolunteersNextYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		like 'A%'       -- <<< IMPLIES VOLUNTEER -- !!! 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() > convert(datetime, @year + '-05-01 00:00:00') and ixo_start_date >= convert(datetime, @nextYear + '-09-01 00:00:00'))
		AND				ixo_status_ext in ('Active','Pending')
	), ValidFeesAndBankThisYear as (
		SELECT			COUNT(*) as Configured
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext                                         -- PARTICIPANT --JOIN ON ... WHERE  mbt_code = 'Participant' 
			inner join	client_scouts_org_fee_x_date	on org_cst_key = a03_org_cst_key and a03_delete_flag = 0 and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' 
		where			(select org_hierarchy_hash_ext from co_organization_ext ce where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			getdate() between a03_from_date and a03_to_date
	), ValidFeesAndBankNextYear as (
		SELECT			COUNT(*) as Configured
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext                                           -- PARTICIPANT --JOIN ON ... WHERE  mbt_code = 'Participant' 
			inner join	client_scouts_org_fee_x_date	on org_cst_key = a03_org_cst_key and a03_delete_flag = 0 and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
		where			(select org_hierarchy_hash_ext from co_organization_ext ce where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			(getdate() > convert(datetime, @nextYear + '-05-01 00:00:00') and getdate() between convert(datetime, @year + '-09-01 00:00:00') and convert(datetime, @nextYear + '-08-31 23:59:00'))
	), VacancyVolunteer		as (
			select	org_vol_capacity_current_ext as [current],
					org_vol_capacity_next_ext [next]
			from	co_organization_ext(nolock)
			where	org_cst_key_ext = @org_cst_key
	), VacancyParticipant	as (
			select	org_youth_capacity_current_ext as [current],
					org_youth_capacity_next_ext [next]
			from	co_organization_ext(nolock)
			where	org_cst_key_ext = @org_cst_key
	)

	select
	CurrentYear			= @year,    -- FOR DISPLAY ('2015' Means that current DATE is in [Sept 1 2014 : 2015 AUG 31 2015] ) 
	VacantThisYear		= (select [current] from VacancyParticipant)	- (select * from ParticipantsThisYear), --(Simple subtract of DATA - count of rows) 
	VacantThisYearVol	= (select [current] from VacancyVolunteer)		- (select * from VolunteersThisYear),   --(Another simple count of DATA - count of rows) 
	
	VacantThisYearnew		= case when isnull((select [current] from VacancyParticipant) - (select Registered from ParticipantsThisYear),0) >  0
								then  isnull((select [current] from VacancyParticipant) - (select Registered from ParticipantsThisYear),0) 
								else 0 
								end ,
								
	VacantThisYearVolnew	= case when isnull((select [current] from VacancyVolunteer)	- (select Registered from VolunteersThisYear)  ,0) > 0 
								then isnull((select [current] from VacancyVolunteer)	- (select Registered from VolunteersThisYear)  ,0)
								else 0 
								end ,		

	AllowRegThisYear	= case when @isRegistrar = '1' 
								or (select org_ogt_code from co_organization(nolock) where org_cst_key = @org_cst_key) in ('National','Council','Area')
									-- looks like if one or more org_ogt_code's are in list ... then 1 
								then 1 
								else (select Configured from ValidFeesAndBankThisYear) -- COUNT OF ROWS ... needing a bit ore review ...
								end,
								
	NextYear			= @nextYear,
	VacantNextYear		= (select [next] from VacancyParticipant)	- (select * from ParticipantsNextYear),
	VacantNextYearVol	= (select [next] from VacancyVolunteer)		- (select * from VolunteersNextYear),
	AllowRegNextYear	= case	when @isRegistrar = '1' or (select org_ogt_code from co_organization(nolock) where org_cst_key = @org_cst_key) in ('National','Council','Area')
								then 1 else (select Configured from ValidFeesAndBankNextYear) end	
								



if @debug = 1 
	return  

if @debug = 2 begin 
--	), ValidFeesAndBankThisYear as (
		select 'OLD : Dates used for valid Fee&Bank this year : getdate() between: ', a03_from_date, a03_to_date , * 
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	on org_cst_key = a03_org_cst_key 
				and a03_delete_flag = 0									 -- not soft deleted (SHOULD THIS BE HERE ????) 
				and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT -- JOINS ON ... WHERE  mbt_code = 'Participant' 
		where			(select org_hierarchy_hash_ext from co_organization_ext ce where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			getdate() between a03_from_date and a03_to_date
			
			
		select 'NEW : Dates used for valid Fee&Bank this year : getdate() between: ', a03_from_date, a03_to_date , * 
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	on org_cst_key = a03_org_cst_key 
				-- and a03_delete_flag = 0									 -- not soft deleted (SHOULD THIS BE HERE ????) 
				and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT -- JOINS ON ... WHERE  mbt_code = 'Participant' 
		where			(select org_hierarchy_hash_ext from co_organization_ext ce where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			getdate() between a03_from_date and a03_to_date
			
			

return 
end


--	for xml path('vacancy'), elements xsinil, 
--	type,	root('vacancies')

--	With ParticipantsThisYear as (
		select			* 
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT --JOIN ON ... WHERE  mbt_code = 'Participant' 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() between ixo_start_date and ixo_end_date)
		AND				ixo_status_ext in ('Active','Pending')

		
--	), ParticipantsNextYear as (
		select			'Dates used to calculate ParticipantsNextYear:', convert(datetime, @year + '-05-01 00:00:00') 'getdate() > than',  convert(datetime, @nextYear + '-09-01 00:00:00') 'ixo_start_date >= than' 
		select			convert(datetime, @year + '-05-01 00:00:00') 'today > than',  convert(datetime, @nextYear + '-09-01 00:00:00') 'ixo_start_date >= than' , * 
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT --JOIN ON ... WHERE  mbt_code = 'Participant' 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() > convert(datetime, @year + '-05-01 00:00:00') and ixo_start_date >= convert(datetime, @nextYear + '-09-01 00:00:00'))
		AND				ixo_status_ext in ('Active','Pending')
	
--		SELECT convert(datetime, '2015' + '-05-01 00:00:00')

--select COUNT(*),  ixo_status_ext from co_individual_x_organization_ext group by ixo_status_ext
select ixo_status_ext from co_individual_x_organization_ext 
where ixo_status_ext = 'NULL'
/*
57		NULL
1		NULL
76645	Active
1826950	Inactive
6109	Pending
52740	Not Renewed
31		Decline Service
*/


--	), VolunteersThisYear as (
		select			* 
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		like 'A%' --  
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() between ixo_start_date and ixo_end_date)
		and				ixo_status_ext in ('Active', 'Pending')    -- <<<< FIX

/* 
exec client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST @debug=3, @parent_org_cst_key = '5DC483F7-A0B2-4851-82BB-ADE1CD257433', @org_cst_key = 'FDACD997-6BFF-4553-92BC-FE1A9FC41228', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST @debug=3, @parent_org_cst_key = '506A35F9-FA35-40DA-953B-1605015C209F', @org_cst_key = 'B056F695-AF2B-4EA7-A711-52E411F7DB26', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST @debug=3, @parent_org_cst_key = '4F0D5D27-A9C1-4656-9AF7-57B181739FF8', @org_cst_key = '63641B47-468D-490E-8E97-2B60DBFAAABE', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST @debug=3, @parent_org_cst_key = '43444947-DF54-45FB-B200-3D19550E03E5', @org_cst_key = 'C816921A-2C07-4663-8973-389BECB1A248', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST @debug=3, @parent_org_cst_key = '8BE1B123-E3C1-4FCA-863E-F2A1557D6D7A', @org_cst_key = 'F1B702C8-59CE-4F48-BF72-E26A1FD6565A', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST @debug=3, @parent_org_cst_key = '6C99B570-1033-4E38-BE95-CE13AC19AA51', @org_cst_key = 'A1F88F66-7335-4D24-8D3D-E536CA33A160', @year = '2015', @isRegistrar = '0'

exec client_scouts_confirm_valid_registration_potential_xweb_new  @parent_org_cst_key = '5DC483F7-A0B2-4851-82BB-ADE1CD257433', @org_cst_key = 'FDACD997-6BFF-4553-92BC-FE1A9FC41228', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_new  @parent_org_cst_key = '506A35F9-FA35-40DA-953B-1605015C209F', @org_cst_key = 'B056F695-AF2B-4EA7-A711-52E411F7DB26', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_new  @parent_org_cst_key = '4F0D5D27-A9C1-4656-9AF7-57B181739FF8', @org_cst_key = '63641B47-468D-490E-8E97-2B60DBFAAABE', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_new  @parent_org_cst_key = '43444947-DF54-45FB-B200-3D19550E03E5', @org_cst_key = 'C816921A-2C07-4663-8973-389BECB1A248', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_NEW  @parent_org_cst_key = '8BE1B123-E3C1-4FCA-863E-F2A1557D6D7A', @org_cst_key = 'F1B702C8-59CE-4F48-BF72-E26A1FD6565A', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb_NEW  @parent_org_cst_key = '6C99B570-1033-4E38-BE95-CE13AC19AA51', @org_cst_key = 'A1F88F66-7335-4D24-8D3D-E536CA33A160', @year = '2015', @isRegistrar = '0'


exec client_scouts_confirm_valid_registration_potential_xweb  @parent_org_cst_key = '5DC483F7-A0B2-4851-82BB-ADE1CD257433', @org_cst_key = 'FDACD997-6BFF-4553-92BC-FE1A9FC41228', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb  @parent_org_cst_key = '506A35F9-FA35-40DA-953B-1605015C209F', @org_cst_key = 'B056F695-AF2B-4EA7-A711-52E411F7DB26', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb  @parent_org_cst_key = '4F0D5D27-A9C1-4656-9AF7-57B181739FF8', @org_cst_key = '63641B47-468D-490E-8E97-2B60DBFAAABE', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb  @parent_org_cst_key = '43444947-DF54-45FB-B200-3D19550E03E5', @org_cst_key = 'C816921A-2C07-4663-8973-389BECB1A248', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb  @parent_org_cst_key = '8BE1B123-E3C1-4FCA-863E-F2A1557D6D7A', @org_cst_key = 'F1B702C8-59CE-4F48-BF72-E26A1FD6565A', @year = '2015', @isRegistrar = '0'
exec client_scouts_confirm_valid_registration_potential_xweb  @parent_org_cst_key = '6C99B570-1033-4E38-BE95-CE13AC19AA51', @org_cst_key = 'A1F88F66-7335-4D24-8D3D-E536CA33A160', @year = '2015', @isRegistrar = '0'

exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "9B205478-4599-4632-A474-F806EAC5E429",
@org_cst_key         =  "A145AD7E-C983-4AAE-9C83-5DC6185CF731"


exec client_scouts_confirm_valid_registration_potential_xweb_JEFFS_TEST  
@parent_org_cst_key = '42A18E8D-94FC-4057-9DD1-C34562B4BBDF' , 
@org_cst_key = 'BB509AC4-6A06-4068-A555-1A9F7BD0100F' , 
@year = '2015', @isRegistrar = '0' -- END OF CURRENT YEAR , @debug=2


----------------------------
-- TEST CASES 1 thru 10 --
----------------------------
-- 1 --
-- ["group_name"]string(19) "5th St Albert Group" 
-- ["section_name"]=> string(22) "5th St Albert A Colony"
exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "9B205478-4599-4632-A474-F806EAC5E429",
@org_cst_key         =  "A145AD7E-C983-4AAE-9C83-5DC6185CF731"

--2--

exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "0BD1C9B0-04D2-4302-BC1D-E09E24C75D60",
@org_cst_key         =  "7DE9CD32-8AB8-47B6-8E67-17C8D6DD4A89"

--3--

exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "42A18E8D-94FC-4057-9DD1-C34562B4BBDF",
@org_cst_key         =  "BB509AC4-6A06-4068-A555-1A9F7BD0100F"

--4--

exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "2534EE25-65BA-45F7-95A4-433B476E3700", 
@org_cst_key         =  "D5609360-CC0D-483B-8B8E-57BA20480C1C" 


--5-- 

exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "2534EE25-65BA-45F7-95A4-433B476E3700",
@org_cst_key         =  "74F816DE-2AF0-4526-A97F-88BBD974E56C"



declare @org_cst_key varchar(50)  =  'D798A43F-5E94-43E2-9628-7647DA7572D0'

SELECT	org_bank_account_received_flag_ext, org_allow_online_reg_flag_ext, org_closed_group_flag_ext, a03_delete_flag,a03_registration_year, a03_from_date, a03_to_date
FROM co_organization(nolock)	inner join	co_organization_ext(nolock)	on org_cst_key = org_cst_key_ext
	inner join	client_scouts_org_fee_x_date on org_cst_key = a03_org_cst_key and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
	where			(select org_hierarchy_hash_ext from co_organization_ext ce 
						where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			
			
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			a03_registration_year = @scouts_ending_date_yyyy_current   
			and			@today between a03_from_date and a03_to_date 
			
			


exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "C3035584-E4D7-4445-BA92-BDC56AC71E71", 
@org_cst_key         =  "94226FA1-79F1-4C93-9A8B-A80392114B2D" 




exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "E4FAE3F8-750F-4AFC-906A-018A66E46CBC", 
@org_cst_key         =  "D798A43F-5E94-43E2-9628-7647DA7572D0" 




exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "96669E05-A046-426B-A89B-B0463542F32A", 
@org_cst_key         =  "60969904-26D2-4E6B-B2B1-5522821E6BAF" 




exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "F9434879-35C3-4508-BB16-A7AF475F3B08",
@org_cst_key         =  "773470F3-D9ED-47FC-8AF5-CB65E273724F"




exec client_scouts_confirm_valid_registration_potential_xweb  
@year = '2015', @isRegistrar = '0',
@parent_org_cst_key  =  "FD01E541-DB4D-4B33-9FA3-3110D8CF3A0B", 
@org_cst_key         =  "532C2C91-8653-4622-8A64-946F70E471D0" 







*/





--	), VolunteersNextYear as (
	    select 'Dates used to calc VolunteersNextYear', convert(datetime, @year + '-05-01 00:00:00') 'getdate() > than', convert(datetime, @nextYear + '-09-01 00:00:00') 'ixo_start_date >= than'
		select			* 
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		like 'A%'
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() > convert(datetime, @year + '-05-01 00:00:00') and ixo_start_date >= convert(datetime, @nextYear + '-09-01 00:00:00'))
		and				ixo_status_ext in ('Active', 'Pending')
		

--	), ValidFeesAndBankThisYear as (
		select 'Dates used for valid Fee&Bank this year : getdate() between: ', a03_from_date, a03_to_date , * 
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	on org_cst_key = a03_org_cst_key 
				and a03_delete_flag = 0     --OR NULL !	 -- << FIX << not soft deleted (SHOULD THIS BE HERE ????) 
				and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT -- JOINS ON ... WHERE  mbt_code = 'Participant' 
		where			(select org_hierarchy_hash_ext from co_organization_ext ce where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'  -- ?? 
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			getdate() between a03_from_date and a03_to_date

			
--	), ValidFeesAndBankNextYear as (
		select 
			'Dates used for valid Fee&Bank NEXT Year: ', 
			convert(datetime, @nextYear + '-05-01 00:00:00') 'getdate() > AND (', 
			convert(datetime, @year + '-09-01 00:00:00') 'getdate() >= than', 
			convert(datetime, @nextYear + '-08-31 23:59:00') 'getdate() <= )'

		select 
			'Dates used for valid Fee&Bank NEXT Year: ', 
			convert(datetime, @nextYear + '-05-01 00:00:00') 'getdate() > AND (', 
			convert(datetime, @year + '-09-01 00:00:00') 'getdate() >= than', 
			convert(datetime, @nextYear + '-08-31 23:59:00') 'getdate() <= )', *
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	on org_cst_key = a03_org_cst_key and a03_delete_flag = 0 and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
		where			(select org_hierarchy_hash_ext from co_organization_ext ce where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and	(
					getdate() > convert(datetime, @nextYear + '-05-01 00:00:00') 
					-- this means that from JAN thru MAY - counts for NEXT period is NOT counted 
					-- but, start MAY1 - counts are calulated for next YEAR 
					-- IT SEES THAT JAN-MAY is 'dead time' where sept to dec calcs for both current and future - although future may be ignored aft sept 1

						and	getdate() between convert(datetime, @year + '-09-01 00:00:00') and convert(datetime, @nextYear + '-08-31 23:59:00')
			)  
	
--	), VacancyVolunteer		as (
		select			* 
			from	co_organization_ext(nolock)
			where	org_cst_key_ext = @org_cst_key
			
--	), VacancyParticipant	as (
		select			* 
			from	co_organization_ext(nolock)
			where	org_cst_key_ext = @org_cst_key

--</MINE




END

