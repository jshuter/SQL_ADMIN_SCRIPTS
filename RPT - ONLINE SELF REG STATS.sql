SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select count(*), o.org_allow_online_reg_flag_ext from 
co_organization org
join co_organization_ext o on org.org_cst_key = o.org_cst_key_ext
where org_status_ext = 'Active' 
and org.org_ogt_code = 'Group'
and org.org_delete_flag = 0 
group by o.org_allow_online_reg_flag_ext

declare @self_part_total int, 
@reg_part_total  int , 
@self_vol_total  int, 
@reg_vol_total int, 
@total int 

select @self_part_total = COUNT(*) from client_scouts_experimental_registration       where x13_type = '2016' and x13_progress in ('Confirmation','Payment Received') and x13_source = 'Self' and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- participant 
select @reg_part_total = COUNT(*) from client_scouts_experimental_registration  where x13_type = '2016' and x13_progress in ('Confirmation','Payment Received') and x13_source <> 'Self' and x13_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- participant 
select @self_vol_total = COUNT(*)  from client_scouts_experimental_registration       where x13_type = '2016' and x13_progress in ('Confirmation','Payment Received') and x13_source = 'Self' and x13_mbt_key = 'AF0C862E-0C1C-4C50-B9D1-7F3DB3225F9E' -- volunteer  
select @reg_vol_total = COUNT(*) from client_scouts_experimental_registration  where x13_type = '2016' and x13_progress in ('Confirmation','Payment Received') and x13_source <> 'Self' and x13_mbt_key = 'AF0C862E-0C1C-4C50-B9D1-7F3DB3225F9E' -- volunteer 
select @total = COUNT(*) from client_scouts_experimental_registration           where x13_type = '2016' and x13_progress in ('Confirmation','Payment Received')

Select 
'Percentage',
(cast(@self_part_total as real) / cast(@self_part_total + @reg_part_total as real)) * 100  as 'Participant by Self',
(cast(@reg_part_total  as real) / cast(@self_part_total + @reg_part_total as real)) * 100  as 'Participant by registrar',
(cast(@self_vol_total  as real) / cast(@self_vol_total + @reg_vol_total as real)) * 100 as 'Volunteer by Self', 
(cast(@reg_vol_total  as real) / cast(@self_vol_total + @reg_vol_total as real)) * 100 as 'Volunteer by Registrar'
,'100'

union 

select  
'Count',
@self_part_total ,
@reg_part_total , 
@self_vol_total , 
@reg_vol_total ,
@total  

--
select org.org_cst_key,  o.org_allow_online_reg_flag_ext, o.org_bank_account_received_flag_ext , 

/* 
AllowReg = (SELECT COUNT(*) as Configured
		FROM co_organization(nolock)
			inner join	co_organization_ext(nolock)		
				on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	
				on org_cst_key = a03_org_cst_key 
					and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
		where (select org_hierarchy_hash_ext from co_organization_ext ce 
			where ce.org_cst_key_ext = org.org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			-- and			org_bank_account_received_flag_ext	= 1
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			a03_registration_year = '2016'
			-- and			GETDATE() between a03_from_date and a03_to_date 
			) 

,
 BankIsReady = (SELECT COUNT(*) as Configured
		FROM co_organization(nolock)
			inner join	co_organization_ext(nolock)		
				on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	
				on org_cst_key = a03_org_cst_key 
					and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
		where (select org_hierarchy_hash_ext from co_organization_ext ce 
			where ce.org_cst_key_ext = org.org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
		
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			-- and			a03_registration_year = '2016'
			-- and			GETDATE() between a03_from_date and a03_to_date 
			) 

'
*/
 
 FeesSetup = (SELECT COUNT(*) as Configured
		FROM co_organization(nolock)
			inner join	co_organization_ext(nolock)		
				on org_cst_key = org_cst_key_ext
			inner join	client_scouts_org_fee_x_date	
				on org_cst_key = a03_org_cst_key 
					and a03_mbt_key = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant 
		where (select org_hierarchy_hash_ext from co_organization_ext ce 
			where ce.org_cst_key_ext = org.org_cst_key) like org_hierarchy_hash_ext + '%'
			and			org_ogt_code = 'Group'
			and			org_allow_online_reg_flag_ext		= 1
			and			org_bank_account_received_flag_ext	= 1
			
			AND			(org_closed_group_flag_ext is null or org_closed_group_flag_ext = 0)
			AND			(a03_delete_flag is null or a03_delete_flag = 0)
			and			a03_registration_year = '2016'
			and			GETDATE() between a03_from_date and a03_to_date ) 

