<?php
	$inCore->loadModel('clientAccount');
	$model_ca = new cms_model_clientAccount();

	$consult_list = $model_ca->getConsultList();

	cmsPage::initTemplate('clientAccount_template', "consult_page")->
	assign('consult_list',$consult_list)->
	display("consult_page.tpl");