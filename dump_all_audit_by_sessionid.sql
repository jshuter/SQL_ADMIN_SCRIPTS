﻿use SMTR_AUDIT 

declare @sid varchar(100) = '1B643692771D512D78C613C00AFFB1E8'
 
 if exists (SELECT * from TOOLS.Holiday_Master WHERE SESSIONID = @sid  )  SELECT * from TOOLS.Holiday_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Pooled_Fund_Parent WHERE SESSIONID = @sid  )  SELECT * from OP.Pooled_Fund_Parent WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Manager_Scope WHERE SESSIONID = @sid  )  SELECT * from OP.X_Manager_Scope WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Pooled_Funds_Child WHERE SESSIONID = @sid  )  SELECT * from OP.Pooled_Funds_Child WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Relationship_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Relationship_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.VAR_Error WHERE SESSIONID = @sid  )  SELECT * from PUB.VAR_Error WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_PSFT_Department WHERE SESSIONID = @sid  )  SELECT * from OP.X_PSFT_Department WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.VAR_Detail WHERE SESSIONID = @sid  )  SELECT * from PUB.VAR_Detail WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Note_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Note_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Holding_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Holding_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_Month WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_Month WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Security_Option_Future WHERE SESSIONID = @sid  )  SELECT * from PUB.Security_Option_Future WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.X_Fee_Type WHERE SESSIONID = @sid  )  SELECT * from PE.X_Fee_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Security_FI_Bond WHERE SESSIONID = @sid  )  SELECT * from PUB.Security_FI_Bond WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.X_Public_Fund_Type WHERE SESSIONID = @sid  )  SELECT * from PUB.X_Public_Fund_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Security_FI_Pooled_Fund WHERE SESSIONID = @sid  )  SELECT * from PUB.Security_FI_Pooled_Fund WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Hedge_Fund_Frequency_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Hedge_Fund_Frequency_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Security_Equity WHERE SESSIONID = @sid  )  SELECT * from PUB.Security_Equity WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Hedge_Fund_Structure WHERE SESSIONID = @sid  )  SELECT * from OP.X_Hedge_Fund_Structure WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Security_Cash WHERE SESSIONID = @sid  )  SELECT * from OP.Security_Cash WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Hedge_Fund_Strategy WHERE SESSIONID = @sid  )  SELECT * from OP.Hedge_Fund_Strategy WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Manager_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Manager_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Hedge_Fund_Sub_Strategy WHERE SESSIONID = @sid  )  SELECT * from OP.Hedge_Fund_Sub_Strategy WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Manager_Note_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Manager_Note_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Split_Transactions WHERE SESSIONID = @sid  )  SELECT * from OP.Split_Transactions WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Frequency WHERE SESSIONID = @sid  )  SELECT * from OP.X_Frequency WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Split_Transaction_Detail WHERE SESSIONID = @sid  )  SELECT * from OP.Split_Transaction_Detail WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Fund_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Fund_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_GL_Account_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_GL_Account_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Transaction_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Transaction_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Holding_Status WHERE SESSIONID = @sid  )  SELECT * from OP.X_Holding_Status WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Forward_Transaction WHERE SESSIONID = @sid  )  SELECT * from PUB.Forward_Transaction WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Asset_Class WHERE SESSIONID = @sid  )  SELECT * from OP.X_Asset_Class WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Forward_Counterparty WHERE SESSIONID = @sid  )  SELECT * from PUB.Forward_Counterparty WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Security_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Security_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Transaction_Note_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Transaction_Note_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Security_Subtype WHERE SESSIONID = @sid  )  SELECT * from OP.X_Security_Subtype WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Transaction_Detail WHERE SESSIONID = @sid  )  SELECT * from OP.Transaction_Detail WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.X_Derivative_Trade_Type WHERE SESSIONID = @sid  )  SELECT * from PUB.X_Derivative_Trade_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Public_Fund WHERE SESSIONID = @sid  )  SELECT * from PUB.Public_Fund WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.X_Security_Derivative_Option_Type WHERE SESSIONID = @sid  )  SELECT * from PUB.X_Security_Derivative_Option_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.AUM_Management_Fee WHERE SESSIONID = @sid  )  SELECT * from PUB.AUM_Management_Fee WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Account_Status WHERE SESSIONID = @sid  )  SELECT * from OP.X_Account_Status WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Hedge_Fund WHERE SESSIONID = @sid  )  SELECT * from PUB.Hedge_Fund WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_Log_Source WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_Log_Source WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Exchange_Fund WHERE SESSIONID = @sid  )  SELECT * from PUB.Exchange_Fund WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_User_Status WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_User_Status WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Private_Alternative WHERE SESSIONID = @sid  )  SELECT * from PE.Private_Alternative WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_Period_Status WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_Period_Status WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Private_Fund_Stage WHERE SESSIONID = @sid  )  SELECT * from PE.Private_Fund_Stage WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_Session_Staus WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_Session_Staus WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Security_Private_Asset WHERE SESSIONID = @sid  )  SELECT * from PE.Security_Private_Asset WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Account_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Account_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Market_Value_Adjustment WHERE SESSIONID = @sid  )  SELECT * from PE.Market_Value_Adjustment WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Transaction_Detail_Direction WHERE SESSIONID = @sid  )  SELECT * from OP.X_Transaction_Detail_Direction WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Security_Private_Asset_Sector WHERE SESSIONID = @sid  )  SELECT * from PE.Security_Private_Asset_Sector WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_GL_Master WHERE SESSIONID = @sid  )  SELECT * from OP.X_GL_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Security_Private_Asset_Class WHERE SESSIONID = @sid  )  SELECT * from PE.Security_Private_Asset_Class WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_GL_Group_Name WHERE SESSIONID = @sid  )  SELECT * from OP.X_GL_Group_Name WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Security_Private_Asset_Stage WHERE SESSIONID = @sid  )  SELECT * from PE.Security_Private_Asset_Stage WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.GL_Account_Multiplier WHERE SESSIONID = @sid  )  SELECT * from OP.GL_Account_Multiplier WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Management_Fees WHERE SESSIONID = @sid  )  SELECT * from PE.Management_Fees WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Ltd_Partner WHERE SESSIONID = @sid  )  SELECT * from PE.Ltd_Partner WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Transaction_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Transaction_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Private_Fund_Commitment WHERE SESSIONID = @sid  )  SELECT * from PE.Private_Fund_Commitment WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Transaction_Subtype WHERE SESSIONID = @sid  )  SELECT * from OP.X_Transaction_Subtype WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Account_Source WHERE SESSIONID = @sid  )  SELECT * from OP.X_Account_Source WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.X_Private_Asset_Status WHERE SESSIONID = @sid  )  SELECT * from PE.X_Private_Asset_Status WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.X_Private_Fund_Status WHERE SESSIONID = @sid  )  SELECT * from PE.X_Private_Fund_Status WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.Accounting_Period_Master WHERE SESSIONID = @sid  )  SELECT * from CTRL.Accounting_Period_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_Role WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_Role WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.User_Master WHERE SESSIONID = @sid  )  SELECT * from CTRL.User_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.Session_Master WHERE SESSIONID = @sid  )  SELECT * from CTRL.Session_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.Session_Log WHERE SESSIONID = @sid  )  SELECT * from CTRL.Session_Log WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Account_Scope WHERE SESSIONID = @sid  )  SELECT * from OP.X_Account_Scope WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Account_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Account_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Account_Link WHERE SESSIONID = @sid  )  SELECT * from OP.Account_Link WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.VAR_Master WHERE SESSIONID = @sid  )  SELECT * from PUB.VAR_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.VAR_Hedge WHERE SESSIONID = @sid  )  SELECT * from PUB.VAR_Hedge WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Account_Note_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Account_Note_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Performance_Return WHERE SESSIONID = @sid  )  SELECT * from OP.Performance_Return WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Account_Groups_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Account_Groups_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Index_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Index_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Fund_Performance_Objective WHERE SESSIONID = @sid  )  SELECT * from OP.Fund_Performance_Objective WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Asset_Class_Policy WHERE SESSIONID = @sid  )  SELECT * from OP.Asset_Class_Policy WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Blended_Benchmark WHERE SESSIONID = @sid  )  SELECT * from OP.Blended_Benchmark WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.XML_Library WHERE SESSIONID = @sid  )  SELECT * from TOOLS.XML_Library WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.X_Security_Private_Asset_Stage WHERE SESSIONID = @sid  )  SELECT * from PE.X_Security_Private_Asset_Stage WHERE SESSIONID =  @sid  
 if exists (SELECT * from PUB.Custodian_Security_Change_Master WHERE SESSIONID = @sid  )  SELECT * from PUB.Custodian_Security_Change_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Source_Of_Funds WHERE SESSIONID = @sid  )  SELECT * from OP.Source_Of_Funds WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Geo_Weight WHERE SESSIONID = @sid  )  SELECT * from OP.Geo_Weight WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Allocated_Transaction_Master WHERE SESSIONID = @sid  )  SELECT * from PE.Allocated_Transaction_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Allocated_Transaction_Detail WHERE SESSIONID = @sid  )  SELECT * from PE.Allocated_Transaction_Detail WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Account_Group_Name WHERE SESSIONID = @sid  )  SELECT * from OP.X_Account_Group_Name WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Transaction_Matrix WHERE SESSIONID = @sid  )  SELECT * from OP.Transaction_Matrix WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Custodian_Security_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Custodian_Security_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Currency WHERE SESSIONID = @sid  )  SELECT * from OP.X_Currency WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Asset_Class_Scope WHERE SESSIONID = @sid  )  SELECT * from OP.X_Asset_Class_Scope WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Index_Type WHERE SESSIONID = @sid  )  SELECT * from OP.X_Index_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.CMPA_Yearly_NAV_Final WHERE SESSIONID = @sid  )  SELECT * from OP.CMPA_Yearly_NAV_Final WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Alternate_Currency WHERE SESSIONID = @sid  )  SELECT * from OP.X_Alternate_Currency WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_Log_Level WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_Log_Level WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.Report_Notes WHERE SESSIONID = @sid  )  SELECT * from TOOLS.Report_Notes WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.FX_Rate_Master WHERE SESSIONID = @sid  )  SELECT * from OP.FX_Rate_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Market_Value_Adjustment_Link WHERE SESSIONID = @sid  )  SELECT * from PE.Market_Value_Adjustment_Link WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Fund_Mandate WHERE SESSIONID = @sid  )  SELECT * from OP.X_Fund_Mandate WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Country WHERE SESSIONID = @sid  )  SELECT * from OP.X_Country WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.IRR_Bulk_Output WHERE SESSIONID = @sid  )  SELECT * from TOOLS.IRR_Bulk_Output WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Fund_Strategy WHERE SESSIONID = @sid  )  SELECT * from OP.X_Fund_Strategy WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Fund_Ownership WHERE SESSIONID = @sid  )  SELECT * from OP.Fund_Ownership WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Security_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Security_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.X_Private_Fund_Type WHERE SESSIONID = @sid  )  SELECT * from PE.X_Private_Fund_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_GICS_Master WHERE SESSIONID = @sid  )  SELECT * from OP.X_GICS_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Private_Fund WHERE SESSIONID = @sid  )  SELECT * from PE.Private_Fund WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Custodian_Cash_Link WHERE SESSIONID = @sid  )  SELECT * from OP.Custodian_Cash_Link WHERE SESSIONID =  @sid  
 if exists (SELECT * from PE.Private_Hedge WHERE SESSIONID = @sid  )  SELECT * from PE.Private_Hedge WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Custodian_Security_Asset_Class WHERE SESSIONID = @sid  )  SELECT * from OP.X_Custodian_Security_Asset_Class WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Risk_Asset WHERE SESSIONID = @sid  )  SELECT * from OP.X_Risk_Asset WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Security_Note_Master WHERE SESSIONID = @sid  )  SELECT * from OP.Security_Note_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Risk_Sub_Asset WHERE SESSIONID = @sid  )  SELECT * from OP.X_Risk_Sub_Asset WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.Job_History WHERE SESSIONID = @sid  )  SELECT * from TOOLS.Job_History WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.X_Option_Delivery_Month_Codes WHERE SESSIONID = @sid  )  SELECT * from OP.X_Option_Delivery_Month_Codes WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Security_Hedge_Fund WHERE SESSIONID = @sid  )  SELECT * from OP.Security_Hedge_Fund WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Risk_Targets WHERE SESSIONID = @sid  )  SELECT * from OP.Risk_Targets WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.X_Report_Status WHERE SESSIONID = @sid  )  SELECT * from TOOLS.X_Report_Status WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Hedge_Fund_Benchmark WHERE SESSIONID = @sid  )  SELECT * from OP.Hedge_Fund_Benchmark WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.Date_Master WHERE SESSIONID = @sid  )  SELECT * from TOOLS.Date_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Risk_Sub_Asset_Benchmark WHERE SESSIONID = @sid  )  SELECT * from OP.Risk_Sub_Asset_Benchmark WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Hedge_Fund_Frequency WHERE SESSIONID = @sid  )  SELECT * from OP.Hedge_Fund_Frequency WHERE SESSIONID =  @sid  
 if exists (SELECT * from CTRL.X_Email_Type WHERE SESSIONID = @sid  )  SELECT * from CTRL.X_Email_Type WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.Report_Job_Master WHERE SESSIONID = @sid  )  SELECT * from TOOLS.Report_Job_Master WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.Report_User_Link WHERE SESSIONID = @sid  )  SELECT * from TOOLS.Report_User_Link WHERE SESSIONID =  @sid  
 if exists (SELECT * from OP.Hedge_Fund_Relationship WHERE SESSIONID = @sid  )  SELECT * from OP.Hedge_Fund_Relationship WHERE SESSIONID =  @sid  
 if exists (SELECT * from TOOLS.X_Holiday_Type WHERE SESSIONID = @sid  )  SELECT * from TOOLS.X_Holiday_Type WHERE SESSIONID =  @sid  
