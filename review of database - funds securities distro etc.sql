use smtr

select IIF(fm.ACCOUNT_INT IS NULL , 0,1) FUND 
, am2.NUMBER_INT CHILD
	,  am1.*, am2.Name_CHR, fm.* 
from op.account_master am1
	left join op.account_link al on am1.NUMBER_INT = al.PARENT_ACCOUNT_INT
	left join op.account_master am2 on al.CHILD_ACCOUNT_INT = am2.NUMBER_INT
	left join op.fund_master  fm on fm.ACCOUNT_INT = am1.NUMBER_INT 
	
where am1.NUMBER_INT in (519, 521	,520,522) 

order by FUND, CHILD,  TYPE_CHR,  fm.ACCOUNT_INT, am1.SCOPE_CHR


--- SECURITY -- ONE GROUP FOR public / holding -- ANOTHER FOR private 

select  COUNT(*) c, TYPE_CHR , SUBTYPE_CHR
from  op.Security_Master
WHERE ISIN_CHR NOT IN (SELECT ISIN_CHR FROM  pe.Security_Private_Asset PA ) 
GROUP BY type_chr , SUBTYPE_CHR
order by c desc 

-- 
select  COUNT(*) c, TYPE_CHR , SUBTYPE_CHR
from  pe.Security_Private_Asset PA 
JOIn OP.Security_Master SM ON PA.ISIN_CHR = sm.ISIN_CHR
GROUP BY type_chr , SUBTYPE_CHR
order by c

------------------------

-- 14,392

select isin_chr , account_int, max(as_of_date)
from op.Holding_Master
group by isin_chr , account_int

select count(*) C, isin_chr , account_int, min(as_of_date), max(as_of_date)
from op.Holding_Master
group by isin_chr , account_int
order by c desc 

select top 100 * from OP.Holding_Master


-- 10,895
select * from op.Security_Master
select top 100 * from op.Security_Master


select * from 


