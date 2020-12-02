declare @date_limit datetime = dateadd(D,180, getdate()) 

select @date_limit 

select distinct cust.cst_ind_full_name_dn, ext.ind_primary_lang_spoken_ext, cust.cst_eml_address_dn, screen.z25_expiration_date, cust.cst_recno --, role.ixo_end_date
, roleext.ixo_status_ext, screen.z25_status, screen.z25_type from 
		co_customer cust
		join co_individual_ext ext on cust.cst_key = ext.ind_cst_key_ext 		
		join client_scouts_external_volunteer_screening screen	on cust.cst_key = screen.z25_ind_cst_key 
		join co_individual_x_organization role on role.ixo_ind_cst_key = cust.cst_key and role.ixo_end_date > getdate() 
		join co_individual_x_organization_ext roleExt on role.ixo_key = roleExt.ixo_key_ext and roleext.ixo_status_ext = 'Active'
where 	z25_type='PRC'
		and ext.ind_status_ext in ('Active','Pending','Not-Renewed') 
		and (ext.ind_mbt_code_ext = 'Volunteer' or ind_mbt_code_ext = 'Employee') 
		and screen.z25_status = 'Passed'
		and screen.z25_expiration_date < @date_limit 
		and cust.cst_eml_address_dn IS NOT NULL 
		and cust.cst_no_email_flag <> 1 
		and (isnull(ext.ind_do_not_contact_flag_ext,0) = 0) 
		and cust.cst_delete_flag <> 1 

order by ind_primary_lang_spoken_ext -- z25_expiration_date
	

