USE [netFORUMSCOUTS]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_individual_search]    Script Date: 08/27/2015 10:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[client_scouts_individual_search]
	@ind_cst_key	uniqueidentifier,
	@status			nvarchar(50)=null,
	@member_type	nvarchar(50)=null,
	@last_name		nvarchar(30)=null,
	@first_name		nvarchar(30)=null,
	@scouting_role	nvarchar(80)=null,
	@org_name		nvarchar(150)=null,
	@org_sub_type	nvarchar(60) =null,
	@email			nvarchar(30) = null
AS
BEGIN
	if  ((@last_name is null) and (@first_name is null))
	or	NOT exists ( SELECT	cst_key from co_customer where cst_key = @ind_cst_key )
	begin
		select	[result_count]			= '0',
				ixo_ind_cst_key			= '',
				[status]				= '', 
				[member_type]			= '',
				[member_number]			= '',
				[last_name]				= '',
				[first_name]			= '',
				[pg_ind_cst_key]		= '',
				[scouting_role]			= '',
				[organization]			= '',
				[organization_sub_type]	= '',
				[member_dob]			= ''
 		for xml path('Individual'), elements xsinil, type, root('Individuals')
		return
	end
	SET NOCOUNT ON


	set			@last_name	= @last_name + '%'
	set			@first_name = @first_name + '%'
	declare		@rescnt as bigint;
	
	With SearchResults as (
		select		[ixo_ind_cst_key]		= ind_cst_key,
					[status]				= ind_status_ext,
					[member_type]			= mbt_code,
					[member_number]			= cst_recno,
					[last_name]				= ind_last_name,
					[first_name]			= ind_first_name,
					[pg_ind_cst_key]		= cst_parent_cst_key,
					[scouting_role]			= ixo_rlt_code,
					[organization]			= org_name,
					[organization_sub_type] = a01_ogt_sub_type,
					[member_dob]			= ind_dob
					
		from		co_individual (nolock)
		join		co_individual_ext (nolock)					on ind_cst_key = ind_cst_key_ext
		inner join	co_customer(nolock)							on ind_cst_key = cst_key
		inner join	co_individual_x_organization(nolock)		on cst_ixo_key = ixo_key
		inner join	co_individual_x_organization_ext(nolock)	on ixo_key = ixo_key_ext
		inner join	mb_member_type(nolock)						on mbt_key = ixo_mbt_key_ext
		inner join	co_organization(nolock)						on ixo_org_cst_key = org_cst_key
		inner join	co_organization_ext(nolock)					on org_cst_key = org_cst_key_ext
		inner join	client_scouts_organization_sub_type			on a01_key = org_a01_key_ext
		
		where		cst_key != '00000000-0000-0000-0000-000000000000'
		and			ind_delete_flag=0
		and			ind_deceased_flag=0
		and			ind_first_name like @first_name
		and			ind_last_name like @last_name
		and			( @email is null or len(@email) <= 1 or cst_eml_address_dn = @email )
		and			( (ind_confidential_status_ext is null or ind_confidential_status_ext='N/A') and	isnull(ind_suspended_flag_ext,0) = 0 ) 
		and			ind_status_ext in ('Active','Not Renewed', 'Pending', 'Inactive') 
		and			(		ind_mbt_code_ext = @member_type 
						or	(ind_age_cp < 18 and @member_type = 'Participant')
						or	@member_type = 'All' or	@member_type is null
					)
	), ResultCount as (select (case when COUNT(*) = 0 then null else count(*) end) as result_count from SearchResults)
	
	select * from ResultCount outer apply SearchResults
	for xml	path('Individual'), elements xsinil, type, root('Individuals')
END
