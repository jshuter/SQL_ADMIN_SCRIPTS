USE [netForumSCOUTSTest]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_confirm_valid_registration_potential_xweb]    Script Date: 02/06/2015 09:56:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
===================================================================================
WHO			WHEN		WHAT, WHY, ETC 
===================================================================================
MCharette	06/14/2012	Perform a series of checks to confirm a section is 
							fit for online registration and has vacancy
 
Jeff Shuter	Jan 2015	Adjusted script to 
						1) correct results for Volunteer Vacancies 
						2) remove hard coded keys for 'Volunteer' and 'Participant'
						3) improve clarity of code related to DATES 
						4) changed != Inactive to = Active, Pending 
							
===================================================================================
*/

ALTER PROCEDURE [dbo].[client_scouts_confirm_valid_registration_potential_xweb_NEW] 
	@org_cst_key		uniqueidentifier,
	@parent_org_cst_key	uniqueidentifier = null,
	@year				varchar(4),				-- << DEPRECATED - leaving in as xWeb calls still pass the 'YEAR' but we will set year within the PROC to avoid 
												-- << spreading out the logic that should be more closely situated. 
	@isRegistrar		varchar(1) = null, 
	@start_mmdd_scouts	varchar(5) = '09-01',	-- MM-DD This is the MONTH and DAY that the 'SCOUTS-YEAR' begins on 
	@start_mmdd_prereg	varchar(5) = '05-01'	-- MM-DD THe MONTH and DAY that Pre-Reg begins on 
	
AS
BEGIN

	SET NOCOUNT ON;

	-- WARNING -- 
	-- 
	--  startdate MMDD variable MUST be in format of "MM-DD" !!!!
	--
	--

	declare @scouts_ending_date_yyyy_current	varchar(4) -- 
	declare @scouts_ending_date_yyyy_next		varchar(4) --> for date calcs 
	declare @scouts_starting_date_yyyy_current	varchar(4) -- 
	declare @prereg_start_date					date -- May 1st of the current Scouts Year 
	declare @scouts_next_year_start_date		date -- Start Date for the next Scouts Year 
	declare @scouts_this_year_start_date		date -- Start Date for the next Scouts Year 
	declare @month int 
	
	-- set current & next ending_year YYYY based on Month (MM) of Scouts Year Start Date
	set @month = cast(left(@start_mmdd_scouts,2) as int) -- defaults to 9 
	
	if MONTH(getdate()) < @month begin 
		set @scouts_starting_date_yyyy_current = YEAR(getdate()) -1  
		set @scouts_ending_date_yyyy_current = YEAR(getdate())
		set @scouts_ending_date_yyyy_next = YEAR(getdate()) + 1 
	end else begin 
		set @scouts_starting_date_yyyy_current = YEAR(getdate()) 
		set @scouts_ending_date_yyyy_current = YEAR(getdate()) + 1
		set @scouts_ending_date_yyyy_next = YEAR(getdate()) + 2
	end  ;

	-- Pre-reg-date for current scouts year 
	set @prereg_start_date =	convert(datetime, @scouts_ending_date_yyyy_current + '-' + @start_mmdd_prereg + ' 00:00:00')
	set @scouts_this_year_start_date = convert(datetime, @scouts_starting_date_yyyy_current + '-' + @start_mmdd_scouts + '  00:00:00')
	set @scouts_next_year_start_date = convert(datetime, @scouts_ending_date_yyyy_current + '-' + @start_mmdd_scouts + '  00:00:00')

;
	With ParticipantsThisYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)

--		and			(getdate() between ixo_start_date and ixo_end_date) -- Miscalcs with last date when time = 00:00:00 
/* change ? -- same as above -- wihout loosing last day ?*/
		and				( (ixo_start_date >= @scouts_this_year_start_date and ixo_start_date < @scouts_next_year_start_date)
						OR (ixo_end_date >= @scouts_this_year_start_date and ixo_end_date < @scouts_next_year_start_date ))
		and				ixo_status_ext in ('Active','Pending')

	), ParticipantsNextYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				getdate() > @prereg_start_date 
		and				ixo_start_date >= @scouts_next_year_start_date
		AND				ixo_status_ext in ('Active','Pending')

	), VolunteersThisYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= 'AF0C862E-0C1C-4C50-B9D1-7F3DB3225F9E' -- Volunteer 
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
--		AND				getdate() between ixo_start_date and ixo_end_date
--		and			(getdate() between ixo_start_date and ixo_end_date) -- Miscalcs with last date when time = 00:00:00 
/* change ? -- same as above -- wihout loosing last day ?*/
		and				( (ixo_start_date >= @scouts_this_year_start_date and ixo_start_date < @scouts_next_year_start_date)
						OR (ixo_end_date >= @scouts_this_year_start_date and ixo_end_date < @scouts_next_year_start_date ))
		and				ixo_status_ext in ('Active','Pending')

		and				ixo_status_ext in ('Active', 'Pending') 
	), VolunteersNextYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= 'AF0C862E-0C1C-4C50-B9D1-7F3DB3225F9E' -- Volunteer
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				getdate() > @prereg_start_date	 -- This will result in 0 for VolunteersNextYear if BEFORE MAY -> max Vacancies IFF before May 
		and				ixo_start_date >= @scouts_next_year_start_date
		and				ixo_status_ext in ('Active', 'Pending') 

	), ValidFeesAndBankThisYear as (
		SELECT			COUNT(*) as Configured
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		
				on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	
				on org_cst_key = a03_org_cst_key 
				and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
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
			inner join	co_organization_ext(nolock)		
				on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	
				on org_cst_key = a03_org_cst_key 
				and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
		where			(select org_hierarchy_hash_ext from co_organization_ext ce where ce.org_cst_key_ext = @org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			getdate() > @prereg_start_date -- This will result in 0 for AllowRegNextYear if BEFORE MAY 
			and			getdate() between @scouts_next_year_start_date and DATEADD(YEAR,1,@scouts_next_year_start_date) -- IN NEXT SCOUTS YEAR
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
			
	), results as (

			select
			
			CurrentYear			= @scouts_ending_date_yyyy_current,
			VacantThisYear		= isnull((select [current] from VacancyParticipant)	- (select Registered from ParticipantsThisYear),0),
			VacantThisYearVol	= isnull((select [current] from VacancyVolunteer)		- (select Registered from VolunteersThisYear),0),
			AllowRegThisYear	= case	when @isRegistrar = '1' or (select org_ogt_code from co_organization(nolock) where org_cst_key = @org_cst_key) in ('National','Council','Area')
										then 1 
										else (select Configured from ValidFeesAndBankThisYear) end,
			NextYear			= @scouts_ending_date_yyyy_next,
			VacantNextYear		= isnull((select [next] from VacancyParticipant)		- (select Registered from ParticipantsNextYear),0),
			VacantNextYearVol	= isnull((select [next] from VacancyVolunteer)			- (select Registered from VolunteersNextYear),0),
			AllowRegNextYear	=  case	when @isRegistrar = '1' or (select org_ogt_code from co_organization(nolock) where org_cst_key = @org_cst_key) in ('National','Council','Area')
										then 1 
										else (select Configured from ValidFeesAndBankNextYear) end	
	) 
	
	--select * from results 
	select * from results for xml path('vacancy'), elements xsinil,	type, root('vacancies')
	
END



