


select cst_delete_flag, * from co_customer where cst_key = '83AFC9A1-452C-4142-956B-99F88D1D1E2D' -- cst_recno = 10192552
select ind_delete_flag, * from co_individual where ind_cst_key = '83AFC9A1-452C-4142-956B-99F88D1D1E2D'

begin transaction 

update  co_customer 
set cst_delete_flag = 0 
where cst_key = '83AFC9A1-452C-4142-956B-99F88D1D1E2D' -- cst_recno = 10192552

update  co_individual 
set ind_delete_flag = 0 
where ind_cst_key = '83AFC9A1-452C-4142-956B-99F88D1D1E2D'

select cst_delete_flag, * from co_customer where cst_key = '83AFC9A1-452C-4142-956B-99F88D1D1E2D' -- cst_recno = 10192552
select ind_delete_flag, * from co_individual where ind_cst_key = '83AFC9A1-452C-4142-956B-99F88D1D1E2D'

-- commit 

-- rollback 