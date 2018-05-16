<?php
$inCore->loadModel('clientAccount');
$model_ca = new cms_model_clientAccount();

$id_client = cmsCore::request('id_client','str','');
$client_info = $model_ca->showClient($id_client);
//print_arr($client_info);

$login = cmsCore::request('login_client','str','');
if($login!=''){
	$pass = cmsCore::request('pass_client','str','');
	$nameClient = cmsCore::request('nick_client','str','');
	$res = $model_ca->editClientAccount(array('login'=>$login,
									  'nickname'=>$nameClient,
									  'group_id'=>'18'),$pass,$id_client);
	if($res){
		cmsCore::redirect('/clientAccount/editClient/'.$id_client);
	}
}

cmsPage::initTemplate('clientAccount_template', "editClientAccount")->
assign('client_info',$client_info)->
display("editClientAccount.tpl");