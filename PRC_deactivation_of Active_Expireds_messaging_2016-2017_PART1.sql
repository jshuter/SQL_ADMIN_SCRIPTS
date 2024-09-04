-- PART 1 
-- EXECUTED - OCT 19 2016 
-- PART 1 sends messages to GROUP LEADERS for section & group, and KEY 3 for area & council 

------------------------------------------
--- SETTINGS FOR DEV 
------------------------------------------

declare @debug				int = 0 ; -- to limit to partial send -- NOT FOR PROD !!!!
declare @commit				int = 0 ; -- 1 to COMMIT - 0 to ROLLBACK 
declare @flag_send_email	bit = 1 ; -- 1 == YES  0 == NO 

--- 

declare @msg_limit			int = 0 ; -- 
if @debug = 1
	set @msg_limit = 1
else 
	set @msg_limit = 9999 

-- only if it exists 
IF OBJECT_ID('tempdb..#tmp_expired_scouters') IS NOT NULL  
  DROP TABLE #tmp_expired_scouters

------------------------------------------

-- for flow control 
declare @recno int ; 
declare @ind_cst_key as uniqueidentifier ; 

-- for msg body 
declare @td_org_name as varchar(100) 
declare @td_scouters_ROLE_CODE as varchar(100) 
declare @td_member_number as varchar(100) 
declare @td_full_name as varchar(100) 
declare @td_email_address as varchar(100) 
declare @td_expiry_date as date 

declare @backcheck_link_en as varchar(100) = 'http://backcheck.net/scoutscanada/info.htm'
declare @backcheck_link_fr as varchar(100) = 'http://backcheck.net/scoutscanada/fr/index.htm'

-- for email target 
declare @msg_engine varchar(100) 


-- prep target msg engine 
if  @@SERVERNAME = 'SCOUTSTESTSQL01' begin
	set @msg_engine = 'system@scouts.ca'
end else begin
	set @msg_engine = 'scouts system messaging'
end

-------------------------------------------------------------------------------
-- 1 -- GET all valid emails for all orgs (area, council, group, and section) 
-- The following is copied from the 30/60/90 nightly process 
-------------------------------------------------------------------------------

	DECLARE @activeRolesConsideredForCC TABLE (
		r					int, 
		eml_address_cc		VARCHAR(200),
		rlt_code			VARCHAR(200),
		org_name			varchar(100), 
		org_key				UNIQUEIDENTIFIER,
		ind_key				UNIQUEIDENTIFIER,
		role_code			VARCHAR(100),
		org_hash_national	VARCHAR(96),
		org_hash_council	VARCHAR(96),
		org_hash_area		VARCHAR(96),
		org_hash_group		VARCHAR(96),
		org_hash_section	VARCHAR(96)
	)

    INSERT INTO @activeRolesConsideredForCC

    SELECT  ROW_NUMBER() over (partition by ixo.ixo_org_cst_key order by ixo.ixo_rlt_code) as R, 
		  cc.cst_eml_address_dn,
		  ixo.ixo_rlt_code, 
		  org_name,
		  ixo.ixo_org_cst_key,
		  ixo.ixo_ind_cst_key,
		  ixo.ixo_rlt_code,
		  (CASE WHEN len(coe.org_hierarchy_hash_ext) < 11 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 11 ) END),
		  (CASE WHEN len(coe.org_hierarchy_hash_ext) < 22 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 22 ) END),
		  (CASE WHEN len(coe.org_hierarchy_hash_ext) < 33 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 33 ) END),
		  (CASE WHEN len(coe.org_hierarchy_hash_ext) < 44 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 44 ) END),
		  (CASE WHEN len(coe.org_hierarchy_hash_ext) < 55 THEN NULL ELSE LEFT( coe.org_hierarchy_hash_ext, 55 ) END)
    from co_individual_x_organization ixo
    inner join co_individual_x_organization_ext ixoe on ixoe.ixo_key_ext = ixo.ixo_key
    inner join co_organization co on co.org_cst_key = ixo.ixo_org_cst_key
    inner join co_organization_ext coe on coe.org_cst_key_ext = ixo.ixo_org_cst_key
    inner join co_customer cc on cc.cst_key = ixo.ixo_ind_cst_key
    where	  cc.cst_eml_address_dn is not null 
    and	  ixoe.ixo_status_ext = 'Active'
    AND	  ixo.ixo_rlt_code in  ('Group Commissioner'
								,'Area Support Manager','Area Commissioner', 'Area Youth Commissioner'
								,'Council Commissioner', 'Council Youth Commissioner', 'Executive Director') 
    AND   (ixo.ixo_delete_flag = 0 or ixo.ixo_delete_flag is null) 
    AND	  ixo.ixo_start_date between '09-01-2016' AND '08-31-2017' 
    

	--- to debug / review ------ 
	--  select cc.r, cc.org_name, cc.role_code  from @activeRolesConsideredForCC as cc
	--  return 
	-- 	select distinct org_key  from @activeRolesConsideredForCC
	-- 	select COUNT(*) from @activeRolesConsideredForCC
	-- 	return -- 1,610 unique orgs -- 1,944 emails 

