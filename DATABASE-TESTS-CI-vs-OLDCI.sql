USE SMTR 
---- 10 min max ! UGH
/* 

select min(teststarttime)st, max(TestEndTime) et from CI.SMTR.tSQLt.TestResult
select * from CI.SMTR.tSQLt.TestResult

*/

-- 1 find the slower (or faster) reults 
;
with TESTS as 
( 
	select testcase, cast(teststarttime as DATE) D1, datediff(MILLISECOND, teststarttime, TestEndTime) T 
	from CI.SMTR.tSQLt.TestResult
) 
,OLDCI AS 
( 
	select *, cast(teststarttime as DATE) D2,  datediff(MILLISECOND, teststarttime, TestEndTime) t
	from PR.electrumWarehouse.fact.TestResultHistory
	where source = 'QWINVCI01' and cast(teststarttime as date) = cast(dateadd(DAY, -11, getdate()) as date)
) , 
REPORT AS ( 
	select 	TESTS.testcase, OLDCI.D2, TESTS.D1, 
		oldci.t /1000.0 OLD_DURATION_SEC, 
		TESTS.t /1000.0 NEW_DURATION_SEC
	from 	TESTS join OLDCI on TESTS.testcase = OLDCI.testcase
) 
SELECT 'TESTS-v-CI_OLD', *, 
	NEW_DURATION_SEC - OLD_DURATION_SEC AS DELTA_T , 
	(NEW_DURATION_SEC / isnulL(OLD_DURATION_SEC, 0.0000001)) * 100.0 as [FACTOR change]
FROM REPORT 
WHERE
	abs(NEW_DURATION_SEC - OLD_DURATION_SEC) > 1 
	OR NEW_DURATION_SEC IS NULL 
	OR OLD_DURATION_SEC IS NULL 
	--or 1=1
order by ISNULL(NEW_DURATION_SEC / OLD_DURATION_SEC, 9999)  desc 


------------------
return 

select * ,  datediff(MILLISECOND, teststarttime, TestEndTime) DURATION
from 
	PR.electrumWarehouse.fact.TestResultHistory 
where teststarttime > cast(dateadd(DAY, -14, getdate()) as date)
	and
	testcase = 'Test-REPORT_DealerExposure'

return 









-------------------------------- 
;
with TESTS as ( 
	select testcase, cast(teststarttime as DATE) D1, datediff(MILLISECOND, teststarttime, TestEndTime) T 
	from CI.SMTR.tSQLt.TestResult
) 
,OLDCI AS ( 
	select *, cast(teststarttime as DATE) D2,  datediff(MILLISECOND, teststarttime, TestEndTime) t
	from PR.electrumWarehouse.fact.TestResultHistory
	where source = 'QWINVCI01' and cast(teststarttime as date) = cast(dateadd(DAY, -10, getdate()) as date)
) , 
REPORT AS ( 
	select	TESTS.testcase, OLDCI.D2, TESTS.D1, oldci.t /1000.0 OLD_DURATION_SEC, TESTS.t /1000.0 NEW_DURATION_SEC
	from	TESTS join OLDCI on TESTS.testcase = OLDCI.testcase
) 
SELECT 'HIST:', REPORT.testcase, 
	NEW_DURATION_SEC - OLD_DURATION_SEC AS DELTA_T , 
	(NEW_DURATION_SEC / isnulL(OLD_DURATION_SEC, 0.0000001)) * 100.0 as [FACTOR change]
--	, HIST.Test
	,  datediff(MILLISECOND, teststarttime, TestEndTime) /1000.0 HIST_DURATION_SEC
	, HIST.Source
	, cast(HIST.TestStartTime as DATE) testedOn
FROM REPORT 
	join PR.electrumWarehouse.fact.TestResultHistory hist on HIST.TESTCASE = REPORT.testcase
WHERE 
	HIST.TestStartTime > cast(dateadd(DAY, -16, getdate()) as date)
	AND ((report.NEW_DURATION_SEC - OLD_DURATION_SEC) > 1 
		OR NEW_DURATION_SEC IS NULL 
		OR OLD_DURATION_SEC IS NULL)
ORDER BY 
	HIST.TestCase, 
	HIST.Source,
	HIST.TestStartTime DESC

-- 2 - list for the slow items 


select 
	source, 
	cast(teststarttime as date) TestedOn,
	min(teststarttime), 
	max(testendtime), 
	datediff(MILLISECOND, min(teststarttime), max(testendtime)) /1000.0 Secs
