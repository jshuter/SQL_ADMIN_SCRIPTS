-- select 'select ''' + table_name + ''', count(*) from ' + table_name from INFORMATION_SCHEMA.TABLES where TABLES.TABLE_NAME like 'CLIENT_SCOUTS%' 

-- part 1 
exec dbo._table_sizes

-- part 2
select 'ivd_price' as 'column-name', sum(ivd_price) as 'SUM' from ac_invoice_detail
union 
select 'cst_recno', SUM(cst_recno) from co_customer 
union 
select 'x13_delete_flag', SUM(x13_delete_flag) from client_scouts_experimental_registration
union 
select 'z03_delete_flag', SUM(z03_delete_flag) from client_scouts_course_catalogue_x_co_customer
union 
select 'z06_external_code', SUM(cast(z06_external_code as int)) from client_scouts_course_catalogue_x_external 
union 
select 'z80_discount_amount', SUM(cast (z80_discount_amount as float) ) from client_scouts_discount 
union 
select 'ixo_wasactive_flag_ext', SUM(ixo_wasactive_flag_ext) from co_individual_x_organization_ext


select 'client_scouts_1415mr_data_source', count(*) from client_scouts_1415mr_data_source
select 'client_scouts_course_catalogue_x_co_customer', count(*) from client_scouts_course_catalogue_x_co_customer
select 'client_scouts_member_account', count(*) from client_scouts_member_account
select 'client_scouts_generic_log', count(*) from client_scouts_generic_log
select 'client_scouts_experimental_registration', count(*) from client_scouts_experimental_registration
select 'client_scouts_online_transaction_error_log', count(*) from client_scouts_online_transaction_error_log
select 'client_scouts_online_user_exception_log', count(*) from client_scouts_online_user_exception_log
select 'client_scouts_mb_member_type_x_role', count(*) from client_scouts_mb_member_type_x_role
select 'client_scouts_organization_sub_type', count(*) from client_scouts_organization_sub_type
select 'client_scouts_compliance_tracking', count(*) from client_scouts_compliance_tracking
select 'client_scouts_course_catalogue', count(*) from client_scouts_course_catalogue
select 'client_scouts_course_catalogue_x_course_catalogue', count(*) from client_scouts_course_catalogue_x_course_catalogue
select 'client_scouts_recognition_list', count(*) from client_scouts_recognition_list
select 'client_scouts_role_x_reports', count(*) from client_scouts_role_x_reports
select 'client_scouts_contact_group_waitlist', count(*) from client_scouts_contact_group_waitlist
select 'client_scouts_individual_x_reference', count(*) from client_scouts_individual_x_reference
select 'client_scouts_coupons', count(*) from client_scouts_coupons
select 'client_scouts_volunteer_screening_reference', count(*) from client_scouts_volunteer_screening_reference
select 'client_scouts_discount', count(*) from client_scouts_discount
select 'client_scouts_discount_approval', count(*) from client_scouts_discount_approval
select 'client_scouts_volunteer_screening', count(*) from client_scouts_volunteer_screening
select 'client_scouts_discount_request', count(*) from client_scouts_discount_request
select 'client_scouts_discount_type', count(*) from client_scouts_discount_type
select 'client_scouts_program', count(*) from client_scouts_program
select 'client_scouts_emergency_contact_info', count(*) from client_scouts_emergency_contact_info
select 'client_scouts_activity', count(*) from client_scouts_activity
select 'client_scouts_activity_x_co_customer', count(*) from client_scouts_activity_x_co_customer
select 'client_scouts_equipment', count(*) from client_scouts_equipment
select 'client_scouts_individual_x_volunteer_program', count(*) from client_scouts_individual_x_volunteer_program
select 'client_scouts_equipment_x_co_customer', count(*) from client_scouts_equipment_x_co_customer
select 'client_scouts_service', count(*) from client_scouts_service
select 'client_scouts_service_x_co_customer', count(*) from client_scouts_service_x_co_customer
select 'client_scouts_rlt_x_rlt', count(*) from client_scouts_rlt_x_rlt
select 'client_scouts_approval_record', count(*) from client_scouts_approval_record
select 'client_scouts_role_x_execute_methods', count(*) from client_scouts_role_x_execute_methods
select 'client_scouts_role_x_forms', count(*) from client_scouts_role_x_forms
select 'client_scouts_org_merge_history', count(*) from client_scouts_org_merge_history
select 'client_scouts_police_records_check', count(*) from client_scouts_police_records_check
select 'client_scouts_participation_area', count(*) from client_scouts_participation_area
select 'client_scouts_recognition_list_x_co_customer', count(*) from client_scouts_recognition_list_x_co_customer
select 'client_scouts_member_registration', count(*) from client_scouts_member_registration
select 'client_scouts_code_of_conduct', count(*) from client_scouts_code_of_conduct
select 'client_scouts_code_of_conduct_x_co_individual', count(*) from client_scouts_code_of_conduct_x_co_individual
select 'client_scouts_security_information', count(*) from client_scouts_security_information
select 'client_scouts_co_individual_x_participation', count(*) from client_scouts_co_individual_x_participation
select 'client_scouts_org_fee_x_date', count(*) from client_scouts_org_fee_x_date
select 'client_scouts_external_volunteer_screening', count(*) from client_scouts_external_volunteer_screening
select 'client_scouts_postal_long_lat', count(*) from client_scouts_postal_long_lat
select 'client_scouts_course_catalogue_x_external', count(*) from client_scouts_course_catalogue_x_external
select 'co_customer', COUNT(*) from co_customer 