----------------------------------------------------------------------------
-- now get individuals that need to be deactivated 
----------------------------------------------------------------------------


declare @rv					smallint				-- for status return value - saved to log 
declare @date_limit			datetime	= dateadd(D,180, getdate()) 
declare @counter			int			= 0 
declare @full_name			varchar(100) 
declare @lang_spoken		varchar(10)
declare @eml_address_dn		varchar(50)
declare @expiration_date	datetime 
declare @cst_recno			bigint ;


--- create list of members with expired PRC's 

with PRC_INFO as ( 

	select ROW_NUMBER() OVER(PARTITION BY cust.cst_key ORDER BY screen.z25_expiration_date DESC) as R
		, cust.cst_key as CUST_KEY
		, cust.cst_recno as MEMBER_NUMBER
		, screen.z25_expiration_date as EXP_DATE
		, screen.z25_key as PRC_KEY
	from 
		co_customer cust
			join client_scouts_external_volunteer_screening screen 
				on cust.cst_key = screen.z25_ind_cst_key 
	where 
		screen.z25_expiration_date is not NULL -- 792 rows (dev) w/o TYPE==PRC -- 650 distinct recno -- 500 discinct recno on PROD
		and screen.z25_type = 'PRC'				-- 1222 rows when we limit to PRC TYPE ! 990 disrinct recno -- 746 distinct recno on PROD
) 

, 

