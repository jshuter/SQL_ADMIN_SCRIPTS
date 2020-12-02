/* 
specific issues for PROD - to be reviewed and corrected 
* mosly renewals for ROVERS !
* with some exceptions 

*/

SELECT ixo_rlt_code, ind_rlt_code_ext, Ind.ind_mbt_code_ext, mbt.mbt_code  ,   * FROM 
co_individual_EXT ind
join co_individual_x_organization ixo on ixo.ixo_ind_cst_key = ind.ind_cst_key_ext
join co_individual_x_organization_ext ixoe on ixoe.ixo_key_ext = ixo.ixo_key
join mb_member_type mbt on mbt.mbt_key = ixoe.ixo_mbt_key_ext 
WHERE ind.ind_cst_key_ext IN ( 
'C7B9185A-B909-49A1-ADF8-C4033F2F1707',
'2A85F656-04F4-4A1A-A9A5-1A8F7467298C',
'D092BAAF-827B-408D-BB63-A8B3151FA68F',
'31EBEBB6-AE3F-43AF-9BC8-1450FB86660F',
'198CF1EA-F3BE-4084-AA8B-438E5B473352',
'58D46B19-82BF-490E-9225-6A44FE3A8DED') 
--AND ixo_status_ext = 'Active'
order by ind_cst_key_ext

/* 
*/

/* 
This process identifies CST_KEYS 
where IND Role is 'Volunteer' but all roles are 'Participant' 
*/ 

-- Can be used to correct data at ROLL OVER TIME ? 

-- 2AD023FF-3AC9-4619-828E-546B2A1ABC8E  - P 
-- AF0C862E-0C1C-4C50-B9D1-7F3DB3225F9E  - V 

select c.cst_recno, c.cst_eml_address_dn, c.cst_ind_full_name_dn, ie.ind_cst_key_ext, 

(select COUNT(*) from co_individual_x_organization A
join co_individual_x_organization_ext  B on a.ixo_key = B.ixo_key_ext
where a.ixo_ind_cst_key = ie.ind_cst_key_ext
and b.ixo_mbt_key_ext = '2AD023FF-3AC9-4619-828E-546B2A1ABC8E'
) as PART, 

(select COUNT(*) from co_individual_x_organization A
join co_individual_x_organization_ext  B on a.ixo_key = B.ixo_key_ext

where a.ixo_ind_cst_key = ie.ind_cst_key_ext
and b.ixo_mbt_key_ext = 'AF0C862E-0C1C-4C50-B9D1-7F3DB3225F9E'
) as VOL

from co_individual_ext ie join co_customer c on c.cst_key = ie.ind_cst_key_ext

where ie.ind_cst_key_ext in (

		-- ALL IND 'Volunteers' with 'Participant' Roles 
		-- 760 
		
		select distinct ie.ind_cst_key_ext -- , ie.ind_mbt_code_ext as indmbt, mbt_code as ixo_mbt  
		from co_individual_ext ie
		  left join co_individual_x_organization ixo on ie.ind_cst_key_ext = ixo.ixo_ind_cst_key
		  left join co_individual_x_organization_ext ixoe on ixo.ixo_key = ixoe.ixo_key_ext
			left join mb_member_type on mbt_key = ixoe.ixo_mbt_key_ext 
		where ie.ind_status_ext = 'Active' 
		and ixoe.ixo_status_ext = 'Active' 
		and mbt_code = 'Participant' 
		and ie.ind_mbt_code_ext = 'Volunteer'
		
		--order by ind_cst_key_ext
)

order by VOL -- ie.ind_cst_key_ext

/** cURRENT HOTFIX CODE : 

------------------------------------------------------------------------------------------
-- This portion fixes people with the wrong ind_mbt_code_ext Oct 16
------------------------------------------------------------------------------------------

	Update	co_individual_ext
	set		ind_mbt_code_ext = 
	(	
			select top 1	mbt_code from 
							co_individual_x_organization(nolock)
			inner join		co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext
			inner join		mb_member_type(nolock) on mbt_key = ixo_mbt_key_ext
			where			ind_cst_key_ext = ixo_ind_cst_key
			and				(ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' or ixo_status_ext = 'Not Renewed')
	)

	where ind_cst_key_ext in -- SELECTS where IXO will have 2 or more different values ... (ie, generally Vol and Part ...) 
	(
		select	ind_cst_key_ext
		from	co_individual_ext(nolock)
		where	(ind_status_ext = 'Active' or ind_status_ext = 'Pending' or ind_status_ext = 'Not Renewed')
		and	ind_mbt_code_ext not in
			(select distinct	mbt_code
			from				co_individual_x_organization(nolock)
			inner join			co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext
			inner join			mb_member_type(nolock) on mbt_key = ixo_mbt_key_ext
			where				ind_cst_key_ext = ixo_ind_cst_key
			and					(ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' or ixo_status_ext = 'Not Renewed')
			)
	)

*/