from 
	PR.electrumWarehouse.fact.TestResultHistory where teststarttime > cast(dateadd(DAY, -14, getdate()) as date)
group by 
	source, 
	cast(teststarttime as date)
	order by 1, 2 desc 


-- 10 minute limit !!!!
select min(teststarttime) , max(teststarttime) from CI.smtr.tsqlt.TestResult

select * from CI.smtr.tsqlt.TestResult

-- 


RETURN 


-- select * from CI.SMTR.tSQLt.TestResult order by teststarttime 

-- FROM most recent CI tests 
; 

with CI as 
( 
	select testcase, cast(teststarttime as DATE) D1, datediff(MILLISECOND, teststarttime, TestEndTime) T 
	from CI.SMTR.tSQLt.TestResult
) 
,OLDCI AS 
( 
	select *, cast(teststarttime as DATE) D2,  datediff(MILLISECOND, teststarttime, TestEndTime) t
	from PR.electrumWarehouse.fact.TestResultHistory
	where source = 'QWINVCI01' and cast(teststarttime as date) = cast(dateadd(DAY, -7, getdate()) as date)
) , 
REPORT AS ( 
select 
	CI.testcase, OLDCI.D2, CI.D1, oldci.t /1000.0 OLD_DURATION_SEC, ci.t /1000.0 NEW_DURATION_SEC
from 
	CI join OLDCI on CI.testcase = OLDCI.testcase
) 
SELECT 'CI:latest', *, NEW_DURATION_SEC - OLD_DURATION_SEC AS DELTA_T 
FROM REPORT 
WHERE
	abs(NEW_DURATION_SEC - OLD_DURATION_SEC) > 1 
	OR NEW_DURATION_SEC IS NULL 
	OR OLD_DURATION_SEC IS NULL 
order by ISNULL(NEW_DURATION_SEC - OLD_DURATION_SEC, 9999)  desc 

-- select SUM(datediff(MILLISECOND, teststarttime, TestEndTime)) TOTAL_TIME from CI.SMTR.tsqlt.testResult 
-- FROM TEST HISTORY (on PR) 
; 

with CI as 
( 
	select testcase, cast(teststarttime as DATE) D1, datediff(MILLISECOND, teststarttime, TestEndTime) T 
	from PR.electrumWarehouse.fact.TestResultHistory
	where source = 'QWINVCI01' and cast(teststarttime as date) = cast(getdate() as date)
) 
,OLDCI AS 
( 
	select *, cast(teststarttime as DATE) D2,  datediff(MILLISECOND, teststarttime, TestEndTime) t
	from PR.electrumWarehouse.fact.TestResultHistory
	where source = 'QWINVCI01' and cast(teststarttime as date) = cast(dateadd(DAY, -7, getdate()) as date)
) , 
REPORT AS ( 
select 
	CI.testcase, OLDCI.D2, CI.D1, oldci.t /1000.0 OLD_DURATION_SEC, ci.t /1000.0 NEW_DURATION_SEC
from 
	CI join OLDCI on CI.testcase = OLDCI.testcase
) 
SELECT 'CI: history', *, NEW_DURATION_SEC - OLD_DURATION_SEC AS DELTA_T 
FROM REPORT where abs(NEW_DURATION_SEC - OLD_DURATION_SEC) > 1 
OR NEW_DURATION_SEC IS NULL 
OR OLD_DURATION_SEC IS NULL 
order by ISNULL(NEW_DURATION_SEC - OLD_DURATION_SEC, 9999)  desc 
--- 
use smtr 

; 
with UT as 
( 
	select testcase, datediff(MILLISECOND, teststarttime, TestEndTime) T 
	from UT.SMTR.tsqlt.testResult
) 
,OLDUT AS 
( 
	select *,  datediff(MILLISECOND, teststarttime, TestEndTime) t
	from PR.electrumWarehouse.fact.TestResultHistory
	where source = 'QWINVUT01' and cast(teststarttime as date) = cast(dateadd(DAY, -7, getdate()) as date)
) , 
REPORT AS ( 
select 
	UT.testcase, ISNULL(oldUT.t, 99999) /1000.0 OLD_DURATION_SEC, ISNULL(UT.t, 999999) /1000.0 NEW_DURATION_SEC
from 
	UT join OLDUT on UT.testcase = OLDUT.testcase
) 
SELECT 'UT: History', *, NEW_DURATION_SEC - OLD_DURATION_SEC AS DELTA_T 
FROM REPORT where abs(OLD_DURATION_SEC - NEW_DURATION_SEC) > 1 
order by 4 desc 




