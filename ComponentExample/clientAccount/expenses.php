<?php
	$inCore->loadModel('clientAccount');
	$model_ca = new cms_model_clientAccount();
	$date_current = date('d.m.Y');
	$list = $model_ca->getExpenses();
	$list_2 = $model_ca->getHangovers();
cmsPage::initTemplate('clientAccount_template', "expenses")->
assign("date_current",$date_current)->
assign("list",$list)->
assign("list_ho",$list_2)->
display("expenses.tpl");