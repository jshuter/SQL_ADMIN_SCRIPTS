select count(*) from pe.Market_Value_Adjustment -- 26000

select top 100 * from pe.Market_Value_Adjustment order by as_of_date desc 


-- 122 Unique MVA Records -- 1 or MANY Securities for each FUND 

select count(*), fund_int from pe.Market_Value_Adjustment group by fund_int

--- MVA for Fund seem to get calculated at End of Each Quarter 
select count(*), AS_OF_DATE from pe.Market_Value_Adjustment group by as_of_date 

--- 3 FUNCTIONS 
--- 

--- TODO - REVIEW >> 590 / 0 for vpa but more for Bulk !!!!

-- this one gives total for the fund -- 
select acct_num,  base_market_value from [TOOLS].[Valuation_Private_Assets_Bulk] ('2017-01-01') 
where acct_num between 550 and 650 
order by acct_num 

-- below gives 1 line per security 
select fm.ACCOUNT_INT, sum(base_market_value)  
from op.Fund_Master FM
	cross apply [TOOLS].[Valuation_Private_Assets] ( '2017-01-01', FM.RISK_SUB_GROUP_CHR, FM.ACCOUNT_INT)
WHERE FM.ACCOUNT_INT between 550 and 650 
group by fm.ACCOUNT_INT
order by ACCOUNT_INT




