select 
 c.cst_recno as Member_number 
 , c.cst_ind_full_name_dn as Name,
 coalesce(ind_prt_resource_person_flag_ext,0) as RESOURCE_PERSON,
 coalesce(ind_prt_camp_helper_flag_ext, 0)  as HELPER,
 coalesce(ind_prt_phoning_flag_ext,0) as PHONING,
 coalesce(ind_prt_fundraising_flag_ext,0) as FUNDRAISING,
 coalesce(ind_prt_communications_flag_ext,0) as COMMUNICATIONS,
 coalesce(ind_prt_organization_planning_flag_ext,0) as ORG_PLANNING,
 coalesce(ind_prt_cooking_banquets_flag_ext,0) as COOKING_BANQUETS,
 coalesce(ind_prt_drawing_art_flag_ext,0) as DRAWING_ART,
 coalesce(ind_prt_acting_flag_ext,0) as ACTING,
 coalesce(ind_prt_games_flag_ext,0) as GAMES,
 coalesce(ind_prt_handicrafts_flag_ext,0) as HANDICRAFTS,
 coalesce(ind_prt_env_nature_lore_flag_ext,0) as NATURE_LORE,
 coalesce(ind_prt_outdoor_activities_flag_ext,0) as ACTIVITIES	,
 coalesce(ind_prt_singing_music_flag_ext,0) as MUSIC,
 coalesce(ind_prt_sports_flag_ext,0) as SPOTS,
 coalesce(ind_prt_woodworking_flag_ext,0) as WOODWORKING,
 coalesce(ind_prt_sci_engg_activities_flag_ext,0) as ENGG_ACTIVITIES,
 coalesce(ind_prt_other_flag_ext,0) as OTHER	

from  

co_organization o
	join co_organization_ext oe on o.org_cst_key = oe.org_cst_key_ext
	join co_individual_x_organization ixo on ixo.ixo_org_cst_key = o.org_cst_key 
	join co_individual_ext i on i.ind_cst_key_ext =  ixo.ixo_ind_cst_key
	join co_customer c on c.cst_key = ixo.ixo_ind_cst_key

where 

	ixo.ixo_delete_flag = 0  	
 and o.org_name like '1st Kirkland Ladner%'
 
 and ixo.ixo_start_date >= '2015-08-01 00:00:00' 
 
 and ( 
 ind_prt_resource_person_flag_ext = 1 or 
 ind_prt_camp_helper_flag_ext = 1 or 
 ind_prt_phoning_flag_ext = 1 or 
 ind_prt_fundraising_flag_ext = 1 or 
 ind_prt_communications_flag_ext = 1 or 
 ind_prt_organization_planning_flag_ext = 1 or 
 ind_prt_cooking_banquets_flag_ext = 1 or 
 ind_prt_drawing_art_flag_ext = 1 or 
 ind_prt_acting_flag_ext = 1 or 
 ind_prt_games_flag_ext = 1 or 
 ind_prt_handicrafts_flag_ext = 1 or 
 ind_prt_env_nature_lore_flag_ext = 1 or 
 ind_prt_outdoor_activities_flag_ext	 = 1 or 
 ind_prt_singing_music_flag_ext = 1 or 
 ind_prt_sports_flag_ext = 1 or 
 ind_prt_woodworking_flag_ext = 1 or 
 ind_prt_sci_engg_activities_flag_ext = 1 or 
 ind_prt_other_flag_ext	= 1
 ) 
