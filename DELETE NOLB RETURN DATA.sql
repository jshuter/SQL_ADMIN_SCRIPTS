select * from ac_invoice where inv_code = 380119 
select * from ac_invoice_detail where ivd_inv_key = '0DF14F71-6FF6-4771-B77D-614F153862F1'


select * from ac_invoice_detail where ivd_key = '08D60BBD-B0BE-49B0-9C4F-EC31068377EF'
/* 
ivd_key                              ivd_inv_key                          ivd_type             ivd_qty                                 ivd_price             ivd_parity  ivd_ovr_key                          ivd_price_override_reason                                                                            ivd_gla_dr_key                       ivd_gla_cr_key                       ivd_pjt_key                          ivd_prc_key                          ivd_prc_prd_key                      ivd_prc_prd_ptp_key                  ivd_backorder_flag ivd_inventory_held_qty                  ivd_process_qty                         ivd_ship_qty                            ivd_cst_ship_key                     ivd_cxa_key                          ivd_cst_key                          ivd_account_number   ivd_ivw_key                          ivd_src_key                          ivd_close_flag ivd_approve_date        ivd_approve_user                                                 ivd_approve_flag ivd_void_date           ivd_void_user                                                    ivd_void_flag ivd_ajd_key                          ivd_notes                                                                                                                                                                                                                                                                                                    ivd_pak_prd_key                      ivd_bun_prd_key                      ivd_odd_key                          ivd_ods_key                          ivd_do_not_fulfill ivd_backorder_email_sent_flag ivd_download_count ivd_add_user                                                     ivd_add_date            ivd_change_user                                                  ivd_change_date         ivd_delete_flag ivd_entity_key                       ivd_ship_flag_cp ivd_amount_cp                           ivd_parity_amount_cp
------------------------------------ ------------------------------------ -------------------- --------------------------------------- --------------------- ----------- ------------------------------------ ---------------------------------------------------------------------------------------------------- ------------------------------------ ------------------------------------ ------------------------------------ ------------------------------------ ------------------------------------ ------------------------------------ ------------------ --------------------------------------- --------------------------------------- --------------------------------------- ------------------------------------ ------------------------------------ ------------------------------------ -------------------- ------------------------------------ ------------------------------------ -------------- ----------------------- ---------------------------------------------------------------- ---------------- ----------------------- ---------------------------------------------------------------- ------------- ------------------------------------ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ------------------------------------ ------------------------------------ ------------------------------------ ------------------------------------ ------------------ ----------------------------- ------------------ ---------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- ----------------------- --------------- ------------------------------------ ---------------- --------------------------------------- ---------------------------------------
08D60BBD-B0BE-49B0-9C4F-EC31068377EF 0DF14F71-6FF6-4771-B77D-614F153862F1 discount             1.0000                                  150.00                1           NULL                                 NULL                                                                                                 B38B95F5-9890-40FC-A15B-60D790BA54D6 NULL                                 NULL                                 A4FBF6A0-06F8-4DDB-A5B4-32EBF389A736 E8B68A58-823B-494F-84BC-0A085B276513 52405A5C-6393-460D-BD35-2BBB2AA79E33 0                  0.0000                                  0.0000                                  0.0000                                  NULL                                 NULL                                 NULL                                 NULL                 NULL                                 NULL                                 1              NULL                    NULL                                                             0                NULL                    NULL                                                             0             NULL                                 NULL                                                                                                                                                                                                                                                                                                         NULL                                 NULL                                 NULL                                 NULL                                 0                  NULL                          NULL               RegistrationWizard                                               2015-10-07 14:47:23.913 NULL                                                             NULL                    0               NULL                                 1                150.00                                  150.00
*/
begin transaction 
delete ac_invoice_detail where ivd_key = '08D60BBD-B0BE-49B0-9C4F-EC31068377EF'

-- commit 
-- rollback 

/*
Msg 547, Level 16, State 0, Line 2
The DELETE statement conflicted with the REFERENCE constraint "FK_ac_payment_detail_ac_invoice_detail". 
The conflict occurred in database "netFORUMSCOUTS", table "dbo.ac_payment_detail", column 'pyd_ivd_key'.
The statement has been terminated.

select * from ac_payment_detail p where p.pyd_ivd_key = '08D60BBD-B0BE-49B0-9C4F-EC31068377EF'

pyd_key                              pyd_pay_key                          pyd_ivd_key                          pyd_cdd_key                          pyd_type             pyd_amount            pyd_gla_dr_key                       pyd_gla_cr_key                       pyd_cc_held_status pyd_void_date           pyd_void_user                                                    pyd_void_flag pyd_ajd_key                          pyd_add_user                                                     pyd_add_date            pyd_change_user                                                  pyd_change_date         pyd_delete_flag pyd_entity_key
------------------------------------ ------------------------------------ ------------------------------------ ------------------------------------ -------------------- --------------------- ------------------------------------ ------------------------------------ ------------------ ----------------------- ---------------------------------------------------------------- ------------- ------------------------------------ ---------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- ----------------------- --------------- ------------------------------------
320287EB-149E-4268-8E16-3D8A95D553B4 B340AD75-D606-4703-BC53-168F6F21F3E0 08D60BBD-B0BE-49B0-9C4F-EC31068377EF NULL                                 return               150.00                NULL                                 NULL                                 0                  NULL                    NULL                                                             0             NULL                                 CorinnaMilan                                                     2015-12-16 12:05:52.000 NULL                                                             NULL                    0               NULL

(1 row(s) affected)

*/


begin transaction 
delete ac_payment_detail where pyd_ivd_key = '08D60BBD-B0BE-49B0-9C4F-EC31068377EF'
-- commit 
-- rollback 



/* 
Msg 547, Level 16, State 0, Line 2
The DELETE statement conflicted with the REFERENCE constraint 
"FK_ac_return_ac_invoice_detail1". The conflict occurred 
in database "netFORUMSCOUTS", table "dbo.ac_return".

ret_key                              ret_type   ret_code                                           ret_qty                                 ret_ivd_key                          ret_ivd_prc_prd_key                  ret_cst_key                          ret_add_user                                                     ret_add_date            ret_change_user                                                  ret_change_date         ret_delete_flag ret_entity_key
------------------------------------ ---------- -------------------------------------------------- --------------------------------------- ------------------------------------ ------------------------------------ ------------------------------------ ---------------------------------------------------------------- ----------------------- ---------------------------------------------------------------- ----------------------- --------------- ------------------------------------
F5444D58-78B6-49EF-A5BF-0FB980B02BDF cancel     25079                                              1.0000                                  08D60BBD-B0BE-49B0-9C4F-EC31068377EF E8B68A58-823B-494F-84BC-0A085B276513 589A47A5-3883-4B8E-8E72-627A3843F2D7 CorinnaMilan                                                     2015-12-16 12:05:51.000 NULL                                                             NULL                    1               NULL

*/


-- CANNOT DELETE invoice detail when RETURN exists !

select * from ac_return r where r.ret_ivd_key = '08D60BBD-B0BE-49B0-9C4F-EC31068377EF'

begin transaction 
delete ac_return where ret_ivd_key = '08D60BBD-B0BE-49B0-9C4F-EC31068377EF'
-- commit 
-- rollback 







select * from ac_refund r where r.ref_code = 13002 -- '08D60BBD-B0BE-49B0-9C4F-EC31068377EF'
select * from ac_refund_detail r where r.rfd_ref_key = 'F4E4BCE4-6BA3-43C0-981C-79E68E1F904D'
