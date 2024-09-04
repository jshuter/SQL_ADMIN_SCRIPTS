
use smtr 

EXEC TOOLS.REPORT_SQLServerAndApplicationErrors  @EmailRecipients='shu30@cmpa.org', @startdate = '2024-08-20', @DailySummary=1 , @IncludeAllErrors=1, 
@ShowDetailsToConsole=1
