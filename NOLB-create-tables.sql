USE [netForumSCOUTSTest]

-- DO NOT REUSE !
 
return 
 
declare @mdt_prefix char(3)
declare @mdt_name varchar(100)

--set @mdt_name = 'client_scouts_discount_request'
--set @mdt_prefix = 'z78'

--set @mdt_name = 'client_scouts_discount_type'
--set @mdt_prefix = 'z79'

--set @mdt_name = 'client_scouts_discount'
--set @mdt_prefix = 'z80'

set @mdt_name = 'client_scouts_discount_approval'
set @mdt_prefix = 'z81'

exec ('CREATE TABLE [dbo].['+@mdt_name+'] (
	['+@mdt_prefix+'_key]  av_key ROWGUIDCOL  NOT NULL,
	['+@mdt_prefix+'_add_user] [av_user] NOT NULL ,
	['+@mdt_prefix+'_add_date] [av_date] NOT NULL ,
	['+@mdt_prefix+'_change_user] [av_user] NULL ,
	['+@mdt_prefix+'_change_date] [av_date] NULL ,
	['+@mdt_prefix+'_delete_flag] [av_delete_flag] NOT NULL ,
	['+@mdt_prefix+'_entity_key] [av_key] NULL 
) ON [PRIMARY]')

exec ('ALTER TABLE [dbo].['+@mdt_name+'] WITH NOCHECK ADD 
	CONSTRAINT [DF_'+@mdt_name+'_'+@mdt_prefix+'_key] DEFAULT (newid()) FOR ['+@mdt_prefix+'_key],
	CONSTRAINT [DF_'+@mdt_name+'_'+@mdt_prefix+'_add_user] DEFAULT (suser_sname()) FOR ['+@mdt_prefix+'_add_user],
	CONSTRAINT [DF_'+@mdt_name+'_'+@mdt_prefix+'_add_date] DEFAULT (getdate()) FOR ['+@mdt_prefix+'_add_date],
	CONSTRAINT [DF_'+@mdt_name+'_'+@mdt_prefix+'_delete_flag] DEFAULT (0) FOR ['+@mdt_prefix+'_delete_flag],
	CONSTRAINT [PK_'+@mdt_name+'] PRIMARY KEY  CLUSTERED 
	(
		['+@mdt_prefix+'_key]
	)  ON [PRIMARY]')



-------
/* 

ALTER TABLE dbo.client_scouts_discount_request
 ADD CONSTRAINT CK_discount_request_status
 CHECK (z78_status IN ('new', 'approve', 'deny'))

*/
 
 