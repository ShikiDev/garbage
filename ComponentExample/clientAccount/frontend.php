<?php
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

 if (!defined('VALID_CMS')) {die('ACCESS DENIED');}
 /////////////////////////////////////////////////////
 
 function clientAccount(){
 	$inCore = cmsCore::getInstance();
	$inPage = cmsPage::getInstance();
	$inUser = cmsUser::getInstance();

	$do = $inCore->do;

	if($do == 'new'){
		include_once("newClientAccount.php");
	}
	if($do == 'addProcatTicket'){
		include_once("addTicketProcat.php");
	}
	if($do == 'listTicketProcat'){
		//include_once();
	}
	if($do == 'listClient'){
		include_once("listClientAccount.php");
	}
	if($do == 'editClient'){
		include_once("editClientAccount.php");
	}
	if($do == 'show_ticket'){
		if(($inUser->group_id != '18')&&($inUser->group_id != '21')){
			include_once("show_ticket.php");
		}elseif($inUser->group_id == '18'){
			include_once("show_ticket_for_urik.php");
		}elseif($inUser->group_id == '21'){
			cmsCore::redirect("/clientAccount/list_ticket");
		}
	}
	if($do == 'list_ticket'){
		if(($inUser->group_id != '18')&&($inUser->group_id != '21')){
			include_once("listTicketProcat.php");
		}else{
			include_once("listTicketProcatClient.php");
		}
	}
	if($do == 'preset_car'){
		include_once("presetCarForTicketProcatWish.php");
	}
	if($do == 'preset_waylist_print'){
		include_once("preset_waylist_print.php");
	}
	if($do == 'client_cabinet'){
		include_once("client_cabinet.php");
	}
/*	if($do == 'reports'){
		include_once("report_page.php");
	}*/
	if($do == 'print_ticket_dogovor'){
		include_once("print_dogovor_for_ticket.php");
	}
	if($do == "consultate"){
		include_once("consult_page.php");
	}
	if($do == "reports_info"){
		include_once("report_ticket_info.php");
	}
	if($do == "expenses"){
		include_once("expenses.php");
	}
	if($do == "dl_some_excel"){
		include_once("dl_some_excel.php");
	}
	if($do == "testodrom"){
		include_once("testodrom.php");
	}
 }