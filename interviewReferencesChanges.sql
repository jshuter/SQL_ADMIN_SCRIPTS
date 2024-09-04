begin transaction

-- each reference should be associated to 1 or more organizations
CREATE TABLE client_scouts_volunteer_screening_reference_x_co_organization(
	z27_key av_key ROWGUIDCOL not null CONSTRAINT [DF_client_scouts_volunteer_screening_reference_x_co_organization_z27_key]  DEFAULT (newid()),
	z27_z22_key av_key not null,
	z27_org_cst_key av_key not null,
	z27_add_user av_user not null CONSTRAINT [DF_client_scouts_volunteer_screening_reference_x_co_organization_z27_add_user]  DEFAULT (suser_sname()),
	z27_add_date av_date not null CONSTRAINT [DF_client_scouts_volunteer_screening_reference_x_co_organization_z27_add_date]  DEFAULT (getdate()),
	z27_change_user av_user null,
	z27_change_date av_date null,
	z27_delete_flag av_delete_flag not null CONSTRAINT [DF_client_scouts_volunteer_screening_reference_x_co_organization_z27_delete_flag]  DEFAULT ((0)),
	CONSTRAINT [PK_client_scouts_volunteer_screening_reference_x_co_organization] PRIMARY KEY CLUSTERED 
	(
		[z27_key] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)

ALTER TABLE [dbo].[client_scouts_volunteer_screening_reference_x_co_organization]  WITH CHECK ADD CONSTRAINT [FK_client_scouts_volunteer_screening_reference_x_co_organization_co_organization] FOREIGN KEY([z27_org_cst_key])
REFERENCES [dbo].[co_organization] ([org_cst_key])
GO

ALTER TABLE [dbo].[client_scouts_volunteer_screening_reference_x_co_organization]  WITH CHECK ADD CONSTRAINT [FK_client_scouts_volunteer_screening_reference_x_co_organization_client_scouts_volunteer_screening_reference] FOREIGN KEY([z27_z22_key])
REFERENCES [dbo].[client_scouts_volunteer_screening_reference] ([z22_key])
GO

/* 

This executed on production on JULY 5 
so that necessary dependencies for new functions etc 
would exist. - JSS - July 5

-- each interview should be associated to an organization

ALTER TABLE client_scouts_volunteer_screening ADD z21_org_cst_key av_key NULL
GO

*/ 

ALTER TABLE [dbo].[client_scouts_volunteer_screening]  WITH CHECK ADD CONSTRAINT [FK_client_scouts_volunteer_screening_co_organization] FOREIGN KEY([z21_org_cst_key])
REFERENCES [dbo].[co_organization] ([org_cst_key])
GO

INSERT INTO md_table (mdt_key,mdt_key_column,mdt_add_user,mdt_delete_flag,mdt_add_date,mdt_prefix,mdt_name,mdt_ignore_entity,mdt_description)
		VALUES(NEWID(),'z27_key','MyScouts',0,GETDATE(),'z27','client_scouts_volunteer_screening_reference_x_co_organization',0,'')

INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',1,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,16,0,'av_key',0,0,16,0,0,0,0,0,0,0,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_key','metadata')
INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',1,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,16,0,'av_key',0,0,16,0,0,0,0,0,0,0,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_z22_key','metadata')
INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',1,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,16,0,'av_key',0,0,16,0,0,0,0,0,0,0,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_org_cst_key','metadata')
INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',1,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,64,0,'av_user',0,0,64,0,0,0,0,0,0,0,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_add_user','metadata')
INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',1,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,20,0,'av_date',0,0,20,0,0,0,0,0,0,0,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_add_date','metadata')
INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',0,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,64,0,'av_user',0,0,64,0,0,0,0,0,0,1,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_change_user','metadata')
INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',0,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,20,0,'av_date',0,0,20,0,0,0,0,0,0,1,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_change_date','metadata')
INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',1,0,GETDATE(),'client_scouts_volunteer_screening_reference_x_co_organization',0,1,0,'av_delete_flag',0,0,1,0,0,0,0,0,0,0,0,0,'client_scouts_volunteer_screening_reference_x_co_organization','z27_delete_flag','metadata')

INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
		VALUES ('MyScouts',0,0,GETDATE(),'client_scouts_volunteer_screening',0,16,0,'av_key',0,0,16,0,0,0,0,0,0,1,0,0,'client_scouts_volunteer_screening','z21_org_cst_key','metadata')


-- each interview should be associated to 1 organization
ALTER TABLE client_scouts_approval_record ADD z26_org_cst_key av_key NULL
GO

ALTER TABLE [dbo].[client_scouts_approval_record]  WITH CHECK ADD CONSTRAINT [FK_client_scouts_approval_record_co_organization] FOREIGN KEY([z26_org_cst_key])
REFERENCES [dbo].[co_organization] ([org_cst_key])
GO

INSERT INTO md_column (mdc_add_user,mdc_required,mdc_available_in_social_flag,mdc_add_date,mdc_table_name,mdc_autopostback,mdc_width_max,mdc_not_editable,mdc_data_type,mdc_query_select_flag,mdc_readonly,mdc_width,mdc_ext,mdc_change_log_flag,mdc_has_lookup,mdc_readonlyedit,mdc_disable_autocomplete_flag,mdc_enable_subform_lookup_flag,mdc_nullable,mdc_hidden,mdc_delete_flag,mdc_mdt_name,mdc_name,mdc_description) 
VALUES ('MyScouts',0,0,GETDATE(),'client_scouts_approval_record',0,16,0,'av_key',0,0,16,0,0,0,0,0,0,1,0,0,'client_scouts_approval_record','z26_org_cst_key','metadata')

-- rollback




