

use netForumSCOUTSTest 

-- GET STATS DATES 

SELECT name AS stats_name, STATS_DATE(object_id, stats_id) AS statistics_update_date
FROM sys.stats 
WHERE object_id = OBJECT_ID('dbo.co_individual_ext');

