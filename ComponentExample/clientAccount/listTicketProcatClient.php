<?php

$inCore->loadModel('clientAccount');
cmsCore::loadClass('auto_use');
$inUser = cmsUser::getInstance();

$model_ca = new cms_model_clientAccount();
$auto_obj = new cmsAuto_use();

$user_id = $inUser->id;

$list_ticket_procat = $model_ca->getListTicketProcat($user_id);
$counter_ticket = count($list_ticket_procat);

cmsPage::initTemplate('clientAccount_template', "listTicketProcatClient")->
assign('list_ticket_procat',$list_ticket_procat)->
assign('counter_ticket',$counter_ticket)->
assign('nickname',$inUser->nickname)->
assign('group_id',$inUser->group_id)->
display("listTicketProcatClient.tpl");