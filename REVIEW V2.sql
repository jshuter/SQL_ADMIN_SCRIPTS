select * from op.account_master AM 
	left join op.account_attributes AA on am.NUMBER_INT = AA.ACCOUNT_INT

-- op.account_attributes
-- CARDINALITY : OPTIONAL - 1:1  (34 rows of possible 704) 
select count(*), AA.account_INT
	from op.account_master AM LEFT join op.account_attributes AA on am.NUMBER_INT = AA.ACCOUNT_INT
	group by AA.ACCOUNT_INT


order by aa.ACCOUNT_INT
