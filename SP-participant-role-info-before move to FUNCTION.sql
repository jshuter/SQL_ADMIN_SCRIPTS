USE [netforumscoutsTest]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_participant_roles_info]    Script Date: 03/16/2016 10:50:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/** 
 *  PROC: client_scouts_participant_roles_info
 * 
 *  This procedure summarizes ALL ROLES that exist for a single MEMBER/IND_SCT_KEY 
 *  The data is grouped by the SCOUTING GROUP that each role belongs to 
 *  The selection is limited to FUTURE and CURRENT roles 
 *  and the ROLES are limited to ROLES within SECTIONS by PARTICIPANTS 
 * 
 *  Volunteer roles are not included
 * 
 *  This proc is used to support the online registration process and to determine
 *  If a Participant has been reg'd for next year, and if they should be allowed to pre-register
 * 
 */
 

/* 

TESTS 

exec [client_scouts_participant_roles_info] -- no args 

-- test status -- 
exec [client_scouts_participant_roles_info] '1FE42B16-5DD0-40A7-AD9C-A5907B29E726' -- good arg
exec [client_scouts_participant_roles_info] '1FE42B16-5DD0-40A7-AD9C-A5907B29E726',@status = 'Active'
exec [client_scouts_participant_roles_info] '1FE42B16-5DD0-40A7-AD9C-A5907B29E726',@status = 'Inactive'
exec [client_scouts_participant_roles_info] '1FE42B16-5DD0-40A7-AD9C-A5907B29E726',@status = 'Pending'

-- me 
exec [client_scouts_participant_roles_info] '3999E32D-2DC0-4BAB-B94C-A8E514A9113D'

 -- TEST CASE - has future role!
 
exec [client_scouts_participant_roles_info] '5920CACD-5EA7-43D3-8149-5B9DE07AE0FD'

-- test Active -- LIMIT to only ACTIVE roles where NOT YET ANY IN NEXT YEAR 

exec [client_scouts_participant_roles_info] '5920CACD-5EA7-43D3-8149-5B9DE07AE0FD'
	,@role_count_this_year=1, @role_count_next_year=0, @status = 'Active' 

-- then -- LOOK WHERE Not Renewed exists
exec [client_scouts_participant_roles_info] '5920CACD-5EA7-43D3-8149-5B9DE07AE0FD', @status = 'Not Renewed' 
exec [client_scouts_participant_roles_info] '5920CACD-5EA7-43D3-8149-5B9DE07AE0FD', @status = 'Active' 


-- ALLOW @status = 'Active,Not Renewed' ?

*/

ALTER PROCEDURE  [dbo].[client_scouts_participant_roles_summary] ( 
	@ind_cst_key as uniqueidentifier = NULL, 
	@status as varchar(100) = NULL,		-- defaults to ALL 
	@role_count_this_year int  = -1 ,	--	see below re this field -- indicates '0 or more' 
	@role_count_next_year int  = -1 	--	see below re this field -- indicates '0 or more' 
) 

AS

BEGIN 

SET NOCOUNT ON ; 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ; 

declare @role_count_this_year_min  int  = 0  --	displays even if none exists -- 1 > only show if 'One or More' exist
declare @role_count_this_year_max  int  = 9999  --	displays even if none exists -- 1 > only show if 'At least 1 exists'

declare @role_count_next_year_min  int  = 0	--	displays all -- 1 > only show if one exists  	
declare @role_count_next_year_max  int  = 9999	--	displays all -- 1 > only show if one exists  	


DECLARE	@status_list table (s varchar(20)) 

-- The following three param settings are related to the final 
-- GROUP BY - HAVING Clause at the end of the select !

-- Only select if Status is the one indicated. default is ALL ...
if (@status is NULL) begin 
	insert into @status_list(s) values ('Active') 
	insert into @status_list(s) values ('Pending') 
	insert into @status_list(s) values ('Inactive') 
	insert into @status_list(s) values ('Not Renewed') 
end else begin 
	insert into @status_list(s) values (@status) 
end 

-- default is for ANY number of roles in Next Year  
if (@role_count_next_year > -1) begin -- handle value that is passed 
	if @role_count_next_year = 0 begin -- force setting of 0 
		set @role_count_next_year_min = 0 
		set @role_count_next_year_max = 0 
	end else begin -- any positive int means > 0 
		set @role_count_next_year_min = 1 
		set @role_count_next_year_max = 9999 
	end 
end 

