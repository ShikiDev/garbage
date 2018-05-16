<?php
$inCore->loadModel('clientAccount');
cmsCore::loadClass('auto_use');
$inUser = cmsUser::getInstance();

$model_ca = new cms_model_clientAccount();
$auto_obj = new cmsAuto_use();
$user_id = $inUser->id;
$group_id = $model_ca->getUserById($user_id);

$list_ticket_procat = $model_ca->getListTicketProcat($user_id);
$list_client_ur = $model_ca->listNickClient();
$status_procat = $model_ca->getProcatStatuses();
$counter_ticket = count($list_ticket_procat);
$today = date('d.m.Y');
//print_arr($list_ticket_procat);
cmsPage::initTemplate('clientAccount_template', "list_ticket_procat")->
assign('list_ticket_procat',$list_ticket_procat)->
assign('group_id',$group_id)->
assign('list_client_ur',$list_client_ur)->
assign('status_procat',$status_procat)->
assign('counter_ticket',$counter_ticket)->
assign('date_current',$today)->
display("list_ticket_procat.tpl");