section_scouter as ( 

	select -- distinct 

	parent_org_orginfo.org_cst_key as mail_join_org_cst_key
	, parent_org_orginfo.org_name as parent_org_name 
	, org_orginfo.org_ogt_code
	, org_orginfo.org_name as role_in_org 
	, parent_org_orginfo.org_cst_key as parent_orgs_cst_key 
	, org_orginfo.org_cst_key as orgs_cst_key
	, cust.cst_ind_full_name_dn as full_name
	, roleExt.ixo_status_ext
	, role.ixo_rlt_code as scouters_ROLE_CODE 
	, ext.ind_status_ext
	, ext.ind_primary_lang_spoken_ext as primary_language
	, z25_type as [type]
	, z25_expiration_date as expiry_date
	, cust.cst_recno as member_number
	, cust.cst_eml_address_dn as email_address
	, screen.z25_status as status

from PRC_INFO

	-- Scouter to deactivate 
	join co_customer cust on CUST_KEY = cust.cst_key 
	join co_individual_ext ext on cust.cst_key	= ext.ind_cst_key_ext 	
	join co_individual ind on cust.cst_key		=     ind.ind_cst_key 	
	-- PRC data 
	join client_scouts_external_volunteer_screening screen on screen.z25_key = PRC_KEY
	-- Active roles for the Scouter 
	join co_individual_x_organization role on role.ixo_ind_cst_key = cust.cst_key and role.ixo_end_date > getdate() 
	join co_individual_x_organization_ext roleExt on role.ixo_key = roleExt.ixo_key_ext and roleext.ixo_status_ext = 'Active'
	
	join co_organization ORG on org.org_cst_key = role.ixo_org_cst_key 
	join co_customer orginfo on orginfo.cst_key = org.org_cst_key 
	join co_organization org_orginfo on org_orginfo.org_cst_key = orginfo.cst_key	
	join co_organization parent_org_orginfo on parent_org_orginfo.org_cst_key = orginfo.cst_parent_cst_key
	
where

	R=1 and screen.z25_status = 'expired'  -- Scouters that are expired !!!! 

	and ext.ind_status_ext in ('Active')  
	and ext.ind_mbt_code_ext = 'Volunteer' -- or ind_mbt_code_ext = 'Employee') 
	and screen.z25_expiration_date < '2016-09-01' 
	and cust.cst_eml_address_dn IS NOT NULL
	and isnull(cust.cst_delete_flag,0) = 0
	and isnull(ind.ind_deceased_flag,0) = 0
	
	and org_orginfo.org_ogt_code = 'Section' 
	
) 
, 
non_section_scouter as ( 

	select -- distinct 
	
	org_orginfo.org_cst_key as mail_join_org_cst_key

	, parent_org_orginfo.org_name as parent_org_name 
	, org_orginfo.org_ogt_code
	, org_orginfo.org_name as role_in_org 
	, parent_org_orginfo.org_cst_key as parent_orgs_cst_key 
	, org_orginfo.org_cst_key as orgs_cst_key
	, cust.cst_ind_full_name_dn as full_name
	, roleExt.ixo_status_ext
	, role.ixo_rlt_code as scouters_ROLE_CODE 
	, ext.ind_status_ext
	, ext.ind_primary_lang_spoken_ext as primary_language
	, z25_type as [type]
	, z25_expiration_date as expiry_date
	, cust.cst_recno as member_number
	, cust.cst_eml_address_dn as email_address
	, screen.z25_status as status

from PRC_INFO

	-- Scouter to deactivate 
	join co_customer cust on CUST_KEY = cust.cst_key 
	join co_individual_ext ext on cust.cst_key	= ext.ind_cst_key_ext 	
	join co_individual ind on cust.cst_key		=     ind.ind_cst_key 	
	-- PRC data 
	join client_scouts_external_volunteer_screening screen on screen.z25_key = PRC_KEY
	-- Active roles for the Scouter 
	join co_individual_x_organization role on role.ixo_ind_cst_key = cust.cst_key and role.ixo_end_date > getdate() 
	join co_individual_x_organization_ext roleExt on role.ixo_key = roleExt.ixo_key_ext and roleext.ixo_status_ext = 'Active'
	
	join co_organization ORG on org.org_cst_key = role.ixo_org_cst_key 
	join co_customer orginfo on orginfo.cst_key = org.org_cst_key 
	join co_organization org_orginfo on org_orginfo.org_cst_key = orginfo.cst_key	
	join co_organization parent_org_orginfo on parent_org_orginfo.org_cst_key = orginfo.cst_parent_cst_key
	
where

	R=1 and screen.z25_status = 'expired'

	and ext.ind_status_ext in ('Active') 
	and ext.ind_mbt_code_ext = 'Volunteer'
	and screen.z25_expiration_date < '2016-09-01' 
	and cust.cst_eml_address_dn IS NOT NULL
	and isnull(cust.cst_delete_flag,0) = 0
	and isnull(ind.ind_deceased_flag,0) = 0
	
 and org_orginfo.org_ogt_code <> 'Section' 
 
) 

select * into #tmp_expired_scouters
from section_scouter  
UNION 
select * from non_section_scouter


----------------------------------------------------------------
--- NOW OUR LIST OF INDIVIDUALS IS IN : #tmp_expired_scouters !
----------------------------------------------------------------

-- for each ORG in the list of Scouters -- 485 distinct orgs affected - dev 
-- select distinct mail_join_org_cst_key from #tmp_expired_scouters -- 398 rows on prod 

