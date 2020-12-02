with a as ( 
	select h.FUND_INT , s.Name_CHR , s.ISIN_CHR 
	from op.Security_Master s
	join op.transaction_Master h on h.cash_ISIN_CHR = s.ISIN_CHR 
	group by h.FUND_INT , s.Name_CHR , s.ISIN_CHR
) 
, b as ( 
	select count(*) cOUNTS, fund_INT, Name_CHR from a 
	GROUP BY A.fund_INT , A.Name_CHR 
) 
, C AS ( SELECT * FROM B WHERE COUNTS > 1) 

SELECT 
	* 
FROM 
	C

join ( 
	select DISTINCT h.fund_INT,  S.* from 
	op.Security_Master s 
		join op.transaction_Master h on H.cash_ISIN_CHR = s.ISIN_CHR 

) r on C.fund_INT = R.fund_INT AND C.Name_CHR = r.Name_CHR

ORDER BY TYPE_CHR, SUBTYPE_CHR,  C.Name_CHR






-- example of duplicate NAME - 2 ISIN's 
select * from op.Security_Master s
join pe.Security_Private_Asset p on s.ISIN_CHR = p.ISIN_CHR


where p.ISIN_CHR in (
	--'CAPRME003873CA', 	'CAPRME004194CA'
	'USPRPR002164US','USPRPR002172US'
) 
 


