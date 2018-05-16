<?php
$inCore->loadModel('clientAccount');
$model_ca = new cms_model_clientAccount();

$client_id = cmsCore::request('client_id','int',0);
$client_info = $model_ca->showClient($client_id);
$client['name'] = $client_info['nickname'];
$client['login'] = $client_info['login'];
$client['tag'] = $client_info['group_id'];
$client['phone'] = $client_info['phone'];
$client['post_address'] = $client_info['post_address'];
$client['cont_face'] = $client_info['cont_face'];
$client['cont_phone'] = $client_info['cont_phone'];
$client['num_doc'] = $client_info['num_doc'];
$client['data_doc'] = $client_info['data_doc'];
$client['doc_w_h'] = $client_info['doc_w_h'];
$client['email'] = $client_info['email'];
unset($client_info);

$list_ticket = $model_ca->getListTicketOfClient($client_id);

if($client['tag'] == '18'){
	$requisites = $model_ca->getRequisitesToEdit($client_id);
	$check_req = $model_ca->checkExistRequisitesById($client_id);
}elseif($client['tag'] == '21'){
	$requisites = $model_ca->getFizFaceRequisitesById($client_id);
	$check_req = $model_ca->checkExistFizRequisitesById($client_id);
}
$dogov_data = $model_ca->getExistNumberDog($client_id,'ur');
$dogov_data_fiz = $model_ca->getExistNumberDog($client['login'],'fiz');
//print_arr($check_req);
$date_current = date('d.m.Y');

cmsPage::initTemplate('clientAccount_template', "client_cabinet")->
assign('client',$client)->
assign('list_ticket',$list_ticket)->
assign('client_id',$client_id)->
assign('check_req',$check_req)->
assign('requisites',$requisites)->
assign('dog_data',$dogov_data)->
assign('dog_data_fiz',$dogov_data_fiz)->
assign('date_current',$date_current)->
display("client_cabinet.tpl");