-- members affected: 605 
-- select distinct s.email_address  from #tmp_expired_scouters s -- 499 on prod 

-- JUST FOR TEST
-- select 'top 10 #tmp_expired_scouters...'  
--  select distinct member_number from #tmp_expired_scouters
-- return 
 
 
--- LOOP THROUGH ALL AFFECTED ORGS 

declare @orgemail_key as uniqueidentifier ; 

-- CURSOR 
declare orgmail_cursor cursor FOR 
	select distinct S.mail_join_org_cst_key 
	from #tmp_expired_scouters as S ; 

-- OPEN 
OPEN orgmail_cursor; 

declare @c int =0 ; 
declare @c2 int =0 ; 
declare @rc int ; 
declare @s as varchar(500) ; 
declare @msg varchar(5000); 

-- LOOP 
fetch next from orgmail_cursor into @orgemail_key; 
WHILE @@FETCH_STATUS = 0 
begin 

	set @c=@c+1; 
	set @s = ''; 

	-- build email addressee list 			
	select @s=@s + a.eml_address_cc + ';' from @activeRolesConsideredForCC a where org_key = @orgemail_key ; 

	-- truncate extra ; 
	if len(@s) > 2 AND RIGHT(@s,1) = ';' 
		set @s = left(@s, len(@s)-1) 
	
	-- get affected Scouters
	declare scouter_details cursor FOR 
		select distinct S.role_in_org, S.scouters_ROLE_CODE, S.member_number, S.full_name, S.email_address, S.expiry_date  
		from #tmp_expired_scouters S 
		where S.mail_join_org_cst_key = @orgemail_key 
	 
	open scouter_details ; 
	
	set @msg='' 
	set @c2 = 0 
	
	fetch next from scouter_details into @td_org_name, @td_scouters_ROLE_CODE, @td_member_number, @td_full_name, @td_email_address, @td_expiry_date  
	while @@FETCH_STATUS = 0 
	begin 
		
				
		set @c2 = @c2 + 1 
		set @msg = @msg + '<tr><td>' + @td_org_name + '</td>'+
					'<td>' + @td_scouters_ROLE_CODE + '</td>'+ 
					'<td>' + @td_member_number		+ '</td>'+
					'<td>' + @td_full_name			+ '</td>'+ 
					'<td>' + @td_email_address		+ '</td>'+
					'<td>' + CONVERT(varchar(100), @td_expiry_date,107) + '</td></tr>' 
									
		fetch next from scouter_details into @td_org_name, @td_scouters_ROLE_CODE, @td_member_number, @td_full_name, @td_email_address, @td_expiry_date  
	
	end 
	close scouter_details 
	deallocate scouter_details

	-- send the email 
	
	if (LEN(@msg) > 0)  AND (LEN(@s) > 0)   begin 
		
		set @msg = '<html><head></head><body>
			<p><i><small>La version française suit l''anglais dans ce courriel / French version follows the English in this e-mail</small></i></p>	
			<p><b>Hello Scouter,</b></p>
			<p>As you are aware, volunteers must renew their Police Records Check (PRC) every three years to remain active members of Scouts Canada. </p>
			<p>The following members in your Group had their PRC&rsquo;s expire during the last Scouting Year. As such, they no longer meet the conditions 
				of membership with Scouts Canada and have been made inactive. As non-members, these individuals are no longer eligible to participate in 
				Scouting activities.</p>

			<p><table border=1 cellspacing=0 cellpadding=6px>

			<tr bgcolor="#dddddd"><td>Organization</td><td>Role</td><td>Member Number</td><td>Name</td><td>Email</td><td>PRC Expiry Date</td></tr>' + @msg + '</table></p>

			<p>If any of the individuals named above wishes to maintain their Scouts Canada membership, please have them renew their PRC at their earliest 
				opportunity. We appreciate your dedication to Scouts Canada and helping more youth have great, safe Scouting adventures. </p>
			<p>This is an automated email, please do not reply. If you need any help contacting your local council, or to learn how your Police Records 
				Check can be renewed, please contact the Scouts Canada Help Centre, by e-mailing helpcentre@scouts.ca, or calling us at 1-888-855-3336.  </p>
			
			<hr>

			<p><b>Bonjour</b>,</p>
			
			<p>Comme vous le savez, nos b&eacute;n&eacute;voles doivent renouveler leur attestation de v&eacute;rification de casier judiciaire (AVCJ) 
				tous les trois ans pour conserver leur statut de membres actifs.</p>
				
			<p>Les personnes suivantes ont vu leur AVCJ expirer au cours de la derni&egrave;re ann&eacute;e. Par cons&eacute;quent, ils ne 
				r&eacute;pondent plus aux conditions d&rsquo;adh&eacute;sion et leur statut a &eacute;t&eacute; d&eacute;sactiv&eacute;, car ils ne sont 
				plus autoris&eacute;s &agrave; prendre part aux activit&eacute;s scoutes.</p>
				
			<p><table border=1 cellspacing=0 cellpadding=6px>
			<tr bgcolor="#dddddd"><td>Organisation</td><td>Role</td><td>Num&eacute;ro de membre</td><td>Nom</td><td>courriel</td><td>Expiration de l&rsquo;AVCJ</td></tr>' + @msg + '</table></p>
			
			<p>Si ces personnes souhaitent demeurer des membres actifs de Scouts Canada, ils devront renouveler leur AVCJ d&egrave;s que possible. 
				Nous vous remercions de votre d&eacute;vouement envers le mouvement scout, qui permet &agrave; de nombreux jeunes de vivre des aventures 
				scoutes aussi stimulantes que s&eacute;curitaires.</p>
				
			<p>Ceci est un message automatis&eacute;, veuillez ne pas y r&eacute;pondre. Si vous avez besoin d&rsquo;aide pour contacter votre conseil 
				ou pour savoir comment faire v&eacute;rifier votre casier judiciaire, communiquez avec le Centre d&rsquo;assistance de Scouts Canada, 
				&agrave; helpcentre@scouts.ca ou au 1-888-855-3336. </p>

			</body></html>';
			

	print 'Processing ORGS : ' 	+  cast(@c as varchar(10)) + ',  ' +  cast(@orgemail_key as varchar(50)) + ',  ORG_EMAILS:' +  @s  

	-- SEND THE MESSAGES
	
	BEGIN TRY 		

		if @flag_send_email = 1 begin 
		
			EXECUTE msdb.dbo.sp_send_dbmail    @profile_name = @msg_engine,
				@recipients = @s , -- 'jeffrey.shuter@scouts.ca', -- ;jshuter@teradocs.com', -- ;pjohnsen@scouts.ca',  --- @email_address,
				@copy_recipients = 'system.scouts.ca',
				@subject = 'Message to Scouters - Expired PRC Deactivations',	 
				@body = @MSG,	 
				@body_format = 'HTML';
				
		end 	

	end try 
	
	begin catch
		print 'ERROR !'
	end catch
		
	end else begin 
	
		if LEN(@s) = 0 
			print 'no email recipient!' 
		if LEN(@msg) = 0 
			print 'no MSG to send!' 
	end 
	
	-- get next org emails 
	fetch next from orgmail_cursor into @orgemail_key; 
	
	-- exit this loop 
	if @c >= @msg_limit
		break ; 	
	
