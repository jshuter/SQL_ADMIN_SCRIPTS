USE SMTR 

select * from op.x_risk_sub_asset 


select count(*), type_chr from op.account_master group by TYPE_CHR


-- 131	Performance
select count(distinct ACCOUNT_INT) from op.Performance_Return -- 343 

select * -- most are Active / Public 
from op.Account_Master AM 
where am.TYPE_CHR = 'Performance' 

order by ASSET_CLASS_CHR, risk_sub_group_chr, type_chr 


select * from op.Fund_Master FM -- 286 
	 join op.Account_Master AM on AM.NUMBER_INT = FM.ACCOUNT_INT 
order by ASSET_CLASS_CHR, risk_sub_group_chr, type_chr 

-- 124	Index

-- 340	Fund
-- 8	Cash
select count(*) from op.fund_master -- 286 
select * from op.Fund_Master FM -- 286 
	 join op.Account_Master AM on AM.NUMBER_INT = FM.ACCOUNT_INT 
order by ASSET_CLASS_CHR, risk_sub_group_chr, type_chr 

-- 94	Account
-- 9	PeopleSoft
-- 2	Prospect
-- 25	Custodian Account


with data as ( 
select 
(select count(*) from op.Account_Attributes where ACCOUNT_INT = AM.NUMBER_INT ) as ATTRIBUTES, 
(select count(*) from op.Fund_Master f where f.ACCOUNT_INT = AM.NUMBER_INT ) as FUNDS, 
(select count(*) from op.Holding_Master h where h.ACCOUNT_INT = AM.NUMBER_INT ) as HOLDINGS, 
(select count(*) from op.Transaction_Master T where T.FUND_INT = AM.NUMBER_INT ) as TRANSACTIONS, 
(select count(*) from op.Performance_Return P where P.ACCOUNT_INT = AM.NUMBER_INT ) as PERFORMANCES, 
 *  
FROM op.Account_Master AM
) 
select * from data 
WHERE NUMBER_INT IN (600, 601) 
order by funds, holdings, transactions, PERFORMANCES






--- TO DO -- ADD DATA for ALL FUND ?? IE 600  --- 

--- HANDLE WHERE EXPECTED RETURN does not exists --- assume 0  

