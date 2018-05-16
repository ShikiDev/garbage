<?php
$inCore->loadModel('clientAccount');
cmsCore::loadClass('auto_use');
cmsCore::loadModel('partner');
cmsCore::loadModel('callbackTickets');
$inUser = cmsUser::getInstance();
$model_partner = new cms_model_partner();

$model_ca = new cms_model_clientAccount();
$auto_obj = new cmsAuto_use();
$model_call = new cms_model_callbackTickets();
$user_id = $inUser->id;
$ticket_id = cmsCore::request('ticket_id','str','');

$nick_user = $model_ca->getNickUser($user_id);
$ticket_info = $model_ca->getTicketInfo($ticket_id);
$group_id = $model_ca->getUserById($user_id);
$class_list = $model_partner->get_class_search();
$status_procat = $model_ca->getProcatStatuses();

$type_ts = $auto_obj->getListOfTypeCars();
$marka_list_ts = $auto_obj->getListMarkaAuto();
$marka_list_bus = $auto_obj->getListMarkBus();
$shortWishList = $model_ca->getShotInfoWishCar($ticket_id);
$commerc_offer_hist = $model_ca->commerc_offer_history($ticket_id);
$waylist_procat_list = $model_ca->getWaylistsForProcat($ticket_id);
//$listComment = $model_ca->getListCallbackForTicket($ticket_id);
$listComment = $model_call->getCallBackHistoryByTicketId($ticket_id,'client');
$list_callback_finclient = $model_call->getCallBackHistoryByTicketId($ticket_id,'client');
$list_account_ur_face = $model_ca->getListAccountUrWithIdOnly();
$list_account_fiz_face = $model_ca->getListAccountFizWithIdOnly();
$partner_statuses = $model_ca->getPartnerStatus();
$getFizFaceRequisites = $model_ca->getFizFaceRequisites($ticket_id);
//$getListPayment = $model_call->getPaymentList($ticket_id);
$getListPayment = $model_ca->getPaymentList($ticket_id);
$commentAboutTicketList = $model_ca->getCommentAboutTicket($ticket_id);
$listOwner = $model_ca->getListOwner($ticket_id);

$check_req = $model_ca->checkExistRequisitesById($ticket_info['user_id']);
$requisites_ur = $model_ca->getRequisitesToEdit($ticket_info['user_id']);
//print_arr($getListPayment_partner);
$date_current = date('d.m.Y');
$short_finance_info = $model_ca->getFinanceFullInfoByTicket($ticket_id);
$list_controller = $model_ca->getListControllers();

$list_services = $model_ca->getListServicesForTicket();

//print_arr($short_finance_info);
 
/*	ini_set('display_errors', 1);
	ini_set('error_reporting', E_ALL);*/

$count_car_wish = count($ticket_info['car_list']);
if($user_id != 0){
	cmsPage::initTemplate('clientAccount_template', "show_ticket")->
	assign('ticket_info',$ticket_info)->
	assign('user_id',$user_id)->
	assign('group_id',$group_id)->
	assign('partner_statuses',$partner_statuses)->
	assign('class_list',$class_list)->
	assign('marka_list',$marka_list_ts)->
	assign('type_ts',$type_ts)->
	assign('commerc_offer_hist',$commerc_offer_hist)->
	assign('marka_list_bus',$marka_list_bus)->
	assign('status_procat',$status_procat)->
	assign('shortWishList',$shortWishList)->
	assign('date_current',$date_current)->
	assign('listComment',$listComment)->
	assign('check_req',$check_req)->
	assign('list_controller',$list_controller)->
	assign('requisites_ur',$requisites_ur)->
	assign('urface',$list_account_ur_face)->
	assign('fizface',$list_account_fiz_face)->
	assign('getListPayment',$getListPayment)->
	assign('waylist_procat_list',$waylist_procat_list)->
	assign('list_services',$list_services)->
	assign('list_callback_client',$list_callback_client)->
	assign('list_callback_finclient',$list_callback_finclient)->
	assign('list_callback_partner',$list_callback_partner)->
	assign('list_callback_finpartner',$list_callback_finpartner)->
	assign('count_car_wish',$count_car_wish)->
	assign('commentAboutTicketList',$commentAboutTicketList)->
	assign('getFizFaceRequisites',$getFizFaceRequisites)->
	assign('short_finance_info',$short_finance_info)->
	assign('listOwner',$listOwner)->
	display("show_ticket.tpl");
}else{
 	echo "Упс. Вы не авторизованы! Для просмотра информации будьте добры авторизоваться";
}