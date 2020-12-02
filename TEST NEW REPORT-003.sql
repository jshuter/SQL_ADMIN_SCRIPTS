--*************************************************************************
--Use this query for monthly invoice reports to Finance
--March 4, 2015
--****************************************************************************
/* 
VERSION 003 removed INVOICE DETAILS from the join - get data in sub query !!!!
  2,501 - ORG KEYS DO NOT MATCH ORG of IXO !
169,047 - ORGS DO MATCH 
*/

set transaction isolation level read uncommitted ; 

with invoice_detail_summary as (
	select 
	  ivd_inv_key,
	  case when MAX(d.ivd_delete_flag) = MIN(d.ivd_delete_flag) 
		then 'OK'
		else 'MIXED'
	  end as same, 
	  max(isnull(d.ivd_delete_flag,0)) as invoice_detail_deleted, 
	  max(isnull(d.ivd_void_flag,0)) as invoice_detail_voided, 
		max(d.ivd_void_date) as invoice_detail_void_date
	from ac_invoice_detail d 
	group by ivd_inv_key
) 

SELECT --DISTINCT 

		co_customer_1.cst_recno AS RegisteredMemberNo, 
		co_individual.ind_first_name AS RegisteredMemberFirstName, 
		co_individual.ind_last_name AS RegisteredMemberLastName, 
		co_individual_ext.ind_status_ext AS MemberStatusofRegisteredMember, 
		mbt.mbt_code AS RegisteredMemberType, 
		batch_org.org_name AS BatchOrg, 
		ac_invoice.inv_code AS InvoiceNumber, 
		ac_invoice.inv_trx_date AS InvoiceDate, 
		batch.bat_code AS BatchNumber, 
		ISNULL(CONVERT(nvarchar(50), batch.bat_close_date, 101), 'Open') AS closed, 
		org.org_name AS RegisteredOrg, 

		-- NULL AS 'Credit Code', 
		-- NULL AS 'Refund Date', 
		-- NULL AS 'Refund Number', 

		reg.x13_type AS RegistrationYear,
		
		(SELECT     SUM(ac_invoice_detail.ivd_amount_cp) AS Expr1
			FROM          ac_invoice_detail INNER JOIN
						   oe_price ON ac_invoice_detail.ivd_prc_key = oe_price.prc_key INNER JOIN
						   oe_price_ext ON oe_price.prc_key = oe_price_ext.prc_key_ext INNER JOIN
						   co_organization ON oe_price_ext.prc_org_cst_key_ext = co_organization.org_cst_key
			WHERE      (co_organization.org_ogt_code = 'National') 
						AND (ac_invoice_detail.ivd_inv_key = ac_invoice.inv_key) 
						AND (ac_invoice_detail.ivd_void_flag = 0) AND 
						   (ac_invoice.inv_delete_flag = 0)) AS [National],
		--
		(SELECT     sub_inv_detail.ivd_price
			FROM		ac_invoice AS sub_inv 
						LEFT JOIN ac_invoice_detail AS sub_inv_detail ON sub_inv.inv_key = sub_inv_detail.ivd_inv_key
			WHERE	(sub_inv_detail.ivd_type = N'discount') 
						AND (sub_inv_detail.ivd_inv_key = ac_invoice.inv_key) 
						AND (sub_inv.inv_delete_flag = 0)) 
			AS [DISCOUNT], 
			
		--			
  		  (SELECT     SUM(ac_invoice_detail_2.ivd_amount_cp) AS Expr1
			FROM	ac_invoice_detail AS ac_invoice_detail_2 
						INNER JOIN oe_price AS oe_price_2 ON ac_invoice_detail_2.ivd_prc_key = oe_price_2.prc_key 
						INNER JOIN oe_price_ext AS oe_price_ext_2 ON oe_price_2.prc_key = oe_price_ext_2.prc_key_ext 
						INNER JOIN  co_organization AS co_organization_2 ON oe_price_ext_2.prc_org_cst_key_ext = co_organization_2.org_cst_key
			WHERE	(co_organization_2.org_ogt_code = 'Council') 
						AND (ac_invoice_detail_2.ivd_inv_key = ac_invoice.inv_key) 
						AND (ac_invoice_detail_2.ivd_void_flag = 0) 
						AND (ac_invoice.inv_delete_flag = 0)) 
		AS [Council],

		--
		(SELECT SUM(ac_invoice_detail_1.ivd_amount_cp) AS Expr1
			FROM          ac_invoice_detail AS ac_invoice_detail_1 INNER JOIN
						   oe_price AS oe_price_1 ON ac_invoice_detail_1.ivd_prc_key = oe_price_1.prc_key INNER JOIN
						   oe_price_ext AS oe_price_ext_1 ON oe_price_1.prc_key = oe_price_ext_1.prc_key_ext INNER JOIN
						   co_organization AS org ON oe_price_ext_1.prc_org_cst_key_ext = org.org_cst_key
			WHERE      (org.org_ogt_code = 'Group') 
						AND (ac_invoice_detail_1.ivd_inv_key = ac_invoice.inv_key) 
						AND (ac_invoice_detail_1.ivd_void_flag = 0) 
						AND (ac_invoice.inv_delete_flag = 0)) 
		AS [Group],
			
		NULL AS 'FeeTotal', co_customer.cst_recno AS MemberInvoiced, 
		  
		co_individual_1.ind_first_name AS InvoiceFName, co_individual_1.ind_last_name AS InvoiceLName, 
		org_subtype.a01_ogt_sub_type AS RegisteredOrgSubType,
		reg.x13_source AS RegisteredSource, 
		reg.x13_progress AS RegistrationProgress, 
		batch_org.org_ogt_code AS BatchOrgType, 
		batch_org_subtype.a01_ogt_sub_type AS BatchOrgSubType, 
		batch_org_ext.org_hierarchy_hash_ext AS BatchOrganizationHash, 
		org_ext.org_hierarchy_hash_ext AS RegisteredOrganizationHash,
		org_ext.org_hierarchy_friendly_ext AS RegisteredOrganizationFriendly, 
		reg.x13_delete_flag AS [Registration Deleted], 
		reg.x13_change_user AS [Registration Change User], 
		reg.x13_change_date AS [Registration Change Date], 
		co_individual.ind_delete_flag AS Individualdeleted, 
		       
		ac_invoice.inv_change_user,

		invoice_detail_summary.invoice_detail_voided, 
		invoice_detail_summary.invoice_detail_deleted,
		invoice_detail_summary.invoice_detail_void_date,
		invoice_detail_summary.same

