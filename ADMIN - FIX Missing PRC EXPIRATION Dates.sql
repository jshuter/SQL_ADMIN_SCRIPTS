BEGIN TRANSACTION 

select dateadd(YEAR,3,z25_completion_date), * from client_scouts_external_volunteer_screening
where	z25_status = 'Passed'
and		z25_expiration_date is null 
and		z25_type = 'PRC' 
order by z25_add_date

UPDATE client_scouts_external_volunteer_screening
set z25_expiration_date = dateadd(YEAR,3,z25_completion_date)
, z25_change_user = 'admin-fix'
, z25_change_date = getdate() 
where	z25_status = 'Passed'
and		z25_expiration_date is null 
and		z25_completion_date is not NULL 
and		z25_type = 'PRC' 

UPDATE client_scouts_external_volunteer_screening
set z25_expiration_date = dateadd(YEAR,3,z25_application_date)
, z25_change_user = 'admin-fix'
, z25_change_date = getdate() 
where	z25_status = 'Passed'
and		z25_expiration_date is null 
and		z25_application_date is not NULL 
and		z25_type = 'PRC' 

UPDATE client_scouts_external_volunteer_screening
set z25_expiration_date = dateadd(YEAR,3,z25_add_date)
, z25_change_user = 'admin-fix'
, z25_change_date = getdate() 
where	z25_status = 'Passed'
and		z25_expiration_date is null 
and		z25_add_date is not NULL 
and		z25_type = 'PRC' 

select dateadd(YEAR,3,z25_completion_date), * from client_scouts_external_volunteer_screening
where	z25_status = 'Passed'
and		z25_expiration_date is null 
and		z25_type = 'PRC' 
order by z25_add_date

-- ROLLBACK 
-- COMMIT 
/* 
select dateadd(YEAR,3,z25_completion_date), * from client_scouts_external_volunteer_screening
where	z25_change_user = 'admin-fix' 
order by z25_add_date
*/ 