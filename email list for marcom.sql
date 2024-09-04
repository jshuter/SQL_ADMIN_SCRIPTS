set transaction isolation level read uncommitted
;
WITH 
ALL_EMAILS as (
	SELECT  co_customer.cst_eml_address_dn,
		co_customer.cst_recno AS [Memb Number], 
		mb_member_type.mbt_code AS [Role Member Type], 
		co_individual_x_organization_ext.ixo_status_ext AS [Role Status], 
		co_individual_x_organization.ixo_rlt_code ,
		co_individual.ind_first_name,
		co_individual.ind_last_name,
		co_individual.ind_dob as DOB,
		co_individual_ext.ind_status_ext,
		co_organization.org_name, 
		client_scouts_organization_sub_type.a01_ogt_sub_type AS [Org Sub Type], 
		co_organization.org_ogt_code AS [Org type]
		
	FROM  	-- ORG 
			co_organization  
			INNER JOIN	co_organization_ext  		
				ON co_organization.org_cst_key = co_organization_ext.org_cst_key_ext 
				-- ORG TYPE 
				INNER JOIN	client_scouts_organization_sub_type  
					ON co_organization_ext.org_a01_key_ext = client_scouts_organization_sub_type.a01_key 
			-- IXO's 
			INNER JOIN	co_individual_x_organization  	
				ON co_organization.org_cst_key = co_individual_x_organization.ixo_org_cst_key
			INNER JOIN	co_individual_x_organization_ext	
				ON co_individual_x_organization_ext.ixo_key_ext = co_individual_x_organization.ixo_key
				-- MBT 
				INNER JOIN	mb_member_type ON co_individual_x_organization_ext.ixo_mbt_key_ext = mb_member_type.mbt_key 
			-- INDIVIDUAL 
			INNER JOIN	co_individual 		ON co_individual_x_organization.ixo_ind_cst_key = co_individual.ind_cst_key
			INNER JOIN	co_individual_ext 	ON co_individual.ind_cst_key = co_individual_ext.ind_cst_key_ext 
			INNER JOIN	co_customer   		ON co_customer.cst_key = co_individual.ind_cst_key 
										
	WHERE  
		co_individual_x_organization.ixo_delete_flag = 0
		AND co_individual.ind_delete_flag = 0
		AND (co_customer.cst_no_email_flag = 0 OR co_customer.cst_no_email_flag IS NULL) 
		AND (ind_suspended_flag_ext = 0 or ind_suspended_flag_ext is null)  
		AND (co_individual_x_organization_ext.ixo_status_ext = 'Active'
			OR co_individual_x_organization_ext.ixo_status_ext = 'Pending') 
)

select * from ALL_EMAILS E
	where E.ixo_rlt_code = 'Rover Scout Participant' and DOB < dateadd(YEAR, -13, getdate()) 
	
/* 
-- ALL_VOLUNTEERS2 AS ( 
	SELECT '3' as z, count(*) as c -- '2' as src, * 
	from ALL_EMAILS a WHERE a.[Role Member Type] = 'Volunteer' 
	and dob < dateadd(YEAR, -13, getdate()) -- 13 YEARS OLD 
), 
ALL_VENTURES2 as ( 
	SELECT '4' as z, count(*) as c -- top 10 '3' as src, * 
	from ALL_EMAILS a WHERE ixo_rlt_code = 'Venturer Scout'
	and dob < dateadd(YEAR, -13, getdate()) -- 13 YEARS OLD  
) 
*/

