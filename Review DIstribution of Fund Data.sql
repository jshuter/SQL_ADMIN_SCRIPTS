
SELECT * from op.Fund_Master a left join SMTR.PUB.Hedge_Fund b on a.ACCOUNT_INT = b.FUND_INT 

select 

	AM.NUMBER_INT as 'AM' 
	, FM.ACCOUNT_INT as 'FM' 

	, PF.FUND_INT as 'PF' 
	,  EF.FUND_INT as 'EF' 
	, HF.FUND_INT as 'pub HF' 
	, PH.FUND_INT as 'priv HF' 
	, PA.FUND_INT as 'Priv Alt' 

	, ISNULL(PF.FUND_INT,0) 
	+ ISNULL(EF.FUND_INT,0) 
	+ ISNULL(HF.FUND_INT,0) 
	+ ISNULL(PH.FUND_INT ,0) 
	+ ISNULL(PA.FUND_INT,0)  as TOT

	, AM.STATUS_CHR

	, ISNULL(RSA.RISK_GROUP_CHR,'missing') AS 'RSA GRP' 
	, ISNULL(RSA.RISK_SUB_GROUP_CHR,'missing') AS 'RSA SUB GRP' 

from 
	SMTR.OP.Account_Master AM
	inner join SMTR.OP.Fund_Master FM				ON AM.NUMBER_INT = FM.ACCOUNT_INT 
	inner join SMTR.OP.X_Risk_Sub_Asset RSA			ON FM.RISK_SUB_GROUP_CHR = RSA.RISK_SUB_GROUP_CHR

	left outer join SMTR.PUB.Public_Fund PF			ON FM.ACCOUNT_INT = PF.FUND_INT
	Left Outer join SMTR.PUB.Exchange_Fund EF		ON FM.ACCOUNT_INT = EF.FUND_INT 
	Left Outer join SMTR.PUB.Hedge_Fund HF			ON FM.ACCOUNT_INT = HF.FUND_INT 
	Left Outer join SMTR.PE.PRIVATE_HEDGE PH		ON FM.ACCOUNT_INT = PH.FUND_INT 
	Left Outer JOIN SMTR.PE.PRIVATE_ALTERNATIVE PA	ON FM.ACCOUNT_INT = PA.FUND_INT
