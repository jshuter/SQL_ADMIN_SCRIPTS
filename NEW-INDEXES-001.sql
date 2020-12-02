

use netForumSCOUTSTest
go 

sp_help [client_scouts_compliance_tracking]

INDEX FOR [client_scouts_compliance_tracking]

[c01_ind_cst_key]										[netForumSCOUTSTest].[dbo].[client_scouts_compliance_tracking]

-- ONLY 1 INDEX - c01_key 

/* CREATED INDEX 

CREATE NONCLUSTERED INDEX IX_client_scouts_compliance_tracking_c01_ind_cst_key     ON dbo.[client_scouts_compliance_tracking] (c01_ind_cst_key);

*/


------------ =========================================================================================


sp_help [client_scouts_experimental_registration]


-- ONLY 1 INDEX - x13_key 


INDEX FOR [client_scouts_experimental_registration] 

[x13_ind_cst_key_2]										[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
[x13_ind_cst_key_2]		[x13_progress]	NULL	NULL	[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]
[x13_ind_cst_key_2]		[x13_progress],[x13_type] 		[netForumSCOUTSTest].[dbo].[client_scouts_experimental_registration]

-- from SP - delete_registration 
x13_ixo_key - used in join (col: joined IXO table:ixo_key) -> simple index ??

-- from listing_xweb

SELECT x13_key,x13_type x13_progress,x13_source 
WHERE 
	x13_ind_cst_key_1 = parent.ind_cst_key
	x13_ind_cst_key_2 = child.ind_cst_key
	x13_org_cst_key = org_cst_key
	x13_mbt_key = mbt_key
	x13_inv_key = inv_key
	x13_ixo_key = ixo_key

/* CREATED INDEXES 

- EXECUTED on MAR 5 2015 - DEV 

CREATE NONCLUSTERED INDEX IX_client_scouts_experimental_registration_x13_ind_cst_key_1 ON dbo.[client_scouts_experimental_registration] (x13_ind_cst_key_1);
CREATE NONCLUSTERED INDEX IX_client_scouts_experimental_registration_x13_ind_cst_key_2 ON dbo.[client_scouts_experimental_registration] (x13_ind_cst_key_2);
CREATE NONCLUSTERED INDEX IX_client_scouts_experimental_registration_x13_org_cst_key ON dbo.[client_scouts_experimental_registration] (x13_org_cst_key);
CREATE NONCLUSTERED INDEX IX_client_scouts_experimental_registration_x13_mbt_key     ON dbo.[client_scouts_experimental_registration] (x13_mbt_key);
CREATE NONCLUSTERED INDEX IX_client_scouts_experimental_registration_x13_inv_key     ON dbo.[client_scouts_experimental_registration] (x13_inv_key);
CREATE NONCLUSTERED INDEX IX_client_scouts_experimental_registration_x13_ixo_key     ON dbo.[client_scouts_experimental_registration] (x13_ixo_key);

*/


 
-- from batch_invoice
	x13_inv_key
	x13_ind_cst_key_2
	x13_org_cst_key
	
-- batch detail 
	x13_mbt_key

	
FK_client_scouts_experimental_registration_ac_invoice						x13_inv_key			REFERENCES netForumSCOUTSTest.dbo.ac_invoice (inv_key)
FK_client_scouts_experimental_registration_co_individual					x13_ind_cst_key_1  	REFERENCES netForumSCOUTSTest.dbo.co_individual (ind_cst_key)
FK_client_scouts_experimental_registration_co_individual_x_organization		x13_ixo_key  	 	REFERENCES netForumSCOUTSTest.dbo.co_individual_x_organization (ixo_key)
FK_client_scouts_experimental_registration_co_individual1					x13_ind_cst_key_2  	REFERENCES netForumSCOUTSTest.dbo.co_individual (ind_cst_key)
FK_client_scouts_experimental_registration_co_organization					x13_org_cst_key  	REFERENCES netForumSCOUTSTest.dbo.co_organization (org_cst_key)
FK_client_scouts_experimental_registration_mb_member_type					x13_mbt_key 	 	REFERENCES netForumSCOUTSTest.dbo.mb_member_type (mbt_key)


select COUNT(*) from client_scouts_experimental_registration -- 122000 
select COUNT(*) from client_scouts_member_registration --236000

sp_help co_individual 

