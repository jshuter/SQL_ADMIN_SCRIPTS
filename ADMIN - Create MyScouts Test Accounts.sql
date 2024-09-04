

begin transaction 

-- rollback 

declare @email_addr varchar(50) = 'jeffrey.shuterx@scouts.ca' -- 'jshuter@teradocs.com'
declare @first_name as varchar(20) = 'first name' 
declare @last_name as varchar(20) = 'last name'
declare @new_rlt_code as varchar(20) = 'Colony Scouter' 

declare @age int = 15 
declare @ind_dob date = dateadd(YEAR,@age * -1,getdate()) 

declare @mbt_code varchar(20) = 'Volunteer' -- OR 'Participant' 

declare @mbt_key uniqueidentifier = (select mbt_key from mb_member_type where mbt_code = @mbt_code) 

declare @start_date varchar(50) = '2017-09-01'
declare @end_date varchar(50) = '2018-08-31'

declare @org_cst_key uniqueidentifier = (select org_cst_key from co_organization where org_name = '1st expedition colony') 

----------------------

declare @new_cst_key uniqueidentifier = newid() 
declare @new_cxa_key uniqueidentifier = newid() 
declare @new_adr_key uniqueidentifier = newid() 
declare @new_ixo_key uniqueidentifier = newid() 
declare @new_eml_key uniqueidentifier = newid() 
declare @new_x13_key uniqueidentifier = newid() 

--------------------------------------------------------------
-- insure email is not yet in use 
--------------------------------------------------------------

declare @email_test varchar(100)  
declare @new_cst_recno int 
declare @msg varchar(100) 

select @email_test = z11_email from client_scouts_member_account where z11_email = @email_addr

