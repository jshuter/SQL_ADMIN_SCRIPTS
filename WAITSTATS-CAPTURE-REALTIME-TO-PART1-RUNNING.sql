select * from smtr.op.account_master 

begin transaction 

UPDATE smtr.OP.Account_Master SET ModifiedBy = 'test1'

waitfor delay '00:00:05'

select * from smtr.op.account_master 

rollback 

select * from smtr.op.account_master 