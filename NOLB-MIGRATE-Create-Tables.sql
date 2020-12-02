--- COMPLETED ON AUG 27 2015 

RETURN 


/****** Object:  Table [dbo].[client_scouts_discount]    Script Date: 08/27/2015 11:21:41 ******/
USE [netForumSCOUTS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[client_scouts_discount](
	[z80_key] [dbo].[av_key] ROWGUIDCOL  NOT NULL,
	[z80_add_user] [dbo].[av_user] NOT NULL,
	[z80_add_date] [dbo].[av_date] NOT NULL,
	[z80_change_user] [dbo].[av_user] NULL,
	[z80_change_date] [dbo].[av_date] NULL,
	[z80_delete_flag] [dbo].[av_delete_flag] NOT NULL,
	[z80_entity_key] [dbo].[av_key] NULL,
	[z80_expiry_date] [dbo].[av_date] NULL,
	[z80_discount_type] [varchar](10) NULL,
	[z80_discount_amount] [varchar](10) NULL,
	[z80_date_used] [dbo].[av_date] NULL,
	[z80_discount_request_key] [dbo].[av_key] NULL,
	[z80_discount_unit] [varchar](10) NULL,
	[z80_experimental_registration_key] [dbo].[av_key] NULL,
	[z80_cancelled_flag] [dbo].[av_flag] NULL,
	[z80_prc_key] [dbo].[av_key] NULL,
 CONSTRAINT [PK_client_scouts_discount] PRIMARY KEY CLUSTERED 
(
	[z80_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [netForumSCOUTS]
GO

/****** Object:  Table [dbo].[client_scouts_discount_approval]    Script Date: 08/27/2015 11:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[client_scouts_discount_approval](
	[z81_key] [dbo].[av_key] ROWGUIDCOL  NOT NULL,
	[z81_add_user] [dbo].[av_user] NOT NULL,
	[z81_add_date] [dbo].[av_date] NOT NULL,
	[z81_change_user] [dbo].[av_user] NULL,
	[z81_change_date] [dbo].[av_date] NULL,
	[z81_delete_flag] [dbo].[av_delete_flag] NOT NULL,
	[z81_entity_key] [dbo].[av_key] NULL,
	[z81_approver_cst_key] [dbo].[av_key] NULL,
	[z81_status] [varchar](10) NULL,
	[z81_discount_request_key] [dbo].[av_key] NULL,
	[z81_approved_by] [varchar](500) NULL,
 CONSTRAINT [PK_client_scouts_discount_approval] PRIMARY KEY CLUSTERED 
(
	[z81_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'primary key to discount approval record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'client_scouts_discount_approval', @level2type=N'COLUMN',@level2name=N'z81_key'
GO

USE [netForumSCOUTS]
GO

/****** Object:  Table [dbo].[client_scouts_discount_request]    Script Date: 08/27/2015 11:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[client_scouts_discount_request](
	[z78_key] [dbo].[av_key] ROWGUIDCOL  NOT NULL,
	[z78_family_income] [int] NOT NULL,
	[z78_child_count] [smallint] NOT NULL,
	[z78_add_user] [dbo].[av_user] NOT NULL,
	[z78_add_date] [dbo].[av_date] NOT NULL,
	[z78_change_user] [dbo].[av_user] NULL,
	[z78_change_date] [dbo].[av_date] NULL,
	[z78_delete_flag] [dbo].[av_delete_flag] NOT NULL,
	[z78_status] [varchar](12) NOT NULL,
	[z78_cst_key] [dbo].[av_key] NULL,
	[z78_council_key] [dbo].[av_key] NULL,
	[z78_group_key] [dbo].[av_key] NULL,
	[z78_family_size] [smallint] NULL,
 CONSTRAINT [PK_client_scouts_discount_request] PRIMARY KEY CLUSTERED 
(
	[z78_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [netForumSCOUTS]
GO

/****** Object:  Table [dbo].[client_scouts_discount_type]    Script Date: 08/27/2015 11:21:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[client_scouts_discount_type](
	[z79_key] [dbo].[av_key] ROWGUIDCOL  NOT NULL,
	[z79_add_user] [dbo].[av_user] NOT NULL,
	[z79_add_date] [dbo].[av_date] NOT NULL,
	[z79_change_user] [dbo].[av_user] NULL,
	[z79_change_date] [dbo].[av_date] NULL,
	[z79_delete_flag] [dbo].[av_delete_flag] NOT NULL,
	[z79_entity_key] [dbo].[av_key] NULL,
 CONSTRAINT [PK_client_scouts_discount_type] PRIMARY KEY CLUSTERED 
(
	[z79_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[client_scouts_discount]  WITH CHECK ADD  CONSTRAINT [FK_client_scouts_discount_client_scouts_discount] FOREIGN KEY([z80_discount_request_key])
REFERENCES [dbo].[client_scouts_discount_request] ([z78_key])
GO

ALTER TABLE [dbo].[client_scouts_discount] CHECK CONSTRAINT [FK_client_scouts_discount_client_scouts_discount]
GO

ALTER TABLE [dbo].[client_scouts_discount]  WITH CHECK ADD  CONSTRAINT [FK_client_scouts_discount_client_scouts_experimental_registration] FOREIGN KEY([z80_experimental_registration_key])
REFERENCES [dbo].[client_scouts_experimental_registration] ([x13_key])
GO

ALTER TABLE [dbo].[client_scouts_discount] CHECK CONSTRAINT [FK_client_scouts_discount_client_scouts_experimental_registration]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_key]  DEFAULT (newid()) FOR [z80_key]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_add_user]  DEFAULT (suser_sname()) FOR [z80_add_user]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_add_date]  DEFAULT (getdate()) FOR [z80_add_date]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_delete_flag]  DEFAULT ((0)) FOR [z80_delete_flag]
GO

ALTER TABLE [dbo].[client_scouts_discount] ADD  CONSTRAINT [DF_client_scouts_discount_z80_cancelled]  DEFAULT ((0)) FOR [z80_cancelled_flag]
GO

ALTER TABLE [dbo].[client_scouts_discount_approval] ADD  CONSTRAINT [DF_client_scouts_discount_approval_z81_key]  DEFAULT (newid()) FOR [z81_key]
GO

ALTER TABLE [dbo].[client_scouts_discount_approval] ADD  CONSTRAINT [DF_client_scouts_discount_approval_z81_add_user]  DEFAULT (suser_sname()) FOR [z81_add_user]
GO

ALTER TABLE [dbo].[client_scouts_discount_approval] ADD  CONSTRAINT [DF_client_scouts_discount_approval_z81_add_date]  DEFAULT (getdate()) FOR [z81_add_date]
GO

ALTER TABLE [dbo].[client_scouts_discount_approval] ADD  CONSTRAINT [DF_client_scouts_discount_approval_z81_delete_flag]  DEFAULT ((0)) FOR [z81_delete_flag]
GO

ALTER TABLE [dbo].[client_scouts_discount_request]  WITH CHECK ADD  CONSTRAINT [FK_client_scouts_discount_request_co_customer] FOREIGN KEY([z78_cst_key])
REFERENCES [dbo].[co_customer] ([cst_key])
GO

ALTER TABLE [dbo].[client_scouts_discount_request] CHECK CONSTRAINT [FK_client_scouts_discount_request_co_customer]
GO

ALTER TABLE [dbo].[client_scouts_discount_request]  WITH CHECK ADD  CONSTRAINT [CK_discount_request_status] CHECK  (([z78_status]='deny' OR [z78_status]='approve' OR [z78_status]='new'))
GO

ALTER TABLE [dbo].[client_scouts_discount_request] CHECK CONSTRAINT [CK_discount_request_status]
GO

ALTER TABLE [dbo].[client_scouts_discount_request] ADD  CONSTRAINT [DF_client_scouts_discount_request_z78_key]  DEFAULT (newid()) FOR [z78_key]
GO

ALTER TABLE [dbo].[client_scouts_discount_request] ADD  CONSTRAINT [DF_client_scouts_discount_request_z78_add_user]  DEFAULT (suser_sname()) FOR [z78_add_user]
GO

ALTER TABLE [dbo].[client_scouts_discount_request] ADD  CONSTRAINT [DF_client_scouts_discount_request_z78_add_date]  DEFAULT (getdate()) FOR [z78_add_date]
GO

ALTER TABLE [dbo].[client_scouts_discount_request] ADD  CONSTRAINT [DF_client_scouts_discount_request_z78_delete_flag]  DEFAULT ((0)) FOR [z78_delete_flag]
GO

ALTER TABLE [dbo].[client_scouts_discount_request] ADD  CONSTRAINT [DF_client_scouts_discount_request_z78_status]  DEFAULT ('new') FOR [z78_status]
GO

ALTER TABLE [dbo].[client_scouts_discount_type] ADD  CONSTRAINT [DF_client_scouts_discount_type_z79_key]  DEFAULT (newid()) FOR [z79_key]
GO

ALTER TABLE [dbo].[client_scouts_discount_type] ADD  CONSTRAINT [DF_client_scouts_discount_type_z79_add_user]  DEFAULT (suser_sname()) FOR [z79_add_user]
GO

ALTER TABLE [dbo].[client_scouts_discount_type] ADD  CONSTRAINT [DF_client_scouts_discount_type_z79_add_date]  DEFAULT (getdate()) FOR [z79_add_date]
GO

ALTER TABLE [dbo].[client_scouts_discount_type] ADD  CONSTRAINT [DF_client_scouts_discount_type_z79_delete_flag]  DEFAULT ((0)) FOR [z79_delete_flag]
GO


