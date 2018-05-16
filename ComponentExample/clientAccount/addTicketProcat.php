<?php
$inCore->loadModel('clientAccount');
cmsCore::loadClass('auto_use');
$inUser = cmsUser::getInstance();	

$model_ca = new cms_model_clientAccount();
$auto_obj = new cmsAuto_use();
$user_id = $inUser->id;

$today = date('d.m.Y');
$marka_list_ts = $auto_obj->getListMarkaAuto();
$type_ts = $auto_obj->getListOfTypeCars();
$marka_list_bus = $auto_obj->getListMarkBus();
$marka_list_minivan = $auto_obj->getListMarkMinivan();
$marka_list_autobus = $auto_obj->getListMarkBigBus();
$nick_user = $model_ca->getNickUser($user_id);
$group_id = $model_ca->getUserById($user_id);
$name_user = $inUser->nickname;
$phone_user = $inUser->phone;
$email_user = $inUser->email;

$carList = cmsCore::request('carsList','str','');
if(cmsCore::request('tel','str','')!=''){
	if(cmsCore::request('type_client','str','') == 'ur'){
		$face_id = cmsCore::request('id_face','str','');
		$face_nick = $model_ca->getNickUser($face_id);
		$user_id = ($face_id == $user_id)?$user_id:$face_id;
		$nick_user = ($face_nick == $nick_user)?$nick_user:$face_nick;
	}elseif(cmsCore::request('type_client','str','') == 'fiz'){
		if(($group_id == '18')||($group_id == '21')){
			$user_id = ($user_id!= '0')?$user_id:'0';
			$nick_user_fiz = cmsCore::request('contact_face','str','');
			$nick_user = ($nick_user!='')?$nick_user:$nick_user_fiz;		
		}else{
			$user_id = '0';
			$nick_user = cmsCore::request('contact_face','str','');
		}
	}

	$array_ticket_procat = array('user_id'=>$user_id,
								 'nick_client'=>$nick_user,
								 'type_client'=>cmsCore::request('type_client','str',''),
								 'type_payment'=>cmsCore::request('payment','str',''),
								 'contact_face'=>cmsCore::request('contact_face','str',''),
								 'tel'=>cmsCore::request('tel','str',''),
								 'without_tel'=>str_replace(array(" ","(",")","-"),"",cmsCore::request('tel','str','')),
								 'email'=>cmsCore::request('email','str',''),
								 'client_budget'=>cmsCore::request('client_budget','str',''),
								 'time_add'=>date('Y-m-d H:i',time()),
								 'status_ticket'=>'Новая заявка',
								 'ticket_city'=>cmsCore::request('ticket_city','str',''),
								 'came_from'=>cmsCore::request('came_from','str','')
								);
	//print_arr($array_ticket_procat);
	$ticket_id = $model_ca->addTicketProcat($array_ticket_procat,$carList);
	//print_arr($ticket_id);
	if(($ticket_id != '')&&(cmsCore::request('email','str','')!='')){
		$subject_vsk = "Новая заявка. ТЕСТ!!!";
		$subject_client = "Вы оставили заявку на транспортное средство в прокат";
		$text_vsk = "<span>Оставлена новая заявка №".$ticket_id."</span>
					<br>
					<span>Подробности по заявке вы можете посмотреть в карточке заявки</span><br><br>".$model_ca->formingLink($ticket_id);
		$message_vsk_body = $model_ca->getShapeForBodyMessage($text_vsk);
		$message_vsk_footer = $model_ca->getFooterForMessageFirst();
		$message_vsk = $model_ca->fulltemplateForMessage($message_vsk_body,$message_vsk_footer);


		$message_client = "";
		$text_client = "<span>Вы оставили заявку на прокат транспортного средства.</span>
						<br>
						<span>Подробнее данные по заявке вы можете посмотреть в карточке заявки</span><br><br>".$model_ca->formingLink($ticket_id);
		$message_client_body = $model_ca->getShapeForBodyMessage($text_client);
		$message_client_header = $model_ca->getFooterForMessageFirst();
		$message_client = $model_ca->fulltemplateForMessage($message_client_body,$message_vsk_footer);

		$header  = "Content-type: text/html; charset=utf-8 \r\n";
        $header .= "From: ВСК Лоджистик <rent@vsklogistic.ru>\r\n";

		$model_ca->sendMailVSK($subject_vsk,$message_vsk,$header);
		//$model_ca->sendMailClient((string)cmsCore::request('email','str',''),$subject_client,$message_client,$header);
		cmsCore::redirect('/clientAccount/ticket_procat/'.$ticket_id);
	}else{
		cmsCore::redirect('/clientAccount/ticket_procat/'.$ticket_id);
	}
	//print_arr($_POST);
}

cmsPage::initTemplate('clientAccount_template', "addTicketProcat")->
assign('date_current',$today)->
assign('marka_list',$marka_list_ts)->
assign('type_ts',$type_ts)->
assign('marka_list_bus',$marka_list_bus)->
assign('marka_list_minivan',$marka_list_minivan)->
assign('marka_list_autobus',$marka_list_autobus)->
assign('group_id',$group_id)->
assign('phone_user',substr($phone_user,0))->
assign('email_user',$email_user)->
assign('name_user',$name_user)->
display("addTicketProcat.tpl");