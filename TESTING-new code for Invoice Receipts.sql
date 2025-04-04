-- TODO 

-- FIX - the 2 keys to right should give same results - but DO NOT !!  (ie, all invoice for all in cxc should give same results) 

declare @ind_cst_key uniqueidentifier = '104BB94D-4A49-4A2E-B4D5-5691FCDC33C6' -- 'FD90ED22-AB13-4D6A-A491-8CFB745405AB'

declare @debug bit 
declare @start_date datetime 
declare @end_date datetime 
declare @scouting_year varchar(10) 
declare @x13_source varchar(12) 

declare @org_hash AS varchar(max);
declare @TblSources as Table(v varchar(200) ) 
declare @TblYears as Table(v varchar(200) ) 
declare @TblMemberTypes as Table(v varchar(200) ) 

-- this is for testing purposes, specifying an org hierarchy top node

	
--------------------------------------------------
-- BEGIN MAIN QUERY HERE 
---------------------------------------------------
	
; with 

invoice_detail_summary as (

	-- MUST JOIN ON ivd_inv_key !!!
	select 
		ivd_inv_key,
		d.ivd_delete_flag as invoice_detail_deleted, 
		d.ivd_void_flag as invoice_detail_voided, 
		CONVERT(VARCHAR(11),d.ivd_void_date,101) as invoice_detail_void_date,	
		'OK' as same  
	from ac_invoice_detail d with (nolock)
	group by ivd_inv_key, ivd_delete_flag, ivd_void_flag, ivd_void_date
)
,

national_amount as(
	-- this is joined on inv_key and also grouped by same, so should return mar 1 row / 1 value !
	SELECT	ac_invoice_detail.ivd_inv_key as inv_key, 
			SUM(ac_invoice_detail.ivd_amount_cp) AS total

		FROM ac_invoice_detail 
			INNER JOIN  oe_price with (nolock) ON ac_invoice_detail.ivd_prc_key = oe_price.prc_key 
			INNER JOIN  oe_price_ext with (nolock) ON oe_price.prc_key = oe_price_ext.prc_key_ext 
			INNER JOIN  co_organization with (nolock) ON oe_price_ext.prc_org_cst_key_ext = co_organization.org_cst_key
						   
		WHERE  (co_organization.org_ogt_code = 'National') 
			AND (ac_invoice_detail.ivd_void_flag = 0) 
			
		GROUP BY  ac_invoice_detail.ivd_inv_key 
) 
, 


group_amount as ( 
	-- this is joined on inv_key and also grouped by same, so should return mar 1 row / 1 value !
	SELECT	ac_invoice_detail.ivd_inv_key as inv_key, 
			SUM(ac_invoice_detail.ivd_amount_cp) AS total

		FROM ac_invoice_detail 
			INNER JOIN  oe_price with (nolock) ON ac_invoice_detail.ivd_prc_key = oe_price.prc_key 
			INNER JOIN  oe_price_ext with (nolock) ON oe_price.prc_key = oe_price_ext.prc_key_ext 
			INNER JOIN  co_organization with (nolock) ON oe_price_ext.prc_org_cst_key_ext = co_organization.org_cst_key
						   
		WHERE  (co_organization.org_ogt_code = 'Group') 
			AND (ac_invoice_detail.ivd_void_flag = 0) 
			
		GROUP BY  ac_invoice_detail.ivd_inv_key 
		
) 
 
