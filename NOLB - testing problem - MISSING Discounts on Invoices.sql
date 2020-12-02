
select * from client_scouts_experimental_registration x where x.x13_add_date > '2015-08-25'
order by x13_add_date

select * from client_scouts_discount d where d.z80_experimental_registration_key in (select x13_key from client_scouts_experimental_registration x where x.x13_add_date > '2015-08-25') 

select * from client_scouts_discount d where d.z80_date_used > '2015-08-26'

select * from client_scouts_discount d 
	join client_scouts_experimental_registration x on d.z80_experimental_registration_key = x.x13_key 
	join ac_invoice inv on x.x13_inv_key = inv.inv_key
where d.z80_date_used > '2015-08-26'

INV CODES : 

319839 - 0/0 cancelled or voided 
319840 - 0/0 cancelled or voided 
319841 - NO DISCOUNT ON INVOICE !!!!
319842 - YES - discount is on ... 
319843 - YES - discount is on ...
319844 - NO - discount is not on ...







