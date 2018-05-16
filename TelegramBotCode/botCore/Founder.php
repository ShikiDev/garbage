<?php
/**
 * Created by PhpStorm.
 * User: user
 * Date: 18.01.2018
 * Time: 12:11
 */
namespace botCore;

class Founder
{
	/*в целях зашиты представлен такой странный токен*/
    const BOT_TOKEN = "535520388:1";
    private $token;
    private $url;
    private $id_bot;
    private $botname;
    public static $update_ID;
    public static $authorized = false;

    public function __construct(){
        $this->token = SELF::BOT_TOKEN;
        $this->url = 'https://api.telegram.org/bot'.$this->token.'/';
        self::$update_ID = 0;
    }

    public  function request($method,$fields = null,$headers = null,$json = true){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->url.$method); //куда мы отсылаем запрос
        if(is_array($headers)) curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);//заголовки
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);//
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);
        $response = curl_exec($ch);
        //self::print_arr($response);
        curl_close($ch);
        if($json) return json_decode($response);
    }

    public function authorizeBot(){
        $request_res =  $this->request('getMe');
        if($request_res===null)
        {
            return 'null';
        }
        if($request_res->ok)
        {
            $this->id_bot = $request_res->result->id;
            $this->botname = $request_res->result->username;

            return 21;
        }else{
            if($request_res->error_code){
                $err_string = "Error: ".$request_res->error_code." Description error: ".$request_res->description;
            }else{
                $err_string = "Unexpected error.T_T";
            }
            return $err_string;
        }
    }

    public function  getUpdates($offset,$timeout = 600,$limit = 10,$allowed_updates = null){
        $offset++;
        $result = $this->request('getUpdates', ['offset'=>$offset,'timeout' => $timeout, 'limit' => $limit, 'allowed_updates' => $allowed_updates]);
        return $result;
    }

    /*Отладка работы приват параметров. Не забыть удалить*/
    public function getPrivateData(){
        $string = "token: ".$this->token;
        $string .= " url: ".$this->url;
        return $string;
    }

     public static function print_arr($i) {
        echo '<pre>';
        print_r($i);
        echo '</pre>';
    }

    public function sendMessage($chat_id,$text,$reply_markup = null,$parse_mode = false,$disable_web_page_preview = false,$disable_notification = false, $reply_to_message_id = null){
        if(is_int($chat_id)) {
            if(is_string($text)) {
                $text = str_replace("/","",$text);
                $this->request('sendMessage',
                    ["chat_id"=>$chat_id,"text"=>$text,'parse_mode'=>$parse_mode,
                     'disable_web_page_preview'=>$disable_web_page_preview,'disable_notification'=>$disable_notification,
                     'reply_to_message_id'=>$reply_to_message_id,'reply_markup'=>$reply_markup]);
            }
        }
    }

    public function answerCBQuery($cb_query_id,$text = null,$url = null,$show_alert = false, $cache_time = null){
        $this->request('answerCallbackQuery',['callback_query_id'=>$cb_query_id,'text'=>$text,'url'=>$url,'show_alert'=>$show_alert,'cache_time'=>$cache_time]);
    }

    public function sendYourLocation($chat_id,$latitude,$longitude,$keyboard = null, $live_period = null, $disable_notification = false,$reply_to_message_id = null){
        $this->request('sendLocation',['chat_id'=>$chat_id,'latitude'=>$latitude,'longitude'=>$longitude,'reply_markup'=>$keyboard,'live_period'=>$live_period,'disable_notification'=>$disable_notification,'reply_to_message_id'=>$reply_to_message_id]);
    }

    public function sendPhoto($chat_id,$photo,$caption,$keyboard = null,$disable_notification = false,$reply_to_message_id = null){
        $this->request('sendPhoto',['chat_id'=>$chat_id,'photo'=>$photo,'caption'=>$caption,'reply_markup'=>$keyboard,'disable_notification'=>$disable_notification,'reply_to_message_id'=>$reply_to_message_id]);
    }

    public function sendVenue($chat_id,$latitude,$longitude,$title,$address,$keyboard = null,$foursquare_id = null,$disable_notification=false,$reply_message_id = null){
        $this->request('sendVenue',['chat_id'=>$chat_id,'latitude'=>$latitude,'longitude'=>$longitude,
                                            'title'=>$title,'address'=>$address,'reply_markup'=>$keyboard,
                                            'foursquare_id'=>$foursquare_id,'disable_notification'=>$disable_notification,'reply_message_id'=>$reply_message_id]);
    }

    public function sendDocument($chat_id,$document,$caption,$keyboard = null,$disable_notification = false,$reply_to_message_id = null){
        $this->request('sendDocument',['chat_id'=>$chat_id,'document'=>$document,'caption'=>$caption,'reply_markup'=>$keyboard,'disable_notification'=>$disable_notification,'reply_to_message_id'=>$reply_to_message_id]);
    }

    public function sendVideo($chat_id,$video,$duration = null,$width = null,$height = null,$caption = null,$keyboard = null,$disable_notification = false,$reply_to_message_id = null){
        $this->request('sendVideo',['chat_id'=>$chat_id,'video'=>$video,'duration'=>$duration,'width'=>$width,'height'=>$height,'caption'=>$caption,'reply_markup'=>$keyboard,'disable_notification'=>$disable_notification,'reply_to_message_id'=>$reply_to_message_id]);
    }

    public function  sendChatAction($chat_id,$action){
        $this->request('sendChatAction',['chat_id'=>$chat_id,'action'=>$action]);
    }

    public function downloadFile($user_id,$file_path,$folder_name = null){
        $tg_bot_img_link = "https://api.telegram.org/file/bot".$this->token."/".$file_path;
        $folder_name = ($folder_name!=null)?"/".$folder_name:"";
        if($folder_name!=null){
            $dir = "/var/www/u0213320/data/www/b2b.vsklogistic.ru/upload/img_telegram_bot".$folder_name;
            if (!is_dir($dir)) {
                mkdir($dir);         
            }
        }
        $new_img_path = "/var/www/u0213320/data/www/b2b.vsklogistic.ru/upload/img_telegram_bot".$folder_name."/".$user_id."_";
        $doc_num = strtotime(date('Y-m-d H:i'));
        if(!copy($tg_bot_img_link,$new_img_path.$doc_num.".jpg")){
            return false;
        }else{
            return true;
        }
    }

    public function getFile($file_id){
        return $this->request('getFile',['file_id'=>$file_id]);
    }

    public function getWebhookInfo($url,$pending_update_count,$has_custom_certificate = true,$last_error_date = null,$last_error_message = null){
        return $this->request('getWebhookInfo',['url'=>$url,'has_custom_certificate'=>$has_custom_certificate,'pending_update_count'=>$pending_update_count,'last_error_date'=>$last_error_date,'last_error_message'=>$last_error_message]);
    }
}