-- UPDATE STATEMENT -- 

begin transaction 

	-- SHOW ALL 
	select 		org_dues_prc_key_ext		, org_cst_key_ext		, prc_org_cst_key_ext
	from 
		oe_price (nolock) 
		join oe_price_ext pe on pe.prc_key_ext = prc_key
		join oe_product (nolock) on prd_key = prc_prd_key
		join co_organization_ext (nolock) on prc_key = org_dues_prc_key_ext 
		join co_organization (nolock) on org_cst_key = org_cst_key_ext
	where 
		org_status_ext = 'Active' 
		and org_ogt_code = 'Group'
-- 		and prc_org_cst_key_ext IS NULL 

	-- SHOW ONLY MISSING 
	
	select 		org_dues_prc_key_ext		, org_cst_key_ext		, prc_org_cst_key_ext
	from 
		oe_price (nolock) 
		join oe_price_ext pe on pe.prc_key_ext = prc_key
		join oe_product (nolock) on prd_key = prc_prd_key
		join co_organization_ext (nolock) on prc_key = org_dues_prc_key_ext 
		join co_organization (nolock) on org_cst_key = org_cst_key_ext
	where 
		org_status_ext = 'Active' 
		and org_ogt_code = 'Group'
 		and prc_org_cst_key_ext IS NULL 

	-- UPDATE MISSING DATA !!!
	
	UPDATE oe_price_ext 
	SET prc_org_cst_key_ext = org_dues_prc_key_ext
	from 
		oe_price (nolock) 
		join oe_price_ext pe on pe.prc_key_ext = prc_key
		join oe_product (nolock) on prd_key = prc_prd_key
		join co_organization_ext (nolock) on prc_key = org_dues_prc_key_ext 
		join co_organization (nolock) on org_cst_key = org_cst_key_ext
	where 
		org_status_ext = 'Active' 
		and org_ogt_code = 'Group'
 		and prc_org_cst_key_ext IS NULL 

	-- RESHOW AFTER FIX 
	
	select 		org_dues_prc_key_ext		, org_cst_key_ext		, prc_org_cst_key_ext
	from 
		oe_price (nolock) 
		join oe_price_ext pe on pe.prc_key_ext = prc_key
		join oe_product (nolock) on prd_key = prc_prd_key
		join co_organization_ext (nolock) on prc_key = org_dues_prc_key_ext 
		join co_organization (nolock) on org_cst_key = org_cst_key_ext
	where 
		org_status_ext = 'Active' 
		and org_ogt_code = 'Group'
-- 		and prc_org_cst_key_ext IS NULL 

	select 		org_dues_prc_key_ext		, org_cst_key_ext		, prc_org_cst_key_ext
	from 
		oe_price (nolock) 
		join oe_price_ext pe on pe.prc_key_ext = prc_key
		join oe_product (nolock) on prd_key = prc_prd_key
		join co_organization_ext (nolock) on prc_key = org_dues_prc_key_ext 
		join co_organization (nolock) on org_cst_key = org_cst_key_ext
	where 
		org_status_ext = 'Active' 
		and org_ogt_code = 'Group'
 		and prc_org_cst_key_ext IS NULL 


-- rollback 




