

select * from co_email em where em.eml_address like 'jeff%'					-- 186	-- 1347 
select * from co_customer where cst_eml_address_dn like 'jeff%'				-- 189	-- 1351
select * from co_customer where cst_web_login like 'jeff%'				    -- 189	 -- 631
select * from client_scouts_member_account ma where ma.z11_email like 'jeff%'-- 97   -- 722

select COUNT(*) from co_email em where em.eml_address like 'john%'					 -- 2297 
select COUNT(*) from co_customer where cst_eml_address_dn like 'john%'				 -- 2303

select COUNT(*) from co_customer where cst_web_login like 'john%'				 --		1260
select COUNT(*) from client_scouts_member_account ma where ma.z11_email like 'john%' -- 1263

-- FIELD : CST_WEB_LOGIN 
		-- appears to be DEPRACATED - and NO LONGER USED !

select cst_eml_address_dn, cst_web_login , * 
 from co_customer 
 where (cst_eml_address_dn like 'john%'  or cst_web_login like 'john%') 
-- and cst_web_login IS NOT NULL 
-- and cst_eml_address_dn <> cst_web_login
 and cst_add_date > '2014-01-01'
