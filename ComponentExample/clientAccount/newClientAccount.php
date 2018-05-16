<?php
$inCore->loadModel('clientAccount');
$model_ca = new cms_model_clientAccount();

$login = cmsCore::request('login_client','str','');
if($login!=''){
	$pass = cmsCore::request('pass_client','str','');
	$nameClient = cmsCore::request('nick_client','str','');
	$res = $model_ca->addClientAccount(array('login'=>$login,
									  'nickname'=>$nameClient,
									  'group_id'=>'18'),$pass,'ur');
	if($res){
		cmsCore::redirect('/clientAccount/editClient/'.$res);
	}
}


cmsPage::initTemplate('clientAccount_template', "newClientAccount")->
display("newClientAccount.tpl");