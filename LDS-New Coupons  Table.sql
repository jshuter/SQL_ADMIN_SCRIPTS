USE [netforumscoutsTest]
GO

/****** Object:  Table [dbo].[client_scouts_coupons]    Script Date: 05/25/2016 13:45:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[client_scouts_coupons](
	[z83_key] [dbo].[av_key] ROWGUIDCOL  NOT NULL,
	[z83_coupon_type] [varchar](10) NULL,
	[z83_coupon_amount] [varchar](10) NULL,
	[z83_coupon_unit] [varchar](10) NULL,
	[z83_expiry_date] [dbo].[av_date] NULL,
	[z83_org_cst_key] [dbo].[av_key] NULL,
	[z83_add_user] [dbo].[av_user] NOT NULL,
	[z83_add_date] [dbo].[av_date] NOT NULL,
	[z83_change_user] [dbo].[av_user] NULL,
	[z83_change_date] [dbo].[av_date] NULL,
	[z83_delete_flag] [dbo].[av_delete_flag] NOT NULL,
 CONSTRAINT [PK_client_scouts_coupons] PRIMARY KEY CLUSTERED 
(
	[z83_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[client_scouts_coupons] 
ADD  CONSTRAINT [DF_client_scouts_coupons_z83_key]  DEFAULT (newid()) FOR [z83_key]
GO

ALTER TABLE [dbo].[client_scouts_coupons] 
ADD  CONSTRAINT [DF_client_scouts_coupons_z83_add_user]  DEFAULT (suser_sname()) FOR [z83_add_user]
GO

ALTER TABLE [dbo].[client_scouts_coupons] 
ADD  CONSTRAINT [DF_client_scouts_coupons_z83_add_date]  DEFAULT (getdate()) FOR [z83_add_date]
GO

ALTER TABLE [dbo].[client_scouts_coupons] 
ADD  CONSTRAINT [DF_client_scouts_coupons_z83_delete_flag]  DEFAULT ((0)) FOR [z83_delete_flag]
GO



