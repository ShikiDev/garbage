<?php
/**
 * Created by PhpStorm.
 * User: user
 * Date: 18.01.2018
 * Time: 12:10
 */


define('PATH', dirname(__FILE__));
require_once('botCore/Founder.php');
require_once('botCore/Keyboard.php');
require_once('botCore/Database.php');
use botCore\Founder;
use botCore\Keyboard;
use botCore\Database;
$bot_obj = new Founder();
$key_obj = new Keyboard();
$db_obj = new Database();
$auth_res = $bot_obj->authorizeBot();

$array_user = [];
Founder::print_arr($auth_res);
if($auth_res!=21) {
    print_r($auth_res);
}else{
	echo "inside";
    $messages = json_decode(file_get_contents("php://input"));
    Founder::print_arr($messages);

    print_r($bot_obj->getWebhookInfo("https://b2b.vsklogistic.ru/bot.php",8));
	Founder::print_arr($messages);

	$chat_id = $messages->message->chat->id;

    if($messages->message) {
        echo $messages->message->text;
        if($messages->message->text == "/start"){
            $type = "start";
        }elseif($messages->message->text == "/restart"){
            $type = "restart";
        }elseif($messages->message->text) {
            if(stripos($messages->message->text,"*") === 0){
                $resCheck = stripos($messages->message->text,"*");
                if($resCheck === false){
                    $type = $messages->message->text;
                    if($type == "К выезду готов"){
                        $type = "driver_informed";
                    }
                }else{
                    $type = "getroutedata";
                }
            }elseif(stripos($messages->message->text,"#") === 0){
                $resCheck = stripos($messages->message->text,"#");
                if($resCheck === false){
                    $type = $messages->message->text;
                    if($type == "К выезду готов"){
                        $type = "driver_informed";
                    }
                }else{
                    $type = "readygetphoto";
                }
            }else{
               $type = $messages->message->text;
                if($type == "К выезду готов"){
                    $type = "driver_informed";
                }
            }
        }elseif ($messages->message->contact) {
            $type = "getphone";
        }elseif ($messages->message->photo){
            $type = "getphoto";
        }elseif($messages->message->location) {
            $type = "getlocation";
        }else{
            $type = "";
        }
    }elseif($messages->callback_query){
        $type = "callback_query";
    }

    $chat_id = $messages->message->chat->id;
    Founder::$update_ID = $messages->update_id;

    print_r($type);
    switch ($type){
        case 'start':
            $getPhoneNumber = $key_obj->button("Поделиться номером телефона",'contact');
            $key_obj->getRowKeyboard($getPhoneNumber);
            $bot_obj->sendMessage($chat_id, "Здравствуйте, я бот. Позвольте мне познакомить вас с некоторыми моими возможностями.",$key_obj->generateKeyboard('reply'));
            break;
        case 'restart':
            $getPhoneNumber = $key_obj->button("Поделиться номером телефона",'contact');
            $key_obj->getRowKeyboard($getPhoneNumber);
            $bot_obj->sendMessage($chat_id, "Здравствуйте, я бот. Позвольте мне познакомить вас с некоторыми моими возможностями.",$key_obj->generateKeyboard('reply'));
            break;
        case 'getphone':
            $array = [];
            $array['user_id'] = $chat_id;
            $array['phone'] = str_replace("+","",$messages->message->contact->phone_number);

            $chech_exist = $db_obj->select("srm_procat_drivers",['id'],"deleted = 0 and tel1_short LIKE '%{$array['phone']}%'");
            if($chech_exist){                        
                if($db_obj->getAuthorization($chat_id)){
                   $res = $db_obj->update("srm_botuser_ids",['phone'=>$array['phone']],"user_id = '{$chat_id}'");
                   if($res){
                        $bot_obj->sendMessage($chat_id,"Вы авторизованы!");
                   }else{
                        $bot_obj->sendMessage($chat_id,"Упс, произошла ошибка при регистрации. Попробуйте позже!");
                   }
                }else{
                   $res = $db_obj->insert("srm_botuser_ids",$array);
                    if($res){
                        $bot_obj->sendMessage($chat_id,"Вы были успешно зарегистрированы!");
                    }else{
                        $bot_obj->sendMessage($chat_id,"Упс, произошла ошибка при регистрации. Попробуйте позже!");
                    }
                }
            }else{
                $bot_obj->sendMessage($chat_id,"Извините, но ваш номер телефона не был найден в базе. Свяжитесь с сотрудником для получения доступа. ваш телефон ".$array['phone']);
            }
            break;
        case 'readygetphoto':
            if($db_obj->getAuthorization($chat_id)){
                $number = rand(24,25);
                $today_begin = date('Y-05-'.$number);
                $today_end = date('Y-m-d',strtotime($today_begin)+86400);
                $resu = $db_obj->select("srm_procat_events",['id']," (data_begin <= '{$today_begin}' and data_end >= '{$today_end}')");
                if(($resu['id']!= '0')&&($resu!='')){
                    $getData = substr($messages->message->text,1);
                    $arr_data = explode('.',$getData);
                    $today_b = date('Y-m-d 00:00',strtotime(implode('-',array(date('Y'),$arr_data[1],$arr_data[0]))));
                    $today_e = date('Y-m-d 23:59',strtotime($today_b));
                    $db_obj->update("srm_driver_route_confirm",['gotwlphoto'=>'1'],"user_id = '{$chat_id}' and dt BETWEEN '{$today_b}' and '{$today_e}' ORDER BY id DESC LIMIT 1");
                    $bot_obj->sendMessage($chat_id,"Мы готовы принять ваш путевой лист за ".date('d.m.Y',strtotime($today_b)).".");
                }else{
                    $bot_obj->sendMessage($chat_id,"Сейчас не проводятся мероприятия!");
                }                    
            }else{
                $bot_obj->sendMessage($chat_id,"В доступе отказано. Авторизуйтесь, чтобы мы смогли принять ваши фотографии");
            }
            
            break;
        case 'getphoto':
            if($db_obj->getAuthorization($chat_id)){
                $number = rand(24,25);
                $today_begin = date('Y-05-'.$number);
                $today_end = date('Y-m-d',strtotime($today_begin)+86400);
                $resu = $db_obj->select("srm_procat_events",['id']," (data_begin <= '{$today_begin}' and data_end >= '{$today_end}')");
                if(($resu['id']!= '0')&&($resu!='')){
                    $last_id = count($messages->message->photo) - 1;
                    $file = $bot_obj->getFile($messages->message->photo[$last_id]->file_id);
                    $bot_obj->downloadFile($chat_id,$file->result->file_path,(string)$resu[0]['id']);
                    $bot_obj->sendMessage($chat_id,"Ваша фотография была сохранена.");
                }else{
                    $bot_obj->sendMessage($chat_id,"Сейчас не проводятся мероприятия!");
                }                    
            }else{
                $bot_obj->sendMessage($chat_id,"В доступе отказано. Авторизуйтесь, чтобы мы смогли принять ваши фотографии");
            }
            
            break;
        case 'getdocument':
            if($db_obj->getAuthorization($chat_id)){
                $file = $bot_obj->getFile($messages->message->document->file_id);
                $bot_obj->downloadFile($file->result->file_path);
            }else{
                $bot_obj->sendMessage($chat_id,"В доступе отказано. Авторизуйтесь, чтобы мы смогли принять ваши фотографии");
            }
            break;
        case 'getvideo':
            if($db_obj->getAuthorization($chat_id)){
                $file = $bot_obj->getFile($messages->message->video->file_id);
                $bot_obj->downloadFile($file->result->file_path);
            }else{
                $bot_obj->sendMessage($chat_id,"В доступе отказано. Авторизуйтесь, чтобы мы смогли принять ваши фотографии");   
            }
            break;
        case 'getroutedata':
            $res = substr($messages->message->text,1);                   
            $array = explode(" ",$res);                    
            $data = array_shift($array);
            $time = array_shift($array);
            $route = implode(" ",$array);
            $route = str_replace(array("'","\\","/","`","?","\""),"", $route);                    
            $data = ($data!='')?date('Y-m-d',strtotime($data.".".date('Y'))):"0000-00-00";
            $time = (($time!='')&&(strtotime($time) != 10800))?date('H:i',strtotime($time)):"00:00";
            $dt = date('Y-m-d H:i',strtotime($data." ".$time));
            if(($data != '1970-01-01')&&($data != '0000-00-00')){
                if(($dt != '1970-01-01 03:00:00')&&($dt != '0000-00-00 00:00:00')&&($route!='')&&(strtotime($dt)>time())&&($time!='00:00')){
                    $check_data = date('Y-m-d',strtotime($dt));
                    $today = date('Y-m-d');
                    $temp_dt_format = date('Y-m-d',strtotime($dt));
                    $check_exist = $db_obj->select('srm_driver_route_confirm',array('id'),"user_id = '{$chat_id}' and dt LIKE '%{$temp_dt_format}%'");
                    if($check_exist[0] > 0){
                        $today_b = date('Y-m-d 00:00',strtotime($dt));
                        $today_e = date('Y-m-d 23:59',strtotime($dt));
                        $driver_info =$db_obj->select("srm_driver_route_confirm",array('id_driver','id_event','ticket_id'),"user_id = '{$chat_id}'");
                        $db_obj->update("srm_driver_route_confirm",['route'=>$route,'dt'=>$dt,'informed'=>1],"user_id = '{$chat_id}' and dt BETWEEN '{$today_b}' and '{$today_e}' ORDER BY id DESC LIMIT 1");
                    }else{
                        $driver_info = $db_obj->select("srm_driver_route_confirm",array('id_driver','id_event','ticket_id'),"user_id = '{$chat_id}' and dt >= '0000-00-00 00:00'");
                        $db_obj->insert("srm_driver_route_confirm",['route'=>$route,'dt'=>$dt,'user_id'=>$chat_id,'id_driver'=>$driver_info[0]['id_driver'],'id_event'=>$driver_info[0]['id_event'],'ticket_id'=>$driver_info[0]['ticket_id']]);
                    }
                    $bot_obj->sendMessage($chat_id,"Вы прислали маршрут: ".$route." на ".$dt);
                }else{
                    $bot_obj->sendMessage($chat_id,"Вы указали маршрут в неверном формате или прошедшую дату. Повторите попытку. Формат *дд.мм чч:мм адрес");
                }
            }else{
                $bot_obj->sendMessage($chat_id,"Вы указали маршрут в неверном формате. Повторите попытку. Формат *дд.мм чч:мм адрес");
            }
            break;
        case 'driver_informed':
            $time_b_range = date("Y-m-d 00:00");
            $time_e_range = date("Y-m-d 23:59");
            $db_obj->update("srm_driver_route_confirm",['confirmed'=>1],"user_id = '{$chat_id}' and dt BETWEEN '{$time_b_range}' and '{$time_e_range}'");
            $bot_obj->sendMessage($chat_id,"Спасибо за подтверждение",$key_obj->removeKeyboard());
            break;
        case 'callback_query':
            break;
        default:
            $bot_obj->sendMessage($chat_id, "Я не знаю такой команды. Попробуйте воспользоваться командами через \/ или кнопки управления для того, чтобы я вас корректно понимал.");
            break;
    }
}

?>