end 

CLOSE orgmail_cursor;  
DEALLOCATE orgmail_cursor; 

--------------------------------------------
-- STOP HERE FOR PART 1 -- 
--------------------------------------------

RETURN 

--------------------------------------------



--select @c as distinct_orgs 
--select distinct x.member_number as 'member to deactivate'  from #tmp_expired_scouters x

------------------------------------------------
-- foreach member - 
------------------------------------------------

	set @c=0; 

	DECLARE scouter_cursor cursor for 
		select distinct scouter.full_name, scouter.member_number, scouter.email_address, scouter.expiry_date  
		from #tmp_expired_scouters as scouter 

	OPEN scouter_cursor ; 

	fetch scouter_cursor into @td_full_name, @td_member_number, @td_email_address, @td_expiry_date 

	while @@FETCH_STATUS = 0 
	begin 
	
		set @c=@c+1; 
		-- fill body of text with param data 

		set @msg = '<html><head></head><body>
		<p><i><small>La version française suit l''anglais dans ce courriel / French version follows the English in this e-mail</small></i></p>

		<p><b>Hello '+ @td_full_name + ', </b></p>
		
		<p>As you are aware, in order to remain an active member with Scouts Canada, you must renew your Police Records Check (PRC) every three years. </p>
		<p><b>Your PRC expired during the last Scouting Year on ' + CONVERT(varchar(100), @td_expiry_date,107) + '</b>. As such, you no longer meet the conditions of membership with Scouts 
			Canada and have been made inactive. Normally members whose PRC expired during the previous Scouting Year are deactivated at the start of the new 
			Scouting Year on September 1st, however this year we offered a longer grace period. </p>
		<p>If you wish to continue your membership, you can simply <a href="' + @backcheck_link_en + '">go to Backcheck</a> to renew your PRC. Please note there is a small charge for using this service. 
			Alternately you can renew your PRC through local sources and once received, send it directly to your Council for processing. If you need a refresher 
			on the volunteer screening process, please contact your Local Council (<a href="http://www.scouts.ca/ca/find-your-local-council">You can find your Local Council here</a>). </p>
		<p>We appreciate your dedication to Scouts Canada and helping more youth have great, safe Scouting adventures. We hope that you continue your Scouting 
			journey with Scouts Canada. We&rsquo;ll see you on the Path! </p>
		<p>This is an automated email, please do not reply. If you need any help contacting your local council, or to learn how your Police Records Check 
			can be renewed, please contact the Scouts Canada Help Centre, by e-mailing helpcentre@scouts.ca, or calling us at 1-888-855-3336.</p>

		<hr>
		
		<p><b>Bonjour '+ @td_full_name + ',</b></p>
		<p>Comme vous le savez, pour demeurer un membre actif de Scouts Canada, vous devez renouveler votre attestation de v&eacute;rification de 
			casier judiciaire (AVCJ) tous les trois ans.</p>
		<p><b>Comme votre AVCJ a expir&eacute; le ' + CONVERT(varchar(100), @td_expiry_date,107) + '</b>, vous ne r&eacute;pondez d&eacute;sormais plus aux conditions d&rsquo;adh&eacute;sion 
			et votre statut a &eacute;t&eacute; d&eacute;sactiv&eacute;. Habituellement, les membres dont l&rsquo;AVCJ a expir&eacute; au cours de 
			l&rsquo;ann&eacute;e pr&eacute;c&eacute;dente voient leur statut d&eacute;sactiv&eacute; le 1er septembre, mais cette ann&eacute;e, nous 
			avons &eacute;tir&eacute; ce d&eacute;lai jusqu&rsquo;au 28 octobre.</p>
		<p>Si vous souhaitez demeurer un membre actif de Scouts Canada, nous vous invitons &agrave; <a href="' + @backcheck_link_fr + '">utiliser le service Backcheck</a> pour renouveler 
			votre AVCJ (de l&eacute;gers frais s&rsquo;appliquent). Vous pouvez aussi renouveler votre AVCJ aupr&egrave;s des autorit&eacute;s de votre 
			r&eacute;gion et transmettre les documents obtenus &agrave; votre conseil scout. N&rsquo;h&eacute;sitez pas &agrave; communiquer avec votre 
			conseil si vous avez des questions concernant notre proc&eacute;dure de pr&eacute;s&eacute;lection des b&eacute;n&eacute;voles (<a href="http://www.scouts.ca/fr/trouvez-votre-conseil-local">cliquez ici 
			pour obtenir les coordonn&eacute;es de votre conseil</a>).</p>
		<p>Nous vous remercions de votre d&eacute;vouement, qui permet &agrave; de nombreux jeunes de vivre des aventures scoutes aussi stimulantes 
			que s&eacute;curitaires. Nous esp&eacute;rons que vous poursuivrez votre partenariat avec Scouts Canada. Au plaisir de vous croiser sur 
			le Sentier!</p>
		<p>Ceci est un message automatis&eacute;, veuillez ne pas y r&eacute;pondre. Si vous avez besoin d&rsquo;aide pour contacter votre conseil 
			ou pour savoir comment faire v&eacute;rifier votre casier judiciaire, communiquez avec le Centre d&rsquo;assistance de Scouts Canada, 
			&agrave; helpcentre@scouts.ca ou au 1-888-855-3336. </p>

		</body>
		</html>
		';

		print 'Processing recno:' + @td_member_number + ' name:' + @td_full_name + ' email:' + @td_email_address ; 
				
		---------------------------------------------------- 
		-- send email 
		---------------------------------------------------- 
		
		BEGIN TRY 		
			
			if @flag_send_email = 1 begin 
	
				EXECUTE msdb.dbo.sp_send_dbmail  @profile_name = @msg_engine,
					@recipients = 'jeffrey.shuter@scouts.ca;jshuter@teradocs.com', --;pjohnsen@scouts.ca',  --- @email_address,
					@copy_recipients = 'system.scouts.ca',
					@subject = 'Message to Scouters - Deactivation - PRC Expired',	 
					@body = @MSG,	 
					@body_format = 'HTML';
			
			end 

			select @ind_cst_key = cst_key 
			from co_customer c
			where c.cst_recno = @td_member_number 
		
		

	
			IF LEN(@ind_cst_key) > 20  begin 

				--- DACTIVATE THIS MEMBER --- 
									
				-- UPDATE 4 				

				begin transaction 
				
					-- Make all individual roles Inactive

					-- Set the change_user and change_date in each role THAT IS ACTIVE 
					
					UPDATE co_individual_x_organization
					SET ixo_change_user = 'MyScouts.System', ixo_change_date = GETDATE()
					FROM   co_individual_x_organization ixo
						INNER JOIN co_individual_x_organization_ext ixoe ON ixo.ixo_key = ixoe.ixo_key_ext
					WHERE ixo.ixo_ind_cst_key = @ind_cst_key 
						and ixoe.ixo_status_ext = 'Active' 
					
					---
					
					UPDATE co_individual_x_organization_ext
					SET co_individual_x_organization_ext.ixo_status_ext = 'Inactive'
					FROM  co_individual_x_organization_ext ixoe
						INNER JOIN co_individual_x_organization ixo ON ixo.ixo_key = ixoe.ixo_key_ext
					WHERE ixo.ixo_ind_cst_key = @ind_cst_key 
						AND ixoe.ixo_status_ext = 'Active' 
					
					--- UPDATE the individual status 
					-- Set the individual Inactive (1 row by defn) 
					UPDATE co_individual_ext SET co_individual_ext.ind_status_ext = 'Inactive'
					WHERE ind_cst_key_ext = @ind_cst_key  and ind_status_ext = 'Active' 
					
					-- Set the change_user and change_date for the individual (1 row by defn) 
					UPDATE co_individual SET ind_change_user = 'MyScouts.System',ind_change_date = GETDATE()
					WHERE ind_cst_key = @ind_cst_key 

				-- in testing - we will mostly rollback ... until final checks 
				if @commit = 1 begin 			
					commit 
				end else  begin 
					rollback 
				end 
			
			end else begin 
			
				print 'WARNING ind_cst_key was missing !' 
			
			end 
			
			--------------------------------------------
				
		end try 
		
		begin catch
			print 'ERROR ...'
		end catch


		fetch scouter_cursor into @td_full_name, @td_member_number, @td_email_address, @td_expiry_date 

		if @c >= @msg_limit
			break ; 
	
	end 

CLOSE scouter_cursor ; 
deallocate scouter_cursor ; 

---------------------------------------------------



