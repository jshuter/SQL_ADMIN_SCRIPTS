/* 
'8C0AE35D-95EA-49FC-97E9-410B49BC5C0E'  -- Warren Johnsen</Name>
'5EE579BD-F229-4432-A9CB-DDF0F92217AE' -- DONALD DUCK 
*/

DECLARE @cst_key uniqueidentifier 
SET @CST_KEY = 'BAAB41C3-AD68-4D52-BA20-D9656DC4DF8F'	-- 3 parent (1 dup) 
--
SET @CST_KEY = '3BFB631B-198E-46BC-9C14-47762BFD73FA'  --<< key of child 1 (GLEN J) >> 1 PARENT (Warren) (SEE BELOW) -- HAS 1 PARENT 
SET @CST_KEY = 'BAAB41C3-AD68-4D52-BA20-D9656DC4DF8F'  --<< key of child 2 (JR J) >> 1 PARENT (Warren) (SEE BELOW) -- HAS 2 PARENTS 
SET @CST_KEY = '5EE579BD-F229-4432-A9CB-DDF0F92217AE'  --<< key of child 3 (Don Duck) >> 1 PARENT (Warren) (SEE BELOW) -- HAS 4 Parents
SET @cst_key = '8C0AE35D-95EA-49FC-97E9-410B49BC5C0E'  --<< key of Parent (Glenn J) >>  3 CHILDREN 
--

-- select * from co_customer where cst_key = @cst_key 

-- this finds all 
/* 
SELECT ind_cst_key,[relationship]=cxc_rlt_code2,[name]=ind_first_name+' '+a.ind_last_name 
	from co_customer_x_customer join co_individual a 
	on cxc_cst_key_2=ind_cst_key 
	where cxc_cst_key_1=@cst_key 
UNION -- distinct
SELECT ind_cst_key,[relationship]=cxc_rlt_code,[name]=ind_first_name+' '+a.ind_last_name 
	from co_customer_x_customer  join co_individual a 
	on cxc_cst_key_1=ind_cst_key 
	where cxc_cst_key_2=@cst_key 
*/

-- THIS FINDS PARENTS

SELECT ind_cst_key,[relationship]=cxc_rlt_code2,[name]=ind_first_name+' '+a.ind_last_name 
	from co_customer_x_customer join co_individual a 
	on cxc_cst_key_2=ind_cst_key 
	where cxc_cst_key_1=@cst_key 
		and cxc_rlt_code2 = 'Parent/Guardian' 

UNION -- distinct

SELECT ind_cst_key,[relationship]=cxc_rlt_code,[name]=ind_first_name+' '+a.ind_last_name 
	from co_customer_x_customer  join co_individual a 
	on cxc_cst_key_1=ind_cst_key 
	where cxc_cst_key_2=@cst_key 
		and cxc_rlt_code = 'Parent/Guardian' 

-- NEED TO FIND - OTHER PARENTS FOR THE CHILD !
-- THIS FINDS ALL PARENTS OF ALL CHILDREN OF KEY 

UNION 

SELECT ind_cst_key,[relationship]=cxc_rlt_code2,[name]=ind_first_name+' '+a.ind_last_name 
	from co_customer_x_customer join co_individual a 
	on cxc_cst_key_2=ind_cst_key 
	where cxc_cst_key_1 in (
		SELECT ind_cst_key 
		from co_customer_x_customer join co_individual a 
		on cxc_cst_key_2=ind_cst_key 
		where cxc_cst_key_1=@cst_key and cxc_rlt_code2 = 'Child' 
		UNION 
		SELECT ind_cst_key
		from co_customer_x_customer join co_individual a 
		on cxc_cst_key_1=ind_cst_key 
		where cxc_cst_key_2=@cst_key and cxc_rlt_code = 'Child' 
	) 
	and cxc_rlt_code2 = 'Parent/Guardian' 
		
UNION -- distinct

SELECT ind_cst_key,[relationship]=cxc_rlt_code,[name]=ind_first_name+' '+a.ind_last_name 
	from co_customer_x_customer  join co_individual a 
	on cxc_cst_key_1=ind_cst_key 
	where cxc_cst_key_2 in (
		SELECT ind_cst_key 
		from co_customer_x_customer join co_individual a 
		on cxc_cst_key_2=ind_cst_key 
		where cxc_cst_key_1=@cst_key and cxc_rlt_code2 = 'Child' 
		UNION 
		SELECT ind_cst_key
		from co_customer_x_customer join co_individual a 
		on cxc_cst_key_1=ind_cst_key 
		where cxc_cst_key_2=@cst_key and cxc_rlt_code = 'Child' 
	) 
	and cxc_rlt_code = 'Parent/Guardian' 

