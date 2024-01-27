select * from smtr.op.account_master 

begin transaction 

UPDATE smtr.OP.Account_Master SET ModifiedBy = 'test2'

rollback 

select * from smtr.op.account_master 