---- TESTING UNDER HERE ----- 
		
		select	top 100 ind_cst_key_ext, ie.ind_mbt_code_ext, M.mbt_code, IXOE.ixo_mbt_key_ext , * 
		from	co_individual_ext(nolock) IE
					join co_individual I on I.ind_cst_key = IE.ind_cst_key_ext
					join co_individual_x_organization IXO on IXO.ixo_ind_cst_key = IE.ind_cst_key_ext
					join co_individual_x_organization_ext(nolock) IXOE on ixo.ixo_key = IXOE.ixo_key_ext
					join mb_member_type(nolock) M  on M.mbt_key = IXOE.ixo_mbt_key_ext
		where	(ind_status_ext = 'Active' or ind_status_ext = 'Pending' or ind_status_ext = 'Not Renewed')
				and	(IXOE.ixo_status_ext = 'Active' or IXOE.ixo_status_ext = 'Pending' or IXOE.ixo_status_ext = 'Not Renewed')
				and IXO.ixo_delete_flag = 0 
				and I.ind_delete_flag = 0 
				and I.ind_deceased_flag = 0 
								
		and	ind_mbt_code_ext not in

		( select distinct	mbt_code
			from				co_individual_x_organization(nolock)
			inner join			co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext
			inner join			mb_member_type(nolock) on mbt_key = ixo_mbt_key_ext
			where				IE.ind_cst_key_ext = ixo_ind_cst_key
			and					(ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' or ixo_status_ext = 'Not Renewed')
			)

			-- CUURENT ISSUES >>
			
				-->> IND MBT is Volunteer 
				-->> BUT all IXO's are PARTICIPANT !
			
			and IE.ind_cst_key_ext IN ( 
			'E755E1BB-819A-4B7F-A537-620968DE1010',
			'EBD386A7-B1F6-47CE-9B82-66A8E56AC0C8',
			'3AFF3785-6B49-4678-BC46-70BA129C5184',
			'8E353F07-C580-432E-836A-77E374A05433',
			'7F044963-1DFE-43EF-84E1-E8581168F67A',
			'BDB122AE-CAF9-4FDE-AFC1-111467967397',
			'6F562288-571A-4854-9C28-3BF7F2BDFDBF',
			'D7F0A1C9-8D8C-45FC-8111-504F60711298',
			'45471A0B-7A17-4B6E-A75B-6095800D0861',
			'6172B38E-0DE2-483F-BB64-B30867F11AD2',
			'882D4870-388F-4708-BE60-C7AA5A928FE0',
			'94BE7C5F-A568-4A42-BD8C-09B36EB7D788',
			'55B2876D-F328-4322-A82C-35D577385092',
			'105B95E2-7E30-4E7F-95A9-58A52BE0AA64',
			'6B0010DE-3164-4CCB-8CFB-96E0129F09C1',
			'1C28E80E-6F8B-4E07-A219-B96F7B121B2B',
			'CB8A66D0-D744-4017-A3EC-C1995652F631',
			'458B83C7-7AB9-4473-BC1E-DA20FBADA5E8',
			'F90BD059-D8A7-45A5-9A4A-2E147DAA8667',
			'BFCA69D1-41A1-496C-90D3-307EB598A720',
			-- new ?
			'85E6A587-4EB4-4EDD-8BF0-C3E5E4C5953F',
			'31EBEBB6-AE3F-43AF-9BC8-1450FB86660F',
			'58D46B19-82BF-490E-9225-6A44FE3A8DED') 
			-- <<< CURRENT ISSUES 
				
		ORDER BY IE.ind_cst_key_ext
		


-- TEST 

select 	ind_mbt_code_ext, 
	ind_mbt_code_ext = 
	(	
			select top 1	mbt_code from 
							co_individual_x_organization(nolock)
			inner join		co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext
			inner join		mb_member_type(nolock) on mbt_key = ixo_mbt_key_ext
			where			ind_cst_key_ext = ixo_ind_cst_key
			and				(ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' or ixo_status_ext = 'Not Renewed')
	)

	from co_individual_ext

where ind_cst_key_ext in   -- SELECTS where IXO will have 2 or more different values ... (ie, generally Vol and Part ...) 
(		select	ind_cst_key_ext
		from	co_individual_ext(nolock)
		where	(ind_status_ext = 'Active' or ind_status_ext = 'Pending' or ind_status_ext = 'Not Renewed')
		and	ind_mbt_code_ext not in
			(select distinct	mbt_code
			from				co_individual_x_organization(nolock)
			inner join			co_individual_x_organization_ext(nolock) on ixo_key = ixo_key_ext
			inner join			mb_member_type(nolock) on mbt_key = ixo_mbt_key_ext
			where				ind_cst_key_ext = ixo_ind_cst_key
			and					(ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' or ixo_status_ext = 'Not Renewed')
			)
		and ind_cst_key_ext in (
		'E755E1BB-819A-4B7F-A537-620968DE1010',
		'EBD386A7-B1F6-47CE-9B82-66A8E56AC0C8',
		'3AFF3785-6B49-4678-BC46-70BA129C5184',
		'8E353F07-C580-432E-836A-77E374A05433',
		'7F044963-1DFE-43EF-84E1-E8581168F67A',
		'BDB122AE-CAF9-4FDE-AFC1-111467967397',
		'6F562288-571A-4854-9C28-3BF7F2BDFDBF',
		'D7F0A1C9-8D8C-45FC-8111-504F60711298',
		'45471A0B-7A17-4B6E-A75B-6095800D0861',
		'6172B38E-0DE2-483F-BB64-B30867F11AD2',
		'882D4870-388F-4708-BE60-C7AA5A928FE0',
		'94BE7C5F-A568-4A42-BD8C-09B36EB7D788',
		'55B2876D-F328-4322-A82C-35D577385092',
		'105B95E2-7E30-4E7F-95A9-58A52BE0AA64',
		'6B0010DE-3164-4CCB-8CFB-96E0129F09C1',
		'1C28E80E-6F8B-4E07-A219-B96F7B121B2B',
		'CB8A66D0-D744-4017-A3EC-C1995652F631',
		'458B83C7-7AB9-4473-BC1E-DA20FBADA5E8',
		'F90BD059-D8A7-45A5-9A4A-2E147DAA8667',
		'BFCA69D1-41A1-496C-90D3-307EB598A720',
-- new ?
		'85E6A587-4EB4-4EDD-8BF0-C3E5E4C5953F',
		'31EBEBB6-AE3F-43AF-9BC8-1450FB86660F',
		'58D46B19-82BF-490E-9225-6A44FE3A8DED') 
) 


/*** 

-- EXECUTED ON OCT 5 2015 

--- ACTUAL FIX to the 20 rows that have this issue !

begin transaction 
Update	co_individual_ext set ind_mbt_code_ext = 'Participant'
-- select ind_mbt_code_ext from co_individual_ext 
where ind_cst_key_ext in (
'E755E1BB-819A-4B7F-A537-620968DE1010',
'EBD386A7-B1F6-47CE-9B82-66A8E56AC0C8',
'3AFF3785-6B49-4678-BC46-70BA129C5184',
'8E353F07-C580-432E-836A-77E374A05433',
'7F044963-1DFE-43EF-84E1-E8581168F67A',
'BDB122AE-CAF9-4FDE-AFC1-111467967397',
'6F562288-571A-4854-9C28-3BF7F2BDFDBF',
'D7F0A1C9-8D8C-45FC-8111-504F60711298',
'45471A0B-7A17-4B6E-A75B-6095800D0861',
'6172B38E-0DE2-483F-BB64-B30867F11AD2',
'882D4870-388F-4708-BE60-C7AA5A928FE0',
'94BE7C5F-A568-4A42-BD8C-09B36EB7D788',
'55B2876D-F328-4322-A82C-35D577385092',
'105B95E2-7E30-4E7F-95A9-58A52BE0AA64',
'6B0010DE-3164-4CCB-8CFB-96E0129F09C1',
'1C28E80E-6F8B-4E07-A219-B96F7B121B2B',
'CB8A66D0-D744-4017-A3EC-C1995652F631',
'458B83C7-7AB9-4473-BC1E-DA20FBADA5E8',
'F90BD059-D8A7-45A5-9A4A-2E147DAA8667',
'BFCA69D1-41A1-496C-90D3-307EB598A720') 

-- commit 

*/
