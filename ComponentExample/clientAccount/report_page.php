<?php
$inCore->loadModel('clientAccount');
cmsCore::loadClass('auto_use');
$inUser = cmsUser::getInstance();

$model_ca = new cms_model_clientAccount();
$group_id = $model_ca->getUserById($user_id);

$fin_report_data = $model_ca->getFinReport();
print_arr($fin_report_data);

$arr = $model_ca->formDataAboutPaymentByType(10);
print_arr($arr);

cmsPage::initTemplate('clientAccount_template', "report_page")->
assign('group_id',$group_id)->
display("report_page.tpl");