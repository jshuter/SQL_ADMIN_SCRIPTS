-- count 
select count(*) from co_individual_x_organization 
JOIN co_individual_x_organization_ext on ixo_key = ixo_key_ext 	
where ixo_status_ext = 'Not Renewed'

-- then 
BEGIN transaction 

UPDATE ix 
SET ix.ixo_status_ext = 'Inactive'
FROM co_individual_x_organization as i JOIN co_individual_x_organization_ext as ix ON i.ixo_key = ix.ixo_key_ext
WHERE ix.ixo_status_ext = 'Not Renewed'

-- commit -- after count verified 


-- step 1 -- should take about 15 seconds 
exec client_scouts_individual_status_rebuild 

-- step 2 -- should take about 15 seconds 
exec client_scouts_rebuild_primary_ixo 