/* 


-- >> list all reg -> invoices - where PRODUCT is linked to NULL ORG CODE 
SELECT  DISTINCT 
oe_price_ext_1.prc_org_cst_key_ext
,oe_price_ext_1.prc_key_ext

, org.org_ogt_code
, org.org_cst_key
, org.org_name
, prc_code, prc_display_name 
, orgext.org_hierarchy_hash_ext

FROM 
ac_invoice_detail AS ac_invoice_detail_1 WITH (nolock) 
JOIN AC_INVOICE ON inv_key = ac_invoice_detail_1.ivd_inv_key
join client_scouts_experimental_registration EXP on exp.x13_inv_key = ac_invoice.inv_key 
join co_organization org on exp.x13_org_cst_key = org.org_cst_key
join co_organization_ext orgext on orgext.org_cst_key_ext = org.org_cst_key
LEFT  outer JOIN  oe_price AS oe_price_1 WITH (nolock) ON ac_invoice_detail_1.ivd_prc_key = oe_price_1.prc_key 
LEFT  outer JOIN  oe_price_ext AS oe_price_ext_1 WITH (nolock) ON oe_price_1.prc_key = oe_price_ext_1.prc_key_ext                                               
WHERE      
x13_type = '2016' 

and ac_invoice_detail_1.ivd_type='Product'
AND (ac_invoice_detail_1.ivd_void_flag = 0) AND (ac_invoice.inv_delete_flag = 0)
AND (ac_invoice_detail_1.ivd_inv_key = ac_invoice.inv_key) 
and oe_price_ext_1.prc_org_cst_key_ext IS NULL 


-- LOOKUP Group KEY for Section 
SELECT distinct  prt.org_cst_key, PRT.ORG_NAME, cst.cst_recno
FROM co_organization  org
JOIN co_organization_ext EXT ON ORG.ORG_CST_KEY = EXT.org_cst_key_ext
JOIN co_organization_ext PRT_EXT ON PRT_EXT.org_hierarchy_hash_ext = LEFT( EXT.org_hierarchy_hash_ext, 44) 
JOIN co_organization prt ON prt.ORG_CST_KEY = prt_EXT.org_cst_key_ext
JOIN co_customer CST on cst_key = prt.org_cst_key 
WHERE ORG.org_ogt_code = 'SECTION' AND PRT.org_ogt_code = 'Group'
AND EXT.org_status_ext = 'active' 
and prt_ext.org_status_ext = 'active'
order by prt.org_name 

--- fix






SELECT org2.org_cst_key,  prt.org_cst_key, 	PRT.org_ogt_code, 	PRT.ORG_NAME 
FROM  co_organization  org2
JOIN co_organization_ext EXT ON ORG2.ORG_CST_KEY = EXT.org_cst_key_ext
JOIN co_organization_ext PRT_EXT ON PRT_EXT.org_hierarchy_hash_ext = LEFT( EXT.org_hierarchy_hash_ext, 44) 
JOIN co_organization prt ON prt.ORG_CST_KEY = prt_EXT.org_cst_key_ext
WHERE 
 ORG2.org_ogt_code = 'SECTION' AND PRT.org_ogt_code = 'Group'
AND EXT.org_status_ext = 'active'
and prt_ext.org_status_ext  = 'Active' 
and 
ORG2.org_cst_key in (
SELECT  DISTINCT  org.org_cst_key
FROM 
ac_invoice_detail AS ac_invoice_detail_1 WITH (nolock) 
JOIN AC_INVOICE ON inv_key = ac_invoice_detail_1.ivd_inv_key
join client_scouts_experimental_registration EXP on exp.x13_inv_key = ac_invoice.inv_key 
join co_organization org on exp.x13_org_cst_key = org.org_cst_key
join co_organization_ext orgext on orgext.org_cst_key_ext = org.org_cst_key
LEFT outer JOIN   oe_price AS oe_price_1 WITH (nolock) ON ac_invoice_detail_1.ivd_prc_key = oe_price_1.prc_key 
LEFT outer  JOIN   oe_price_ext AS oe_price_ext_1 WITH (nolock) ON oe_price_1.prc_key = oe_price_ext_1.prc_key_ext                                               
LEFT  outer JOIN  co_organization AS co_organization_1 WITH (nolock) ON oe_price_ext_1.prc_org_cst_key_ext = co_organization_1.org_cst_key
WHERE      
x13_type = '2016' 
and ac_invoice_detail_1.ivd_type='Product'
AND (ac_invoice_detail_1.ivd_void_flag = 0) 
AND (ac_invoice.inv_delete_flag = 0)
AND (ac_invoice_detail_1.ivd_inv_key = ac_invoice.inv_key) 
and co_organization_1.org_ogt_code IS NULL 
) 










---- 


SELECT  DISTINCT 
prt.org_cst_key, PRT.ORG_NAME, cst.cst_recno,
prc_code, oe_price_ext_1.prc_org_cst_key_ext
,oe_price_ext_1.prc_key_ext
, org.org_ogt_code
, org.org_cst_key
, org.org_name
, prc_display_name 
, orgext.org_hierarchy_hash_ext

FROM 
ac_invoice_detail AS ac_invoice_detail_1 WITH (nolock) 
JOIN AC_INVOICE ON inv_key = ac_invoice_detail_1.ivd_inv_key
join client_scouts_experimental_registration EXP on exp.x13_inv_key = ac_invoice.inv_key 
join co_organization org on exp.x13_org_cst_key = org.org_cst_key
join co_organization_ext orgext on orgext.org_cst_key_ext = org.org_cst_key
LEFT  outer JOIN  oe_price AS oe_price_1 WITH (nolock) ON ac_invoice_detail_1.ivd_prc_key = oe_price_1.prc_key 
LEFT  outer JOIN  oe_price_ext AS oe_price_ext_1 WITH (nolock) ON oe_price_1.prc_key = oe_price_ext_1.prc_key_ext                                               
---
JOIN co_organization_ext EXT ON ORG.ORG_CST_KEY = EXT.org_cst_key_ext
JOIN co_organization_ext PRT_EXT ON PRT_EXT.org_hierarchy_hash_ext = LEFT( EXT.org_hierarchy_hash_ext, 44) 
JOIN co_organization prt ON prt.ORG_CST_KEY = prt_EXT.org_cst_key_ext
JOIN co_customer CST on cst_key = prt.org_cst_key 

WHERE      
x13_type = '2016' 

and ac_invoice_detail_1.ivd_type='Product'
AND (ac_invoice_detail_1.ivd_void_flag = 0) AND (ac_invoice.inv_delete_flag = 0)
AND (ac_invoice_detail_1.ivd_inv_key = ac_invoice.inv_key) 
and oe_price_ext_1.prc_org_cst_key_ext IS NULL 


AND ORG.org_ogt_code = 'SECTION' 
AND PRT.org_ogt_code = 'Group'
AND EXT.org_status_ext = 'active' 
and prt_ext.org_status_ext = 'active'

order by prt.org_name 


-------------

select * from oe_price_ext          -- 2868 
join oe_price on prc_key = prc_key_ext
join oe_price_x_ac_gl_account
where prc_org_cst_key_ext IS NULL   -- 299 ROWS 


------




	select 		org_cst_key_ext,		prc_key ,		prc_prd_key,		prc_prd_ptp_key,		price = 0.00,		prc_ptr_key,
		prd_atc_key,		prd_code,		prd_ptp_key,		prc_gla_ar_key,		prc_gla_revenue_key,		
		--org_type = case when org_cst_key_ext = @group_org_cst_key then 'Group'					when org_cst_key_ext = @council_org_cst_key then 'Council'					else 'National' end,
		price_okay = 0


	select 
		org_dues_prc_key_ext
		, org_cst_key_ext
		, prc_org_cst_key_ext
--		oe_product.* -- SCOUTS DUES -- 1 product 
--		oe_price.*   -- EACH GROUP has a price 

	from 
		oe_price (nolock) 
		join oe_price_ext pe on pe.prc_key_ext = prc_key
		join oe_product (nolock) on prd_key = prc_prd_key
		join co_organization_ext (nolock) on prc_key = org_dues_prc_key_ext 
		join co_organization (nolock) on org_cst_key = org_cst_key_ext

	where 
		--org_cst_key_ext in ('A613C68C-FED0-4D99-9BD0-4FA8C9B80043')
		--and 
		org_status_ext = 'Active' 
		and org_ogt_code = 'Group'
		
		and prc_org_cst_key_ext IS NULL 
		
		
		
A613C68C-FED0-4D99-9BD0-4FA8C9B80043 -- grp 
559B3D3B-2FCB-4849-8D1E-1C2A8D170265 -- section 

*/