<?php
$inCore->loadModel('clientAccount');
cmsCore::loadClass('auto_use');
cmsCore::loadModel('partner');
$inUser = cmsUser::getInstance();
$model_partner = new cms_model_partner();

$model_ca = new cms_model_clientAccount();
$auto_obj = new cmsAuto_use();

$user_id = $inUser->id;
$ticket_id = cmsCore::request('ticket_id','str','');

$listWishes = $model_ca->getTicketInfo($ticket_id);
$class_list = $model_partner->get_class_search();
$ticket_city = $listWishes['ticket_city'];

foreach ($listWishes['car_list'] as $key => $wish){
	$preset_array[$key] = $model_ca->getPresetCar($wish['id']);
}

foreach ($preset_array as $set) {
	foreach ($set as $value) {
		$temp_arr[] = $value['car_info']['id'];
	}
}

$line_preset_car = implode(',',$temp_arr);

cmsPage::initTemplate('clientAccount_template', "presetCarForTicketProcatWish")->
assign('listWishes',$listWishes)->
assign('class_list',$class_list)->
assign('preset_array',$preset_array)->
assign('line_preset_car',$line_preset_car)->
assign('ticket_city',$ticket_city)->
display("presetCarForTicketProcatWish.tpl");