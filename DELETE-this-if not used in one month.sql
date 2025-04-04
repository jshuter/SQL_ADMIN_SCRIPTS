USE [netforumscoutsTest]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_rpt_group_summary_TEST_ALL]    Script Date: 04/26/2016 15:59:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Create date: APRIL 2016 
-- Description:	Management Reports: Organization Summary Report 
-- =============================================

/* 
TEST 
exec [client_scouts_rpt_group_summary] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D','E87125F1-78AE-4C44-B4A3-39A406516C64'

exec [client_scouts_rpt_group_summary] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D','9B49FAEB-061F-49EA-840C-720D7C65AAC2'
*/

ALTER PROCEDURE [dbo].[client_scouts_rpt_group_summary_TEST_ALL]
	-- Add the parameters for the stored procedure here	
	@ind_cst_key uniqueidentifier = NULL,
	@org_cst_key uniqueidentifier = NULL
AS

BEGIN 

	SET NOCOUNT ON -- added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- turn with lock/readuncommitted on...


	declare @debug bit = 0


	-- identify scouting year/period variable sets and types

	DECLARE @currentScoutingYear varchar(4)                                                   
	DECLARE @currentScoutingPeriodStartDate datetime;
	DECLARE @currentScoutingPeriodEndDate datetime;
	DECLARE @currentScoutingPeriodString varchar(20);
	
	DECLARE @previousScoutingPeriodStartDate datetime;
	DECLARE @previousScoutingPeriodEndDate datetime;
	DECLARE @previousScoutingPeriodString varchar(20);

	DECLARE @nextScoutingPeriodStartDate datetime;
	DECLARE @nextScoutingPeriodEndDate datetime;

	DECLARE @NextScoutingYear varchar(4)                                                   
	
	DECLARE @ScoutingPeriodYearsSeparator varchar(4) = '-';
	DECLARE @NodePathSeparator varchar(4) = '.';

	DECLARE @org_hash AS varchar(max);

	--this is for testing purposes, specifying an org hierarchy top node
	IF @org_cst_key IS NULL BEGIN 
			set @org_cst_key = 'E87125F1-78AE-4C44-B4A3-39A406516C64'
			--SET @org_cst_key = 'F15FF832-A40D-404A-87E2-F3BDB704822A'
	END

	--Define Organization that should be at the top of the hierarchy resultset
	IF @org_cst_key IS NULL 
		BEGIN 
			SET @org_hash = ''
		END
	ELSE
		BEGIN 
			SET @org_hash = (SELECT ISNULL(org_hierarchy_hash_ext, '') FROM co_organization_ext WHERE org_cst_key_ext = @org_cst_key)
		END

	--Define scouting periods variables
	SELECT	@currentScoutingPeriodStartDate = scouting_start_date,
			@currentScoutingPeriodEndDate = scouting_end_date
	FROM  dbo.client_scouts_get_scouting_date_range();    
	
	SET @previousScoutingPeriodStartDate = DATEADD(YEAR,-1,@currentScoutingPeriodStartDate) ;
	SET @previousScoutingPeriodEndDate = DATEADD(YEAR,-1,@currentScoutingPeriodEndDate) ;                

	SET @nextScoutingPeriodStartDate = DATEADD(YEAR,+1,@currentScoutingPeriodStartDate) ;
	SET @nextScoutingPeriodEndDate = DATEADD(YEAR,+1,@currentScoutingPeriodEndDate) ;                
	
	SET @currentScoutingYear = CAST(YEAR(@currentScoutingPeriodEndDate) AS varchar(4)) ;
	SET @currentScoutingPeriodString = CAST(YEAR(@currentScoutingPeriodStartDate) AS varchar(4)) + @ScoutingPeriodYearsSeparator + CAST(YEAR(@currentScoutingPeriodEndDate) AS varchar(4));
	SET @previousScoutingPeriodString = CAST(YEAR(@previousScoutingPeriodStartDate) AS varchar(4)) + @ScoutingPeriodYearsSeparator + CAST(YEAR(@previousScoutingPeriodEndDate) AS varchar(4));

	SET @NextScoutingYear = @currentScoutingYear + 1 ;
	

