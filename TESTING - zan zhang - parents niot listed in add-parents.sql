select * from co_customer where cst_recno = 10196879

exec client_scouts_my_family_xWeb '1AA636F9-EF27-4B38-B8A1-08830B456712' --zan zhang --> 3 parents

exec client_scouts_list_parents_at_registration_xweb '1AA636F9-EF27-4B38-B8A1-08830B456712' --> 1 parent 


<individual>
    <cxc_key>008F9427-5B67-49DC-82E1-2B928226F6CA</cxc_key>
    <ind_cst_key>663C78B2-A9A1-470B-B9A0-172EF6D193FE</ind_cst_key>
    <Relationship>Parent/Guardian</Relationship>
    <Name>Yun Lu Zhang</Name>
    <ParentKey>1AA636F9-EF27-4B38-B8A1-08830B456712</ParentKey>
</individual>

select * from co_customer_x_customer where cxc_key = '008F9427-5B67-49DC-82E1-2B928226F6CA' -- OK -- parent/child OK -- not deleted 

select * from co_customer where cst_key = '663C78B2-A9A1-470B-B9A0-172EF6D193FE' --Yun Lu Zhang- not deleted -- BUT cst CXA link is NULL (no address record) !!!!

<individual>
    <cxc_key>08135D96-A548-414A-8DC3-3951586F45DA</cxc_key>
    <ind_cst_key>783317CE-C581-452C-B606-18867AA288FA</ind_cst_key>
    <Relationship>Parent/Guardian</Relationship>
    <Name>Mui Li</Name>
    <ParentKey>1AA636F9-EF27-4B38-B8A1-08830B456712</ParentKey>
</individual>
