USE [netForumSCOUTSTest]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_confirm_valid_registration_potential_xweb_OLD]    Script Date: 02/06/2015 09:56:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--	MCharette
-- Create date: 06/14/2012
-- Description:	Perform a series of checks to confirm a section is fit for online registration and has vacancy
-- =============================================
ALTER PROCEDURE [dbo].[client_scouts_confirm_valid_registration_potential_xweb] 
	@org_cst_key		uniqueidentifier,
	@parent_org_cst_key	uniqueidentifier = null,
	@year				varchar(4),
	@isRegistrar		varchar(1) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @nextYear varchar(4) = convert(int, @year) + 1;

	With ParticipantsThisYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() between ixo_start_date and ixo_end_date)
		AND				ixo_status_ext in ('Active','Pending')
	), ParticipantsNextYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		= '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() > convert(datetime, @year + '-05-01 00:00:00') and ixo_start_date >= convert(datetime, @nextYear + '-09-01 00:00:00'))
		AND				ixo_status_ext in ('Active','Pending')
	), VolunteersThisYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		like 'A%'
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() between ixo_start_date and ixo_end_date)
		and				ixo_status_ext != 'Inactive'
	), VolunteersNextYear as (
		select			Count(*) as Registered
		from			co_individual_x_organization
		inner join		co_individual_x_organization_ext on ixo_key = ixo_key_ext
		where			ixo_org_cst_key		= @org_cst_key
		and				ixo_mbt_key_ext		like 'A%'
		and				(ixo_delete_flag is null or ixo_delete_flag	= 0)
		AND				(getdate() > convert(datetime, @year + '-05-01 00:00:00') and ixo_start_date >= convert(datetime, @nextYear + '-09-01 00:00:00'))
		and				ixo_status_ext != 'Inactive'
	), ValidFeesAndBankThisYear as (
		SELECT			COUNT(*) as Configured
		FROM			co_organization(nolock)
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext
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
			inner join	co_organization_ext(nolock)		on org_cst_key = org_cst_key_ext
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
	CurrentYear			= @year,
	VacantThisYear		= (select [current] from VacancyParticipant)	- (select * from ParticipantsThisYear),
	VacantThisYearVol	= (select [current] from VacancyVolunteer)		- (select * from VolunteersThisYear),
	AllowRegThisYear	= case	when @isRegistrar = '1' or (select org_ogt_code from co_organization(nolock) where org_cst_key = @org_cst_key) in ('National','Council','Area')
								then 1 else (select Configured from ValidFeesAndBankThisYear) end,
	NextYear			= @nextYear,
	VacantNextYear		= (select [next] from VacancyParticipant)		- (select * from ParticipantsNextYear),
	VacantNextYearVol	= (select [next] from VacancyVolunteer)			- (select * from VolunteersNextYear),
	AllowRegNextYear	= case	when @isRegistrar = '1' or (select org_ogt_code from co_organization(nolock) where org_cst_key = @org_cst_key) in ('National','Council','Area')
								then 1 else (select Configured from ValidFeesAndBankNextYear) end	


	for xml path('vacancy'), elements xsinil, 
	type,	root('vacancies')
END