FROM    client_scouts_experimental_registration reg 

			-- Member type 
			INNER JOIN mb_member_type mbt ON mbt.mbt_key = reg.x13_mbt_key  

			-- Invoice Info 			
			INNER JOIN ac_invoice ON reg.x13_inv_key = ac_invoice.inv_key 
			INNER JOIN co_customer ON co_customer.cst_key = ac_invoice.inv_cst_key 
			INNER JOIN co_individual AS co_individual_1 ON co_customer.cst_key = co_individual_1.ind_cst_key 

			-- Batch Group Info 
			INNER JOIN ac_batch Batch ON ac_invoice.inv_bat_key = Batch.bat_key 
            INNER JOIN ac_batch_ext BE on BE.bat_key_ext = Batch.bat_key 
            INNER JOIN co_organization AS batch_org ON be.bat_org_cst_key_ext = batch_org.org_cst_key 
            INNER JOIN co_organization_ext AS batch_org_ext ON batch_org.org_cst_key = batch_org_ext.org_cst_key_ext 
            INNER JOIN client_scouts_organization_sub_type AS batch_org_subtype ON batch_org_ext.org_a01_key_ext = batch_org_subtype.a01_key 
			
			-- Registered Group Info 
			INNER JOIN co_organization AS org ON reg.x13_org_cst_key = org.org_cst_key 
            INNER JOIN co_organization_ext org_ext ON org.org_cst_key = org_ext.org_cst_key_ext 
			INNER JOIN client_scouts_organization_sub_type org_subtype ON  org_subtype.a01_key = org_ext.org_a01_key_ext 
            			
			-- Registered CST_2 Key -- (Parent or Participant?) 
            INNER JOIN co_customer AS co_customer_1 ON reg .x13_ind_cst_key_2 = co_customer_1.cst_key 
            INNER JOIN co_individual ON co_customer_1.cst_key = co_individual.ind_cst_key 
            INNER JOIN co_individual_ext ON co_individual.ind_cst_key = co_individual_ext.ind_cst_key_ext
            
   			INNER JOIN invoice_detail_summary ON ac_invoice.inv_key = invoice_detail_summary.ivd_inv_key 

WHERE     (ac_invoice.inv_trx_date >= CONVERT(DATETIME, '2015-02-01 00:00:00', 102)) AND (ac_invoice.inv_trx_date < CONVERT(DATETIME, '2015-02-05 00:00:00', 102))

order by inv_code