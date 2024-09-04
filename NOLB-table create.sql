USE [netForumSCOUTSTest]
GO


CREATE TABLE [dbo].[client_scouts_discount](
	[z80_key] [dbo].[av_key] ROWGUIDCOL  NOT NULL,
	-- custom below 
	[z80_key] [dbo].[av_key] ROWGUIDCOL  NOT NULL,
	-- custom above 
	[z80_add_user] [dbo].[av_user] NOT NULL,
	[z80_add_date] [dbo].[av_date] NOT NULL,
	[z80_change_user] [dbo].[av_user] NULL,
	[z80_change_date] [dbo].[av_date] NULL,
	[z80_delete_flag] [dbo].[av_delete_flag] NOT NULL,
	[z80_entity_key] [dbo].[av_key] NULL,
 CONSTRAINT [PK_client_scouts_discount] PRIMARY KEY CLUSTERED 
(
	[z80_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_key]  DEFAULT (newid()) FOR [z80_key]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_add_user]  DEFAULT (suser_sname()) FOR [z80_add_user]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_add_date]  DEFAULT (getdate()) FOR [z80_add_date]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_delete_flag]  DEFAULT ((0)) FOR [z80_delete_flag]
GO