SELECT
	
		council.cst_org_name_dn as council_name, 
		area.cst_org_name_dn as area_name, 
		grp.cst_org_name_dn as group_name, 	

		co_customer_1.cst_recno AS RegisteredMemberNo, 
		co_customer_2.cst_recno AS RegisteredMemberOrParent, 
		co_individual.ind_first_name AS RegisteredMemberFirstName, 
		co_individual.ind_last_name AS RegisteredMemberLastName, 
		co_individual_ext.ind_status_ext AS MemberStatusofRegisteredMember, 
		batch_org.org_name AS BatchOrg, 
		ac_invoice.inv_code AS InvoiceNumber, 
		CONVERT(VARCHAR(11),ac_invoice.inv_trx_date,101) AS InvoiceDate, 
		national_amount.total as national_amount, 
		group_amount.total as group_amount, 
		(SELECT     sub_inv_detail.ivd_price
			FROM		ac_invoice AS sub_inv 
						LEFT JOIN ac_invoice_detail AS sub_inv_detail ON sub_inv.inv_key = sub_inv_detail.ivd_inv_key
			WHERE	(sub_inv_detail.ivd_type = N'discount') 
						AND (sub_inv_detail.ivd_inv_key = ac_invoice.inv_key) 
						AND (sub_inv.inv_delete_flag = 0)) 
			AS [DISCOUNT], 

		invoice_detail_summary.invoice_detail_voided, 
		invoice_detail_summary.invoice_detail_deleted,
		invoice_detail_summary.invoice_detail_void_date,

		batch.bat_code AS BatchNumber, 
		ISNULL(CONVERT(nvarchar(50), batch.bat_close_date, 101), 'Open') AS closed, 
		org.org_name AS RegisteredOrg, 

		reg.x13_type AS RegistrationYear,
					
		co_customer.cst_recno AS MemberInvoiced,   
		inv_ind.ind_first_name AS InvoiceFName, 
		inv_ind.ind_last_name AS InvoiceLName, 
		org_subtype.a01_ogt_sub_type AS RegisteredOrgSubType,
		reg.x13_source AS RegisteredSource, 
		reg.x13_progress AS RegistrationProgress, 
		batch_org.org_ogt_code AS BatchOrgType, 
		batch_org_subtype.a01_ogt_sub_type AS BatchOrgSubType, 
		batch_org_ext.org_hierarchy_hash_ext AS BatchOrganizationHash, 
		org_ext.org_hierarchy_hash_ext AS RegisteredOrganizationHash,
		org_ext.org_hierarchy_friendly_ext AS RegisteredOrganizationFriendly, 
		reg.x13_delete_flag AS [RegistrationDeleted], 
		reg.x13_change_user AS [RegistrationChangeUser], 
		reg.x13_change_date AS [RegistrationChangeDate], 
		co_individual.ind_delete_flag AS Individualdeleted, 
		       
		ac_invoice.inv_change_user

		