,
LAST_YEAR_SELF = (select COUNT(*) from co_customer cstSection 
						join  co_individual_x_organization  ixoSection
							on ixoSection.ixo_org_cst_key = cstSection.cst_key
						join co_individual_x_organization_ext ixoeSection
							on ixoSection.ixo_key = ixoeSection.ixo_key_ext
						join client_scouts_experimental_registration REG 
							on REG.x13_ixo_key = ixoSection.ixo_key
							
							where cstSection.cst_parent_cst_key = org_cst_key 
							and ixoeSection.ixo_wasactive_flag_ext = 1
							and ixoeSection.ixo_mbt_key_ext =  '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant
							and ixoSection.ixo_end_date between '2014-09-01'
								and '2015-09-01'
							and reg.x13_source = 'Self'
						) 
								
, 
THIS_YEAR_SELF = (select COUNT(*) from co_customer cstSection 
						join  co_individual_x_organization  ixoSection
							on ixoSection.ixo_org_cst_key = cstSection.cst_key
						join co_individual_x_organization_ext ixoeSection
							on ixoSection.ixo_key = ixoeSection.ixo_key_ext
						join client_scouts_experimental_registration REG 
							on REG.x13_ixo_key = ixoSection.ixo_key
							
							where cstSection.cst_parent_cst_key = org_cst_key 
							and ixoeSection.ixo_wasactive_flag_ext = 1
							and ixoeSection.ixo_mbt_key_ext =  '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant
							and ixoSection.ixo_start_date > '2015-08-31'
							and reg.x13_source = 'Self'
		)
							
,
LAST_YEAR_NOT_SELF = (select COUNT(*) from co_customer cstSection 
						join  co_individual_x_organization  ixoSection
							on ixoSection.ixo_org_cst_key = cstSection.cst_key
						join co_individual_x_organization_ext ixoeSection
							on ixoSection.ixo_key = ixoeSection.ixo_key_ext
						join client_scouts_experimental_registration REG 
							on REG.x13_ixo_key = ixoSection.ixo_key
							
							where cstSection.cst_parent_cst_key = org_cst_key 
							and ixoeSection.ixo_wasactive_flag_ext = 1
							and ixoeSection.ixo_mbt_key_ext =  '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant
							and ixoSection.ixo_end_date between '2014-09-01'
								and '2015-09-01'
							and reg.x13_source <> 'Self'
						) 
								
, 
THIS_YEAR_NOT_SELF = (select COUNT(*) from co_customer cstSection 
						join  co_individual_x_organization  ixoSection
							on ixoSection.ixo_org_cst_key = cstSection.cst_key
						join co_individual_x_organization_ext ixoeSection
							on ixoSection.ixo_key = ixoeSection.ixo_key_ext
						join client_scouts_experimental_registration REG 
							on REG.x13_ixo_key = ixoSection.ixo_key
							
							where cstSection.cst_parent_cst_key = org_cst_key 
							and ixoeSection.ixo_wasactive_flag_ext = 1
							and ixoeSection.ixo_mbt_key_ext =  '2AD023FF-3AC9-4619-828E-546B2A1ABC8E' -- Participant
							and ixoSection.ixo_start_date > '2015-08-31'
							and reg.x13_source <> 'Self'
		)
						
from 

co_organization org
join co_organization_ext o on org.org_cst_key = o.org_cst_key_ext
where org_status_ext = 'Active' 
and org.org_ogt_code = 'Group'
and org.org_delete_flag = 0 
-- and o.org_allow_online_reg_flag_ext = 1 

