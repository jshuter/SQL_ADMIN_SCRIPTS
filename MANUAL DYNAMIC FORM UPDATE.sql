select * from md_dynamic_form_control where dys_dyn_key = 'BE51F8D7-2B8A-4E57-ABA2-33A38279BD2D'
and dys_control_name like '%tag%'
order by dys_control_name

--commit 
BEGIN TRANSACTION 

insert into md_dynamic_form_control (
 dys_key
,dys_dyn_key
,dys_control_name
,dys_control_class
,dys_readonly
,dys_readonly_control
,dys_conditional_control_class
,dys_conditional_control_class_operator
,dys_conditional_control_class_value
,dys_conditional_control_class_control
,dys_readonly_operator
,dys_readonly_value
,dys_readonlyedit
,dys_required
,dys_required_control
,dys_required_operator
,dys_required_value
,dys_invisible
,dys_invisible_control
,dys_invisible_operator
,dys_invisible_value
,dys_autopostback
,dys_invisible_for_add
,dys_value_from
,dys_value_column
,dys_value_text_column
,dys_value_where
,dys_value_where_add
,dys_value_orderby
,dys_dyp_key
,dys_cssclass
,dys_default_value
,dys_default_value_function
,dys_order
,dys_value
,dys_data
,dys_top
,dys_left
,dys_width
,dys_height
,dys_add_user
,dys_add_date
,dys_change_user
,dys_change_date
,dys_delete_flag
,dys_entity_key) 

VALUES(
'ABD3722A-7B45-46E2-BB07-9D7ACD022685'
,'BE51F8D7-2B8A-4E57-ABA2-33A38279BD2D'
,'Caption_z05_tag_dn'
,'Label'
,0
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,0
,0
,NULL
,NULL
,NULL
,0
,NULL
,NULL
,NULL
,0
,0
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,'DataFormLabel'
,NULL
,NULL
,3
,'Nominator:'
,NULL
,45
,17
,78
,13
,'JShuter_Scouts'
,'2016-11-10 13:53:10.000'
,'JShuter_Scouts'
,'2016-11-10 15:32:55.000'
,0
,NULL) 


insert into md_dynamic_form_control (
 dys_key
,dys_dyn_key
,dys_control_name
,dys_control_class
,dys_readonly
,dys_readonly_control
,dys_conditional_control_class
,dys_conditional_control_class_operator
,dys_conditional_control_class_value
,dys_conditional_control_class_control
,dys_readonly_operator
,dys_readonly_value
,dys_readonlyedit
,dys_required
,dys_required_control
,dys_required_operator
,dys_required_value
,dys_invisible
,dys_invisible_control
,dys_invisible_operator
,dys_invisible_value
,dys_autopostback
,dys_invisible_for_add
,dys_value_from
,dys_value_column
,dys_value_text_column
,dys_value_where
,dys_value_where_add
,dys_value_orderby
,dys_dyp_key
,dys_cssclass
,dys_default_value
,dys_default_value_function
,dys_order
,dys_value
,dys_data
,dys_top
,dys_left
,dys_width
,dys_height
,dys_add_user
,dys_add_date
,dys_change_user
,dys_change_date
,dys_delete_flag
,dys_entity_key) 


VALUES ( '1F5B7504-53DA-4199-805B-6286E224B5EC'
,'BE51F8D7-2B8A-4E57-ABA2-33A38279BD2D'
,'z05_tag_dn'
,NULL
,0
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,0
,0
,NULL
,NULL
,NULL
,0
,NULL
,NULL
,NULL
,0
,0
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,NULL
,'DataFormTextBox'
,NULL
,NULL
,4
,'z05_tag_dn'
,NULL
,45
,88
,NULL
,19
,'JShuter_Scouts'
,'2016-11-09 11:55:29.000'
,'JShuter_Scouts'
,'2016-11-10 15:32:55.000'
,0
,NULL) 
