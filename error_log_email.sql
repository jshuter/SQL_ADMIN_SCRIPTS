USE [SMTR_STAGING]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Stage].[FileTypeProcessorLog_Monitor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Stage].[FileTypeProcessorLog_Monitor]
GO
USE [SMTR_STAGING]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* 
DESCRIPTION 

	Executed by : JOB : SMTR_STAGING_FileTypeProcessorLog_Monitor

	This proc is executed by an SQL JOB Hourly and send an email if a new error is found 

	This proc	[1] ignores ZIP processing, because numerous zips are expected to fail 
				[2] updates the FileTypeProcessorLog with an entry to record last datetime that email was sent 

CHANGE LOG 

	FEB 2019 -- INVESTOPS-518 

*/ 
CREATE PROCEDURE STAGE.FileTypeProcessorLog_Monitor ( 
	@sendMail INT = 1, 
	@debug INT = 0 
) 
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @body varchar(max)
	DECLARE @LastReportedDate DATETIME
	DECLARE @count INT = 0 

	-- to test - remove most recent record(s) 
	-- DELETE FROM SRC.FileTypeProcessorLog WHERE ProcessorName = 'LogMailer' 

	-- get last mailing date 
	SELECT @LastReportedDate =  MAX(lg.ProcessedDate) 
	FROM SRC.FileTypeProcessorLog lg 
	WHERE lg.ProcessorName = 'LogMailer' 

	IF @LastReportedDate IS NULL
		SET @LastReportedDate = '2010-01-01' 

	-- check for new issues 
	SELECT @count = COUNT(*)  
	FROM SRC.FileTypeProcessorLog lg 
	WHERE 
		lg.HasSucceeded = 0 
		AND lg.Filename NOT LIKE '%zip'
		AND ProcessedDate > @LastReportedDate 

	IF @debug = 1 AND @count < 1 
		SELECT 'Nothing new found since :', @LastReportedDate last_reported_date 

	IF @count < 1 
		RETURN 

	-- only proceeding if 1 or more error were selected 
	set @body = cast( 
		(
		select td = D.acct
			+ '</td><td>' + D.acctname
			+ '</td><td>' + D.fn
			+ '</td><td>' + D.fa
			+ '</td><td>' + D.Sub
			+ '</td><td>' + D.pdate
			+ '</td><td>' + D.procname
			+ '</td><td>' + D.msg 
		from (-- main data 
			SELECT 
				ISNULL(lg.AccountType, '')  AS acct, 
				ISNULL(lg.AccountName, '') AS acctname, 
				ISNULL(lg.Filename, '') AS fn, 
				ISNULL(lg.FromAddress, '') AS fa, 
				ISNULL(lg.Subject ,'') AS sub, 
				ISNULL(CAST(lg.ProcessedDate AS VARCHAR(20)), '') AS pdate,  
				ISNULL(lg.ProcessorName, '') AS procname, 
				ISNULL(CAST(lg.Message AS VARCHAR(3000)), '') AS msg
			FROM 
				SRC.FileTypeProcessorLog lg 
			WHERE
				lg.HasSucceeded = 0 
				AND lg.Filename NOT LIKE '%zip'
				AND ProcessedDate > @LastReportedDate 
			 ) as d
		for xml path( 'tr' ), type 
		) 

	as varchar(max) )

	SELECT 'ROWCOUNT: ' , @count  

	-- convert XML into HTML TABLE 
	set @body = '
	<h1>FileTypeProcessorLog - New Error Report</h1> 
	<p>NOTE : <small><i>This report will not report on Failure to open ZIP files, as all Loader attempts to open All Zips. 
	 When failure occurs, processing falls thru to old FileLoader. All other error are reported.</i></small></p>
	<p>' + CAST(@count AS VARCHAR(10)) + ' Errors have been recorded since last report of ' + CAST(@LastReportedDate AS VARCHAR(20))  + '</p>
	<style>
	#log {font-family:"Trebuchet MS",Arial,Helvetica, sans-serif;border-collapse: collapse;width:100%;}
	#log td, #customers th {border: 1px solid #ddd; padding: 2px;}
	#log tr:nth-child(even){background-color: #f2f2f2;}
	#log tr:hover {background-color: #ddd;}
	#log th {padding-top:2px; padding-bottom:2px; text-align: left;background-color: #336EFF;color:white;}
	</style><table id="log" cellpadding="2" cellspacing="2" border="1"><tr><th>Account</th><th>Account Name</th>
	<th>File</th><th>From</th><th>Subject</th><th>Process Date</th><th>Processor</th><th>Message</th></tr>'
	+ replace( replace( @body, '&lt;', '<' ), '&gt;', '>' )
	+ '</table>'


	IF @sendMail = 1 
	BEGIN
	 
		EXEC msdb.dbo.sp_send_dbmail
			@profile_name='sqlagentmail',
			@recipients = 'jshuter@cmpa.org',
			@body = @body,
			@body_format = 'HTML',
			@subject = 'FileTypeProcessorLog - New Error Report' 

		INSERT INTO 
			SRC.FileTypeProcessorLog ( Filename, Username,  ProcessedDate, FileTypeName, ProcessorName, HasSucceeded, Message ) 
		VALUES 
			('nofile', USER_NAME(), GETDATE(), 'SPROC - emailing errors', 'LogMailer', 1, 'Errors recorded in the log since last check are being emailed to Middle Office' ) 

	END 

	
END

GO