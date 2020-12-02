-- Create 2 temp tables if they are missing 
IF OBJECT_ID('tempdb..#sp_who2') IS NULL 
BEGIN 
	CREATE TABLE #sp_who2 (
		SPID INT,Status VARCHAR(255),
		Login  VARCHAR(255),
		HostName  VARCHAR(255), 
		BlkBy  VARCHAR(255),
		DBName  VARCHAR(255), 
		Command VARCHAR(255),
		CPUTime INT, 
		DiskIO INT,
		LastBatch VARCHAR(255), 
		ProgramName VARCHAR(255),
		SPID2 INT, 
		REQUESTID INT) 

	CREATE TABLE #sp_who3 (
		SPID INT,Status VARCHAR(255),
		Login  VARCHAR(255),
		HostName  VARCHAR(255), 
		BlkBy  VARCHAR(255),
		DBName  VARCHAR(255), 
		Command VARCHAR(255),
		CPUTime INT, 
		DiskIO INT,
		LastBatch VARCHAR(255), 
		ProgramName VARCHAR(255),
		SPID2 INT, 
		REQUESTID INT) 
END 

-- clear table before re-filling with data 
truncate table #sp_who3 
INSERT INTO #sp_who3 SELECT * FROM #sp_who2
-- get new data 
truncate table #sp_who2 
INSERT INTO #sp_who2 EXEC sp_who2

-- display results 
SELECT 
OLD.SPID, 
OLD.SPID2,
old.REQUESTID, 
old.Status, 
old.Login, 
old.DBName, 
old.Command, 
old.blkby, 
old.LastBatch , 
old.cputime as 'OLD CPU', new.CPUTime as 'NEW CPU' , new.CPUTime - old.CPUTime as 'CPU DELTA', 
old.diskio as 'OLD IO', new.diskio as 'NEW IO' ,  new.diskio - old.diskio as 'IO DELTA '

FROM        #sp_who2 as NEW 
FULL OUTER JOIN #sp_who3 as OLD ON OLD.SPID = NEW.SPID
WHERE       OLD.DBName like 'nfscouts%'
ORDER BY    'CPU DELTA' desc-- OLD.cputime desc



