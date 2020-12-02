
/* 
-- NOTES 

tables that have 0 rows are not recomputed - and therefore the number of days remains large, 
ie, 42,065 as at last count 

see ie > select * from dbo.co_document_classification

*/


-- SHOULD ALWAYS START with TEST DATABASE !

use netForumSCOUTSTest 
GO 

DECLARE @MaxDaysOld INT
DECLARE @SamplePercent INT
DECLARE @SampleType nvarchar(50)

SET @MaxDaysOld = 10
SET @SamplePercent = NULL --25
SET @SampleType = 'PERCENT' --'ROWS'

BEGIN TRY
DROP TABLE #OldStats
END TRY
BEGIN CATCH SELECT 1 END CATCH

SELECT
RowNum = ROW_NUMBER() OVER (ORDER BY ISNULL(STATS_DATE(object_id, st.stats_id),1))
,TableName = OBJECT_SCHEMA_NAME(st.object_id) + '.' + OBJECT_NAME(st.object_id)
,StatName = st.name
,StatDate = ISNULL(STATS_DATE(object_id, st.stats_id),1)
INTO #OldStats
FROM sys.stats st WITH (nolock)
WHERE DATEDIFF(DAY, ISNULL(STATS_DATE(object_id, st.stats_id),1), GETDATE()) > @MaxDaysOld
ORDER BY ROW_NUMBER() OVER (ORDER BY ISNULL(STATS_DATE(object_id, st.stats_id),1))

DECLARE @MaxRecord INT
DECLARE @CurrentRecord INT
DECLARE @TableName nvarchar(255)
DECLARE @StatName nvarchar(255)
DECLARE @SQL nvarchar(MAX)
DECLARE @SampleSize nvarchar(100)

SET @MaxRecord = (SELECT MAX(RowNum) FROM #OldStats)
SET @CurrentRecord = 1
SET @SQL = ''
SET @SampleSize = ISNULL(' WITH SAMPLE ' + CAST(@SamplePercent AS nvarchar(20)) + ' ' + @SampleType,N'')

WHILE @CurrentRecord <= @MaxRecord
BEGIN

SELECT

@TableName = os.TableName
,@StatName = os.StatName
FROM #OldStats os
WHERE RowNum = @CurrentRecord

-- ignore sys generated stats for non indexed columns ...
-- if @StatName not like '_WA_Sys_%' BEGIN 

	-- limit list to selected tables 
	IF @TableName like 'dbo.client%' OR @TableName like 'dbo.co_%' BEGIN
		SET @SQL = N'UPDATE STATISTICS ' + @TableName + ' ' + @StatName + @SampleSize
		PRINT @SQL
	END 

-- EXEC sp_executesql @SQL
--END 

SET @CurrentRecord = @CurrentRecord + 1

END



--- report os stats for selected items 
SELECT
RowNum = ROW_NUMBER() OVER (ORDER BY ISNULL(STATS_DATE(object_id, st.stats_id),1))
,TableName = OBJECT_SCHEMA_NAME(st.object_id) + '.' + OBJECT_NAME(st.object_id)
,StatName = st.name
,StatDate = ISNULL(STATS_DATE(object_id, st.stats_id),1),
DATEDIFF(DAY, ISNULL(STATS_DATE(object_id, st.stats_id),1), GETDATE()) as 'DaysOld'
FROM sys.stats st WITH (nolock)
WHERE (OBJECT_NAME(st.object_id) like 'co_%' or OBJECT_NAME(st.object_id) like 'client_scouts%') 
AND DATEDIFF(DAY, ISNULL(STATS_DATE(object_id, st.stats_id),1), GETDATE()) > @MaxDaysOld
-- and st.name  not like '_WA_Sys%' 
ORDER BY ROW_NUMBER() OVER (ORDER BY ISNULL(STATS_DATE(object_id, st.stats_id),1))
-- client_scouts_individual_x_reference
