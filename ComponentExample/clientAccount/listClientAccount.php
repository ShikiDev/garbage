<?php
$inCore->loadModel('clientAccount');
$model_ca = new cms_model_clientAccount();

$listAccounts = $model_ca->getAllAccounts();
$listAccountsFiz = $model_ca->getAllAccountsFiz();

cmsPage::initTemplate('clientAccount_template', "listClientAccount")->
assign('listAccounts',$listAccounts)->
assign('listAccountsFiz',$listAccountsFiz)->
display("listClientAccount.tpl");