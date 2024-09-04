
select * from client_scouts_course_catalogue_x_co_customer 
where z03_expiration_date = '2016-05-31'
and z03_add_date = '2016-05-31'

begin transaction 

update client_scouts_course_catalogue_x_co_customer 
set z03_expiration_date = NULL 
where z03_expiration_date = '2016-05-31'
and z03_add_date = '2016-05-31'

-- commit