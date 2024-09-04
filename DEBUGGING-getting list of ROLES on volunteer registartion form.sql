select top 100 * from co_organization_ext

select	rlt_code

from	client_scouts_mb_member_type_x_role (nolock)			-- << A02 ...
join	co_relationship_type (nolock) on a02_rlt_code = rlt_code  -- << RLT_...
join	co_organization_ext (nolock) on org_cst_key_ext='744EC8F0-1E38-4A9D-98C9-0007380B08BF' -- @org_cst_key

where	rlt_delete_flag = 0 
and		rlt_type		= 'Ind_Org'
and		rlt_code		not like '%Rover%Parti%'

and		a02_mbt_key		= 'AF0C862E-0C1C-4C50-B9D1-7F3DB3225F9E' -- @mbt_key -- VOLUNTEER 
and		a02_a01_key		= org_a01_key_ext 
and		a02_delete_flag = 0


			and		(	(@useListOfRoles > 0 and rlt_code in (select value from @validRoles))
					 or	(@useListOfRoles = 0))



-- 368 
select COUNT(*) from client_scouts_mb_member_type_x_role
-- 365 -- 
select COUNT(*) from co_relationship_type -- (nolock) on a02_rlt_code = rlt_code  -- << RLT_...
-- 28,558 
select COUNT(*) from co_organization_ext  --(nolock) on org_cst_key_ext='744EC8F0-1E38-4A9D-98C9-0007380B08BF' -- @org_cst_key



select top 10 * from co_organization  where org_ogt_code='Section' 


 cst_key = '45F087BD-2563-4A32-84D1-000512AFADB9'
