
-- SQL SERVER jobs
SELECT j.name, j.enabled,  j.description, s.database_name, s.last_run_date, s.server, s.step_name, s.command
FROM msdb.dbo.sysjobs j 
	join msdb.dbo.sysjobsteps s on s.job_id = j.job_id
where j.name like 'SMTR%' 
order by j.enabled, s.database_name, j.name, s.step_id



SELECT JOB.NAME AS JOB_NAME,
STEP.STEP_ID AS STEP_NUMBER,
STEP.STEP_NAME AS STEP_NAME,
STEP.COMMAND AS STEP_QUERY,
DATABASE_NAME
FROM Msdb.dbo.SysJobs JOB
INNER JOIN Msdb.dbo.SysJobSteps STEP ON STEP.Job_Id = JOB.Job_Id
WHERE JOB.Enabled = 1
AND (JOB.Name like '%SMTR%') --  OR STEP.COMMAND LIKE ‘%Exec AnotherStoredProcedure%’)
ORDER BY JOB.NAME, STEP.STEP_ID