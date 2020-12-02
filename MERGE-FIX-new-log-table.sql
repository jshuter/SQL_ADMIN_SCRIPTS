-- JSS FEB 2014 - NEW TABLE CREATION SCRIPT -- 

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* 

Initially created to log keys being MERGED from the IWEB merge duplicates function 
	
This 'GENERIC LOG' will be a write only target for messages from anywhere. 
field f1 and f2 are meant to allow each insert to use the fields as they see fit

CHANGE LOG 

WHO		WHEN		WHY 
-----	----------	------------------------------------------------
Jeff S, Feb 2014	Initial Creation 
	
*/
-- DROP TABLE [dbo].[client_scouts_generic_log]

CREATE TABLE [dbo].[client_scouts_generic_log](
	[z77_key]			INT IDENTITY(1,1),
	[z77_add_user]		[dbo].[av_user] NOT NULL,
	[z77_add_date]		[dbo].[av_date] NOT NULL,
	[z77_description]	[nvarchar](800) NOT NULL,
	[z77_reason]		[nvarchar](50) NULL,	
	[z77_source]		[nvarchar](50) NULL,
	[z77_f1]			[nvarchar](50) NULL,
	[z77_f2]			[nvarchar](50) NULL,
	[z77_f3]			[nvarchar](50) NULL,
	[z77_f4]			[nvarchar](50) NULL,
	CONSTRAINT [PK_client_generic_log] PRIMARY KEY CLUSTERED ([z77_key] ASC) 
		WITH (PAD_INDEX  = OFF, 
				STATISTICS_NORECOMPUTE  = OFF, 
				IGNORE_DUP_KEY = OFF, 
				ALLOW_ROW_LOCKS  = ON, 
				ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[client_scouts_generic_log] ADD  CONSTRAINT [DF_client_scouts_generic_log_z77_add_user]  DEFAULT (suser_sname()) FOR [z77_add_user]
GO

ALTER TABLE [dbo].[client_scouts_generic_log] ADD  CONSTRAINT [DF_client_scouts_generic_log_z77_add_date]  DEFAULT (getdate()) FOR [z77_add_date]
GO



