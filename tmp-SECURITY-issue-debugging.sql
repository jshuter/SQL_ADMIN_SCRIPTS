USE [netForumSCOUTSTest]
GO

/*
 This is logic used to list which services can be executed by User Accounts !!!
*/

declare @ind_cst_key uniqueidentifier


set @ind_cst_key = '36BE1B73-95A8-4A9E-9612-369E58CFFCC1'


	declare @today datetime
	set @today = getdate()
	
	if exists(
			select ind_cst_key_ext from co_individual_ext (nolock)
			where 
			ind_cst_key_ext = @ind_cst_key and
			ind_status_ext = 'active'
			)
	begin

		create table #temp_rlt (temp_rlt_code nvarchar(200))
		
		insert into #temp_rlt
		select 
			ixo_rlt_code
		from
			co_individual_x_organization (nolock) inner join
			co_individual_x_organization_ext(nolock) on
			ixo_key = ixo_key_ext
		where
			ixo_delete_flag = 0 and
			(ixo_status_ext = 'Active' AND 
			(ixo_end_date is null or ixo_end_date >= @today) and
			((ixo_ind_cst_key = @ind_cst_key) 
			or (ixo_ind_cst_key in (select ind_cst_key
from co_customer_x_customer 
join co_individual  on cxc_cst_key_2=ind_cst_key
where (((cxc_cst_key_1= @ind_cst_key) and  cxc_rlt_code2 = 'Child') and ind_age_cp < 18))  )))

 -- switched ixo_end_date < @today to ixo_end_date > @today, appeared to be bug. 12/13/2011 - Itrumbley
 -- had it check not just the persons records but their childs for security. 2/2/2012 - Itrumbley

		select
			ind_cst_key,
			(	select distinct a21_dyn_key
				from 
					client_scouts_role_x_forms (nolock)
					join #temp_rlt (nolock) on temp_rlt_code = a21_rlt_code
					where a21_delete_flag = 0
				FOR XML PATH('form'), elements xsinil, TYPE, Root('forms')
			),
			(	select distinct wxm_web_method
				from 
					client_scouts_role_x_execute_methods (nolock)
					join ws_web_service_method (nolock) on wxm_key = a22_wxm_key
					join #temp_rlt (nolock) on temp_rlt_code = a22_rlt_code
					where a22_delete_flag = 0
				FOR XML PATH('method'), elements xsinil, TYPE, Root('methods')
			)
		from
			co_individual
		where 
			(ind_cst_key = @ind_cst_key) 

		for xml path('individual'), elements xsinil, type


	end 	else  	begin
	
	
			select
			ind_cst_key,
			(	select a21_dyn_key = null
				where 1=0
				FOR XML PATH('form'), elements xsinil, TYPE, Root('forms')
			),
			(	select wxm_web_method = null
				where 1=0
				FOR XML PATH('method'), elements xsinil, TYPE, Root('methods')
			)
		from
			co_individual
		where 
			(ind_cst_key = @ind_cst_key) 

	end