/*
	if @debug = 1 begin 
		select @currentScoutingYear as currentYear, @NextScoutingYear as nextYear 
		select @previousScoutingPeriodString, @currentScoutingPeriodString
		select @previousScoutingPeriodStartDate, @previousScoutingPeriodEndDate
		select @currentScoutingPeriodStartDate, @currentScoutingPeriodEndDate
	end 
*/

		
	; 
	
	WITH Orgs AS (

		/* This CTE creates a Flat resultset of all Organizations data that are required to build a hierarchy */
		SELECT cst_parent_cst_key as SubTreeRoot, cst_key, org_name, org_ogt_code, org_hierarchy_hash_ext FROM co_customer 
			 INNER JOIN co_organization ON co_customer.cst_key = co_organization.org_cst_key 
			 INNER JOIN co_organization_ext ON co_organization.org_cst_key = co_organization_ext.org_cst_key_ext
			 WHERE co_customer.cst_type = 'Organization'
				  AND org_delete_flag = 0
				  AND co_organization.org_ogt_code IN ('National', 'Council', 'Area', 'Group') 
				  -- why create 23,000 rows if we only want 100 ?
				  AND ( org_hierarchy_hash_ext like @org_hash + '%' 			
					or org_hierarchy_hash_ext = @org_hash) 
	)
	
	, 
	roles_this_year as ( 
	
		-- optional IXO rows ... to count capacity 
		select 
			  sum(case when ixo_status_ext = 'Active' then 1 else 0 end) as active_roles_this_year
			, sum(case when ixo_status_ext = 'Pending' then 1 else 0 end) as pending_roles_this_year
			, ixo_org_cst_key
		from  co_individual_x_organization 
			left join co_individual_x_organization_ext  on ixo_key = ixo_key_ext 
			left join mb_member_type on ixo_mbt_key_ext = mbt_key 				
		where 
			mbt_code = 'Participant'
			and ixo_delete_flag = 0 
			and ixo_start_date between '2015-09-01' and '2016-08-31'
		group by ixo_org_cst_key
	)
	, 

	roles_next_year as ( 
	
		-- optional IXO rows ... to count capacity 
		select 
			  sum(case when ixo_status_ext = 'Active' then 1 else 0 end) as active_roles_next_year
			, sum(case when ixo_status_ext = 'Pending' then 1 else 0 end) as pending_roles_next_year
			, ixo_org_cst_key
		from  co_individual_x_organization 
			left join co_individual_x_organization_ext  on ixo_key = ixo_key_ext 
			left join mb_member_type on ixo_mbt_key_ext = mbt_key 				
		where 
			mbt_code = 'Participant'
			and ixo_delete_flag = 0 
			and ixo_start_date between '2016-09-01' and '2017-08-31'
			and ixo_status_ext = 'Active' 
		group by ixo_org_cst_key
	)
	, 
	group_sections as ( 
		select 
		
			grp.org_date_founded as section_date_founded,
			grp.org_name as section_name, 
			grp.org_num_years_in_business_cp as section_years_in_service, 
			grp.org_ogt_code as section_ogt_code, 
			grp_ext.org_meeting_location_ext, 
			grp_ext.org_meeting_location_type_ext, 
			grp_ext.org_meeting_date_ext, 
			grp_ext.org_meeting_start_time_ext,
			grp_ext.org_primary_contact_email_ext as section_primary_contact_email, 
			grp_ext.org_primary_contact_name_ext as section_primary_contact_name, 
			grp_ext.org_primary_contact_phone_ext as section_primary_contact_phone, 
			grp_ext.org_special_needs_access_flag_ext as section_special_needs_access_flag, 
			grp_ext.org_sponsor_name_ext as section_sponsor_name, 
			grp_ext.org_sponsor_type_ext as section_sponsor_type, 
			grp_ext.org_status_ext as section_status, 
			grp_ext.org_youth_capacity_current_ext, 
			grp_ext.org_youth_capacity_next_ext, 
			grp.org_cst_key,
			cst_parent_cst_key as parent_key
			,a.adr_line1,
			a.adr_line2,
			a.adr_city,
			a.adr_state,
			a.adr_post_code
			,grp_ext.org_coed_flag_ext
			,grp_ext.org_special_needs_access_flag_ext
			,grp_ext.org_notes_ext
			,grp_ext.org_hierarchy_friendly_ext
			
			from co_organization grp   
				join co_organization_ext grp_ext on grp.org_cst_key = grp_ext.org_cst_key_ext 
				join co_customer c on c.cst_key = grp.org_cst_key 
				join orgs as main on cst_parent_cst_key = main.cst_key 
				left join co_customer_x_address cxa on c.cst_cxa_key = cxa.cxa_key
				left join co_address a on cxa.cxa_adr_key = a.adr_key 

			where grp.org_ogt_code = 'Section' 
				and org_status_ext = 'Active' 
				and org_delete_flag = 0
	) 
	
	select
	
		isnull(roles_this_year.active_roles_this_year, 0)  as active_roles_this_year, 
		isnull(roles_this_year.pending_roles_this_year, 0) as pending_roles_this_year, 
		isnull(roles_next_year.active_roles_next_year, 0) as active_roles_next_year,
		isnull(roles_next_year.pending_roles_next_year, 0) as pending_roles_next_year,
		council.cst_org_name_dn as council_name, 
		area.cst_org_name_dn as area_name, 
		grp.cst_org_name_dn as group_name, 
		gs.section_name, 
		isnull(grp_org.org_allow_online_reg_flag_ext,0) as group_allow_online_reg,        -- <<< DOES NULL IMPLY 0 FOR ALL THESE ??
		isnull(grp_org.org_bank_account_received_flag_ext,0) as group_bank_account_received,
		isnull(grp_org.org_closed_group_flag_ext,0) as group_closed_group_flag, 
		grp_org.org_dues_prc_key_ext as group_dues_prc_key, 
		grp_org.org_primary_contact_email_ext as group_primary_contact_email, 
		grp_org.org_primary_contact_name_ext as group_primary_contact_name,
		grp_org.org_primary_contact_phone_ext as group_primary_contact_phone, 
		grp_org.org_status_ext as group_status, 

		gs.section_date_founded,
		gs.section_years_in_service, 
		gs.section_ogt_code, 
		gs.org_meeting_location_ext, 
		gs.org_meeting_location_type_ext, 
		gs.org_meeting_date_ext, 
		gs.org_meeting_start_time_ext,
		gs.section_primary_contact_email, 
		gs.section_primary_contact_name, 
		gs.section_primary_contact_phone, 
		isnull(gs.section_special_needs_access_flag, 0) as section_special_needs_access_flag, 
		gs.section_sponsor_name, 
		gs.section_sponsor_type, 
		gs.section_status, 
		gs.org_youth_capacity_current_ext, 
		gs.org_youth_capacity_next_ext, 
		gs.org_cst_key,
		gs.parent_key ,
		
		gs.adr_line1,
		gs.adr_line2,
		gs.adr_city,
		gs.adr_state,
		gs.adr_post_code,
		
		-- new 
		gs.org_coed_flag_ext,
		gs.org_special_needs_access_flag_ext,
		gs.org_notes_ext,
		gs.org_hierarchy_friendly_ext,
		
		(select top 1 url_code from co_website where url_cst_key = gs.org_cst_key) as website 
		,
		isnull((select top 1 1 as rows_exist
			from client_scouts_org_fee_x_date f
			where f.a03_delete_flag = 0 
				and getdate() between f.a03_from_date and f.a03_to_date 
				and f.a03_registration_year = @currentScoutingYear 
				--and f.a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT
				and f.a03_org_cst_key = grp_org.org_cst_key_ext
		),0) as fees_setup_currentYear 
		,
		isnull((select top 1 1 as rows_exist
			from client_scouts_org_fee_x_date f
			where f.a03_delete_flag = 0 
				and getdate() between f.a03_from_date and f.a03_to_date 
				and f.a03_registration_year = @NextScoutingYear 
				--and f.a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- PARTICIPANT
				and f.a03_org_cst_key = grp_org.org_cst_key_ext
		),0)  as fees_setup_NextYear 
		

	from group_sections gs 
	
		 join co_customer grp on grp.cst_key = gs.parent_key
		 join co_customer area on area.cst_key = grp.cst_parent_cst_key 
		 join co_customer council on council.cst_key = area.cst_parent_cst_key
			join co_organization_ext as grp_org on grp_org.org_cst_key_ext = grp.cst_key
		left join roles_this_year on roles_this_year.ixo_org_cst_key = gs.org_cst_key
		
		left join roles_next_year on roles_next_year.ixo_org_cst_key = gs.org_cst_key
	
	order by org_dues_prc_key_ext, council.cst_org_name_dn, area.cst_org_name_dn, grp.cst_org_name_dn, gs.section_name

	 	



				
				
END 



-- exec [client_scouts_rpt_group_summary] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D'




