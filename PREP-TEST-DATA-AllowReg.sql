-- USED FOR AREA CODE T8N 3X3

-- TURN ON / OFF   on-line-registration for current year (2015) 

-- 2015 ->> 2017 to make offline 
-- 2016 ->> 2018 t0 make offline 

-- ALLOW THIS YEAR REG 
update  client_scouts_org_fee_x_date 
set a03_registration_year = '2015' where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2017'
select * from client_scouts_org_fee_x_date where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2015'


-- ALLOW NEXT YEAR REG 
update  client_scouts_org_fee_x_date 
set a03_registration_year = '2016' where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2018'
select * from client_scouts_org_fee_x_date where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2016'


-- NO ALLOW THIS YEAR REG 
update  client_scouts_org_fee_x_date 
set a03_registration_year = '2017' where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2015'
select * from client_scouts_org_fee_x_date where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2017'


-- NO ALLOW NEXT YEAR REG 
update  client_scouts_org_fee_x_date 
set a03_registration_year = '2018' where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2016'
select * from client_scouts_org_fee_x_date where a03_org_cst_key in (  '9B205478-4599-4632-A474-F806EAC5E429', '0BD1C9B0-04D2-4302-BC1D-E09E24C75D60', '42A18E8D-94FC-4057-9DD1-C34562B4BBDF', '2534EE25-65BA-45F7-95A4-433B476E3700') 
and a03_registration_year = '2018'

