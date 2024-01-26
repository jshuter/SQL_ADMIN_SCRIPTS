--DATABASE-MAKE-MIGRATIONS-BRING-FORWARD-COMMANDS.sql--

use smtr 
go 

-- this is used to bring local database up to date with the database that is in the ORM 
-- to do this we need simply start from clean restore then apply all migrations that have run in PR but not yet run on LOCALHOST 

-- This script generates DbMigrate commands to bring your DB in sync with DBs on PR 

-- should be on local host 

-- run this from bin command bin\makeMyDatabaseslikeProduction 

;
WITH NewMigrationsInPr AS ( 
	SELECT * FROM pr.smtr_staging.dbo.migrations 
	except 
	SELECT * FROM smtr_staging.dbo.migrations 
) 
SELECT 'dbmigrate ' + NewMigrationsInPr.migration FROM NewMigrationsInPr
order by id 



