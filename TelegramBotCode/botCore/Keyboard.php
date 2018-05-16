<?php
/**
 * Created by PhpStorm.
 * User: user
 * Date: 19.01.2018
 * Time: 12:53
 */

namespace botCore;


class Keyboard
{
    private $keys_array;

    public function __construct(){
        $this->keys_array;
    }

    public function button($text,$type = null){
        if($type == 'contact'){
            return ['text' => $text,'request_contact'=>true];
        }elseif($type == 'location'){
            return ['text' => $text,'request_location'=>true];
        }else{
            return ['text' => $text];
        }
    }

    public function inlineButton($text,$url = null,$callback_data = null,$switch_inline_query = null, $switch_inline_query_cur_chat = null, $callback_game = null, $pay = false){
        $array = [];
        $array['text'] = $text;
        if($url) $array['url'] = $url;
        if($callback_data) $array['callback_data'] = $callback_data;
        if($switch_inline_query) $array['switch_inline_query'] = $switch_inline_query;
        if($switch_inline_query_cur_chat) $array['switch_inline_query_cur_chat'] = $switch_inline_query_cur_chat;
        if($callback_game) $array['callback_game'] = $callback_game;
        if($pay) $array['pay'] = $pay;
        return $array;
    }

    public  function getRowKeyboard(){
        $arguments = func_get_args();
        $request = [];
        if(is_array($arguments)){
            foreach ($arguments as $arr) {
                $request[] = $arr;
            }
            $this->keys_array[] = $request;
        }else{
            return false;
        }

    }

    public function  generateKeyboard($type){
        if($type != 'inline') {
            return json_encode(['keyboard'=>$this->keys_array, 'resize_keyboard' => true,'one_time_keyboard' => true]);
        }else{
            return json_encode(['inline_keyboard'=>$this->keys_array]);
        }
    }

    public function removeKeyboard(){
        return json_encode(['remove_keyboard'=>true,'selective'=>false]);
    }
}