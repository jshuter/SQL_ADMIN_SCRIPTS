-- Simple table review 

--=============================================================
-- 704 ACCOUNT Records 
select count(*) from op.account_master

Select * from op.account_master 

select count(*) c , TYPE_CHR, SOURCE_CHR, STATUS_CHR, SCOPE_CHR
from op.account_master 
group by TYPE_CHR, SOURCE_CHR, STATUS_CHR, SCOPE_CHR
order by c desc 

-- code lookups used above 

select * from OP.X_Account_Source
select * from  op.X_Account_Type 

--=============================================================
-- 112 -- PARENT/ CHILD Join Table for Accounts 

select count(*) from op.Account_Link
select *  from OP.account_link

--=============================================================
-- 3,231,128 rows 

-- holding master review -- Links Securities to an Account -- PLUS historical price data during the time it is held 

select count(*) from op.Holding_Master

select top 100 * from op.Holding_Master

select * from op.account_master where NUMBER_INT = 348 

select top 100 * from op.Holding_Master m where  m.ACCOUNT_INT = 348 order by m.AS_OF_DATE DESC 

select TOP 100 count(*) C,  account_int , isin_chr
	from op.Holding_Master
	WHERE ACCOUNT_INT = 348 
	GROUP BY  ACCOUNT_INT, ISIN_CHR
	ORDER BY ACCOUNT_INT

--- 
--=============================================================
-- 10,833 various securities 
-- Breakdown of securities by types 

select count(*) from op.Security_Master
select top 100 * from op.Security_Master 

select count(*), type_chr
from op.Security_Master 
group by type_chr

select count(*), type_chr, subtype_chr 
from op.Security_Master 
group by type_chr, subtype_chr 
order by TYPE_CHR, SUBTYPE_CHR


--=============================================================
-- 39,643 rows 

select count(*) from op.transaction_master 
select top 100 * from op.transaction_master 

select count(*), type_chr, subtype_chr
from op.Transaction_Master 
group by type_chr, SUBTYPE_CHR

--- none == IE -- all TRANSACTIONS ARE LINKED TO A FUND !!!!!
SELECT COUNT(*) FROM OP.Transaction_Master WHERE FUND_INT NOT IN (SELECT ACCOUNT_INT FROM OP.Fund_Master) 

--=============================================================
-- 93,134 rows 

select count(*) from op.Transaction_Detail

select top 100 * from op.Transaction_Detail

with a as ( 
	select count(*) C , TRANSACTION_NUMBER_INT 
	from op.Transaction_Detail
	group by TRANSACTION_NUMBER_INT 
) 
select * from a where c > 4

select * from op.Transaction_Master where NUMBER_INT = 19020 
select * from op.Transaction_Detail where TRANSACTION_NUMBER_INT = 19020 

select sum(Local_Amount_DEC), sum(Base_Amount_DEC) from op.Transaction_Detail where TRANSACTION_NUMBER_INT = 19020 and DIRECTION_CHR = 'CR'
select sum(Local_Amount_DEC), sum(Base_Amount_DEC) from op.Transaction_Detail where TRANSACTION_NUMBER_INT = 19020 and DIRECTION_CHR = 'CR'



--=============================================================
-- 269 ROWS  (Each FUND has 1 Account) 
--=============================================================


select count(*) from op.fund_master 

select  * from op.Fund_Master

SELECT * FROM OP.Account_Master A 
	JOIN OP.FUND_MASTER f ON A.NUMBER_INT = F.ACCOUNT_INT 


select count(*) , asset_class_chr from op.fund_master group by ASSET_CLASS_CHR
select count(*) , STRATEGY_CHR from op.fund_master group by STRATEGY_CHR
select count(*) , MANDATE_CHR from op.fund_master group by MANDATE_CHR
select count(*) , RISK_SUB_GROUP_CHR from op.fund_master group by RISK_SUB_GROUP_CHR

SELECT * FROM OP.Account_Master A 
	JOIN OP.FUND_MASTER f ON A.NUMBER_INT = F.ACCOUNT_INT 
	where ASSET_CLASS_CHR = 'Absolute Return' 
		and Status_chr = 'Active' 


--=============================================================
-- 108 ROWS 

SELECT COUNT(*) FROM OP.Manager_Master

select * from op.Manager_Master

--=============================================================
-- 16 ROWS 

select  * from op.Account_Groups_Master

--=============================================================

SELECT * FROM OP.Fund_Master	-- 269 
select * from pe.Private_Fund	-- 146 
select * from pub.Public_Fund	-- 125 
								-- (18) counted in both 

-- 18 ROWS WHERE FUND IS private & public // MIXED FUNDS ??
select * from pe.Private_Fund PE JOIN pub.Public_Fund PR ON PR.FUND_INT = PE.FUND_INT

-- 16 absolute FUNDS have no Private or Public record 
SELECT * FROM OP.Fund_Master	a
left outer join pe.Private_Fund	b on a.ACCOUNT_INT = b.FUND_INT
left outer join pub.Public_Fund	c on a.ACCOUNT_INT = c.FUND_INT 
where b.FUND_INT is null and c.FUND_INT is null 

--=============================================================
select top 100 * from pe.Private_Hedge
--=============================================================
select top 100 * from pe.Private_Alternative
--=============================================================
select top 100 * from pub.Exchange_Fund
--=============================================================
select top 100 * from pub.Hedge_Fund
--=============================================================


