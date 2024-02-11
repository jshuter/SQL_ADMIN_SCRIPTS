
use smtr 

; with data as ( 
--	select 'mine' as loc, datediff(MILLISECOND, teststarttime, testendtime) t
--	,* from tsqlt.TestResult
--	UNION 
	select 'ci' as LOC, datediff(MILLISECOND, teststarttime, testendtime) t
	,* from CI.SMTR.tsqlt.TestResult
	UNION 
	select 'ut', datediff(MILLISECOND, teststarttime, testendtime) t
	,* from UT.SMTR.tsqlt.TestResult
) 
select * from data 
-- where msg <> ''
order by TestCase, 1

	select 'ci' as LOC, SUM(datediff(MILLISECOND, teststarttime, testendtime) )t from CI.SMTR.tsqlt.TestResult
	select 'ut' as LOC, SUM(datediff(MILLISECOND, teststarttime, testendtime) )t from UT.SMTR.tsqlt.TestResult
