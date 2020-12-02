
DECLARE @STATUS INT 

exec @STATUS = [client_scouts_invoice_purge] '29A00201-8336-410C-8FAB-8F2F177750BE',10000
SELECT @STATUS
exec [client_scouts_invoice_purge] '6272C24B-A0C3-4304-8490-B6764DDD3EB1', 11
exec [client_scouts_invoice_purge] '37F4CEB9-3A2C-4652-84C0-C8F3B4F34F1D', 15
exec [client_scouts_invoice_purge] 'FF787A3B-588E-4C14-8B59-DD33ADDA37E5', 15
exec [client_scouts_invoice_purge] 'BCFB0079-0DA6-4B1D-9BD0-F6EF25BD0D48', 15


select top 10  * from client_scouts_generic_log order by z77_add_date desc 
select * from client_scouts_experimental_registration where x13_key = '6272C24B-A0C3-4304-8490-B6764DDD3EB1'
exec client_scouts_experimental_registration_update '6272C24B-A0C3-4304-8490-B6764DDD3EB1','PaymentWithDiscount','6272C24B-A0C3-4304-8490-B6764DDD3EB1',15
select * from client_scouts_experimental_registration where x13_key = '6272C24B-A0C3-4304-8490-B6764DDD3EB1'
select top 10  * from client_scouts_generic_log order by z77_add_date desc 


/*

SELECT * FROM ac_payment_detail PYD 
		JOIN ac_invoice_detail IVD ON PYD.pyd_ivd_key = IVD.ivd_key
		WHERE IVD.ivd_inv_key = @INV_KEY  




	exec [client_scouts_invoice_purge] '29A00201-8336-410C-8FAB-8F2F177750BE',10000,1
	exec [client_scouts_invoice_purge] '6272C24B-A0C3-4304-8490-B6764DDD3EB1', 10000, 1
	exec [client_scouts_invoice_purge] '37F4CEB9-3A2C-4652-84C0-C8F3B4F34F1D', 10000, 1
	exec [client_scouts_invoice_purge] 'FF787A3B-588E-4C14-8B59-DD33ADDA37E5', 10000, 1
	exec [client_scouts_invoice_purge] 'BCFB0079-0DA6-4B1D-9BD0-F6EF25BD0D48', 10000, 1
	
	The DELETE statement conflicted with the REFERENCE constraint 
	"FK_ac_payment_detail_ac_invoice_detail". 
	The conflict occurred in database "netForumSCOUTSTest", 
	table "dbo.ac_payment_detail", column 'pyd_ivd_key'.
	
	
*/