/*
select 	ind_status_ext, cst_recno,
	cst_eml_address_dn 	as [Email],
	(
	select top 1 z25_expiration_date 
		from client_scouts_external_volunteer_screening 
		where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' 
		order by z25_completion_date desc)
	as [PRCExpire], 
	 
	(select top 1 z25_expiration_date 
		from client_scouts_external_volunteer_screening 
		where z25_ind_cst_key = ind_cst_key_ext 
				and z25_type = 'VSS' 
			order by z25_completion_date desc) as [VSSExpire] 
				from  co_customer(nolock) 
					inner join co_individual_ext(nolock) 
					on cst_key = ind_cst_key_ext
						where (
							(select top 1 z25_expiration_date 
								from client_scouts_external_volunteer_screening where z25_ind_cst_key = ind_cst_key_ext and z25_type = 'PRC' order by z25_completion_date desc)
							< DATEADD(Month,6,GETDATE()))

							and (ind_status_ext = 'Active' 
									or ind_status_ext = 'Pending' 
									or ind_status_ext = 'Not Renewed')
							and (ind_mbt_code_ext = 'Volunteer' 
									or ind_mbt_code_ext = 'Employee') 
							and cst_eml_address_dn is not null 
							and ind_do_not_contact_flag_ext <> 1 
							and cst_no_email_flag <> 1 
							and cst_delete_flag <> 1

*/

	declare @lang as varchar(10) = '' 
	declare @expiry_date date 
	DECLARE @EBODY AS NVARCHAR(MAX)	
	DECLARE @FBODY AS NVARCHAR(MAX)	
	DECLARE @BODY AS NVARCHAR(MAX)	
	DECLARE @BODY_DEFAULT AS NVARCHAR(MAX)		 
	declare @intended_for varchar(100)  


	-- params to set for each message 
	declare @notification_title nvarchar(100) = 'Scouter PRC Expiry Notification'
	set @expiry_date = getdate() 
	set @intended_for = 'Jeffrey Shuter'

    set @EBODY = 'Hello ' + @intended_for + ',<br /><br /> As you are aware, a Police Records Check (PRC) must be renewed every three years to remain 
      an active volunteer with Scouts Canada. You may have started the process of renewing yours, but just in case you have not, please accept this 
      email as a friendly reminder. Your PRC expiry date is ' +  convert(varchar(20) ,@expiry_date,100)  + '.<br /><br /> Returning volunteers can go 
      to <a href="http://Backcheck.net/scoutscanada">Backcheck</a> to apply for a new PRC. Please be aware that there is a small charge for using this 
      service.<br /><br />Once you receive your new PRC, please send it directly to your Council for processing. If you need a refresher on the volunteer 
      screening process please contact your Local Council <a href="http://www.scouts.ca/ca/find-your-local-council">(You can find your Local Council here)</a>.<br />
      <br />If you need any help contacting your local council, or to learn how your Police Records Check can be renewed, please contact the 
      Scouts Canada Help Centre, by e-mailing <a href="mailto:helpcentre@scouts.ca">helpcentre@scouts.ca</a>, or calling us at 1-888-855-3336.<br /><br />
      Thank you for volunteering, from the team of Scouters at Scouts Canada'
      
    declare @footer varchar(1000) = 'This is an automated email, please do not reply. For questions or assistance, you can contact your Council Service 
		Team or the Scouts Canada Help Centre at 1-888-855-3336 or <a href="mailto:helpcentre@scouts.ca">helpcentre@scouts.ca</a>.</p> </td> '

	if @lang = 'French' begin 
	
		set @notification_title = 'Avis du expiration de la PRC'
		
	    set @EBODY = 'Cher bénévole de Scouts Canada,<br /><br />Comme vous le savez, vous devez renouveler votre vérification des dossiers de la police (VDP) 
		tous les trois ans pour demeurer un bénévole actif chez Scouts Canada. Ce courriel vise à vous rappeler que vous devez renouveler votre VDP si 
		vous n''avez pas déjà entamé le processus. La date d''expiration de votre VDP est le {PRC_EXPIRE}.<br /><br />Les anciens membres peuvent 
		visiter le http://Backcheck.net/scoutscanada pour effectuer une nouvelle vérification des dossiers de la police (VDP). Prenez note que des 
		frais minimes sont liés à l''utilisation de ce service.<br /><br />Lorsque vous obtiendrez votre nouvelle VDP, envoyez-la directement à votre
		conseil (http://www.scouts.ca/fr/trouver-votre-conseil-local). Si vous avez besoin de plus amples renseignements sur le processus de présélection 
		des bénévoles, communiquez avec votre conseil ( http://www.scouts.ca/fr/trouver-votre-conseil-local ) ou visitez 
		le http://www.scouts.ca/fr... .<br /><br />Si vous avez besoin d''aide 
		pour contacter votre conseil local ou pour renouveler votre vérification des dossiers de la police, communiquez avec le centre d''assistance de 
		Scouts Canada par courriel à helpcentre@scouts.ca, ou par téléphone au 1-888-855-3336.<br /><br />Merci de faire du bénévolat, de l''équipe de 
		soutien de <br />Scouts Canada<br /><br />Ce message a été généré par le système. Prière de ne pas y répondre.<br /><br /><br /><br />'

		set @footer = '	<td style="text-align: left; border-left: 1px solid #e6e6e6; border-bottom: 1px solid #cccccc; border-right: 1px solid #cccccc; padding-right: 30px"> 
		<p>Ceci est un message automatique , s' + CHAR(34) + 'il vous plaît ne répond pas. Si vous avez des questions ou avez besoin d' + CHAR(34) + 'aide , vous pouvez communiquer avec l' + CHAR(34) + 'équipe de service de conseil ou le centre d' + CHAR(34) + 'assistance de Scouts Canada au 1-888-855-3336 ou à 
		<a href="mailto:helpcentre@scouts.ca">helpcentre@scouts.ca</a> .'
	
	end 
			
	
	SET @BODY = '<html><body>
	<table cellpadding="2" cellspacing="0" style="font-family: Bliss2Normal,Helvetica,Arial; font-size: 14px; margin: 10px; border: 0px solid #cccccc; height: auto"> 
	
	<!-- banner --> 
	<tr><td colspan="2" style="padding: 0px;"> <div style="margin: 0px; padding: 0px; background-color: #006200;width:856px;height:153px;">
	<img src="http://www.scouts.ca/sites/all/themes/scouts/images/renew_header.png" alt="' + @notification_title +'" width="856px" height="153px"> 
	</div> </td> </tr> 
	
	<!-- Heading -->
	<!--  
	<tr>
	<td colspan="2" style="text-align: center;padding:0px; border-right: 1px solid #cccccc; border-left: 1px solid #cccccc; "> 
	<div style="background-color: #f3f3f3; padding: 8px; margin-top:25px; margin-left: auto; margin-right: auto; width: 780px; border: 1px solid #cccccc; "> 
		<table cellpadding="0" cellspacing="0" style="padding:0px;width:100%"> 
		<tr><td style="width: 50%;">'+ @intended_for +'<strong> <displayrecipientnames /></strong>
		</td></tr></table> 
	</div> </td> </tr> 
	--> 
	
	<!-- MESSAGE --> 
	<tr><td style="text-align: left; border-left: 1px solid #cccccc; padding-left: 30px; width:50%">
	<p>' + @EBODY + '</p> </td> </tr> 

	<!-- GREEN LINE --> 
	<tr><td colspan="2" style="text-align: center; border-right: 1px solid #cccccc; border-left: 1px solid #cccccc; margin-top: 0px; padding-top: 0px; margin-bottom: 0px; padding-bottom: 0px; "> 
	<div style="padding: 6px 10px 6px 10px; width: 750px; background-color: #84A136; margin-left: auto; margin-right: auto;"> 
	<table cellpadding="0" cellspacing="0" style="background: #84A136; padding: 0px; width: 97%"> 
	<tr><td> </td> </tr> </table></div></td></tr>
	
	<!-- FOOTER --> 	
	<tr> <td style="text-align: left; border-left: 1px solid #cccccc; border-bottom: 1px solid #cccccc; padding-left: 30px;"> 
	<p>' + @footer + '</p> </td> </tr>
	
	<!-- end --> 
	</table></body></html>'		
 								
	--Send email here. Nothing to do if email does not get sent. 
	--Check SQL Mail logs on SQL Server for results/logs			

	EXEC msdb.dbo.sp_send_dbmail  @profile_name = 'scouts system messaging', -- 'system@scouts.ca',
		@recipients = 'jeffrey.shuter@scouts.ca;jshuter@fastmail.fm',	
		@subject = @notification_title,	 
		@body = @BODY,	 
		@body_format = 'HTML';
