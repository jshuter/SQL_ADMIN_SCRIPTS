/* 
select max(bat_date) from ac_batch
select top 100 * from ac_batch where bat_date > '2015-01-01'
F1A954EA-935A-448C-9F1A-7BAE3B780048
F087821D-151F-4173-9799-A6151898ACB5
select top 100 * from ac_batch where bat_code = '09041300-152901'

select top 100 * from ac_batch 
select top 100 * from ac_batch_ext
select top 100 * from ac_batch_x_fw_group
select top 100 * from ac_batch_x_fw_group_ext

select top 100 * from ac_batch where batch_code = '09041300-152901'
select top 100 * from ac_batch_ext where 
select top 100 * from ac_batch_x_fw_group
select top 100 * from ac_batch_x_fw_group_ext

*/
-- PROBLEM batch number : 09041300-152901 >> 7994E7FC-8B24-4DA8-B5B1-C8C18ECD406C
-- b290c926-549c-4b54-8b20-14d45548ca1f

select top 100 * from ac_batch where bat_code = '09041300-152901'
select top 100 * from ac_batch_ext b where b.bat_key_ext = '7994E7FC-8B24-4DA8-B5B1-C8C18ECD406C'
select top 100 * from ac_batch_x_fw_group b where b.bgr_bat_code = '09041300-152901'
--select top 100 * from ac_batch_x_fw_group_ext b where b.bgr_key_ext


	declare @bat_key uniqueidentifier

	set @bat_key = '7994E7FC-8B24-4DA8-B5B1-C8C18ECD406C'

	select 	inv_key,
		
		isnull(
			(select top 1 tmp.cst_sort_name_dn from 
			co_customer(nolock) as tmp inner join
			client_scouts_experimental_registration(nolock) on tmp.cst_key = x13_ind_cst_key_2
			where x13_inv_key = inv_key)
			,
			cst_sort_name_dn
			)
			AS [MemberName], 
		
		isnull(
			(select top 1 tmp2.mbt_code from 
			co_individual_x_organization_ext(nolock) as tmp inner join
			mb_member_type(nolock) as tmp2 on ixo_mbt_key_ext = mbt_key inner join
			client_scouts_experimental_registration(nolock) on tmp.ixo_key_ext = x13_ixo_key
			where x13_inv_key = inv_key)
			,
			a17_mbr_type
			)
			as [MemberType],
		
		isnull(
			(select top 1 tmp2.a01_ogt_sub_type 
				from co_organization_ext(nolock) as tmp 
				inner join client_scouts_experimental_registration(nolock) 
					on tmp.org_cst_key_ext = x13_org_cst_key
				inner join client_scouts_organization_sub_type(nolock) as tmp2 
					on tmp2.a01_key = tmp.org_a01_key_ext
				where x13_inv_key = inv_key)
			,			
			a01_ogt_sub_type
			) 
			as [SectionType],
		
		convert(decimal(19,2),(select sum(ivd_parity_amount_cp) 
			from ac_invoice_detail (nolock)     
			where ivd_inv_key=inv_key 
				and ivd_delete_flag=0 
		and ( ivd_void_date > bat_close_date or ivd_void_flag = 0) )) AS [Fee], 
		
		convert(decimal(19,2),
		
		isnull(
			(select sum(pyd_amount) from ac_payment_detail (nolock)     
				JOIN ac_invoice_detail (nolock) ON pyd_ivd_key=ivd_key
				where ivd_inv_key=inv_key and pyd_void_flag = 0 and pyd_delete_flag = 0), 0)
			) AS [PaymentAmount], 

		case 	
			when inv_close_flag = 1 THEN 'N'
			else 'Y'
			end AS [Open],
		
		isnull(
			(select x13_type from client_scouts_experimental_registration(nolock)
			where x13_inv_key = inv_key)
			,
			a17_registration_year
			)
			as [RegistrationYear],
			
		inv_code_cp  AS [TrxNumber], 

		inv_trx_date AS [Date]
	
	from
		ac_batch (nolock)
		join ac_invoice (nolock) on inv_bat_key=bat_key
		JOIN co_customer (nolock)    
			ON inv_cst_key=cst_key
		JOIN co_individual (nolock)
		    ON ind_cst_key=cst_key
		left join client_scouts_member_registration (nolock)
			on a17_inv_key is not null and a17_inv_key = inv_key
		left join co_organization_ext on a17_section_org_cst_key=org_cst_key_ext
		left join client_scouts_organization_sub_type on org_a01_key_ext=a01_key
	where
		inv_delete_flag=0
		and bat_key=@bat_key
		and exists (select * from ac_invoice_detail (nolock) 
					where ivd_inv_key = inv_key and ivd_void_flag = 0 and ivd_delete_flag = 0)
	
	order by cst_sort_name_dn


-- 	for xml path('invoice'), elements xsinil, type, root('invoices')		