if @email_test IS NOT NULL begin
	select 'ERROR: Customer with ''' + @email_addr + ''' does not exist and cannot be clone.'
	return 	
end else begin 
	select 'OK - Building new account ...' 
end  

--------------------------------------------------------------------
--1. CREATE THE CO_CUSTOMER
--------------------------------------------------------------------

insert co_customer (cst_type, cst_sort_name_dn, cst_ind_full_name_dn, cst_eml_address_dn) values ('Individual',@first_name, @last_name, @email_addr) 

	select @new_cst_recno = @@identity 
	select @new_cst_key = cst_key from co_customer where cst_recno = @new_cst_recno  

	select 'Processing for new user: key => ', @new_cst_key 

insert co_customer_ext (cst_key_ext,cst_evening_phone_ext) values(@new_cst_key, '(111) 222-3333') 

	select cst_key, cst_type,cst_name_cp,cst_sort_name_dn,cst_ind_full_name_dn,cst_eml_address_dn,cst_recno,cst_id,cst_salutation_1,cst_default_recognize_as
	from co_customer where cst_recno = @new_cst_recno  

	select * from co_customer_ext where cst_key_ext = @new_cst_key 

--------------------------------------------------------------------
--1. CREATE THE CO_INDIVIDUAL 
--------------------------------------------------------------------

insert into co_individual(ind_cst_key, ind_first_name, ind_last_name,ind_dob, ind_gender) values(@new_cst_key,@first_name,@last_name, @ind_dob ,'Male') 

insert into co_individual_ext(ind_cst_key_ext,ind_status_ext,ind_rlt_code_ext,ind_mbt_code_ext) values(@new_cst_key,'Active', @new_rlt_code, @mbt_code) 
    
--------------------------------------------------------------------
--1. CREATE THE CO_EMAIL 
--------------------------------------------------------------------

insert into co_email(eml_key, eml_address, eml_cst_key) values(@new_eml_key, @email_addr, @new_cst_key)

--------------------------------------------------------------------
--1. CREATE THE IXO 
--------------------------------------------------------------------

insert co_individual_x_organization (ixo_key,ixo_ind_cst_key,ixo_org_cst_key ,ixo_rlt_code ,ixo_start_date ,ixo_end_date) values (@new_ixo_key, @new_cst_key, @org_cst_key, @new_rlt_code, @start_date, @end_date)
insert co_individual_x_organization_ext (ixo_key_ext,ixo_status_ext,ixo_mbt_key_ext) values (@new_ixo_key,'Active',@mbt_key) 

--------------------------------------------------------------------
--1. CREATE THE CO_ADDRESS
--------------------------------------------------------------------
	
insert co_address (adr_key) values(@new_adr_key) 
insert co_address_ext (adr_key_ext) values(@new_adr_key) 
	
insert co_customer_x_address (cxa_key,cxa_cst_key,cxa_adr_key ) values(@new_cxa_key, @new_cst_key, @new_adr_key) 
insert co_customer_x_address_ext (cxa_key_ext) values(@new_cxa_key) 


------------------------------------------------
-- make member accoutn for user 
------------------------------------------------


    Insert into client_scouts_member_account (z11_ind_cst_key, z11_email, z11_password, z11_add_date, z11_add_user, z11_memberfuse_flag)
	select ind_cst_key,
			cst_eml_address_dn,
			isnull(cst_web_password,'c9495877f587418e8361c4d8a9817e9c'), -- scouts123
			getdate() as todaysdate,
			'sys admin' as adduser,
			0 as thisflag
  
	 FROM (co_individual(nolock) 
			inner join co_individual_ext(nolock) on ind_cst_key = ind_cst_key_ext) 
			inner join co_customer(nolock) on ind_cst_key = cst_key
	 Where 
			[ind_age_cp] > 14 
			and cst_eml_address_dn IS NOT NULL
			and ind_cst_key = @new_cst_key
  
	
-------------------------------------
--Set foriegn keys 
-------------------------------------

update co_individual set ind_ixo_key = @new_ixo_key	where ind_cst_key = @new_cst_key
update co_customer set cst_ixo_key = @new_ixo_key where cst_key = @new_cst_key
update co_customer set cst_eml_key = @new_eml_key where cst_key = @new_cst_key

-- commit
--C3AA782B-DF09-4B92-9796-06649381C781

declare @key1 uniqueidentifier = @new_cst_key

declare @key2 uniqueidentifier = '3999E32D-2DC0-4BAB-B94C-A8E514A9113D' -- me 

select * from co_customer where cst_key = @key1
select * from co_customer where cst_key = @key2

select * from co_customer_ext where cst_key_ext = @key1 
select * from co_customer_ext where cst_key_ext = @key2 

select * from  co_individual where ind_cst_key = @key1 
select * from  co_individual where ind_cst_key = @key2

select * from co_individual_ext where ind_cst_key_ext = @key1 
select * from co_individual_ext where ind_cst_key_ext = @key2

select * from  co_email where eml_cst_key = @key1  
select * from  co_email where eml_cst_key = @key2  

select * from  co_individual_x_organization join  co_individual_x_organization_ext on ixo_key = ixo_key_ext where ixo_ind_cst_key = @key1
select * from  co_individual_x_organization join  co_individual_x_organization_ext on ixo_key = ixo_key_ext where ixo_ind_cst_key = @key2 

select * from  co_address join co_address_ext on adr_key = adr_key_ext where adr_cst_key_owner = @key1 
select * from  co_address join co_address_ext on adr_key = adr_key_ext where adr_cst_key_owner = @key2

select * from  co_customer_x_address join co_customer_x_address_ext on cxa_key = cxa_key_ext where cxa_cst_key = @key1 
select * from  co_customer_x_address join co_customer_x_address_ext on cxa_key = cxa_key_ext where cxa_cst_key = @key2 

select * from client_scouts_member_account where z11_ind_cst_key = @key1 
select * from client_scouts_member_account where z11_ind_cst_key = @key2 

--commit 

select * from co_customer where cst_eml_address_dn like 'myscouts%' 
select * from client_scouts_member_account where z11_email like 'myscouts%'