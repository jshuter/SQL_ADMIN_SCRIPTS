USE [netFORUMSCOUTS]
GO
/****** Object:  StoredProcedure [dbo].[client_scouts_scouts_list_xweb]    Script Date: 08/25/2015 15:19:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- last updated 4/6/2011
-- tj updated 9/28/2011 on action
-- last updated by itrumbly on 03/10/2012

-- 2015/04/27 - jss - Adjusted to use date-functions - so that testing can occur before May 1st ...
-- 2015/04/27 - jss - moved from drop/create to ALTER - as this is only used on existing DEV/PROD db's 
-- 2015/06/02 - MYAGI - Listing is for Active and Not Renewed participants only

ALTER PROCEDURE [dbo].[client_scouts_scouts_list_xweb]  
  
@org_cst_key uniqueidentifier,
@ind_cst_key uniqueidentifier='00000000-0000-0000-0000-000000000000',
@entity_key nvarchar(38)=null  
  
AS  
  
set nocount on  

declare @parent_key uniqueidentifier
DECLARE @current_date DATETIME = GETDATE()

select 
	@parent_key = cst_parent_cst_key
from 
	co_customer
where 
	cst_key = @org_cst_key
-- no need to get next level, this is for my youth only

-- get org accesses
create table #temp_org_list (temporg_cst_key uniqueidentifier, temp_org_name nvarchar(200),templevel int)

insert into #temp_org_list
exec client_scouts_get_org_tree_up @org_cst_key,5

DECLARE @org_hierarchy TABLE 
([org_cst_key] uniqueidentifier, 
[org_name] nvarchar(150),
[org_ogt_code] nvarchar(30),
[Level] int)

INSERT INTO @org_hierarchy
exec client_scouts_get_org_hierarchy
@org_cst_key = @org_cst_key,
@direction = 'parent',
@return_xml = 0

IF (
		-- individual does not have access to the organization
		not exists
		( 
		select ixo_key
		from
			co_individual_x_organization (nolock) join
			#temp_org_list (nolock) on temporg_cst_key = ixo_org_cst_key
		where
			ixo_ind_cst_key = @ind_cst_key and
			ixo_delete_flag = 0 and 
			(ixo_end_date is null or ixo_end_date>= @current_date) and
			(ixo_start_date is null or ixo_start_date <=@current_date)
		)
		or
		-- there are no related individual to the organization
		NOT exists
		(
		SELECT	
			ixo_key
			--ind_cst_key,
			--[Role]=ixo_rlt_code,
			--[Name]=ind_last_name+', '+ind_first_name,
			--[EveningPhone]=cph_phn_number_complete
		FROM 
			co_individual_x_organization (nolock)     
			JOIN co_individual (nolock)     
				ON ind_cst_key=ixo_ind_cst_key 
				and ind_delete_flag=0
			JOIN co_individual_ext (nolock) on ind_cst_key=ind_cst_key_ext
			JOIN co_customer cOrg   (nolock)   ON cOrg.cst_key = ixo_org_cst_key
			JOIN co_organization (nolock) on ixo_org_cst_key=org_cst_key	
			JOIN co_customer ind  (nolock)   on ind.cst_key=ixo_ind_cst_key
			JOIN co_individual_x_organization_ext (nolock) on ixo_key_ext=ixo_key
			JOIN mb_member_type (nolock) on ixo_mbt_key_ext=mbt_key
		WHERE 
			ixo_delete_flag=0 
				and (mbt_code = 'Participant' )--or mbt_code='Youth' or mbt_code='Employee')
			and ixo_org_cst_key = @org_cst_key
			and ((ind_confidential_status_ext is null or ind_confidential_status_ext='N/A')
and isnull(ind_suspended_flag_ext,0)=0)
			
		)
	)
	SELECT	'' as ixo_key,
		'' as ind_cst_key,
		'' as [MemberType],
		'' as [Role],
		'' as [Name],
		'' as [Birthday],
		'' as [EveningPhone],
		'' as [SectionKey],
		'' as [GroupKey],
		'' as [Actions]
	for xml path('individual'), elements xsinil, type, root('individuals')


ELSE
	Begin
	declare @registrationyear nvarchar(100), 
			@yearstartdate datetime, 
			@yearenddate datetime,
			@prereg_start_month INT,
			@prereg_end_month INT
			
	SET @prereg_start_month = (SELECT MONTH(early_registration_start_date) FROM client_scouts_get_registration_date_range())
	SET @prereg_end_month = (SELECT MONTH(normal_registration_start_date) FROM client_scouts_get_registration_date_range())			
	
	SELECT @registrationyear = YEAR(normal_registration_end_date) FROM client_scouts_get_registration_date_range();
	
	if month(@current_date)>=@prereg_start_month and month(@current_date)< @prereg_end_month

		if ISNUMERIC(@registrationyear)=1
		begin
			begin try
				select @yearenddate = convert(datetime, '8/31/'+@registrationyear)
				select @yearstartdate = DATEADD(year,-1,@yearenddate)
				select @yearstartdate = DATEADD(D,1,@yearstartdate)
				select @yearenddate = dbo.av_end_of_day(@yearenddate)
			end try	
			begin catch
			end catch
		end	
		
		select 
			org_cst_key, 
			org_name
		into 
			#tempSections
		from 
			co_organization (nolock) 
			join co_organization_ext (nolock) on org_cst_key = org_cst_key_ext 
			join co_customer (nolock) on cst_key = org_cst_key 
			join client_scouts_organization_sub_type on org_a01_key_ext=a01_key
		where 
			cst_parent_cst_key = @parent_key
			and org_ogt_code = 'section'
			and org_status_ext = 'active'
			and a01_ogt_sub_type<>'Committee' 
			and a01_ogt_sub_type<>'Service Team'
			and a01_ogt_sub_type<>'Visibility Group'
				
		SELECT	ixo_key = Ixo.ixo_key,
			ind_cst_key,
			[MemberType]=mbt_code,
			[Role]=Ixo.ixo_rlt_code,
			[Name]=ind_last_name+', '+ind_first_name,
			[Birthday] = convert(nvarchar(50),ind_dob,101),
					
			[EveningPhone]=cst_evening_phone_ext,
			(
				select 
					org_cst_key, 
					org_name
				from 
					#tempSections
				FOR XML PATH('SectionKey'), TYPE, Root('SectionKeys')
			),
			[GroupKey]=@parent_key,
			(				
				select [Name]=[Action]
				from
				(
					select [Action]='Transfer'
					where ixo_status_ext='Active'
					union
					-- MYAGI 20150526: Updated logic
					-- If we are in early registration, we only show Renew if the participant is currently 'active'
					-- If during normal registration, we only show Renew if they are 'not renewed'
					select [Action] ='Renew' 
					where
						(
						  (ixo_status_ext = 'Active' 
							 and ixo_renewed_flag_ext=0 
							 AND (month(@current_date)>=@prereg_start_month and month(@current_date)< @prereg_end_month))
							 AND (SELECT			
								    COUNT(*) as Configured
								FROM	co_organization(nolock) co
								    inner join co_organization_ext(nolock) coe on co.org_cst_key = coe.org_cst_key_ext
								    inner join client_scouts_org_fee_x_date csfd on co.org_cst_key = csfd.a03_org_cst_key 
								where
									coe.org_cst_key_ext = (select top 1 org_cst_key FROM @org_hierarchy oh where oh.org_ogt_code = 'Group') AND
									co.org_ogt_code = 'Group' AND
									csfd.a03_mbt_key = IxoExt.ixo_mbt_key_ext AND
									(csfd.a03_delete_flag != 1) AND
									csfd.a03_registration_year = YEAR(@yearenddate) AND
									-- 20150625: PJohnsen request to check from/to fields 
									csfd.a03_from_date <= @current_date AND
									csfd.a03_to_date >= @current_date) > 0
									
						  or 
						  (ixo_status_ext like '%Not Renew%' 
							 and ixo_renewed_flag_ext=0
							 and not (month(@current_date)>=@prereg_start_month and month(@current_date)< @prereg_end_month))
							 AND (SELECT			
								    COUNT(*) as Configured
								FROM	co_organization(nolock) co
								    inner join co_organization_ext(nolock) coe on co.org_cst_key = coe.org_cst_key_ext
								    inner join client_scouts_org_fee_x_date csfd on co.org_cst_key = csfd.a03_org_cst_key 
								where
									coe.org_cst_key_ext = (select top 1 org_cst_key FROM @org_hierarchy oh where oh.org_ogt_code = 'Group') AND
									co.org_ogt_code = 'Group' AND
									csfd.a03_mbt_key = IxoExt.ixo_mbt_key_ext AND
									(csfd.a03_delete_flag != 1) AND
									csfd.a03_registration_year = YEAR(@yearstartdate) AND
									-- 20150625: PJohnsen request to check from/to fields 
									csfd.a03_from_date <= @current_date AND
									csfd.a03_to_date >= @current_date) > 0
						)
						
						and 
						
						not exists 
						(
							select ixo_key
							from co_individual_x_organization OtherIXO (nolock) join
								co_individual_x_organization_ext OtherIXOExt (nolock) on OtherIXO.ixo_key = OtherIXOExt.ixo_key_ext
							where 
								OtherIXO.ixo_ind_cst_key = ind_cst_key and
								OtherIXOExt.ixo_mbt_key_ext = IxoExt.ixo_mbt_key_ext and
								OtherIXO.ixo_end_date between @yearstartdate and @yearenddate and
								OtherIXO.ixo_delete_flag != 1
						)	
					
				) Act
				
				FOR XML PATH('Action'), TYPE, Root('Actions') 
			)
			-- this is the change - Itrumbley, 3/10/2012
			-- this is to see if they fall into a predefined set of roles, 
			-- 
	


		FROM 
			co_individual_x_organization Ixo (nolock)     
			JOIN co_individual (nolock)     
				ON ind_cst_key=Ixo.ixo_ind_cst_key 
				and ind_delete_flag=0
			JOIN co_individual_ext (nolock) on ind_cst_key=ind_cst_key_ext
			JOIN co_customer cOrg   (nolock)   ON cOrg.cst_key = Ixo.ixo_org_cst_key
			JOIN co_organization on Ixo.ixo_org_cst_key=org_cst_key	
			JOIN co_customer ind  (nolock)   on ind.cst_key=Ixo.ixo_ind_cst_key
			join co_customer_ext (nolock) on ind.cst_key = cst_key_ext
			JOIN co_individual_x_organization_ext IxoExt (nolock) on IxoExt.ixo_key_ext=Ixo.ixo_key
			JOIN mb_member_type (nolock) on IxoExt.ixo_mbt_key_ext=mbt_key
		WHERE 
			ixo_delete_flag=0
			-- MYAGI 20150526: We are only concerned about Active and not renewed participants
			-- To prevent regregisteration, 
			and (ixoExt.ixo_status_ext = 'Active' or (ixoExt.ixo_status_ext like '%not renew%' and ixoExt.ixo_renewed_flag_ext = 0 and not (month(@current_date)>=@prereg_start_month and month(@current_date)< @prereg_end_month)))  
			and (ixo_end_date is null or ixo_end_date>= @current_date)
			and (ixo_start_date is null or ixo_start_date <=@current_date) 
			and (mbt_code = 'Participant' )
			and ixo_org_cst_key = @org_cst_key
			and ((ind_confidential_status_ext is null or ind_confidential_status_ext='N/A')
		     and isnull(ind_suspended_flag_ext,0)=0)

		ORDER BY 
			MemberType,Role,Name ASC
		for xml path('individual'), elements xsinil, type, root('individuals')

	End
