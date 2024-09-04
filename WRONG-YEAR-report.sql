-- 0- NOTE // LAST RUN ON AUG 7 2015 
-- RUN AGAIN ON AUG 31st 


--*************************************************************************
--Use this query for monthly invoice reports to Finance
--March 4, 2015
--****************************************************************************

/*
select cst_key, cst_recno, cst_web_login, cst_eml_address_dn, 
	cst_ind_full_name_dn, ext.ixo_status_ext st, x13_type,
	ixo.ixo_start_date sd, ixo.ixo_end_date, x13_source
	, x13_progress,ixo_rlt_code,ixo_add_user, x13_add_date --, *
from client_scouts_experimental_registration xr 
	join co_individual_x_organization ixo on xr.x13_ixo_key = ixo.ixo_key 
	join co_individual_x_organization_ext ext on ext.ixo_key_ext = xr.x13_ixo_key
	join co_customer cst on cst.cst_key = ixo.ixo_ind_cst_key

where xr.x13_add_date > '2015-05-22 00:00:00'
and x13_type='2016' and ixo_start_date < '2015-08-31 23:59:59'
and ixo_status_ext = 'Active'
*/

SELECT Distinct		 
                      co_customer_1.cst_recno AS RegisteredMemberNo,
                       co_individual.ind_first_name AS RegisteredMemberFirstName, 
                       co_individual.ind_last_name AS RegisteredMemberLastName,
 ixo.ixo_start_date	, ixo.ixo_end_date	, ixo.ixo_add_date, ext.ixo_status_ext
				
					,  ixo2016.ixo_start_date	, ixo2016.ixo_end_date	, ixo2016.ixo_add_date ,ext2016.ixo_status_ext
				
					, ac_batch.bat_code AS BatchNumber
					,         co_organization_3.org_name AS BatchOrg, 
                      ISNULL(CONVERT(nvarchar(50), ac_batch.bat_close_date, 101), 'Open') AS closed, 
                      co_organization_1.org_name AS RegisteredOrg, 
                      ac_invoice.inv_code_cp AS InvoiceNumber, 
                      ac_invoice.inv_trx_date AS InvoiceDate, 
                      NULL as 'Credit Code',
                      NULL as 'Refund Date',
                      NULL as 'Refund Number',
                      client_scouts_experimental_registration.x13_type AS RegistrationYear,
                          (SELECT     SUM(ac_invoice_detail.ivd_amount_cp) AS Expr1
                            FROM          ac_invoice_detail WITH (nolock) INNER JOIN
                                                   oe_price WITH (nolock) ON ac_invoice_detail.ivd_prc_key = oe_price.prc_key INNER JOIN
                                                   oe_price_ext WITH (nolock) ON oe_price.prc_key = oe_price_ext.prc_key_ext INNER JOIN
                                                   co_organization WITH (nolock) ON oe_price_ext.prc_org_cst_key_ext = co_organization.org_cst_key
                            WHERE      (co_organization.org_ogt_code = 'National') AND (ac_invoice_detail.ivd_inv_key = ac_invoice.inv_key) AND (ac_invoice_detail.ivd_void_flag = 0) AND 
                                                   (ac_invoice.inv_delete_flag = 0)) AS [National],
                          (SELECT     SUM(ac_invoice_detail_2.ivd_amount_cp) AS Expr1
                            FROM          ac_invoice_detail AS ac_invoice_detail_2 WITH (nolock) INNER JOIN
                                                   oe_price AS oe_price_2 WITH (nolock) ON ac_invoice_detail_2.ivd_prc_key = oe_price_2.prc_key INNER JOIN
                                                   oe_price_ext AS oe_price_ext_2 WITH (nolock) ON oe_price_2.prc_key = oe_price_ext_2.prc_key_ext INNER JOIN
                                                   co_organization AS co_organization_2 WITH (nolock) ON oe_price_ext_2.prc_org_cst_key_ext = co_organization_2.org_cst_key
                            WHERE      (co_organization_2.org_ogt_code = 'Council') AND (ac_invoice_detail_2.ivd_inv_key = ac_invoice.inv_key) AND (ac_invoice_detail_2.ivd_void_flag = 0) 
                                                   AND (ac_invoice.inv_delete_flag = 0)) AS Council,
                          (SELECT     SUM(ac_invoice_detail_1.ivd_amount_cp) AS Expr1
                            FROM          ac_invoice_detail AS ac_invoice_detail_1 WITH (nolock) INNER JOIN
                                                   oe_price AS oe_price_1 WITH (nolock) ON ac_invoice_detail_1.ivd_prc_key = oe_price_1.prc_key INNER JOIN
                                                   oe_price_ext AS oe_price_ext_1 WITH (nolock) ON oe_price_1.prc_key = oe_price_ext_1.prc_key_ext INNER JOIN
                                                   co_organization AS co_organization_1 WITH (nolock) ON oe_price_ext_1.prc_org_cst_key_ext = co_organization_1.org_cst_key
                            WHERE      (co_organization_1.org_ogt_code = 'Group') AND (ac_invoice_detail_1.ivd_inv_key = ac_invoice.inv_key) AND (ac_invoice_detail_1.ivd_void_flag = 0) 
                                                   AND (ac_invoice.inv_delete_flag = 0)) AS [Group], 
                        NULL as 'FeeTotal',
                        co_customer.cst_recno AS MemberInvoiced, 
                        co_individual_1.ind_first_name AS InvoiceFName, 
                      co_individual_1.ind_last_name AS InvoiceLName, 
                      --co_customer.cst_eml_address_dn AS EmailOfMemberInvoiced, 
 
                      co_individual_ext.ind_status_ext AS MemberStatusofRegisteredMember, 
                      mb_member_type.mbt_code AS RegisteredMemberType, 
                      
                      client_scouts_organization_sub_type.a01_ogt_sub_type AS RegisteredOrgSubType, 
                      --Regorgtype
                      client_scouts_experimental_registration.x13_source AS RegisteredSource,
                      client_scouts_experimental_registration.x13_progress AS RegistrationProgress, 
                      co_organization_3.org_ogt_code AS BatchOrgType, 
                      client_scouts_organization_sub_type_1.a01_ogt_sub_type AS BatchOrgSubType,
                      co_organization_ext_1.org_hierarchy_hash_ext AS BatchOrganizationHash, 
                      co_organization_ext.org_hierarchy_hash_ext AS RegisteredOrganizationHash,                       
                      co_organization_ext.org_hierarchy_friendly_ext AS RegisteredOrganizationFriendly, 
                                           
                      --client_scouts_experimental_registration.x13_add_user AS RegMethod, 
                      client_scouts_experimental_registration.x13_delete_flag AS [Registration Deleted],
                      client_scouts_experimental_registration.x13_change_user AS [Registration Change User],
                      client_scouts_experimental_registration.x13_change_date AS [Registration Change Date],
                      co_individual.ind_delete_flag as [Individualdeleted],
                      ac_invoice_detail_3.ivd_delete_flag,
                      ac_invoice_detail_3.ivd_void_flag,
                      ac_invoice_detail_3.ivd_void_date,
                      ac_invoice.inv_change_user
                     
                                            
