USE [netFORUMSCOUTS]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_rpt_prc_vss_expiry_listing]    Script Date: 08/27/2015 10:51:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Itrumbley
-- Create date: May 1/2012
-- Description:	Return a listing of individuals who will require either a PRC or VSS in a given time frame
-- Filter out not requireds
-- =============================================
ALTER PROCEDURE [dbo].[client_scouts_rpt_prc_vss_expiry_listing] 
	-- Add the parameters for the stored procedure here
	@org_cst_key uniqueidentifier,
	@all_child_org_flag_string varchar(max),
	@mb_status varchar(max) = 'Active,Pending,Not Renewed',
	@mbt_type varchar(max) = NULL,
	@ind_cst_key uniqueidentifier = null,
	@prc_date datetime = '1/1/1900',
	@vss_date datetime = '1/1/1900'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	--Membership status
	DECLARE @mb_status_list TABLE (val varchar(max))
	INSERT INTO @mb_status_list
	EXEC client_scouts_sp_split_text @mb_status



	DECLARE @org_hierarchy_hash as varchar(max)
	SELECT @org_hierarchy_hash = org_hierarchy_hash_ext
	FROM co_organization_ext(nolock)
	WHERE org_cst_key_ext = @org_cst_key


    -- Insert statements for procedure here
	-- ok so this if statement is the "all child org" flag
	
if (@all_child_org_flag_string = 'All')
Begin

