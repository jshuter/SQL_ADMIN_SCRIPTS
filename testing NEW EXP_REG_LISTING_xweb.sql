
-- exec client_scouts_experimental_registration_listing_xweb @ind_cst_key = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D'
--SET STATISTICS IO ON 
--SET STATISTICS TIME ON 

declare
	-- Add the parameters for the stored procedure here
	@ind_cst_key uniqueidentifier = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D',
	@org_cst_key uniqueidentifier = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D'


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


IF NOT exists ( SELECT	cst_key
				from co_customer(nolock)
				where cst_key = isnull(@ind_cst_key, @org_cst_key) ) begin 

	SELECT	[x13_key] = '',[Registrant]= '',[sort_first] = '',[sort_last] = '',[Parent] = '',[Type] = '',
			[Role] = '', [Organization] = '',[Year] = '',[Progress] = '',[Invoice] = '', [Source] = ''
	for xml path('registration'), elements xsinil, type, root('registrations')

end ELSE begin 

	if @ind_cst_key IS NOT NULL begin 

		-- Insert statements for procedure here
		select 	x13_key,
			child.ind_full_name_cp as [Registrant],
			child.ind_first_name as [sort_first],
			child.ind_last_name as [sort_last],
			parent.ind_full_name_cp as [Parent],
			mbt_code as [Type],
			ixo_rlt_code as [Role],
			org_name as [Organization],
			x13_type as [Year],
			x13_progress as [Progress],
			inv_code as [Invoice],
			x13_source as [Source]

		from client_scouts_experimental_registration(nolock)
			left join co_individual(nolock) as parent on x13_ind_cst_key_1 = parent.ind_cst_key
			left join co_individual(nolock) as child on x13_ind_cst_key_2 = child.ind_cst_key
			left join co_organization(nolock) on x13_org_cst_key = org_cst_key
			left join co_organization_ext(nolock) as mainorg on mainorg.org_cst_key_ext = org_cst_key
			left join mb_member_type(nolock) on x13_mbt_key = mbt_key
			left join ac_invoice(nolock) on x13_inv_key = inv_key
			left join co_individual_x_organization(nolock) on x13_ixo_key = ixo_key
		
		where x13_delete_flag = 0 and 
		
 			(x13_ind_cst_key_1 = @ind_cst_key or x13_ind_cst_key_2 = @ind_cst_key) 
			and x13_source = 'Self' 
			and x13_progress != 'New'
			and x13_progress != 'Confirmation'
			order by [sort_last], [sort_first]

	end else begin 

		-- MUST HAVE org_cst_key if we got here  

		select 	x13_key,
			child.ind_full_name_cp as [Registrant],
			child.ind_first_name as [sort_first],
			child.ind_last_name as [sort_last],
			parent.ind_full_name_cp as [Parent],
			mbt_code as [Type],
			ixo_rlt_code as [Role],
			org_name as [Organization],
			x13_type as [Year],
			x13_progress as [Progress],
			inv_code as [Invoice],
			x13_source as [Source]

		from client_scouts_experimental_registration(nolock)
			left join co_individual(nolock) as parent on x13_ind_cst_key_1 = parent.ind_cst_key
			left join co_individual(nolock) as child on x13_ind_cst_key_2 = child.ind_cst_key
			left join co_organization(nolock) on x13_org_cst_key = org_cst_key
			left join co_organization_ext(nolock) as mainorg on mainorg.org_cst_key_ext = org_cst_key
			left join mb_member_type(nolock) on x13_mbt_key = mbt_key
			left join ac_invoice(nolock) on x13_inv_key = inv_key
			left join co_individual_x_organization(nolock) on x13_ixo_key = ixo_key
		
		where 
		 		 
		 (org_cst_key = @org_cst_key 
			OR 
			mainorg.org_hierarchy_hash_ext like (select tmp.org_hierarchy_hash_ext from co_organization_ext as tmp where tmp.org_cst_key_ext = @org_cst_key) + '%' 
		 )
		 and x13_source = 'Registrar'		 
		 and x13_progress != 'New'
		 and x13_progress != 'Confirmation'
		 and x13_delete_flag = 0
		 order by [sort_last], [sort_first]
		
	end 

end 
--  for xml path('registration'), elements xsinil, type, root('registrations')




