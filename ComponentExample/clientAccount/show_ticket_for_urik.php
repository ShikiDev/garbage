<?php
$inCore->loadModel('clientAccount');
$inUser = cmsUser::getInstance();
$model = new cms_model_clientAccount();

$user_id = $inUser->id;
$group_id = $inUser->group_id;
$ticket_id = cmsCore::request('ticket_id','str','');

$ticket_info = $model->getTicketDataForUrik($ticket_id);
$check_req = $model->checkExistRequisitesById($user_id);
//print_arr($ticket_info);

if($user_id!=''){
	if($group_id == '18'){
		cmsPage::initTemplate('clientAccount_template', "show_ticket_for_urik")->
		assign('ticket_info',$ticket_info)->
		assign('check_req',$check_req)-> 
		display("show_ticket_for_urik.tpl");
	}else{
		cmsCore::redirect('/clientAccount/list_ticket');
	}
}else{
	echo "Упс. Вы не авторизованы! Для просмотра информации будьте добры авторизоваться";
}
