
-- looking for LOST / Orhpaned data

-- 294 -- 
select COUNT(*) from client_scouts_compliance_tracking X
	left outer join co_customer C
	on c.cst_key = x.c01_ind_cst_key 
	where (x.c01_delete_flag is NULL or x.c01_delete_flag=0) AND C.cst_delete_flag = 1

-- 1517 rows -- 
select COUNT(*) from client_scouts_experimental_registration X
	left outer join co_customer C
	on c.cst_key = x.x13_ind_cst_key_1  OR  c.cst_key = x.x13_ind_cst_key_1 
	where (x.x13_delete_flag is NULL or x.x13_delete_flag=0) AND C.cst_delete_flag = 1

-- 3301 -- 
select COUNT(*) from client_scouts_member_registration X
	left outer join co_customer C
	on c.cst_key = x.a17_ind_cst_key 
	where (x.a17_delete_flag is NULL or x.a17_delete_flag=0) AND C.cst_delete_flag = 1

--21,990 
select COUNT(*) from client_scouts_online_user_exception_log X
	left outer join co_customer C
	on c.cst_key = x.z71_ind_cst_key OR   c.cst_key = x.z71_cst_key
	where (x.z71_delete_flag is NULL or x.z71_delete_flag=0) AND C.cst_delete_flag = 1

-- 1 
select COUNT(*) from client_scouts_police_records_check X
	left outer join co_customer C
	on c.cst_key = x.a18_ind_cst_key 
	where (x.a18_delete_flag is NULL or x.a18_delete_flag=0) AND C.cst_delete_flag = 1