D345A871-1460-4004-ACD2-1B6CAEA722AD
24870A70-AB72-4814-8E80-1E0B96D2B792
E5705AEB-F34E-414A-9100-283E6A13ABEA
BBB1E091-CAF1-46DE-AD26-37C990A32EA4
C93E6597-5E66-406C-BB42-5B205F2AD548
69A31B58-EF7D-4818-A97F-5C3907A5EF1E
8F0E8A05-F189-47BA-B663-63D383B5330D
661E5CCE-7EE2-46C5-964D-68B9ADA0D2CA
22BDA4C8-B2DA-453D-B2FA-9E612890CCF5
B3A44ECB-AD46-4D11-92FD-A782BB6C5521
FA7BC0B1-DAFF-4870-A767-B4A01128DE43
D895BF0A-86B5-4559-8723-BCA965D48620
D39E50A0-5E30-4330-84B7-EC1AA2C1D6C2
4E959970-2680-488F-949E-F6B59A389EFA
FCABBB2D-C895-4505-B3B0-FC610E9FD785
00483510-3E94-4953-B854-FCCBA08FF12A
11815738-8334-4705-8698-0005F574EF62
B86AD97B-AFFE-4309-A1B0-0011A2F8BF96
F7F9370D-11E4-44CD-960F-001B7C864E75
2650D728-7634-4653-8A62-001D48B38EF5
807616F4-F17E-448E-8BC4-002122B1EECF
6AA2A61B-EA30-49CE-AF85-0024D7014B6F
C9750CF1-2B44-41FB-B3E1-0024FE73AE6F
EE71D5B0-9F97-4688-877F-0025B3934F6C
73DA2E6F-4D59-4255-9224-003D33DDCD35
04E654E3-F52A-497B-987C-0040D283C49A
E7ADFEAF-5E62-4D86-B966-00417F767E23
49048B33-25F7-4E62-9755-00456BECDBB8
AB677D4B-C48E-48AE-9DDB-005C6A66737C
0542CDA5-30D6-4788-A8A2-0062755F47BE
02598177-A088-44D8-AFE8-00676775198E
C4F3FB9D-6EFB-4174-9448-006C9119B136
0D87B8CD-3B31-4EF7-9D14-006E3830395B
3C839D6F-AE6A-400D-BD11-0070A264EF3D
45F4C30C-E4AE-4BDC-8B59-0077632C52E9
63984045-F08B-424B-BFDE-0077A7F5D6E2
E804AEB9-F03B-452E-898F-007971A7FC6B
6C0132EF-4733-4692-8073-007AECECCDFA
F145FD40-161F-4B6D-B8B3-008075E1E963
3884FD03-CD7A-4753-9C37-00899A0B1658
7970D783-AE9E-4C95-9BC1-008B38FD4AFE
C46FE05F-A4CE-4F08-8C64-0095C79A7D4A
BF9FE65A-58D0-4083-B84C-0099E74B1389
73AAB6CF-6FBF-4E22-8E35-00BA434ACB69
6866C182-FCCF-4737-B746-00BE2C1CA030
C3763047-7B12-49FC-BAD0-00BE5BC9913E
78E8E751-D779-4405-AD79-00C3ACCE7171
6942E65C-23B1-4DE0-B36B-00CC24E733C7
D4910208-872A-442F-9765-00CC7D8BB8AA
181472B2-F177-4264-B470-00CE2BE59113
B8695626-4DF7-4111-ABD0-00DCC579C573
9C303D85-0F33-494E-BF82-00E9100D8392
5CCFE1D6-8657-4011-9D9A-00F572D37920
949011BD-4B65-47F7-BE52-00FD13AFB55C
DE67E929-BFAD-47D9-A571-00FDAD98E0B5
043C067C-348D-4A18-A8FD-01020AF35A3C
D8676EAD-082D-4C8F-85A4-0104EC1C5D93
C7A33EE6-2871-4BF3-A499-010A12EAF665
4F6451DF-B7AD-4981-9498-0114AF923203
6E6FC1F9-AB85-4BF0-B81B-0118A46EE0E7
81C57CFA-B200-4570-A538-0128F485A903
75416155-979B-4AA9-9B20-012B26443109
048C1954-E7E0-4274-808C-012BCC63AF1F
2FFFD0FC-7A58-47D2-AABA-012D5660F78F
D595443E-C4C8-4DF1-9847-0136E7F8FFB4
F5C13005-9A7E-4751-B2CE-01449983F084
AD9A17C7-AD0A-4C35-896A-01469CA42315
0D55DD30-85E7-4B18-A135-015617EFCE15
86EAB939-B7EF-47A6-9282-015642066811
1FD5BD20-DA2D-4040-9C2D-015990748C02
41F6C385-6E50-4A9E-95FE-016E37EB9258
C1573D3C-CFAB-429F-8F4E-016FF2A4EC6A
DE43C3EF-06FE-4AF3-A641-0173275AA189
8B8A6CD7-E081-4E29-B7A1-017BCB8350ED
7F43FB30-93DD-4DFE-9ABC-017F65465444
22DA8430-D987-4BC4-94E3-0180A7E42603
3E28FB68-1151-454A-9C6A-01830788656E
D94623F5-91AF-44A2-9061-0189192CA3C1
E4FAE3F8-750F-4AFC-906A-018A66E46CBC
97BAE6F0-F97E-4C06-9F96-019E613B13F2
C73C3956-2E65-4DC4-89FD-01A720DDA79D
30A37479-6DC9-4877-8333-01AA8B9A74A3
A20330C3-2C8A-4225-8303-01AC84539EB6
59631B45-A3B0-4E2E-A9C4-01AC94DE318E
BBA3C956-4171-4868-9C9C-01AF8A73E342
902A1D5D-77DE-447C-B0E2-01BCAFCFEBBD
AE30F88C-5704-4B8B-9174-01BCE0AE0B70
63F58399-69DD-4B26-8C43-01C25264588B
4599EECE-2344-4D4F-B3F0-01C93802DC43
8D4A9BCB-91BC-4B89-8A7E-01CB1D6C1146
4590E5A7-FCFD-4914-8308-01CB71EFB888
E32754AC-8CB8-46EC-9BCC-01CDCC589362
2FB2C7BA-29C2-4C4F-A353-01D3480D373B
4F626ED8-5C58-4659-9B18-01DA7E11DCFB
563FC48D-A0A0-42F1-8F7D-01DC608CE973
CD3071BA-5D13-4A46-98DA-01F0AAC6E405
507E91E6-6143-491F-B775-021291DCC0D0
A82202DA-A55B-4D08-B26A-0212D0964E38
5285E4F8-1098-417C-8201-0218F0A76719