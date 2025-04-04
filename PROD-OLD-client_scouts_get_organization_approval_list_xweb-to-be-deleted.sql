USE [netFORUMSCOUTS]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_get_organization_approval_list_xweb]    Script Date: 08/27/2015 10:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ITrumbley
-- Create date: 02/10/2012
-- Description:	Get a list of approved statii
-- Feb 13, removed requries logic to use centralized function get requires string
-- =============================================
ALTER PROCEDURE [dbo].[client_scouts_get_organization_approval_list_xweb] 
	-- Add the parameters for the stored procedure here

	@org_cst_key uniqueidentifier
AS
BEGIN
Declare @OrgType nvarchar(50)
set @OrgType = (select org_ogt_code from co_organization(nolock) where org_cst_key = @org_cst_key)
Declare  @OrgHash nvarchar(1000)

set @OrgHash = (select org_hierarchy_hash_ext from co_organization_ext(nolock) where org_cst_key_ext = @org_cst_key)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF (@OrgType = 'National')
	Select ixo_key, ind_cst_key, mbt_code as [MemberType], ixo_rlt_code as [Role], cst_sort_name_dn as [Name], convert(varchar,ixo_start_date,101) as [StartDate], convert(varchar,ixo_end_date,101) as [MemberTillDate], ixo_status_ext as [Status],
	
		[Requires]= (select dbo.client_scouts_get_requires_string(ixo_key))
	
	
	from (((co_individual_x_organization(nolock) 
	inner join co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext)
	 inner join co_individual(nolock) on ixo_ind_cst_key = ind_cst_key) 
	 inner join mb_member_type (nolock) on ixo_mbt_key_ext=mbt_key)
	 inner join co_individual_ext(nolock) on ind_cst_key = ind_cst_key_ext
	 inner join co_customer(nolock) on ind_cst_key = cst_key
	where (ixo_org_cst_key = @org_cst_key) and ixo_status_ext = 'Pending'
		
	for xml path('Affiliation'), elements xsinil, type, root('Affiliations')
	
	ELSE
	
	
	IF (@OrgType = 'Council')
		Select ixo_key, ind_cst_key, mbt_code as [MemberType], ixo_rlt_code as [Role], iorg.cst_sort_name_dn as [Name], convert(varchar,ixo_start_date,101) as [StartDate], convert(varchar,ixo_end_date,101) as [MemberTillDate], ixo_status_ext as [Status],
		
			[Requires]= (select dbo.client_scouts_get_requires_string(ixo_key))
	
		
	from ((((co_individual_x_organization(nolock) 
	inner join co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext)
	 inner join co_individual(nolock) on ixo_ind_cst_key = ind_cst_key) 
	 inner join mb_member_type (nolock) on ixo_mbt_key_ext=mbt_key)
	 
	 inner join co_organization_ext(nolock) on ixo_org_cst_key = org_cst_key_ext) 
	 inner join co_customer(nolock) as corg on corg.cst_key = org_cst_key_ext
	 inner join co_individual_ext(nolock) on ind_cst_key = ind_cst_key_ext
	 inner join co_customer(nolock) as iorg on iorg.cst_key = ind_cst_key
	where ((  ixo_status_ext = 'Pending') and org_hierarchy_hash_ext LIKE (@OrgHash + '%')) AND 
	((
	((select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) <> 'Passed') OR ((select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) <> 'Passed')
	-- this is the approval count
	OR (select COUNT(z26_key) from client_scouts_approval_record(nolock)
                        
                        where 
                        z26_status = 'Valid'
                        and
                        (z26_expiration_date is null OR z26_expiration_date >= GETDATE())
                        and z26_delete_flag = 0 and z26_cst_key = ind_cst_key_ext) = 0
	
	--
	)
	
	 OR (org_cst_key_ext = @org_cst_key OR corg.cst_parent_cst_key = @org_cst_key ))
	
	for xml path('Affiliation'), elements xsinil, type, root('Affiliations')
	
	ELSE
	
	IF ((@OrgType is not null) and ((@OrgType <> 'Council') and (@OrgType <> 'National')))
	
	Select ixo_key, ind_cst_key, mbt_code as [MemberType], ixo_rlt_code as [Role], iorg.cst_sort_name_dn as [Name], convert(varchar,ixo_start_date,101) as [StartDate], convert(varchar,ixo_end_date,101) as [MemberTillDate], ixo_status_ext as [Status], 	
	
	
	[Requires]= (select dbo.client_scouts_get_requires_string(ixo_key))
	
	from (((((co_individual_x_organization(nolock) 
	inner join co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext)
	 inner join co_individual(nolock) on ixo_ind_cst_key = ind_cst_key) 
	 inner join mb_member_type (nolock) on ixo_mbt_key_ext=mbt_key)
	 inner join co_organization_ext(nolock) on ixo_org_cst_key = org_cst_key_ext) 
	 inner join co_individual_ext(nolock) on ind_cst_key = ind_cst_key_ext)
	 inner join co_customer(nolock) as corg on org_cst_key_ext = corg.cst_key
	 inner join co_customer(nolock) as iorg on iorg.cst_key = ind_cst_key
	where ((  ixo_status_ext = 'Pending') ) AND ((((select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'VSS' order by z25_completion_date desc) = 'Passed') and ((select top 1 z25_status from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc) = 'Passed')) and corg.cst_parent_cst_key = @org_cst_key)
	and 
	-- this bit is to make sure it has to have been approved
	(select COUNT(z26_key) from client_scouts_approval_record(nolock)
                        
                        where 
                        z26_status = 'Valid'
                        and
                        (z26_expiration_date is null OR z26_expiration_date >= GETDATE())
                        and z26_delete_flag = 0 and z26_cst_key = ind_cst_key_ext) > 0
	
	for xml path('Affiliation'), elements xsinil, type, root('Affiliations')
	
	ELSE
		SELECT	'' as ixo_key,
		'' as ind_cst_key,
		'' as [MemberType],
		'' as [Role],
		'' as [Name],
		'' as [StatDate],
		'' as [MemberTillDate],
		'' as [Status],
		'' as [Requires]

	for xml path('Affiliation'), elements xsinil, type, root('Affiliations')

    -- Insert statements for procedure here
	--SELECT 'cheetoes'
	
	
	
	
END
