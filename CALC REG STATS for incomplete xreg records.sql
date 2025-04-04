
-- FOR 2016 

-- 74,627 (not deleted) 80,033 -- ALL // 
-- 50,7014 -- DISTINCT x13_ind_cst_key_1

select COUNT(*) , x13_progress
from client_scouts_experimental_registration
where x13_delete_flag = 0 
and x13_type = '2016'
group by x13_progress



select COUNT(*)
from client_scouts_experimental_registration GOOD
join client_scouts_experimental_registration BAD 
on good.x13_ind_cst_key_1 = bad.x13_ind_cst_key_1
where bad.x13_type = '2016' and GOOD.x13_type = '2016'
and bad.x13_progress = 'NEW' and good.x13_progress in ( 'Confirmation', 'Payment Received')
and good.x13_delete_flag = 0  and bad.x13_delete_flag = 0 
and good.x13_source = 'self'

--and good.x13_progress = 



Count		A.x13_progress

		CONF	(includes DELETED) 
		
9414	4710 (4044 self/ 666 not self) New	>>> 3780 completed by self / 900 completed by reg 5000 NOT COMPLETED 

6507	7443	Registrant Added
2213	1935	Contact Info
1294	1023	Emergency Info
257				Medical Info
838				Photo Release
1496			Parental Involvement
334				Role Added
628		503		Terms
1804			Payment Added
2622	2054	Order Details
------
27,000 INCOMPLETE registrations 


38776					Confirmation
13850					Payment Received
------
52,000 registrations 



38715	Confirmation
1453	Contact Info
962		Emergency Info
183		Medical Info
9417	New
1916	Order Details
769		Parental Involvement
1766	Payment Added
13857	Payment Received
586		Photo Release
4388	Registrant Added
203		Role Added
416		Terms

/* 
begin transaction 

-- select * from co_individual_x_organization where ixo_key = '0BAC786B-5789-4D18-843A-FE1824EAB51B'

insert co_individual_x_organization_ext (
ixo_key_ext,
ixo_status_ext,
ixo_mbt_key_ext) 
values(
 '0BAC786B-5789-4D18-843A-FE1824EAB51B', 
 'Pending' , 
 '2F384A1B-B8B3-4E5D-BF05-3B8223016DC7') 

commit 
*/





declare @cst_key uniqueidentifier = '4736446C-B9F9-4C9F-A66E-E964002EC23B'

SELECT ixo_status_ext, co_individual_x_organization_ext.*
from co_customer_x_customer 
join co_individual a on cxc_cst_key_1=ind_cst_key
join co_customer on a.ind_cst_key=cst_key
left join co_individual_x_organization on ixo_key =cst_ixo_key
left join co_organization c on ixo_org_cst_key = c.org_cst_key
left JOIN co_organization_ext cext (nolock) on cext.org_cst_key_ext=c.org_cst_key
left join co_individual_x_organization_ext on ixo_key=ixo_key_ext
left JOIN co_customer org on c.org_cst_key= org.cst_key
LEFT JOIN co_organization p on org.cst_parent_cst_key=p.org_cst_key
LEFT JOIN co_organization_ext pext on p.org_cst_key=pext.org_cst_key_ext

where cxc_cst_key_2=@cst_key 
--	and (ixo_status_ext = 'Active' or ixo_status_ext = 'Pending' 	or ixo_status_ext = 'Not Renewed' or ixo_status_ext = 'Inactive')

		-- IXO_STATUS IS NULL !!! 

-- Non member parents are added with this search

SELECT cst_ixo_key, * 
from co_customer_x_customer 
join co_individual a on cxc_cst_key_1=ind_cst_key
join co_customer on a.ind_cst_key=cst_key
where (cxc_cst_key_2=@cst_key)
	--and (cst_ixo_key is null)  -- <<<<< cst_ixo_key is NOT NULL !!!!! >>>  0BAC786B-5789-4D18-843A-FE1824EAB51B
	