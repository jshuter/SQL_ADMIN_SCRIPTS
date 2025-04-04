select *  from 
co_individual_ext join co_customer on cst_key = ind_cst_key_ext 
	join co_individual_x_organization  on ixo_key = cst_ixo_key 
	join co_individual_x_organization_ext  on ixo_key_ext = ixo_key
where co_customer.cst_recno = 10204489

select 
	CASE when ext.ixo_key_ext = ixo2.ixo_key_ext
		THEN 'YES'	END		as 'PRIMARY',
	ext.* , ixo.ixo_start_date , c.cst_ixo_key   -- , ixo2.*
	FROM co_customer c 
		join co_individual_x_organization IXO on IXO.IXO_ind_CST_KEY = c.CST_KEY 
		join co_individual_x_organization_ext ext  on ext.ixo_key_ext = ixo.ixo_key
		join co_individual_x_organization_ext ixo2 on c.cst_ixo_key = ixo2.ixo_key_ext 
where C.cst_recno = 10204489 
order by ixo_add_date-- ixo_start_date 

-- fix STATUS OF IND 'Active', 'Pending', or 'Inactive' .... updates to reflect the primary role 
-- UPDATE co_individual_ext SET IND_STATUS_ext = 'Active' where ind_cst_key_ext = '3E634364-A0C9-4A01-9581-51144777B2CB'


/*
-- remove IXO -- to test with No PRIMARY 
begin transaction 
UPDATE co_customer SET cst_ixo_key = NULL where cst_key = '3E634364-A0C9-4A01-9581-51144777B2CB'
commit 
*/

/*

--- TEST 1  -- with ACTIVE - old is NULL 
UPDATE co_customer SET cst_ixo_key = NULL where cst_key = '3E634364-A0C9-4A01-9581-51144777B2CB'
exec client_scouts_update_individual_status 'EBD69D8B-CD43-463E-A520-E0A11F23AC02'

--------------

--- TEST 2 -- with PENDING  - when old is NULL 
UPDATE co_customer SET cst_ixo_key = NULL where cst_key = '3E634364-A0C9-4A01-9581-51144777B2CB'
exec client_scouts_update_individual_status '051F77E7-9188-4B84-A996-E596B5EB296F'

------------------------------------------------------

--TEST ACTIVE when old is pending 
exec client_scouts_update_individual_status 'EBD69D8B-CD43-463E-A520-E0A11F23AC02'

--TEST Pending when old is active 
exec client_scouts_update_individual_status '051F77E7-9188-4B84-A996-E596B5EB296F'

*/

