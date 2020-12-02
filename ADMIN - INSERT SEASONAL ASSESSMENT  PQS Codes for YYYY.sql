BEGIN TRANSACTION 

-----------------------------------
--- REVIEW DATA HERE --- 
-----------------------------------

select top 4 * from client_scouts_recognition_list 
where z04_recognition_code like 'PQS%'
order by z04_recognition_code desc 

select top 1 * from client_scouts_recognition_list 
where z04_recognition_code like 'PQA%'
order by z04_recognition_code desc 

---------------------------------------------------
-- IF MISSING -- insert with the following 
---------------------------------------------------

declare @YYYY1 varchar(4) = '2018'
declare @YYYY2 varchar(4) = '2019'

insert into client_scouts_recognition_list (z04_key, z04_recognition_code, z04_recognition_name, z04_recognition_description, z04_org_ogt_code) 
Values(
	newid()
	, 'PQS-' + @YYYY2 + '-1'
	, 'Seasonal Assessment - FALL ' + @YYYY1 + '-' + @YYYY2
	, 'Seasonal Assessments (AS) and Program Quality Standards (PQS) for Fall ' + @YYYY1 
	, 'Council'
) 

insert into client_scouts_recognition_list (z04_key, z04_recognition_code, z04_recognition_name, z04_recognition_description, z04_org_ogt_code) 
Values(
	newid()
	, 'PQS-' + @YYYY2 + '-2'
	, 'Seasonal Assessment - WINTER ' + @YYYY1 + '-' + @YYYY2
	, 'Seasonal Assessments (AS) and Program Quality Standards (PQS) for Winter ' + @YYYY1 
	, 'Council'
) 

insert into client_scouts_recognition_list (z04_key, z04_recognition_code, z04_recognition_name, z04_recognition_description, z04_org_ogt_code) 
Values(
	newid()
	, 'PQS-' + @YYYY2 + '-3'
	, 'Seasonal Assessment - SPRING ' + @YYYY1 + '-' + @YYYY2
	, 'Seasonal Assessments (AS) and Program Quality Standards (PQS) for Spring ' + @YYYY2
	, 'Council'
) 

insert into client_scouts_recognition_list (z04_key, z04_recognition_code, z04_recognition_name, z04_recognition_description, z04_org_ogt_code) 
Values(
	newid()
	, 'PQS-' + @YYYY2 + '-4'
	, 'Seasonal Assessment - SUMMER ' + @YYYY1 + '-' + @YYYY2
	, 'Seasonal Assessments (AS) and Program Quality Standards (PQS) for Summer ' + @YYYY2
	, 'Council'
) 

insert into client_scouts_recognition_list (z04_key, z04_recognition_code, z04_recognition_name, z04_recognition_description, z04_org_ogt_code) 
Values(
	newid()
	, 'PQA' + right(@YYYY1,2) + right(@YYYY2,2) 
	, 'Program Quality Standard ' + @YYYY1 + '-' + @YYYY2
	, 'Outstanding Section Program Standards ' + @YYYY1 + '-' + @YYYY2
	, 'Council'
) 


select top 9 * from client_scouts_recognition_list 
where z04_recognition_code like 'PQS%'
order by z04_recognition_code desc 

select top 3 * from client_scouts_recognition_list 
where z04_recognition_code like 'PQA%'
order by z04_recognition_code desc 

-- commit 
-- rollback 