FROM    client_scouts_experimental_registration reg 
					
			-- Invoice Info 			
			JOIN ac_invoice					with (nolock) ON reg.x13_inv_key = ac_invoice.inv_key 
			JOIN co_customer				with (nolock) ON co_customer.cst_key = ac_invoice.inv_cst_key 
			JOIN co_individual AS inv_ind	with (nolock) ON co_customer.cst_key = inv_ind.ind_cst_key   -- for names as per invoice 

			-- INVOICE - sectioned amounts
			JOIN national_amount with (nolock) on national_amount.inv_key = ac_invoice.inv_key
			JOIN group_amount with (nolock) on group_amount.inv_key = ac_invoice.inv_key
		
			-- Batch Group Info 
			JOIN ac_batch Batch							with (nolock) ON ac_invoice.inv_bat_key = Batch.bat_key 
            JOIN ac_batch_ext Batch_ext					with (nolock) on batch_ext.bat_key_ext = Batch.bat_key 
            JOIN co_organization AS batch_org			with (nolock) ON batch_ext.bat_org_cst_key_ext = batch_org.org_cst_key 
            JOIN co_organization_ext AS batch_org_ext	with (nolock) ON batch_org.org_cst_key = batch_org_ext.org_cst_key_ext 
            JOIN client_scouts_organization_sub_type AS batch_org_subtype with (nolock) ON batch_org_ext.org_a01_key_ext = batch_org_subtype.a01_key 
			
			-- Registered Group Info 
			JOIN co_organization AS org					with (nolock) ON reg.x13_org_cst_key = org.org_cst_key 
            JOIN co_organization_ext org_ext			with (nolock) ON org.org_cst_key = org_ext.org_cst_key_ext 
			JOIN client_scouts_organization_sub_type org_subtype with (nolock) ON  org_subtype.a01_key = org_ext.org_a01_key_ext 

 
			-- Assuming Registered ORG is a SECTION, and get heirarchy grp/area/council  
			join co_customer sections_customer	with (nolock) on sections_customer.cst_key = org.org_cst_key 
			join co_customer grp				with (nolock) on grp.cst_key = sections_customer.cst_parent_cst_key 
			join co_customer area				with (nolock) on area.cst_key = grp.cst_parent_cst_key 
			join co_customer council			with (nolock) on council.cst_key = area.cst_parent_cst_key
            			
			-- Registered CST_2 Key -- (Parent or Participant?) 
            LEFT OUTER JOIN co_customer AS co_customer_1 with (nolock) ON reg .x13_ind_cst_key_2 = co_customer_1.cst_key 
            LEFT OUTER JOIN co_individual				with (nolock) ON co_customer_1.cst_key = co_individual.ind_cst_key 
            LEFT OUTER JOIN co_individual_ext			with (nolock) ON co_individual.ind_cst_key = co_individual_ext.ind_cst_key_ext

			-- Registered CST_1 Key -- (Parent or Participant?) 
            LEFT OUTER JOIN co_customer AS co_customer_2 with (nolock) ON reg .x13_ind_cst_key_1 = co_customer_2.cst_key 
            LEFT OUTER JOIN co_individual	co_ind2			with (nolock) ON co_customer_2.cst_key = co_ind2.ind_cst_key 
            LEFT OUTER JOIN co_individual_ext co_ind_ext2	with (nolock) ON co_ind2.ind_cst_key = co_ind_ext2.ind_cst_key_ext

            
            -- normalize details data with top 1 from ...
   			JOIN invoice_detail_summary with (nolock) ON ac_invoice.inv_key = invoice_detail_summary.ivd_inv_key 

	WHERE 	
			-- date -- date range is mandatory !!!!
			-- reg.x13_add_date BETWEEN @start_date AND @end_date  
	
--			 ac_invoice.inv_cst_key in ( -- me and relations 			

			 ac_invoice.inv_cst_key IN (
				select fam.cxc_cst_key_1 as k from co_customer_x_customer fam where fam.cxc_cst_key_2 = @ind_cst_key
				UNION 
				select fam.cxc_cst_key_2 as k from co_customer_x_customer fam where fam.cxc_cst_key_1 = @ind_cst_key
				UNION 
				select @ind_cst_key as k ) 
				
order by x13_add_date 


			select * from co_customer_x_customer fam where fam.cxc_cst_key_2 = @ind_cst_key
			UNION 
			select * from co_customer_x_customer fam where fam.cxc_cst_key_1 = @ind_cst_key

				select fam.cxc_cst_key_1 as k from co_customer_x_customer fam where fam.cxc_cst_key_2 = @ind_cst_key
				UNION 
				select fam.cxc_cst_key_2 as k from co_customer_x_customer fam where fam.cxc_cst_key_1 = @ind_cst_key
				UNION 
				select @ind_cst_key as k 

/* 
			or 		
			 x13_ind_cst_key_2 IN (
				select fam.cxc_cst_key_1 as k from co_customer_x_customer fam where fam.cxc_cst_key_2 = @ind_cst_key
				UNION 
				select fam.cxc_cst_key_2 as k from co_customer_x_customer fam where fam.cxc_cst_key_1 = @ind_cst_key
				UNION 
				select @ind_cst_key as k ) 

*/



/*
select top 10 * from client_scouts_experimental_registration order by x13_add_date desc 
select * from co_customer where cst_key = '67A47EBC-918B-4CA6-A1FA-91E033FCADEE'
*/