-- default is for ANY Amount of Roles in Current Year 
if (@role_count_this_year > -1) begin -- handle value that is passed 
	if @role_count_this_year = 0 begin -- force setting of 0 
		set @role_count_this_year_min = 0 
		set @role_count_this_year_max = 0 
	end else begin -- any positive int means > 0 
		set @role_count_this_year_min = 1 
		set @role_count_this_year_max = 9999 
	end 
end 

; 

WITH source_data AS (

	SELECT     dbo.co_individual_x_organization.ixo_ind_cst_key		  -- ind key 
				, dbo.co_customer.cst_parent_cst_key				  -- group key 
                , dbo.co_individual_x_organization_ext.ixo_status_ext -- status 
                , CASE WHEN (ixo_start_date <=						  -- Current Year - Roles exist ? 1/0 
                                (SELECT     scouting_end_date
                                  FROM          dbo.client_scouts_get_scouting_date_range())) THEN 1 ELSE 0 END AS current_year
                , CASE WHEN (ixo_start_date >						  -- Next Year - Roles exist ? 1/0 
                                (SELECT     scouting_end_date
                                  FROM          dbo.client_scouts_get_scouting_date_range())) THEN 1 ELSE 0 END AS next_year
     
     FROM       dbo.co_individual_x_organization INNER JOIN
				dbo.co_individual_x_organization_ext ON dbo.co_individual_x_organization.ixo_key = dbo.co_individual_x_organization_ext.ixo_key_ext INNER JOIN
					dbo.co_organization ON dbo.co_organization.org_cst_key = dbo.co_individual_x_organization.ixo_org_cst_key INNER JOIN
						dbo.co_customer ON dbo.co_customer.cst_key = dbo.co_individual_x_organization.ixo_org_cst_key JOIN 
		                mb_member_type mbt on mbt.mbt_key = ixo_mbt_key_ext 
                
     WHERE      dbo.co_individual_x_organization.ixo_start_date >= (SELECT scouting_start_date -- Get All Current & Future Roles 
                                  FROM  dbo.client_scouts_get_scouting_date_range() ) 
                and dbo.co_individual_x_organization.ixo_delete_flag = 0
				
				and ixo_ind_cst_key = @ind_cst_key 
				and mbt.mbt_code = 'Participant'
				
	UNION ALL

	-- last years 'Not Renewed' will be counted in 'THIS YEAR' column (even though it is from LAST-YEAR !!!!)
	-- because NOT RENEWED has a short TIME-TO-LIVE and indicates that Roles 'Was Active'.  
	
	SELECT     dbo.co_individual_x_organization.ixo_ind_cst_key
				, dbo.co_customer.cst_parent_cst_key
                , dbo.co_individual_x_organization_ext.ixo_status_ext
                , 1 as current_year 
                , 0 AS next_year
     
     FROM       dbo.co_individual_x_organization INNER JOIN
                dbo.co_individual_x_organization_ext ON 
                dbo.co_individual_x_organization.ixo_key = dbo.co_individual_x_organization_ext.ixo_key_ext INNER JOIN
                dbo.co_organization ON dbo.co_organization.org_cst_key = dbo.co_individual_x_organization.ixo_org_cst_key INNER JOIN
                dbo.co_customer ON dbo.co_customer.cst_key = dbo.co_individual_x_organization.ixo_org_cst_key
				join mb_member_type mbt on mbt.mbt_key = ixo_mbt_key_ext 
                
     WHERE      dbo.co_individual_x_organization.ixo_start_date >= (SELECT  dateadd(YEAR, -1, scouting_start_date)
								FROM  dbo.client_scouts_get_scouting_date_range() )
				
				and dbo.co_individual_x_organization.ixo_end_date <= (SELECT scouting_start_date
								FROM  dbo.client_scouts_get_scouting_date_range() AS client_scouts_get_scouting_date_range_1)
				
				and  dbo.co_individual_x_organization.ixo_delete_flag = 0
				
				and ixo_ind_cst_key = @ind_cst_key 
				and ixo_status_ext = 'Not Renewed'
				and mbt.mbt_code = 'Participant' 
)
                                  
SELECT  TOP (100) ixo_ind_cst_key, cst_parent_cst_key
		, ixo_status_ext, SUM(current_year) AS role_count_this_year
		, SUM(next_year) AS role_count_next_year
		
FROM     source_data AS source_data_1

GROUP BY ixo_ind_cst_key, cst_parent_cst_key, ixo_status_ext
		having sum(next_year) between @role_count_next_year_min and @role_count_next_year_max 
			and sum(current_year) between  @role_count_this_year_min and @role_count_this_year_max 
			and ixo_status_ext in (select * from @status_list) 

END 

