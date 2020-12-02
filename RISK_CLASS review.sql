select * from OP.X_Risk_Sub_Asset RSA

select FM.* , RSA.RISK_GROUP_CHR, RSA.Description_CHR
from 		 OP.Fund_Master FM	-- 259 
	left  join OP.X_Risk_Sub_Asset RSA
	ON FM.RISK_SUB_GROUP_CHR = RSA.RISK_SUB_GROUP_CHR