select ind_cst_key, ind_full_name_cp, ind_cst.cst_recno,org_name, ixo_rlt_code, ind_cst_ext.cst_daytime_phone_ext, ind_cst_ext.cst_evening_phone_ext, ind_cst.cst_eml_address_dn,  
(select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_status_ext, 
(select top 1 convert(varchar,z25_completion_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_date_ext,
 (select top 1 convert(varchar,z25_expiration_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_exp_ext,
 (select top 1 convert(varchar, z25_application_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_app_date,
 
  (select top 1 convert(varchar,z25_completion_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_complete_date_ext, 
  (select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_status_ext,
  (select top 1 convert(varchar,z25_expiration_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_exp_ext, 
  (select top 1 convert(varchar,z25_application_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_app_date, 
 
  ind_reference_check_status_ext,  ind_interview_status_ext, convert(varchar,ind_interview_date_ext,110) as ind_interview_date_ext, 
  convert(varchar,ind_dob,110) as DOB, ind_cst_ext.cst_other_phone_ext, 
  ind_mbt_code_ext, ind_vol_screening_code_ext  from co_individual(nolock)
  --, co_organization_ext.org_hierarchy_friendly_ext as Hierarchy   
  
  
inner join co_individual_ext(nolock) on ind_cst_key = ind_cst_key_ext
inner join co_customer(nolock) as ind_cst on ind_cst_key = ind_cst.cst_key
inner join co_customer_ext(nolock) as ind_cst_ext on ind_cst_key = ind_cst_ext.cst_key_ext
inner join co_individual_x_organization(nolock) on ixo_key = ind_cst.cst_ixo_key
inner join co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext
inner join co_organization(nolock) on ixo_org_cst_key = org_cst_key
inner join co_organization_ext(nolock) on org_cst_key = org_cst_key_ext


where  -- 
( (@vss_date >= (select top 1 z25_expiration_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) and (select top 1 z25_completion_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' and z25_status = 'Passed' order by z25_completion_date desc ) is not null)
or

(@prc_date >= (select top 1 z25_expiration_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) and (select top 1 z25_completion_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' and z25_status = 'Passed' order by z25_completion_date desc ) is not null) )
and
ind_cst_key in 

( -- this is the list of valid individuals in the hierarchy
select a.ind_cst_key
from co_individual as a (nolock)
inner join co_individual_ext(nolock) as b  on a.ind_cst_key = b.ind_cst_key_ext
inner join co_individual_x_organization(nolock) as c on a.ind_cst_key = c.ixo_ind_cst_key
inner join co_individual_x_organization_ext(nolock) as d on c.ixo_key = d.ixo_key_ext
inner join co_organization_ext(nolock)  as e on c.ixo_org_cst_key = e.org_cst_key_ext
inner join mb_member_type(nolock) as f on d.ixo_mbt_key_ext = f.mbt_key
where 
(b.ind_suspended_flag_ext = 0 or b.ind_suspended_flag_ext is null)
AND
(b.ind_confidential_status_ext = 'N/A' or b.ind_confidential_status_ext is null)
AND
(c.ixo_delete_flag = 0)
AND
 (co_individual.ind_delete_flag = 0)
AND
(d.ixo_status_ext in (SELECT * FROM @mb_status_list)) -- criteria
AND
(e.org_hierarchy_hash_ext like @org_hierarchy_hash+'%' ) -- criteria
AND
(f.mbt_code = @mbt_type or @mbt_type is null)
)
order by org_hierarchy_hash_ext
end -- end all child org

-- Else this is just the org itself, the difference being on the org hierarchy hash logic

Else
Begin
	
select ind_cst_key, ind_full_name_cp, ind_cst.cst_recno,org_name, ixo_rlt_code, ind_cst_ext.cst_daytime_phone_ext, ind_cst_ext.cst_evening_phone_ext, ind_cst.cst_eml_address_dn,  
(select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_status_ext, 
(select top 1 convert(varchar,z25_completion_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_date_ext, 
(select top 1 convert(varchar,z25_expiration_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_exp_ext,

(select top 1 convert(varchar, z25_application_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) as ind_prc_app_date,

 (select top 1 convert(varchar,z25_completion_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_complete_date_ext, 
 (select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_status_ext,
 (select top 1 convert(varchar,z25_expiration_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_exp_ext, 
 
 (select top 1 convert(varchar,z25_application_date,110) from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) as ind_vss_app_date, 
 
 ind_reference_check_status_ext,  ind_interview_status_ext, convert(varchar,ind_interview_date_ext,110) as ind_interview_date_ext, convert(varchar,ind_dob,110) as DOB, 
 ind_cst_ext.cst_other_phone_ext, ind_mbt_code_ext, ind_vol_screening_code_ext  from co_individual(nolock)
 --,  co_organization_ext.org_hierarchy_friendly_ext
 
inner join co_individual_ext(nolock) on ind_cst_key = ind_cst_key_ext
inner join co_customer(nolock) as ind_cst on ind_cst_key = ind_cst.cst_key
inner join co_customer_ext(nolock) as ind_cst_ext on ind_cst_key = ind_cst_ext.cst_key_ext
inner join co_individual_x_organization(nolock) on ixo_key = ind_cst.cst_ixo_key
inner join co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext
inner join co_organization(nolock) on ixo_org_cst_key = org_cst_key
inner join co_organization_ext(nolock) on org_cst_key = org_cst_key_ext


where  -- Currently assumes expiration is 3 years after completion
( (@vss_date >= (select top 1 z25_expiration_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) and (select top 1 z25_completion_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' and z25_status = 'Passed' order by z25_completion_date desc ) is not null)
or
(@prc_date >= (select top 1 z25_expiration_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) and (select top 1 z25_completion_date from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' and z25_status = 'Passed' order by z25_completion_date desc ) is not null) )
and
ind_cst_key in 

( -- this is the list of valid individuals in the hierarchy
select a.ind_cst_key
from co_individual as a (nolock)
inner join co_individual_ext(nolock) as b  on a.ind_cst_key = b.ind_cst_key_ext
inner join co_individual_x_organization(nolock) as c on a.ind_cst_key = c.ixo_ind_cst_key
inner join co_individual_x_organization_ext(nolock) as d on c.ixo_key = d.ixo_key_ext
inner join co_organization_ext(nolock)  as e on c.ixo_org_cst_key = e.org_cst_key_ext
inner join mb_member_type(nolock) as f on d.ixo_mbt_key_ext = f.mbt_key
where 
(b.ind_suspended_flag_ext = 0 or b.ind_suspended_flag_ext is null)
AND
(b.ind_confidential_status_ext = 'N/A' or b.ind_confidential_status_ext is null)
AND
(c.ixo_delete_flag = 0)
AND
 (co_individual.ind_delete_flag = 0)
AND
(d.ixo_status_ext in (SELECT * FROM @mb_status_list)) -- criteria
AND
(e.org_hierarchy_hash_ext like @org_hierarchy_hash+'%' ) -- criteria
AND
(f.mbt_code = @mbt_type or @mbt_type is null)
)
order by org_hierarchy_hash_ext
end -- end of the else (ie, end of just the org itself


END
