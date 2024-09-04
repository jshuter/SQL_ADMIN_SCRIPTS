/* 
-------------------------------------------------------------------------------
-- NOLB problem - could not Cancel INV with NOLB 
select * from ac_invoice where inv_code = 438812
select * from ac_invoice_detail where ivd_inv_key = 'AC34077C-B0A5-42FD-8851-5E7D3B13E5DA'
/ * 
ivd_key									ivd_inv_key	ivd_type	ivd_qty	ivd_price	ivd_parity	ivd_ovr_key	ivd_price_override_reason	ivd_gla_dr_key	ivd_gla_cr_key	ivd_pjt_key	ivd_prc_key	ivd_prc_prd_key	ivd_prc_prd_ptp_key	ivd_backorder_flag	ivd_inventory_held_qty	ivd_process_qty	ivd_ship_qty	ivd_cst_ship_key	ivd_cxa_key	ivd_cst_key	ivd_account_number	ivd_ivw_key	ivd_src_key	ivd_close_flag	ivd_approve_date	ivd_approve_user	ivd_approve_flag	ivd_void_date	ivd_void_user	ivd_void_flag	ivd_ajd_key	ivd_notes	ivd_pak_prd_key	ivd_bun_prd_key	ivd_odd_key	ivd_ods_key	ivd_do_not_fulfill	ivd_backorder_email_sent_flag	ivd_download_count	ivd_add_user	ivd_add_date	ivd_change_user	ivd_change_date	ivd_delete_flag	ivd_entity_key	ivd_ship_flag_cp	ivd_amount_cp	ivd_parity_amount_cp
44B18424-7082-4382-A82E-12051D5DC4DD	AC34077C-B0A5-42FD-8851-5E7D3B13E5DA	discount	1.0000	160.00	1	NULL	NULL	B38B95F5-9890-40FC-A15B-60D790BA54D6	NULL	NULL	A4FBF6A0-06F8-4DDB-A5B4-32EBF389A736	E8B68A58-823B-494F-84BC-0A085B276513	52405A5C-6393-460D-BD35-2BBB2AA79E33	0	0.0000	0.0000	0.0000	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	0	NULL	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	RegistrationWizard	2016-09-16 15:26:22.567	PJohnsen	2016-09-16 15:27:33.000	0	NULL	0	160.00	160.00
* / 
begin transaction 
select * from ac_invoice_detail where ivd_key = '44B18424-7082-4382-A82E-12051D5DC4DD'
delete  from ac_invoice_detail where ivd_key = '44B18424-7082-4382-A82E-12051D5DC4DD'
select * from ac_invoice_detail where ivd_key = '44B18424-7082-4382-A82E-12051D5DC4DD'
-- commit 
----------------------------------------------------------------------------------
-- NOLB problem - could not Cancel INV with NOLB 
select * from ac_invoice where inv_code = 451632
select * from ac_invoice_detail where ivd_type = 'discount' and ivd_inv_key = '6D03FDD6-25C2-45EC-AED8-A44EAB787DFD'
/ * 
ivd_key									ivd_inv_key	ivd_type	ivd_qty	ivd_price	ivd_parity	ivd_ovr_key	ivd_price_override_reason	ivd_gla_dr_key	ivd_gla_cr_key	ivd_pjt_key	ivd_prc_key	ivd_prc_prd_key	ivd_prc_prd_ptp_key	ivd_backorder_flag	ivd_inventory_held_qty	ivd_process_qty	ivd_ship_qty	ivd_cst_ship_key	ivd_cxa_key	ivd_cst_key	ivd_account_number	ivd_ivw_key	ivd_src_key	ivd_close_flag	ivd_approve_date	ivd_approve_user	ivd_approve_flag	ivd_void_date	ivd_void_user	ivd_void_flag	ivd_ajd_key	ivd_notes	ivd_pak_prd_key	ivd_bun_prd_key	ivd_odd_key	ivd_ods_key	ivd_do_not_fulfill	ivd_backorder_email_sent_flag	ivd_download_count	ivd_add_user	ivd_add_date	ivd_change_user	ivd_change_date	ivd_delete_flag	ivd_entity_key	ivd_ship_flag_cp	ivd_amount_cp	ivd_parity_amount_cp
44B18424-7082-4382-A82E-12051D5DC4DD	AC34077C-B0A5-42FD-8851-5E7D3B13E5DA	discount	1.0000	160.00	1	NULL	NULL	B38B95F5-9890-40FC-A15B-60D790BA54D6	NULL	NULL	A4FBF6A0-06F8-4DDB-A5B4-32EBF389A736	E8B68A58-823B-494F-84BC-0A085B276513	52405A5C-6393-460D-BD35-2BBB2AA79E33	0	0.0000	0.0000	0.0000	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	0	NULL	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	RegistrationWizard	2016-09-16 15:26:22.567	PJohnsen	2016-09-16 15:27:33.000	0	NULL	0	160.00	160.00
* / 
begin transaction 
select * from ac_invoice_detail where ivd_key = 'A11770EC-662C-49FC-A44C-881600DB0B2E'
delete  from ac_invoice_detail where ivd_key = 'A11770EC-662C-49FC-A44C-881600DB0B2E'
select * from ac_invoice_detail where ivd_key = 'A11770EC-662C-49FC-A44C-881600DB0B2E'
-- commit 
/ * 
ivd_key									ivd_inv_key	ivd_type	ivd_qty	ivd_price	ivd_parity	ivd_ovr_key	ivd_price_override_reason	ivd_gla_dr_key	ivd_gla_cr_key	ivd_pjt_key	ivd_prc_key	ivd_prc_prd_key	ivd_prc_prd_ptp_key	ivd_backorder_flag	ivd_inventory_held_qty	ivd_process_qty	ivd_ship_qty	ivd_cst_ship_key	ivd_cxa_key	ivd_cst_key	ivd_account_number	ivd_ivw_key	ivd_src_key	ivd_close_flag	ivd_approve_date	ivd_approve_user	ivd_approve_flag	ivd_void_date	ivd_void_user	ivd_void_flag	ivd_ajd_key	ivd_notes	ivd_pak_prd_key	ivd_bun_prd_key	ivd_odd_key	ivd_ods_key	ivd_do_not_fulfill	ivd_backorder_email_sent_flag	ivd_download_count	ivd_add_user	ivd_add_date	ivd_change_user	ivd_change_date	ivd_delete_flag	ivd_entity_key	ivd_ship_flag_cp	ivd_amount_cp	ivd_parity_amount_cp
44B18424-7082-4382-A82E-12051D5DC4DD	AC34077C-B0A5-42FD-8851-5E7D3B13E5DA	discount	1.0000	160.00	1	NULL	NULL	B38B95F5-9890-40FC-A15B-60D790BA54D6	NULL	NULL	A4FBF6A0-06F8-4DDB-A5B4-32EBF389A736	E8B68A58-823B-494F-84BC-0A085B276513	52405A5C-6393-460D-BD35-2BBB2AA79E33	0	0.0000	0.0000	0.0000	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	0	NULL	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	RegistrationWizard	2016-09-16 15:26:22.567	PJohnsen	2016-09-16 15:27:33.000	0	NULL	0	160.00	160.00
* / 

*/ 


-------------------------------------------
--- START HERE 

begin transaction 

declare @k uniqueidentifier = NULL 

-- get key to delete
select @k = d.ivd_key from ac_invoice i join ac_invoice_detail d
on i.inv_key = d.ivd_inv_key
where d.ivd_type = 'discount' and i.inv_code = 459170 -- 456083 -- 450099 -- 448208

-- DELETE IFF key exists 

if @k is NULL begin 
	print 'NOTHING TO DELETE !!' 
	rollback 
end else begin 
	select * from ac_invoice_detail where ivd_key = @k 
	delete  from ac_invoice_detail where ivd_key = @k 
	select * from ac_invoice_detail where ivd_key = @k 
end 

-- commit 
-- rollback 
-- END HERE - manual commit !
