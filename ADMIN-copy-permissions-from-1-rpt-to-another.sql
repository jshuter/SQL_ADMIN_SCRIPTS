/****** Script for SelectTopNRows command from SSMS  ******/

select COUNT(*) from client_scouts_role_x_reports

INSERT INTO client_scouts_role_x_reports (a36_key, a36_rlt_code, a36_report_name) 
SELECT 
	 NEWID() as a36_key 
     ,[a36_rlt_code]
     ,'LDS Batch Report' --'Section Capacity Report' 
FROM client_scouts_role_x_reports
where a36_report_name = 'Group Capacity Report'



--- 
select COUNT(*) from client_scouts_role_x_reports

SELECT * FROM client_scouts_role_x_reports where a36_report_name = 'Group Capacity Report'
SELECT * FROM client_scouts_role_x_reports where a36_report_name = 'Section Capacity Report'
SELECT * FROM client_scouts_role_x_reports where a36_report_name = 'LDS Batch Report'