FROM         co_customer WITH (nolock) LEFT OUTER JOIN
                      co_individual AS co_individual_1 WITH (nolock) ON co_customer.cst_key = co_individual_1.ind_cst_key 
                      
                      LEFT OUTER JOIN       client_scouts_organization_sub_type WITH (nolock) 
                      
                      RIGHT OUTER JOIN      co_organization_ext WITH (nolock) ON client_scouts_organization_sub_type.a01_key = co_organization_ext.org_a01_key_ext 
                      
                      RIGHT OUTER JOIN      co_organization AS co_organization_1 WITH (nolock) ON co_organization_ext.org_cst_key_ext = co_organization_1.org_cst_key 
                      
                      RIGHT OUTER JOIN	ac_batch WITH (nolock) 
                      
                      RIGHT OUTER JOIN	ac_invoice WITH (nolock) 
                      
                      LEFT OUTER JOIN	ac_invoice_detail AS ac_invoice_detail_3 WITH (nolock) ON ac_invoice.inv_key = ac_invoice_detail_3.ivd_inv_key 
                      
                      RIGHT OUTER JOIN	mb_member_type 
                      
                      INNER JOIN client_scouts_experimental_registration WITH (nolock) 
						ON mb_member_type.mbt_key = client_scouts_experimental_registration.x13_mbt_key 
						ON ac_invoice.inv_key = client_scouts_experimental_registration.x13_inv_key 
						ON ac_batch.bat_key = ac_invoice.inv_bat_key LEFT OUTER JOIN co_individual_ext WITH (nolock) 
                      
                       
                      RIGHT OUTER JOIN co_individual WITH (nolock) ON co_individual_ext.ind_cst_key_ext = co_individual.ind_cst_key 
                      
                      RIGHT OUTER JOIN co_customer AS co_customer_1 WITH (nolock) ON co_individual.ind_cst_key = co_customer_1.cst_key 
						ON client_scouts_experimental_registration.x13_ind_cst_key_2 = co_customer_1.cst_key 
						ON co_organization_1.org_cst_key = client_scouts_experimental_registration.x13_org_cst_key 
					  
					  RIGHT OUTER JOIN ac_batch_ext WITH (nolock) 
						ON ac_batch.bat_key = ac_batch_ext.bat_key_ext 
						ON co_customer.cst_key = ac_invoice.inv_cst_key 
						
						RIGHT OUTER JOIN
                      client_scouts_organization_sub_type AS client_scouts_organization_sub_type_1 WITH (nolock) 
                      
                      RIGHT OUTER JOIN   co_organization AS co_organization_3 WITH (nolock) 
                      
                      LEFT OUTER JOIN    co_organization_ext AS co_organization_ext_1 WITH (nolock) ON co_organization_3.org_cst_key = co_organization_ext_1.org_cst_key_ext
						 ON    client_scouts_organization_sub_type_1.a01_key = co_organization_ext_1.org_a01_key_ext 
						 ON    ac_batch_ext.bat_org_cst_key_ext = co_organization_3.org_cst_key
						 
						 
                        join co_individual_x_organization ixo on client_scouts_experimental_registration.x13_ixo_key = ixo.ixo_key 
						join co_individual_x_organization_ext ext on ext.ixo_key_ext = client_scouts_experimental_registration.x13_ixo_key
						
						left outer join co_individual_x_organization ixo2016 on ixo2016.ixo_ind_cst_key = co_customer.cst_key and ixo2016.ixo_start_date >= '2015-09-01' 
						left outer join co_individual_x_organization_ext ext2016 on ext2016.ixo_key_ext = ixo2016.ixo_key
						
WHERE 

--client_scouts_experimental_registration.x13_type = '2015'  
--(co_organization_ext.org_hierarchy_hash_ext NOT LIKE '-000010229O-000027472O%')   
--and 

client_scouts_experimental_registration.x13_type = '2016' 

and ixo.ixo_start_date < '2015-09-01'

and ac_invoice.inv_trx_date >=CONVERT(DATETIME, '2015-06-20 00:00:00', 102)
--AND (ac_invoice.inv_trx_date < CONVERT(DATETIME, '2015-06-02 00:00:00', 102)) 
      
and isnull(client_scouts_experimental_registration.x13_delete_flag,0) <> 1 

and ixo2016.ixo_key is NULL 

and ivd_void_flag = 0 

order by  co_customer.cst_recno, ixo.ixo_add_date