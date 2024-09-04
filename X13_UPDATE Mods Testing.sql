select * from client_scouts_coupons  -- 
-- z83_key -> 8FC71CEB-8B77-4C5D-8618-18DC3CC3C8E9

-- client_scouts_online_transaction_error_log
-- z70 -- 9A8D0A94-6CC6-458B-9FA0-0005B467B5AD

update client_scouts_experimental_registration
set x13_inv_key = NULL 
where x13_key ='38E3A46E-CD48-48D2-B1C7-00001D321453'

select x13_z70_key from client_scouts_experimental_registration where x13_key ='38E3A46E-CD48-48D2-B1C7-00001D321453'

select * from client_scouts_online_transaction_error_log where z70_key  = '9A8D0A94-6CC6-458B-9FA0-0005B467B5AD'
-- COUPON is in z70 AUTH CODE -- when Paymnet made by coupon !!!!

exec client_scouts_experimental_registration_update '38E3A46E-CD48-48D2-B1C7-00001D321453', 'PaymentWithCoupon', '9A8D0A94-6CC6-458B-9FA0-0005B467B5AD'


select dbo.client_scouts_get_online_batch_key('32C17B5C-D2E4-4B93-AAB9-529640C9F343') 


----

declare @x uniqueidentifier = newid() 

exec client_scouts_create_online_batch @x, '','','32C17B5C-D2E4-4B93-AAB9-529640C9F343'

