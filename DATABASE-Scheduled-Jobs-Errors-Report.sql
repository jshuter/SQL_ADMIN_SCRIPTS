--USE SMTR same for both 
--use master 

	SELECT 
				CAST(SJV.Name AS VARCHAR(100)) Job_Name, 
				CASE WHEN  SJH.run_status = 1 THEN 'Succeeded'	ELSE 'Failed' END Job_Status,
				CAST(SJH.step_name AS VARCHAR(100)) Step_Name, 
				CAST(CONCAT(CONVERT(DATE , CAST(SJH.run_date AS VARCHAR(8)), 112), ' ', CONVERT(TIME, REVERSE(STUFF(STUFF(REVERSE(RIGHT('000' + CAST(SJH.run_time AS VARCHAR(6)), 6)),3,0,':'),6,0,':')),114)) AS DATETIME2(0)) as RunDateTime
	FROM	msdb.dbo.sysjobhistory SJH
				inner join msdb.dbo.sysjobs_view SJV ON SJH.job_id = SJV.job_id 
				inner join msdb.dbo.sysjobschedules SJS	ON SJH.job_id = SJS.job_id 
				inner join msdb.dbo.sysschedules_localserver_view SSLV ON SJS.schedule_id = SSLV.schedule_id 
	WHERE 
		SSLV.enabled = 1 
		AND SJV.Name LIKE 'smtr%' 
--		AND run_status <> 1
--		AND SJV.Name <> 'SMTR_CustomLoadProcessorLog_Monitor'
	ORDER BY 
		4 desc 
