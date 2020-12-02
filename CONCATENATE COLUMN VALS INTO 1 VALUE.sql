
-- STATUS -- completed testing 
-- moving code to final report procedure 




declare @s varchar(1000) = ''

select top 100 @s=@s+ind_full_name_cp+',' from co_individual 

select  @s

declare @i int = 0 

;

with me as (
	select cst_key as parent_cst_key 
		, cst_eml_address_dn as parent_email
	from co_customer 
		where cst_eml_address_dn = 'pjohnsen@scouts.ca'
		OR cst_eml_address_dn = 'JEFFREY.SHUTER@scouts.ca'
		OR cst_eml_address_dn = 'XXXXXXX.SHUTER@scouts.ca'
		OR cst_eml_address_dn = 'zzjshuter@teradocs.comzz'
) 

, 

all_children as

	( 	select c.cst_ind_full_name_dn as cst_ind_full_name_dn 
				, c.cst_key as childs_cst_key 
				, cxc_key as cxc_key 
				, cxc_cst_key_1 AS parent_key

		from co_customer_x_customer with(nolock)
			join co_customer c with(nolock) on cxc_cst_key_2 = c.cst_key 
			join me on me.parent_cst_key = cxc_cst_key_1 
		
		where cxc_rlt_code2 = 'child' 
			and cxc_delete_flag = 0 
			and cst_delete_flag = 0 					
	
	UNION 
	
		select c.cst_ind_full_name_dn as cst_ind_full_name_dn 
			, c.cst_key as childs_cst_key 
			, cxc_key as cxc_key 
			, cxc_cst_key_2 AS parent_key
			
		from co_customer_x_customer with(nolock)
			join co_customer c with(nolock) on cxc_cst_key_1 = c.cst_key 
			join me on me.parent_cst_key = cxc_cst_key_2 
		
		where cxc_rlt_code = 'child' 
			and cxc_delete_flag = 0 
			and cst_delete_flag = 0 					

	--- repeat - but join on EMAIL insteaed of ind_cst_key 
	--  will need to ADJUST FOR EMAIL 
	
	UNION 
	
	 	select c.cst_ind_full_name_dn as cst_ind_full_name_dn 
	 			, c.cst_key as childs_cst_key 
	 			, cxc_key as cxc_key 
				, cxc_cst_key_1 AS parent_key

		from co_customer_x_customer with(nolock)
			join co_customer c with(nolock) on cxc_cst_key_2 = c.cst_key 
			-- ADJUSTED FOR EMAIL 
			join co_customer p with(nolock) on cxc_cst_key_1 = p.cst_key 
			join me on me.parent_email = p.cst_eml_address_dn 
		
		where cxc_rlt_code2 = 'child' 
			and cxc_delete_flag = 0 
			and c.cst_delete_flag = 0 					
			and p.cst_delete_flag = 0 
	
	UNION 
	
		select c.cst_ind_full_name_dn as cst_ind_full_name_dn 
			, c.cst_key as childs_cst_key 
			, cxc_key as cxc_key 
			, cxc_cst_key_2 AS parent_key
			
		from co_customer_x_customer with(nolock)
			join co_customer c with(nolock) on cxc_cst_key_1 = c.cst_key 
			-- join me on me.parent_cst_key = cxc_cst_key_2 
			-- ADJUSTED FOR EMAIL 
			join co_customer p with(nolock) on cxc_cst_key_2 = p.cst_key
			join me on me.parent_email = p.cst_eml_address_dn 
		
		where cxc_rlt_code = 'child' 
			and cxc_delete_flag = 0 
			and c.cst_delete_flag = 0
			and p.cst_delete_flag = 0

	) 

, list as ( 

	SELECT parent_cst_key , 
		child_list = STUFF(	(SELECT ', ' + cst_ind_full_name_dn 
								FROM all_children CH	
								WHERE  CH.parent_key = ME.parent_cst_key		
								ORDER BY cst_ind_full_name_dn  
								FOR XML PATH(''),TYPE).value('.','varchar(1000)'),1,2,'')  
				,l = STUFF(	(select 'x' as c						
								FROM all_children AC
								WHERE  AC.parent_key = ME.parent_cst_key
								ORDER BY cst_ind_full_name_dn
								FOR XML PATH(''),TYPE).value('.','varchar(1000)'),1,1,'x') 
		from me

	) 	

/*	
	select (select ac.cst_ind_full_name_dn 
	FROM all_children ac join me on ac.parent_key = ME.parent_cst_key 
	FOR XML PATH(''),TYPE).value('.','varchar(1000)') 
*/	
	
select * , len(l) as child_count from list 

--	select me.parent_cst_key, child_list, cc as [count] 
--	from ME JOIN list ON ME.parent_cst_key = list.parent_cst_key 
	
	
