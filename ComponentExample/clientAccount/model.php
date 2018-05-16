<?php
  if (!defined('VALID_CMS')) {die('ACCESS DENIED');}

  ///////////////////////////////////////////////////////////////////////////////

  class cms_model_clientAccount{
  		public function __construct() {
        	$this->inDB = cmsDatabase::getInstance();
    	}

    	public function addClientAccount($arr,$pass,$type_client){
    		$password = md5($pass);
    		$set = implode(',',prepareSQL($arr));
    		$sql = ("INSERT INTO srm_users SET {$set}, password ='{$password}', passClientShow = '{$pass}'");
    		$result = $this->inDB->query($sql);
    		unset($sql);
    		unset($result);
            switch ($type_client) {
                case 'ur':
                    $id_group = "18";
                    break;
                case 'fiz':
                    $id_group = "21";
                    break;
            }
    		$sql = ("SELECT id FROM srm_users WHERE group_id = '{$id_group}' ORDER BY id DESC LIMIT 1");
    		$result = $this->inDB->query($sql);
    		$data  = $this->inDB->fetch_assoc($result);
            unset($sql);
            unset($result);
            $sql = ("INSERT INTO srm_user_profiles SET user_id ='{$data['id']}'");
            $result = $this->inDB->query($sql);
            return $data['id'];
    	}

    	public function showClient($id){
    		$sql = ("SELECT * FROM srm_users WHERE id = '{$id}' and (group_id = '18' or group_id = '21')");
    		$result = $this->inDB->query($sql);
    		while($trash = $this->inDB->fetch_assoc($result)){
    			$data = $trash;
    		}
    		return $data;
    	}

    	public function editClientAccount($arr,$pass,$client_id){
            $password = md5($pass);
    		$set = implode(',',prepareSQL($arr));
    		$sql = ("UPDATE srm_users SET {$set}, password ='{$password}', passClientShow = '{$pass}' WHERE id ='{$client_id}'");
    		$result = $this->inDB->query($sql);
    		return true;
    	}

        public function getAllAccounts(){
            $sql = ("SELECT * FROM srm_users WHERE group_id = '18'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['col_ticket'] = $this->countTicketByClientId($trash['id']);
                $data[] = $trash;
            }
            return $data;
        }

        public function getAllAccountsFiz(){
            $sql = ("SELECT * FROM srm_users WHERE group_id = '21'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['col_ticket'] = $this->countTicketByClientId($trash['id']);
                $data[] = $trash;
            }
            return $data;
        }

        public function addTicketProcat($arr,$car_list){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketProcat SET {$set}");
            $result = $this->inDB->query($sql);
            unset($sql);
            unset($result);
            $sql = ("SELECT id FROM srm_procat_ticketProcat ORDER BY id DESC LIMIT 1");
            $result = $this->inDB->query($sql);
            $data  = $this->inDB->fetch_assoc($result);
            $ticket_id = $data['id'];

            $arr_car = explode(']', substr($car_list,1));
            foreach ($arr_car as $key => $car) {
                $massive = explode('|', $car);
                $massive[3] = date('Y-m-d',strtotime($massive[3]));
                $massive[4] = date('Y-m-d',strtotime($massive[4]));              
                $sql = ("INSERT INTO srm_procat_carsWishForTicketProcat SET ticket_id = '{$ticket_id}',
                                                                            type_ts = '{$massive[0]}',
                                                                            mark_ts = '{$massive[1]}',
                                                                            model_ts = '{$massive[2]}',
                                                                            begin_procat = '{$massive[3]}',
                                                                            end_procat = '{$massive[4]}',
                                                                            begin_time = '{$massive[5]}',
                                                                            end_time = '{$massive[6]}',
                                                                            route = '{$massive[7]}',
                                                                            analog = '{$massive[8]}',
                                                                            count_ts = '{$massive[9]}',
                                                                            comment_ts = '{$massive[10]}',
                                                                            auto_without_driver = '{$massive[11]}',
                                                                            transfer = '{$massive[12]}',
                                                                            color_ts = '{$massive[13]}',
                                                                            count_places = '{$massive[14]}'
                                                                            ");
                $result = $this->inDB->query($sql);

                unset($massive);
                unset($sql);
                unset($result);
            }
            return $ticket_id;
        }

        public function getNickUser($id){
            $sql = ("SELECT nickname FROM srm_users WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
            $trash = $this->inDB->fetch_assoc($result);
            return $trash['nickname'];
        }

        public function getTicketInfo($ticket_id){
            $sql = ("SELECT * FROM srm_procat_ticketProcat WHERE id = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                $trash['list'] = $trash['car_list'];
                $trash['car_list'] = $this->getListWishedCarForTicketProcat($trash['id']);
                $trash['manager_info'] = ($trash['id_control']!='0')?$this->getUserInfo($trash['id_control']):'';
                $trash['last_client_callback'] = $this->getLastCommentForClient($ticket_id);
                $trash['color_status'] = $this->getColorStatusByValue($trash['status_ticket']);
                $data = $trash;
            }
            return $data;
        }

        public function setInController($ticket_id,$id_control){
            $sql = ("UPDATE srm_procat_ticketProcat SET id_control = '{$id_control}',status_ticket='Принята в работу' WHERE id = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
        }

        public function getUserInfo($user_id){
            $sql = ("SELECT nickname,phone FROM srm_users WHERE id = '{$user_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data = $trash;
            }
            return $data;
        }

        public function getUserById($user_id){
            $sql = ("SELECT group_id FROM srm_users WHERE id = '{$user_id}'");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);
            return $data['group_id'];
        }

        public function getListTicketProcat($user_id){
            $group_id = $this->getUserById($user_id);
            if(($group_id != '18')&&($group_id != '21')){
                $sql = ("SELECT * FROM srm_procat_ticketProcat WHERE id!=0 and (status_ticket!='Закрыта' AND status_ticket!='Отказ') ORDER BY time_add DESC");
            }else{
                $sql = ("SELECT * FROM srm_procat_ticketProcat WHERE user_id = '{$user_id}' ORDER BY time_add DESC");
            }
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                $trash['controller'] = ($trash['id_control']!='0')?$this->getUserInfo($trash['id_control']):'';
                $trash['last_client_callback'] = $this->getLastCommentForClient($trash['id']);
                $trash['data_start'] = $this->getDataBeginWorkTicket($trash['id']);
                $trash['partner_work_list'] = $this->getListPartnerWorkTicket($trash['id']);
                $trash['color_status'] = $this->getColorStatusByValue($trash['status_ticket']);
                $data[] = $trash;
            }
            return $data;
        }

        public function sendMailVSK($subject,$message,$header){
            mail('rent@vsklogistic.ru',$subject,$message,$header);
        }

        public function sendMailClient($to,$subject,$message,$header){
            mail($to,$subject,$message,$header);
        }

        public function getListWishedCarForTicketProcat($ticket_id){
            $sql = ("SELECT * FROM srm_procat_carsWishForTicketProcat WHERE ticket_id = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
            while ($trash = $this->inDB->fetch_assoc($result)) {
                $trash['begin_procat'] = date('d.m.Y',strtotime($trash['begin_procat']));
                $trash['end_procat'] = date('d.m.Y',strtotime($trash['end_procat']));
                if($trash['setted_car']!='0'){
                    $trash['car_setted'] = $this->getSettedTS($trash['id']);
                }
                $trash['begin_time'] = date('H:i',strtotime($trash['begin_time']));
                $trash['end_time'] = date('H:i',strtotime($trash['end_time']));
                $confirme = $this->getConfirmedTSByIdWish($trash['id']);
                $conf_short = array($confirme['id'],$confirme['id_wishcar']);
                $trash['confirmed'] = ($confirme)?$confirme:'';
                $trash['confirmed_short'] = ($confirme)?implode('|', $conf_short):'';
                $trash['auto_without_driver'] = ($trash['auto_without_driver'] == 'y')?'Да':'Нет';
                unset($confirme);
                $data[] = $trash;
            }
            return $data;
        }

        public function getHeaderForMessage(){
            $str = "";
            $str = "<table width='100%' border='0' cellpadding='0' cellspacing='0' style='border-bottom:2px solid #b5b4b4;'>
                        <tbody>
                            <tr>
                                <td style='font-family:Arial,Helvetica,sans-serif;border: none;font-size: 15px; margin-left:10px; margin-top:15px; font-width:bold;'>
                                    <table width='600' border='0' cellspacing='0' cellpadding='0' align='center'>
                                        <tbody>
                                            <tr style='bgcolor:#ffffff;border-bottom:2px solid #00000'>
                                                <td width='65%'></td>
                                                <td width='35%' ><a href='http://b2b.vsklogistic.ru/' target='_blank'><img style='padding-left:10;padding-top:10;float:right' src='http://b2b.vsklogistic.ru/vsk_logo.png' width='180px;'/></a></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>";
            return $str;
        }

        public function getFooterForMessageFirst(){
            $str = "";
            $str = "<table width='684' border='0' cellpadding='0' cellspacing='0' style='border-top:2px solid #b5b4b4;'>
                        <tbody>
                            <tr>
                                <td>
                                    <table width='600' border='0' cellspacing='0' cellpadding='0' align='center'>
                                        <tbody>
                                            <tr>
                                                <td width='65%' style='font-family:Arial,Helvetica,sans-serif;border: none;font-size:16px !important; padding-left:25px; padding-top:15px;font-width:bold;line-height: 20px;'>
                                                    <span>C уважением,</span>
                                                    <br>
                                                    <span>ВСК Логистик</span>
                                                    <br>
                                                    <span>8 (812) 648-83-52</span>
                                                    <br>
                                                    <a href='mailto:rent@vsklogistic.ru'><span>rent@vsklogistic.ru</span></a>
                                                </td>
                                                <td width='35%' style='bgcolor:#fffff;><a href='http://b2b.vsklogistic.ru/' target='_blank'><img style='padding-left:10px;padding-top:10px;float:right;' src='http://b2b.vsklogistic.ru/vsk_logo.png' width='180px;'/></a>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>";
            return $str;
        }

        public function getShapeForBodyMessage($message){
            $str = "";
            $str = "<table width='100%' border='0' cellpadding='0' cellspacing='0'>
                        <tbody>
                            <tr>
                                <td>
                                    <table width='600' border='0' cellspacing='0' cellpadding='0' align='center'>
                                        <tbody>
                                            <tr>
                                                <td width='15%' style='min-width:100px;background-color:#e6e6e6 !important;'></td>
                                                <td width='70%' bgcolor='#ffffff' style='font-family:Arial,Helvetica,sans-serif;border: none;font-size: 16px;line-height: 20px;padding:20px 15px; border-left:2px solid #b5b4b4;border-right:2px solid #b5b4b4;'><br>".$message."<br></td>
                                                <td width='15%' style='min-width:100px;background-color:#e6e6e6 !important;'></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>";
            return $str;
        }

        public function fulltemplateForMessage($body,$footer){
            $str = "";
            $str = "<table width='100%' border='0' cellpadding='0' cellspacing='0'>
                        <tbody>
                            <tr>
                                <td width='100%' align='center'>
                                    <table width='600' border='0' cellpadding='0' cellspacing='0' style='min-width:600px;'>
                                        <tbody>
                                            <tr>
                                                <td width='600' align='center' valing='top' style='min-width:600px;font-family:Arial,Helvetica, sans-serif;font-size:20px;color:#000000;'>".$this->getHeaderForMessage()."</td>
                                            </tr>
                                            <tr>
                                                <td width='600' align='center' valing='top' style='min-width:600px;font-family:Arial,Helvetica, sans-serif;font-size:20px;color:#000000;>".$body."</td>
                                            </tr>
                                            <tr>
                                                <td width='600' align='center' valing='top' style='min-width:600px;font-family:Arial,Helvetica, sans-serif;font-size:20px;color:#000000;'>".$footer."</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>";
            return $str;
        }

        public function formingLink($id){
            $str = "";
            $str = "<table width='450' border='0' cellspacing='0' cellpadding='0'>
                        <tbody>
                            <tr>
                                <td align='center' valing='middle'>
                                    <table border='0' cellspacing='0' cellpadding='0'>
                                        <tbody>
                                            <tr>
                                                <td align='center' bgcolor='#356590'>
                                                    <a style='font-size:16px;font-family:Arial, Helvetica, sans-serif;color:#ffffff;text-decoration:none;border-radius:3px;padding-top:12px;padding-bottom:12px;padding-left:29px;padding-right:29px; border:1px solid #356590; display:block;' href='http://b2b.vsklogistic.ru/clientAccount/ticket_procat/".$id."' target='_blank'><b> Перейти к заявке</b></a>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>";
            return $str;
        }

        public function searchCarsForProcat($class,$mark,$model,$not_show_id,$awd,$gen_list,$city){
            $not_show_id = explode(',', $not_show_id);
            $sql = ("SELECT
                 srm_procat_auto.id,
                 srm_procat_auto.id_owner,
                 srm_procat_auto.mark,
                 srm_procat_auto.model,
                 srm_procat_auto.generation,
                 srm_procat_auto.type_vehicle,
                 srm_procat_auto.year,
                 srm_procat_auto.color,
                 srm_procat_auto.class,
                 srm_procat_auto.f_nom_part,
                 srm_procat_auto.s_nom_part,
                 srm_procat_auto.th_nom_part,
                 srm_procat_auto.nom_region,
                 srm_procat_auto.linked_perm,
                 srm_procat_auto.price_on_week,
                 srm_procat_auto.price_weekend,
                 srm_procat_auto.f_min_hours_day,
                 srm_procat_auto.f_min_hour_all,
                 srm_procat_auto.col_places,
                 srm_procat_auto.drive_to_foreign,
                 srm_procat_auto.col_places_dr FROM srm_procat_auto INNER JOIN srm_procat_proprietor ON srm_procat_auto.id_owner = srm_procat_proprietor.id WHERE srm_procat_auto.deleted != 1 and (srm_procat_auto.workProcat = 'y' or srm_procat_auto.workTaxi = 'y')");
            if($class!=''){
                $sql .=" and srm_procat_auto.class LIKE '{$class}'";
            }
            if($mark!=''){
                $sql .=" and srm_procat_auto.mark LIKE '{$mark}'";
            }
            if($model!=''){
                $sql .=" and srm_procat_auto.model LIKE '{$model}'";
            }
            if($awd == 'Да'){
                $sql .=" and srm_procat_auto.auto_without_dr = 'y'";
            }else{
                $sql .=" and srm_procat_auto.auto_without_dr = 'n'";
            }
            if($gen_list!=''){
                $sql .=" and srm_procat_auto.generation = '{$gen_list}'";
            }
            if($city!=''){
                $sql .=" and srm_procat_proprietor.work_city LIKE '%{$city}%'";
            }
            $sql .= "and srm_procat_auto.f_status != 'Не активна' ORDER BY srm_procat_auto.price_on_week ASC";
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['gos_nomer'] = implode(' ',array($trash['f_nom_part'],$trash['s_nom_part'],$trash['th_nom_part'],$trash['nom_region']));
                $trash['owner_name'] = implode(' ',$this->getOwnerName($trash['id_owner']));
                $trash['owner_phone'] = $this->getPhoneOfOwnerCar($trash['id_owner']);
                $trash['partner_work'] = $this->checkTSworkInTicket($trash['id'],$trash['id_owner']);
                $trash['drive_to_foreign'] = ($trash['drive_to_foreign'] == 'y')?'Да':'Нет';
                $data[] = $trash;
            }
            return $data;
        }

        public function getOwnerName($owner_id){
            $sql = ("SELECT surname,first_name,sec_name FROM srm_procat_proprietor WHERE id = '{$owner_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data = $trash;
            }
            return $data;
        }

        public function pickTsToProcat($array){
            $carWishId = $array['id_wishcar'];
            $set = implode(', ',prepareSQL($array));
            $sql = ("INSERT INTO srm_procat_carsListArendaByWishCar SET {$set}");
            $result = $this->inDB->query($sql);
            unset($sql);
            unset($result);
            $sql = ("UPDATE srm_procat_carsWishForTicketProcat SET setted_car='1' WHERE id='{$carWishId}'");
            $result = $this->inDB->query($sql);
            return true;
        }

        public function getSettedTS($id){
            cmsCore::loadModel('partner');
            cmsCore::loadModel('callbackTickets');
            $model_cars = new cms_model_partner();
            $model_call = new cms_model_callbackTickets();

            $temp_arr = $this->getShotInfoWishCarById($id);
            $id_ticket = $temp_arr['ticket_id'];
            unset($temp_arr);

            $sql = ("SELECT * FROM srm_procat_carsListArendaByWishCar WHERE id_wishcar = '{$id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $car_info = $model_cars->show_car($trash['id_car']);
                $trash['time_begin'] = date('d.m.Y',strtotime($trash['time_begin']));
                $trash['time_end'] = date('d.m.Y',strtotime($trash['time_end']));
                $trash['type_ts'] = $car_info['type_vehicle'];
                $trash['mark'] = $car_info['mark'];
                $trash['model'] = $car_info['model']." ".$car_info['generation'];
                $trash['body_car'] = $car_info['body_car'];
                $trash['year'] = $car_info['year'];
                $trash['color'] = $car_info['color'];
                $trash['owner_id'] = $car_info['id_owner'];
                $trash['owner_info']= $this->getInfoOwner($trash['owner_id']);
                $trash['gos_nomer'] = implode(' ',array($car_info['f_nom_part'],$car_info['s_nom_part'],$car_info['th_nom_part'],$car_info['nom_region']));
                $trash['last_partner_callback'] = $this->getLastCommentForPartner($id_ticket);
                
                $temp_arr = $model_call->getPartnerCallbackHistoryByTicketNPartnerLastLine($id_ticket,$trash['owner_id'],'partner');
                $trash['predoplata_dialog'] = $temp_arr['summ'];
                $trash['last_form_payment'] = $temp_arr['payment_form'];
                $trash['list_work_data'] = $this->getDataWorkPartnerForWishCar($id,$trash['owner_id']);
                $trash['list_work_data_sec'] = $this->getDataWorkPartnerByCarId($trash['id_car'],$id);
                $temp_d_p_p = $this->getDataAboutPricesOfPartner($trash['id_car'],$id);
                $trash['fullPriceSettedTS'] = $temp_d_p_p['fullPriceSettedTS'];
                $trash['linePriceSettedTS'] = $temp_d_p_p['linePriceSettedTS'];
                if($trash['fullPriceSettedTS'] == $trash['endPriceSettedTS']){
                    $trash['endPriceSettedTS'] == $trash['fullPriceSettedTS'];
                }elseif($trash['endPriceSettedTS'] == '0'){
                    $trash['endPriceSettedTS'] = $trash['fullPriceSettedTS'];
                }
                unset($car_info);
                $data[] = $trash;
            }
            return $data;
        }

        public function editSettedTS($arr,$id_car){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("UPDATE srm_procat_carsListArendaByWishCar SET {$set} WHERE id = '{$id_car}'");
            $result = $this->inDB->query($sql);
            
        }

        public function removeSettedTS($id_car,$id_wish){
            $sql = ("DELETE FROM srm_procat_carsListArendaByWishCar WHERE id = '{$id_car}'");
            $result = $this->inDB->query($sql);
            unset($sql);
            unset($result);
            $sql = ("SELECT id FROM srm_procat_carsListArendaByWishCar WHERE id_wishcar = '{$id_wish}'");
            $result = $this->inDB->query($sql);
            if($num = $this->inDB->num_rows($result)){
                return true;
            }else{
                unset($sql);
                unset($result);
                $sql = ("UPDATE srm_procat_carsWishForTicketProcat SET setted_car = '0' WHERE id = '{$id_wish}'");
                $result = $this->inDB->query($sql);
            }
        }

        public function getProcatStatuses(){
            $sql = ("SELECT status_procat FROM srm_procat_ticketProcatStatus ORDER BY order_line ASC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data[] = $trash['status_procat'];
            }
            return $data;
        }
        //все по заявке
        public function getShotInfoWishCar($ticket_id){
            $sql = ("SELECT * FROM srm_procat_carsWishForTicketProcat WHERE ticket_id = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $wish_info['id'] = $trash['id'];
                $wish_info['type'] = $trash['type_ts'];
                $wish_info['mark'] = $trash['mark_ts'];
                $wish_info['model'] = $trash['model_ts'];
                $wish_info['begin_procat'] = $trash['begin_time']." ".$trash['begin_place'];
                $wish_info['end_procat'] = $trash['end_time']." ".$trash['end_place'];
                $wish_info['analog'] = ($trash['analog']=='y')?'Да':'Нет';
                $data[] = $wish_info;
            }
            return $data;
        }
        //конкретная
        public function getShotInfoWishCarById($id){
            $sql = ("SELECT * FROM srm_procat_carsWishForTicketProcat WHERE id = '{$id}' ");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $wish_info['id'] = $trash['id'];
                $wish_info['type'] = $trash['type_ts'];
                $wish_info['mark'] = $trash['mark_ts'];
                $wish_info['model'] = $trash['model_ts'];
                $wish_info['begin_procat'] = $trash['begin_time']." ".$trash['begin_place'];
                $wish_info['end_procat'] = $trash['end_time']." ".$trash['end_place'];
                $wish_info['analog'] = ($trash['analog']=='y')?'Да':'Нет';
                $wish_info['ticket_id'] = $trash['ticket_id'];
                $data = $wish_info;
            }
            return $data;
        }

        public function addCommercOfferInHistory($offer,$id){
            $today = date('Y-m-d H:i');
            $sql = ("INSERT INTO srm_procat_commerc_offer_history SET id_ticket = '{$id}',
                                                                      date_send ='{$today}',
                                                                      data_offer_serialized = '{$offer}'");
            $result = $this->inDB->query($sql);
        }

        public function commerc_offer_history($ticket_id){
            $sql = ("SELECT * FROM srm_procat_commerc_offer_history WHERE id_ticket = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
            
            $count_hours = '';
            $sum_price = '';
            $sum_finprice ='';

            while($trash = $this->inDB->fetch_assoc($result)){
                if(strstr($trash['data_offer_serialized'],'|')){
                    $predata = explode('|',$trash['data_offer_serialized']);
                    foreach ($predata as $temp) {
                        $temp_arr = explode(';', $temp);
                        $temp_arr['wish_car'] = $this->getShotInfoWishCarById($temp_arr['0']);
                        $arr[] = $temp_arr;
                        unset($temp);
                        unset($temp_arr);
                    }
                    $trash['count_elem'] = 'many';
                }else{
                    $arr = explode(';', $trash['data_offer_serialized']);
                    $arr['wish_car'] = $this->getShotInfoWishCarById($arr['0']);
                    $trash['count_elem'] = 'one';
                }
                $trash['arr_unses'] = $arr;
                $data[] = $trash;
            }
            return $data;
        }

        public function savePresetCar($id_preset,$id_wishcar){
            $sql=("INSERT INTO srm_procat_presetCarListForTicketProcat SET id_wishcar='{$id_wishcar}',
                                                                            preset_car_id='{$id_preset}'");
            $result = $this->inDB->query($sql);
        }

        public function getPresetCar($id_wishcar){
            $sql=("SELECT * FROM srm_procat_presetCarListForTicketProcat WHERE id_wishcar ='{$id_wishcar}'");
            $result=$this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $temp['car_info'] = $this->getCarInfo($trash['preset_car_id']);
                $temp['owner_info'] =$this->getInfoOwner($temp['car_info']['id_owner']);
                $temp['dialog_info'] = $this->getDialogPresetInfo($trash['preset_car_id'],$trash['id_wishcar']);
                $data[] = $temp;
                unset($temp);
            }
            return $data;
        }

        public function getCarInfo($id){
            cmsCore::loadModel('partner');
            $model_cars = new cms_model_partner();
            $data = $model_cars->show_car($id);
            return $data;
        }

        public function saveDialogPreset($arr){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_presetCarDialog SET {$set}");
            $result = $this->inDB->query($sql);
            
        }

        public function getDialogPresetInfo($id_preset,$id_wishcar){
            $sql=("SELECT * FROM srm_procat_presetCarDialog WHERE id_wishcar = '{$id_wishcar}' and preset_car_id = '{$id_preset}' ORDER BY id DESC LIMIT 1");
            $result = $this->inDB->query($sql);
            while($trash=$this->inDB->fetch_assoc($result)){
                if(($trash['date_next_call']!='1970-01-01 03:00:00')&&($trash['date_next_call']!='0000-00-00 00:00:00')){
                    $trash['date_next_call'] = date('d.m.Y H:i',strtotime($trash['date_next_call']));
                }else{
                    $trash['date_next_call'] = "";
                }

                if(($trash['date_adding']!='1970-01-01 03:00:00')&&($trash['date_adding']!='0000-00-00 00:00:00')){
                    $trash['date_adding'] = date('d.m.Y H:i',strtotime($trash['date_adding']));
                }else{
                    $trash['date_adding'] = "";
                }
                $data = $trash;
            }
            return $data;
        }

        public function getDialogPresetInfoAll($id_preset,$id_wishcar){
            $sql=("SELECT * FROM srm_procat_presetCarDialog WHERE id_wishcar = '{$id_wishcar}' and preset_car_id = '{$id_preset}' ORDER BY id DESC");
            $result = $this->inDB->query($sql);
            while($trash=$this->inDB->fetch_assoc($result)){
                if(($trash['date_next_call']!='1970-01-01 03:00:00')&&($trash['date_next_call']!='0000-00-00 00:00:00')){
                    $trash['date_next_call'] = date('d.m.Y H:i',strtotime($trash['date_next_call']));
                }else{
                    $trash['date_next_call'] = "";
                }

                if(($trash['date_adding']!='1970-01-01 03:00:00')&&($trash['date_adding']!='0000-00-00 00:00:00')){
                    $trash['date_adding'] = date('d.m.Y H:i',strtotime($trash['date_adding']));
                }else{
                    $trash['date_adding'] = "";
                }

                $trash['status_preset'] = $this->getStatusPresetDialogName($trash['status_preset']);
                
                $data[] = $trash;
            }
            return $data;
        }

        public function deletePreset($id){
            $sql = ("DELETE FROM srm_procat_presetCarListForTicketProcat WHERE preset_car_id = '{$id}'");
            $result = $this->inDB->query($sql);
            $sql = ("DELETE FROM srm_procat_presetCarDialog WHERE preset_car_id = '{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function getInfoOwner($id){
            cmsCore::loadModel('partner');
            $model_p = new cms_model_partner();
            $temp = $model_p->takePartnerInfo('proprietor',$id);
            $owner_info['id'] = $id;
            $owner_info['name'] = $temp[0]['surname']." ".$temp[0]['first_name']." ".$temp[0]['sec_name'];
            $owner_info['tel'] = $temp[0]['tel_1'];
            $owner_info['e_mail'] = $temp[0]['e_mail'];
            $owner_info['cart_info'] = $temp[0]['cart_account']." ".$temp[0]['name_bank'];
            return $owner_info;
        }

        public function addWayListForProcat($arr){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_waylists_procat SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function getWaylistsForProcat($ticket_id){
            $sql = ("SELECT * FROM srm_procat_waylists_procat WHERE id_ticket = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $car_info = $this->getCarInfo($trash['id_car']);
                $trash['car_info'] = $car_info['type_vehicle']."<br>".$car_info['mark']." ".$car_info['model'];
                $trash['begin_event'] = date('H:i',strtotime($trash['begin_event']));
                $trash['end_event'] = date('H:i',strtotime($trash['end_event']));
                $trash['data_event'] = date('d.m.Y',strtotime($trash['data_event']));
                $data[$trash['id_wishcar']][] = $trash;
            }
            return $data;
        }

        public function editWaylistProcat($id,$arr){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("UPDATE srm_procat_waylists_procat SET {$set} WHERE id='{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function deleteWaylistProcat($id){
            $sql = ("DELETE FROM srm_procat_waylists_procat WHERE id='{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function addCallBackClientToTicket($arr){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketProcatCallback SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function getListCallbackForTicket($ticket_id){
            $sql = ("SELECT * FROM srm_procat_ticketProcatCallback WHERE ticket_id = '{$ticket_id}' and type = 'client' ORDER BY id DESC");
            $result = $this->inDB->query($sql);
            while ($trash = $this->inDB->fetch_assoc($result)) {
                $trash['date_add'] = date('d.m.Y H:i',strtotime($trash['date_add']));
                $trash['date_callback'] = date('d.m.Y H:i',strtotime($trash['date_callback']));
                $trash['nickname'] = $this->getNickUser($trash['id_user']);
                $data[] = $trash;
            }
            return $data;
        }

        public function changeStatusTicket($id,$status){
            $sql = ("UPDATE srm_procat_ticketProcat SET status_ticket = '{$status}' WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function getWishCarInfoByCarId($id_wishcar){
            $sql = ("SELECT * FROM srm_procat_carsWishForTicketProcat WHERE id = '{$id_wishcar}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['begin_procat'] = date('d.m.Y',strtotime($trash['begin_procat']));
                $trash['end_procat'] = date('d.m.Y',strtotime($trash['end_procat']));
                $trash['begin_time'] = date('H:i',strtotime($trash['begin_time']));
                $trash['end_time'] = date('H:i',strtotime($trash['end_time']));
                $data = $trash;
            }
            return $data;
        }

        public function editWishTS($arr,$id){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("UPDATE srm_procat_carsWishForTicketProcat SET {$set} WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function addWishTS($arr){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_carsWishForTicketProcat SET {$set}");
            $result = $this->inDB->query($sql);
            
        }

        public function set_preset_to_ticket($arr,$preset_id,$w_id){
            $set = implode(', ', prepareSQL($arr));
            $ticket_info = $this->getWishCarInfoByCarId($w_id);
            $begin_procat = date('Y-m-d',strtotime($ticket_info['begin_procat']));
            $end_procat = date('Y-m-d',strtotime($ticket_info['end_procat']));
            $sql = ("INSERT INTO srm_procat_carsListArendaByWishCar SET {$set},
                                                                        id_wishcar='{$w_id}',
                                                                        id_car='{$preset_id}',
                                                                        time_begin='{$begin_procat}',
                                                                        time_end = '{$end_procat}'");
            $result = $this->inDB->query($sql);

            $sql = ("UPDATE srm_procat_carsWishForTicketProcat SET setted_car = '1' WHERE id = '{$w_id}'");
            $result = $this->inDB->query($sql);
        }

        public function addConfirmedTS($array){
            $set = implode(', ', prepareSQL($array));
            $sql = ("INSERT INTO srm_procat_confirmed_ts_procat SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function getConfirmedTSByIdWish($id){
            $sql = ("SELECT * FROM srm_procat_routeList_confirmed WHERE id_wishcar='{$id}' ORDER BY id DESC LIMIT 1");
            $result = $this->inDB->query($sql);
            if($this->inDB->num_rows($result)){
                while($trash = $this->inDB->fetch_assoc($result)){
                    $data = $trash;
                }
            }else{
                return false;
            }

            $sql_2 = ("SELECT * FROM srm_procat_routeList_confirmed WHERE id_wishcar='{$id}'");
            $result_2 = $this->inDB->query($sql_2);
            $transfer_count = array();
            if($this->inDB->num_rows($result_2)){
                while($trash = $this->inDB->fetch_assoc($result_2)){
                    if($trash['service_type'] == ''){
                        $begin = strtotime($trash['begin'])/3600;
                        $end = strtotime($trash['end'])/3600;
                        if($begin>$end){
                            $hour_way = ($end-$begin)+24;
                        }elseif($end>$begin){
                            $hour_way = $end-$begin;
                        }
                        $hour_way = ($trash['itwasaday'] == 'y')?($hour_way+24):$hour_way;
                        $hour_way = ($trash['add_hours'] != '')?($hour_way + $trash['add_hours']):$hour_way;
                        $trash['hours'] = round($hour_way,2);
                        $hours += $trash['hours'];
                        $add_hours +=  $trash['add_hours'];
                        $data['final'] += $trash['hours']*$trash['price'];
                        $car_list[] = $trash['type_ts']." ".$trash['marka_ts']." ".$trash['model_ts'];
                        $all_priceses[] = $trash['price'];
                        $transfer = $trash['service_type'];
                    }else{
                       $car_list[] = $trash['type_ts']." ".$trash['marka_ts']." ".$trash['model_ts'];
                       $transfer[] = $trash['service_type'];
                       $all_priceses[] = $trash['price'];
                       $data['final'] += $trash['price'];
                       $transfer_count[$trash['service_type']]+=1;
                    }
                }
                if($transfer == ''){
                    $data['hours'] = $hours;
                    $data['car_list'] = implode(',<br>',array_unique($car_list, SORT_STRING));
                    $data['all_priceses'] = implode(', ',array_unique($all_priceses, SORT_NUMERIC));
                    $data['add_hours'] = $add_hours;
                    $data['hours'] = $hours - $data['add_hours'];
                    //$data['final'] = $final;
                }else{
                    $data['add_hours'] = "";
                    $data['car_list'] = implode(',<br>',array_unique($car_list, SORT_STRING));                    
                    $data['add_hours'] = ($add_hours!='0')?$add_hours:'';
                    $hours = ($hours!='')?$hours-$data['add_hours']." | ":'';
                    $line = "";
                    $data['check_iter'] = $transfer_count;
                    $transfer = array_unique($transfer);
                    foreach($transfer as $t){
                        $line .= $t." (".$transfer_count[$t]."); ";
                    }
                    $data['hours'] = $hours." ".$line;
                    $data['all_priceses'] = implode('|',array_unique($all_priceses, SORT_NUMERIC));
                    //$data['final'] = $price;
                }

                /*if(($final!='')&&($transfer == 'y')){
                    $data['final'] +=$final;
                }*/
                return $data;
            }else{
                return false;
            }
        }

        public function updateConfirmedTSByIdWish($arr,$id_wish){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("UPDATE srm_procat_confirmed_ts_procat SET {$set} WHERE id_wishcar = '{$id_wish}'");
            $result = $this->inDB->query($sql);
        }

        public function addConfirmedRouteList($arr){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_routeList_confirmed SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function getConfirmedRouteList($id_wishcar){
            $sql = ("SELECT * FROM srm_procat_routeList_confirmed WHERE id_wishcar = '{$id_wishcar}' ORDER BY data ASC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data'] = date('d.m.Y',strtotime($trash['data']));
                if($trash['service_type']==''){
                    $begin = strtotime($trash['begin'])/3600;
                    $end = strtotime($trash['end'])/3600;
                    if($begin>$end){
                        $hour_way = ($end-$begin)+24;
                    }elseif($end>$begin){
                        $hour_way = $end-$begin;
                    }
                    $trash['hour_way'] = ($trash['itwasaday'] == 'y')?($hour_way+24):$hour_way;
                    $trash['hour_way'] = ($trash['add_hours'] != '')?($trash['hour_way'] + $trash['add_hours']):$trash['hour_way'];
                    $trash['hour_way'] = round($trash['hour_way'],2);
                    $trash['end'] = date('H:i',strtotime($trash['end']));
                }else{
                    $trash['hour_way'] = 0;
                    $trash['end'] = $trash['service_type'];
                }
                $trash['begin'] = date('H:i',strtotime($trash['begin']));
                $data[] = $trash;
            }
            return $data;
        }

        public function removeRouteLine($id){
            $sql = ("DELETE FROM srm_procat_routeList_confirmed WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function getIdConfirmTS($id_wish){
            $sql = ("SELECT id FROM srm_procat_confirmed_ts_procat WHERE id_wishcar = '{$id_wish}'");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);

            return $data['id'];
        }

        public function listNickClient(){
            $sql = ("SELECT DISTINCT nick_client FROM srm_procat_ticketProcat WHERE type_client = 'ur'");
            $result = $this->inDB->query($sql);
            while ($trash = $this->inDB->fetch_assoc($result)) {
                $list[] = $trash['nick_client'];
            }
            return $list;
        }

        public function searchTicketByParam($arr){
            $id = ($arr['id']!='')?" and id = '{$arr['id']}'":FALSE;
            $name = ($arr['client']!='')?" and nick_client LIKE '{$arr['client']}'":FALSE;
            $tel = ($arr['phone']!='')?" and tel LIKE '{$arr['phone']}'":FALSE;
            $status = ($arr['status']!='')?" and status_ticket = '{$arr['status']}'":FALSE;
            $con_face = ($arr['cont_face']!='')?" and contact_face LIKE '%{$arr['cont_face']}%'":FALSE;
            $ticket_city = ($arr['ticket_city']!='')?" and ticket_city LIKE '%{$arr['ticket_city']}%'":FALSE;
            $email = ($arr['email']!='')?" and e_mail LIKE '%{$arr['email']}%'":FALSE;
            $sql = ("SELECT * FROM srm_procat_ticketProcat WHERE id != ''");
            if($id){
                $sql .= $id;
            }
            if($name){
                $sql .= $name;
            }
            if($tel){
                $sql .= $tel;
            }
            if($status){
                $sql .= $status;
            }
            if($con_face){
                $sql .= $con_face;
            }
            if($ticket_city){
                $sql .= $ticket_city;
            }
            if($email){
                $sql .= $email;
            }
            if(($arr['begin']!='')&&($arr['end']!='')){
                $arr['begin'] = date('Y-m-d H:i',strtotime($arr['begin']));
                $arr['end'] = date('Y-m-d H:i',strtotime($arr['end'])+86280);
                $sql .= " and time_add BETWEEN '{$arr['begin']}' and '{$arr['end']}'";
            }
            $sql .= " ORDER BY id DESC";
            $result = $this->inDB->query($sql);
            if($this->inDB->num_rows($result)){
                while($trash = $this->inDB->fetch_assoc($result)){
                    $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                    $trash['controller'] = ($trash['id_control']!='0')?$this->getUserInfo($trash['id_control']):'';
                    $trash['last_client_callback'] = $this->getLastCommentForClient($trash['id']);
                    $trash['data_start'] = $this->getDataBeginWorkTicket($trash['id']);
                    $trash['partner_work_list'] = $this->getListPartnerWorkTicket($trash['id']);
                    $trash['color_status'] = $this->getColorStatusByValue($trash['status_ticket']);
                    $data[] = $trash;
                }
                return $data;
            }else{
                return "no";
            }
        }

        public function getConfirmedListByTicketId($ticket_id){
            $sql = ("SELECT srm_procat_routeList_confirmed.*
                    FROM srm_procat_routeList_confirmed INNER JOIN srm_procat_carsWishForTicketProcat
                        ON srm_procat_routeList_confirmed.id_wishcar = srm_procat_carsWishForTicketProcat.id
                    WHERE srm_procat_carsWishForTicketProcat.ticket_id = '{$ticket_id}'
                    ORDER BY srm_procat_routeList_confirmed.data ASC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                
                    $trash['data'] = date('d.m.Y',strtotime($trash['data']));
                    if($trash['service_type'] == ''){
                        $trash['hourswork'] = $this->getCountHoursByBeginNEnd($trash['begin'],$trash['end']);
                        $trash['hourswork'] +=$trash['add_hours'];
                        $trash['begin'] = date('H:i',strtotime($trash['begin']));
                        $trash['end'] = date('H:i',strtotime($trash['end']));
                        $trash['final_price_per_car'] = $trash['hourswork']*$trash['price'];
                    }else{
                        if(($trash['service_type'] == "Трансфер")||($trash['service_type'] == "Сутки")){
                            $trash['begin'] = date('H:i',strtotime($trash['begin']));
                            $trash['end'] = $trash['service_type'];
                        }else{
                            $trash['type_ts'] = $trash['service_type'];
                            $trash['markmodelTS'] = "-";
                            $trash['marka_ts'] = "-";
                            $trash['model_ts'] = "-";
                            $trash['begin'] = "-";
                            $trash['end'] = "-";
                            $trash['route_desc'] = "-";
                        }

                        $trash['hourswork'] = "";
                        $trash['add_hours'] = "";
                        $trash['final_price_per_car'] = $trash['price'];
                        $trash['price'] = "";
                    }
                    $data[] = $trash;
                
            }
            return $data;
        }

        public function getCountHoursByBeginNEnd($begin,$end){
            $begin_temp = strtotime($begin)/3600;
            $end_temp = strtotime($end)/3600;
            if($begin_temp>$end_temp){
                $hour_way = ($end_temp-$begin_temp)+24;
            }elseif($end_temp>$begin_temp){
                $hour_way = $end_temp-$begin_temp;
            }
            return $hour_way;
        }

        public function getListTicketOfClient($id_client){
            $sql = ("SELECT * FROM srm_procat_ticketProcat WHERE user_id = '{$id_client}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                $trash['manager_info'] = ($trash['id_control']!='0')?$this->getUserInfo($trash['id_control']):'';
                $data[] = $trash;
            }
            return $data;
        }

        public function getListTicketOfPartner($id_partner){
            $sql = ("SELECT srm_procat_ticketProcat.id,srm_procat_ticketProcat.id_control,srm_procat_carsWishForTicketProcat.begin_procat,srm_procat_carsWishForTicketProcat.end_procat FROM srm_procat_ticketProcat INNER JOIN srm_procat_carsWishForTicketProcat ON srm_procat_ticketProcat.id = srm_procat_carsWishForTicketProcat.ticket_id INNER JOIN srm_procat_carsListArendaByWishCar ON srm_procat_carsListArendaByWishCar.id_wishcar = srm_procat_carsWishForTicketProcat.id INNER JOIN srm_procat_auto ON srm_procat_auto.id = srm_procat_carsListArendaByWishCar.id_car WHERE srm_procat_auto.id_owner = '{$id_partner}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['begin_procat'] = date('d.m.Y',strtotime($trash['begin_procat']));
                $trash['end_procat'] = date('d.m.Y',strtotime($trash['end_procat']));
                $trash['manager_info'] = ($trash['id_control']!='0')?$this->getUserInfo($trash['id_control']):'';
                $data[] = $trash;
            }
            return $data;
        }

        public function addClientUrRequisites($arr){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_clientUrRequisites SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function checkExistRequisitesById($id_client){
            $sql = ("SELECT id FROM srm_procat_clientUrRequisites WHERE id_client = '{$id_client}'");
            $result = $this->inDB->query($sql);
            if($this->inDB->num_rows($result)){
                return 'y';
            }else{
                return 'n';
            }
        }

        public function checkExistFizRequisitesById($id_client){
            $sql = ("SELECT id FROM srm_procat_ticketProcat_fizrequisites WHERE user_id = '{$id_client}'");
            $result = $this->inDB->query($sql);
            if($this->inDB->num_rows($result)){
                return 'y';
            }else{
                return 'n';
            }
        }

        public function editClientUrRequisites($arr,$client_id){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("UPDATE srm_procat_clientUrRequisites SET {$set} WHERE id_client = '{$client_id}'");
            $result = $this->inDB->query($sql);
        }

        public function getRequisitesToEdit($client_id){
            $sql = ("SELECT * FROM srm_procat_clientUrRequisites WHERE id_client = '{$client_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data = $trash;
            }
            return $data;
        }

        public function getCountTicketProcatToday(){
            $today = date('Y-m-d');
            $sql = ("SELECT srm_procat_ticketProcat.*, srm_procat_carsWishForTicketProcat.type_ts,srm_procat_carsWishForTicketProcat.mark_ts,srm_procat_carsWishForTicketProcat.model_ts, srm_procat_carsWishForTicketProcat.id as id_wishcar,srm_procat_ticketPartnerRoutePayment.car_id as partner_car FROM srm_procat_ticketProcat INNER JOIN srm_procat_carsWishForTicketProcat ON srm_procat_ticketProcat.id = srm_procat_carsWishForTicketProcat.ticket_id LEFT JOIN srm_procat_routeList_confirmed ON srm_procat_carsWishForTicketProcat.id = srm_procat_routeList_confirmed.id_wishcar LEFT JOIN srm_procat_ticketPartnerRoutePayment ON srm_procat_ticketPartnerRoutePayment.id_route = srm_procat_routeList_confirmed.id WHERE srm_procat_routeList_confirmed.data = '{$today}' and (srm_procat_ticketProcat.status_ticket!='Отказ' AND srm_procat_ticketProcat.status_ticket!='Закрыта')");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                if($trash['partner_car'] == ''){
                    $temp_car = $this->getSettedTS($trash['id_wishcar']);
                }else{
                    $temp_car = $this->getPartnerSetterCarInfo($trash['partner_car'],$trash['id_wishcar']);
                }
                $trash['auto_setted'] = $temp_car[0]['mark']." ".$temp_car[0]['model']." ".$temp_car[0]['color'];
                $trash['owner_partner'] = $temp_car[0]['owner_info']['name']."<br>".$temp_car[0]['owner_info']['tel'];
                $trash['partner_status'] = $temp_car[0]['status'];
                $trash['temp'] = $temp_car;
                $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                $data[] = $trash;
            }
            return $data;
        }

        public function getCountTicketProcatTomorrow(){
            $tomorrow = date('Y-m-d',strtotime(date('Y-m-d'))+172000);
            $today = date('Y-m-d',strtotime(date('Y-m-d'))+86400);
            $sql = ("SELECT srm_procat_ticketProcat.*, srm_procat_carsWishForTicketProcat.type_ts,srm_procat_carsWishForTicketProcat.mark_ts,srm_procat_carsWishForTicketProcat.model_ts, srm_procat_carsWishForTicketProcat.id as id_wishcar,srm_procat_ticketPartnerRoutePayment.car_id as partner_car FROM srm_procat_ticketProcat INNER JOIN srm_procat_carsWishForTicketProcat ON srm_procat_ticketProcat.id = srm_procat_carsWishForTicketProcat.ticket_id LEFT JOIN srm_procat_routeList_confirmed ON srm_procat_carsWishForTicketProcat.id = srm_procat_routeList_confirmed.id_wishcar LEFT JOIN srm_procat_ticketPartnerRoutePayment ON srm_procat_ticketPartnerRoutePayment.id_route = srm_procat_routeList_confirmed.id WHERE srm_procat_routeList_confirmed.data >= '{$today}' and srm_procat_routeList_confirmed.data <= '{$tomorrow}' and (srm_procat_ticketProcat.status_ticket!='Отказ' AND srm_procat_ticketProcat.status_ticket!='Закрыта')");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                if($trash['partner_car'] == ''){
                    $temp_car = $this->getSettedTS($trash['id_wishcar']);
                }else{
                    $temp_car = $this->getPartnerSetterCarInfo($trash['partner_car'],$trash['id_wishcar']);
                }
                $trash['auto_setted'] = $temp_car[0]['mark']." ".$temp_car[0]['model']." ".$temp_car[0]['color'];
                $trash['owner_partner'] = $temp_car[0]['owner_info']['name']."<br>".$temp_car[0]['owner_info']['tel'];
                $trash['partner_status'] = $temp_car[0]['status'];
                $trash['temp'] = $temp_car;
                $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                $data[] = $trash;
            }
            return $data;
        }

        public function getCountTicketProcatYesterday(){
            //$today = date('Y-m-d');
            $yesterday = date('Y-m-d',strtotime(date('Y-m-d'))-86000);
            $sql = ("SELECT srm_procat_ticketProcat.*, srm_procat_carsWishForTicketProcat.type_ts,srm_procat_carsWishForTicketProcat.mark_ts,srm_procat_carsWishForTicketProcat.model_ts, srm_procat_carsWishForTicketProcat.id as id_wishcar,srm_procat_ticketPartnerRoutePayment.car_id as partner_car FROM srm_procat_ticketProcat INNER JOIN srm_procat_carsWishForTicketProcat ON srm_procat_ticketProcat.id = srm_procat_carsWishForTicketProcat.ticket_id LEFT JOIN srm_procat_routeList_confirmed ON srm_procat_carsWishForTicketProcat.id = srm_procat_routeList_confirmed.id_wishcar LEFT JOIN srm_procat_ticketPartnerRoutePayment ON srm_procat_ticketPartnerRoutePayment.id_route = srm_procat_routeList_confirmed.id WHERE srm_procat_routeList_confirmed.data = '{$yesterday}' and (srm_procat_ticketProcat.status_ticket!='Отказ' AND srm_procat_ticketProcat.status_ticket!='Закрыта')");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                if($trash['partner_car'] == ''){
                    $temp_car = $this->getSettedTS($trash['id_wishcar']);
                }else{
                    $temp_car = $this->getPartnerSetterCarInfo($trash['partner_car'],$trash['id_wishcar']);
                }
                $trash['auto_setted'] = $temp_car[0]['mark']." ".$temp_car[0]['model']." ".$temp_car[0]['color'];
                $trash['owner_partner'] = $temp_car[0]['owner_info']['name']."<br>".$temp_car[0]['owner_info']['tel'];
                $trash['partner_status'] = $temp_car[0]['status'];
                $trash['temp'] = $temp_car;
                $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                $data[] = $trash;
            }
            return $data;
        }

        public function getListAccountUrWithIdOnly(){
            $sql = ("SELECT id,nickname FROM srm_users WHERE group_id = '18'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data[] = $trash;
            }
            return $data;
        }

        public function getListAccountFizWithIdOnly(){
            $sql = ("SELECT id,nickname FROM srm_users WHERE group_id = '21'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data[] = $trash;
            }
            return $data;
        }

        public function lookingForByPhone($phone){
            $sql = ("SELECT DISTINCT contact_face,tel,email FROM srm_procat_ticketProcat WHERE type_client = 'fiz' and without_tel LIKE '%{$phone}%'");
            $result = $this->inDB->query($sql);
            if($this->inDB->num_rows($result)){
                while($trash = $this->inDB->fetch_assoc($result)){
                    $data[] = $trash;
                }
                return $data;
            }else{
                return "nothing";
            }
            
        }

        public function updateTicket($arr,$id_ticket){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("UPDATE srm_procat_ticketProcat SET {$set} WHERE id = '{$id_ticket}'");
            $result = $this->inDB->query($sql);
        }

        public function getPhoneOfOwnerCar($id_owner){
            $sql = ("SELECT tel_1 FROM srm_procat_proprietor WHERE id = '{$id_owner}'");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);
            return $data['tel_1'];
        }

        public function getPartnerStatus(){
            $sql = ("SELECT status FROM srm_procat_ticketProcat_partner_status ORDER BY order_line ASC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data[] = $trash['status'];
            }
            return $data;
        }

        public function updateSettedCar($arr,$id_car){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("UPDATE srm_procat_carsListArendaByWishCar SET {$set} WHERE id ='{$id_car}'");
            $result = $this->inDB->query($sql);
            
        }

        public function addFizFaceRequisites($arr){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketProcat_fizrequisites SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function getFizFaceRequisites($ticket_id){
            $sql = ("SELECT * FROM srm_procat_ticketProcat_fizrequisites WHERE ticket_id = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data_get'] = date('d.m.Y',strtotime($trash['data_get']));
                $trash['data_born'] = date('d.m.Y',strtotime($trash['data_born']));
                $data = $trash;
            }
            return $data;
        }

        public function getFizFaceRequisitesById($user_id){
            $sql = ("SELECT * FROM srm_procat_ticketProcat_fizrequisites WHERE user_id = '{$user_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data_get'] = date('d.m.Y',strtotime($trash['data_get']));
                $trash['data_born'] = date('d.m.Y',strtotime($trash['data_born']));
                $data = $trash;
            }
            return $data;
        }

        public function editFizFaceRequisites($arr,$ticket_id){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("UPDATE srm_procat_ticketProcat_fizrequisites SET {$set} WHERE ticket_id = '{$ticket_id}'");
            $result = $this->inDB->query($sql);
        }

        public function editFizFaceRequisitesById($arr,$user_id){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("UPDATE srm_procat_ticketProcat_fizrequisites SET {$set} WHERE user_id = '{$user_id}'");
            $result = $this->inDB->query($sql);
        }

        public function getStatusPresetDialogName($name){
            switch ($name) {
                case 'think':
                    $a = "Думает";
                    break;
                case 'busy':
                    $a = "Занят";
                    break;
                case 'ready':
                    $a = "Готов работать";
                    break;
                case 'work':
                    $a = "Работает";
                    break;
            }
            return $a;
        }

        public function saveCommentAboutTicket($arr){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketProcat_comments SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function getCommentAboutTicket($ticket_id){
            $sql = ("SELECT * FROM srm_procat_ticketProcat_comments WHERE ticket_id = '{$ticket_id}' ORDER BY id DESC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data_add'] = date('d.m.Y H:i',strtotime($trash['data_add']));
                $trash['user_name'] = $this->getNickUser($trash['user_id']);
                $data[] = $trash;
            }
            return $data;
        }

        public function getFinReport(){
            $sql = ("SELECT DISTINCT ticket_id FROM srm_procat_ticketProcatCallback WHERE date_summ_pay != '0000-00-00 00:00:00' and summ!='0' and summ!='' and preset = 'n'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $arr[] = $this->formDataAboutPaymentByType($trash['ticket_id']);
            }
            return $arr;
        }

        public function getPaiedSumm($ticket_id,$type){
            $sql_1 = ("SELECT date_summ_pay,summ FROM srm_procat_ticketProcatCallback WHERE date_summ_pay != '0000-00-00 00:00:00' and summ!='' and summ!='0' and ticket_id = '{$trash_1['ticket_id']}' and type = '{$type}' and preset = 'n'");
            $result_1 = $this->inDB->query($sql_1);
            $summ = 0;
            while($trash_1 = $this->inDB->fetch_assoc($result_1)){
                $summ += $trash_1['summ'];
            }
            return $summ;
        }

        public function formDataAboutPaymentByType($ticket_id){
            $temp_client = $this->getListWishedCarForTicketProcat($ticket_id);
            $temp_partner = $temp_client['setted_car'];
            $arr[$ticket_id][$temp_client['id']]['client']['data_add'] = date('d.m.Y H:i',($temp_client['time_add']));
            if($temp_client['confirmed']!=''){
                $arr[$ticket_id][$temp_client['id']]['client']['full_price'] = $temp_client['confirmed']['final']; 
            }
            $arr[$ticket_id][$temp_client['id']]['client']['data_begin_work'] = $temp_client['begin_procat'];
            $arr[$ticket_id][$temp_client['id']]['partner']['data_begin_work'] = $temp_client['begin_procat'];
            $arr[$ticket_id][$temp_client['id']]['partner']['data_add'] = date('d.m.Y H:i',($temp_client['time_add']));
            $arr[$ticket_id][$temp_client['id']]['partner']['full_price'] = $temp_partner['endPriceSettedTS'];
            $arr[$ticket_id][$temp_client['id']]['partner']['givenMoney'] = $this->getPaiedSumm($ticket_id,'partner');
            $arr[$ticket_id][$temp_client['id']]['client']['givenMoney'] = $this->getPaiedSumm($ticket_id,'client');
            return $arr;
        }

        public function getLineOfConfirmed($id){
            $sql = ("SELECT * FROM srm_procat_routeList_confirmed WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
            while ($trash = $this->inDB->fetch_assoc($result)){
                $trash['data'] = date('d.m.Y',strtotime($trash['data']));
                $trash['begin'] = date('H:i',strtotime($trash['begin']));
                $trash['end'] = date('H:i',strtotime($trash['end']));
                $data = $trash;
            }
            return $data;
        }

        public function editConfirmedRouteLine($arr,$id){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("UPDATE srm_procat_routeList_confirmed SET {$set} WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function getSettedAuto($wish_id){
            $sql = ("SELECT id_car FROM srm_procat_carsListArendaByWishCar WHERE id_wishcar = '{$wish_id}'");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);
            $car_info = $this->getCarInfo($data['id_car']);
            $car['type'] = $car_info['type_vehicle'];
            $car['mark'] = $car_info['mark'];
            $car['model'] = $car_info['model'];
            unset($car_info);
            return $car;
        }

        public function getSettedAutoBySettedId($car_id){
            $sql = ("SELECT id_car FROM srm_procat_carsListArendaByWishCar WHERE id_car = '{$car_id}'");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);
            $car_info = $this->getCarInfo($data['id_car']);
            $car['type'] = $car_info['type_vehicle'];
            $car['mark'] = $car_info['mark'];
            $car['model'] = $car_info['model'];
            unset($car_info);
            return $car;
        }

        public function getListOwner($ticket_id){
            $trash = $this->getTicketInfo($ticket_id);
            foreach($trash['car_list'] as $wishcar){
                foreach($wishcar['car_setted'] as $setted){
                    $owner_arr[] = $setted['owner_info'];
                }
            }
            unset($trash);
            return $owner_arr;
        }

        public function getListConfirmedRouteForPartner($id_wishcar){
            $sql = ("SELECT * FROM srm_procat_routeList_confirmed WHERE id_wishcar = '{$id_wishcar}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data'] = date('d.m.Y', strtotime($trash['data']));
                $trash['begin'] = date('H:i',strtotime($trash['begin']));
                $trash['end'] = date('H:i',strtotime($trash['end']));
                if($trash['service_type'] != ''){
                    $trash['end'] = $trash['service_type'];
                }
                $trash['route_p_desc'] = "<span class='label label-primary'>".$trash['data']."</span> <span class='label label-primary'>".$trash['begin']." - ".$trash['end']."</span> ".$trash['route_desc']." ".$trash['type_ts']." ".$trash['marka_ts']." ".$trash['model_ts'];
                $trash['days'] = $this->getCountHoursByBeginNEnd($trash['begin'],$trash['end']);
                $data[] = $trash;
            }
            return $data;
        }

        public function unsetPartnerFromRoute($partner_id,$id_route){
            $sql = ("SELECT partner_id FROM srm_procat_routeList_confirmed WHERE id = '{$id_route}'");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);
            if($data['partner_id'] == $partner_id){
                $sql_2 = ("UPDATE srm_procat_routeList_confirmed SET partner_id = '0' WHERE id = '{$id_route}'");
                $result_2 = $this->inDB->query($sql_2);
                return true;
            }else{
                return false;
            }
            
        }

        public function getConfirmedListByTicketIdNPartnerId($ticket_id,$partner_car_line){
            $line = "(";
            foreach($partner_car_line as $p){
                $line .= " srm_procat_ticketPartnerRoutePayment.car_id = '".$p."' or";
            }
            $line .= " srm_procat_ticketPartnerRoutePayment.car_id ='false')";
            $sql = ("SELECT srm_procat_routeList_confirmed.*,
                            srm_procat_ticketPartnerRoutePayment.price,
                            srm_procat_ticketPartnerRoutePayment.type_route
                     FROM srm_procat_routeList_confirmed INNER JOIN srm_procat_ticketPartnerRoutePayment
                     ON srm_procat_routeList_confirmed.id = srm_procat_ticketPartnerRoutePayment.id_route
                     INNER JOIN srm_procat_carsWishForTicketProcat 
                     ON srm_procat_carsWishForTicketProcat.id = srm_procat_routeList_confirmed.id_wishcar
                     WHERE srm_procat_carsWishForTicketProcat.ticket_id = '{$ticket_id}' and {$line}
                     ORDER BY srm_procat_routeList_confirmed.data ASC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                //$temp = $this->getSettedTS($trash['id_wishcar']);
                $trash['data'] = date('d.m.Y',strtotime($trash['data']));
                    if($trash['service_type'] == ''){
                        $trash['hourswork'] = $this->getCountHoursByBeginNEnd($trash['begin'],$trash['end']);
                        $trash['hourswork'] +=$trash['add_hours'];
                        $trash['begin'] = date('H:i',strtotime($trash['begin']));
                        $trash['end'] = date('H:i',strtotime($trash['end']));
                        $trash['final_price_per_car'] = $trash['hourswork']*$trash['price'];
                    }else{
                        $trash['end'] = '';
                            if(($trash['service_type']  == 'Трансфер')||$trash['service_type']  == 'Сутки'){
                                $trash['begin'] = date('H:i',strtotime($trash['begin']));
                            }else{
                                $trash['begin'] = "";
                            }
                        $trash['hourswork'] = "";
                        $trash['add_hours'] = "";
                        $trash['final_price_per_car'] = $trash['price'];
                        $trash['price'] = "";
                    }
                $data[] = $trash;
            }
            return $data;
        }

        public function addNumberDogovorClient($arr){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketDogovorNomers SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function checkExistNumberDog($client_id,$type_client){
            $sql = ("SELECT id FROM srm_procat_ticketDogovorNomers WHERE client_id = '{$client_id}' and type_client='{$type_client}'");
            $result = $this->inDB->query($sql);
            if($this->inDB->num_rows($result)){
                return $this->getExistNumberDog($client_id,$type_client);
            }else{
                return 'n';
            }
        }

        public function getExistNumberDog($client_id,$type_client){
            $sql = ("SELECT * FROM srm_procat_ticketDogovorNomers WHERE client_id = '{$client_id}' and type_client='{$type_client}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data_dogovor'] = date('d.m.Y',strtotime($trash['data_dogovor']));
                $data = $trash;
            }
            return $data;
        }

        public function getLastNumberDog($type_client){
            $sql = ("SELECT num_dogovor FROM srm_procat_ticketDogovorNomers WHERE type_client='{$type_client}' ORDER BY id DESC LIMIT 1");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $temp = explode("-",$trash['num_dogovor']);
                $data = $temp[1];
            }
            return $data;
        }

        public function getConsultList(){
            $sql = ("SELECT * FROM srm_procat_ticketConsultList ORDER BY id DESC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data'] = date('d.m.Y H:i',strtotime($trash['data']));
                $data[] = $trash;
            }
            return $data;
        }

        public function addConsult($arr){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketConsultList SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function updateConsult($arr,$id){
            $set = implode(', ', prepareSQL($arr));
            $sql = ("UPDATE srm_procat_ticketConsultList SET {$set} WHERE $id = '{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function getConsultLine($id){
            $sql = ("SELECT * FROM srm_procat_ticketConsultList WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data'] = date('d.m.Y H:i',strtotime($trash['data']));
                $data = $trash;
            }
            return $data;
        }

        public function deleteConsultLine($id){
            $sql = ("DELETE FROM srm_procat_ticketConsultList WHERE id = '{$id}'");
            $result = $this->inDB->query($sql);
        }

        public function getLastCommentForClient($ticket_id){
            $today = date('Y-m-d');
            //and date_callback>='{$today}' 
            $sql = ("SELECT date_callback FROM srm_procat_ticketProcatCallback WHERE type='client' and ticket_id = '{$ticket_id}' and worked !='y' ORDER BY id ASC LIMIT 1");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);
            $data_callback = date('d.m.Y H:i',strtotime($data['date_callback']));
            $data_callback = (($data_callback != "01.01.1970 03:00")&&($data_callback != "00.00.0000 00:00"))?$data_callback:"Не установлен";
            return $data_callback;
        }

        public function getLastCommentForPartner($ticket_id){
            $sql = ("SELECT date_callback FROM srm_procat_ticketProcatCallback WHERE ticket_id = '{$ticket_id}' and worked !='y' and type = 'partner' ORDER BY id DESC LIMIT 1");
            $result = $this->inDB->query($sql);
            $data = $this->inDB->fetch_assoc($result);
            $data_callback = date('d.m.Y H:i',strtotime($data['date_callback']));
            $data_callback = (($data_callback != "01.01.1970 03:00")&&($data_callback != "00.00.0000 00:00"))?$data_callback:"Не установлен";
            return $data_callback;
        }

        public function getPaymentList($ticket_id){
            $sql = ("SELECT * FROM srm_procat_ticketPaymentList WHERE ticket_id = '{$ticket_id}' and is_delete = '0'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data'] = date('d.m.Y H:i',strtotime($trash['data']));
                $type = ($trash['payment_from'] == 'client')?"клиент":"партнер";
                $stream = ($trash['stream'] == 'In')?'Входящий от ':'Исходящий ';
                $type .= ($trash['stream'] == 'In')?'а':'у';
                $trash['payment_from_line'] = $stream.$type;
                $data[$trash['payment_from']][] = $trash;
            }
            return $data;
        }

        public function getPaymentListNative($ticket_id){
            $sql = ("SELECT * FROM srm_procat_ticketPaymentList WHERE ticket_id = '{$ticket_id}' and is_delete = '0' ORDER BY data ASC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data[] = $trash;
            }
            return $data;
        }

        public function addDataToPaymentList($arr){
            $set = implode(", ",prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketPaymentList SET {$set}");
            $result = $this->inDB->query($sql);
        }

        public function editDataToPaymentList($arr,$id_line){
            $set = implode(", ",prepareSQL($arr));
            $sql = ("UPDATE srm_procat_ticketPaymentList SET {$set} WHERE id = '{$id_line}'");
            $result = $this->inDB->query($sql);
        }

        public function deleteDataToPaymentList($id_line){
            $sql = ("UPDATE srm_procat_ticketPaymentList SET is_delete = '1' WHERE id = '{$id_line}'");
            $result = $this->inDB->query($sql);
        }

        public function getDataWorkPartnerForWishCar($id_wishcar,$partner_id){
            $sql = ("SELECT srm_procat_routeList_confirmed.data,srm_procat_routeList_confirmed.begin,srm_procat_routeList_confirmed.end,srm_procat_routeList_confirmed.transfer_confirmed,srm_procat_routeList_confirmed.service_type FROM srm_procat_routeList_confirmed WHERE id_wishcar = '{$id_wishcar}' and partner_id = '{$partner_id}'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data']=date('d.m.Y',strtotime($trash['data']));
                $trash['begin']=date('H:i',strtotime($trash['begin']));
                $trash['end']=date('H:i',strtotime($trash['end']));
                $data[] = $trash;
            }
        return $data;
        }

        public function getPaymentListById($id){
            $sql = ("SELECT * FROM srm_procat_ticketPaymentList WHERE id = '{$id}' and is_delete = '0'");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $trash['data'] = date('d.m.Y H:i',strtotime($trash['data']));
                $type = ($trash['payment_from'] == 'client')?"клиент":"партнер";
                $stream = ($trash['stream'] == 'In')?'Входящий от ':'Исходящий ';
                $type .= ($trash['stream'] == 'In')?'а':'у';
                //$trash['payment_from_line'] = $stream.$type;
                $data = $trash;
            }
            return $data;
        }

        public function getDataBeginWorkTicket($ticket_id){
            $today = date('Y-m-d');
            // and srm_procat_carsWishForTicketProcat.begin_procat>='{$today}'
            $sql = ("SELECT srm_procat_routeList_confirmed.data as begin_procat,srm_procat_routeList_confirmed.begin as begin_time FROM srm_procat_ticketProcat INNER JOIN srm_procat_carsWishForTicketProcat ON srm_procat_ticketProcat.id = srm_procat_carsWishForTicketProcat.ticket_id INNER JOIN srm_procat_routeList_confirmed ON srm_procat_carsWishForTicketProcat.id = srm_procat_routeList_confirmed.id_wishcar  WHERE srm_procat_ticketProcat.id = '{$ticket_id}' GROUP BY srm_procat_routeList_confirmed.id_wishcar");
            $result = $this->inDB->query($sql);
            while ($trash = $this->inDB->fetch_assoc($result)) {
                $trash['begin_procat'] = date('d.m.Y',strtotime($trash['begin_procat']));
                $trash['begin_time'] = date('H:i',strtotime($trash['begin_time']));
                $data[] = implode(' ', $trash);
            }
            $data = array_unique($data);
            return $data;
        }

        public function getListPartnerWorkTicket($ticket_id){
            $temp_big_data = $this->getListWishedCarForTicketProcat($ticket_id);
            foreach ($temp_big_data as $car_wish){
                if($car_wish['setted_car']!='0'){
                    foreach($car_wish['car_setted'] as $setted){
                        $data[] = $setted['owner_info']['name'];
                    }
                }else{
                    break;
                }
            }
            return $data;
        }

        public function checkTSworkInTicket($id_car,$partner_id){
            $sql = ("SELECT srm_procat_ticketProcat.id as ticket_id, srm_procat_carsWishForTicketProcat.id FROM srm_procat_carsListArendaByWishCar INNER JOIN srm_procat_carsWishForTicketProcat ON srm_procat_carsWishForTicketProcat.id = srm_procat_carsListArendaByWishCar.id_wishcar INNER JOIN srm_procat_ticketProcat ON srm_procat_ticketProcat.id = srm_procat_carsWishForTicketProcat.ticket_id WHERE srm_procat_carsListArendaByWishCar.id_car = '{$id_car}' and (srm_procat_ticketProcat.status_ticket!= 'Отказ' AND srm_procat_ticketProcat.status_ticket != 'Закрыта')");
            $result = $this->inDB->query($sql);
            if($this->inDB->num_rows($result)){
                while($trash = $this->inDB->fetch_assoc($result)){
                    $trash['time_work'] = $this->getDataWorkForWishCar($partner_id,$trash['id']);
                    $line = "<a href='/clientAccount/ticket_procat/".$trash['ticket_id']."' style='font-weight:bold;' target='_blank'>Работает по заявке №".$trash['ticket_id']." с ".$trash['time_work']."</a>";
                    $data[] = $line;
                }
                $data = implode('<br>', $data);
                
            }else{
                $data = '-';
            }
            return $data;
        }

        public function getDataWorkForWishCar($partner_ticket_id,$wishcar_id){
            $sql = ("SELECT data FROM srm_procat_routeList_confirmed WHERE id_wishcar = '{$wishcar_id}' and partner_id = '{$partner_ticket_id}' ORDER BY data ASC");
            $result = $this->inDB->query($sql);
            while($trash = $this->inDB->fetch_assoc($result)){
                $data[] = date('d.m.Y',strtotime($trash['data']));
            }
            return $data[0]." по ".$data[count($data)-1];
        }

        public function getColorStatusByValue($status){
            switch ($status) {
                case 'Отправлено КП':
                    $color = "yellow";
                    break;
                case 'Согласовано':
                    $color = "pink";
                    break;
                case 'Ожидание':
                    $color = "green_light";
                    break;
                case 'Подтверждено':
                    $color = "green_dark";
                    break;
                case 'Закрыта':
                    $color = "red";
                    break;
                case 'Отказ':
                    $color = "gray";
                    break;
                case 'Новая заявка':
                    $color = "white";
                    break;
                case 'Принята в работу':
                    $color = "blue";
                    break;
                case 'Расчет':
                    $color = "purple";
                    break;
                case 'Документооборот':
                    $color = "cherry";
                    break;
            }

            return $color;

        }

        public function getFinanceShortInfoByTicket($ticket_id){
            $temp_ticket_info = $this->getTicketInfo($ticket_id);
            foreach($temp_ticket_info['car_list'] as $wc){
                foreach($wc['car_setted'] as $sc){
                    $p_t_arr[] = $sc['endPriceSettedTS'];
                }
                $c_t_arr[] = $wc['confirmed']['final'];
            }

            $a['partner_summ'] = array_sum($p_t_arr);
            $a['client_summ'] = array_sum($c_t_arr);
            $a['ak_summ'] = $a['client_summ'] - $a['partner_summ'];

            $temp_payment_h = $this->getPaymentList($ticket_id);
            foreach($temp_payment_h['client'] as $c){
                if($c['stream'] == 'In'){
                    $c_pay_t_arr[] = $c['summ'];
                }
                if($c['type_payment'] == 'АК'){
                    $ak = $c['summ'];
                    $from = $c['payment_from'];
                }
                $type_p_c = $c['type_payment'];
            }

            foreach($temp_payment_h['partner'] as $p){
                if($p['stream'] == 'Out'){
                    $p_pay_t_arr[] = $p['summ'];
                }
                if($c['type_payment'] == 'АК'){
                    $ak = $p['summ'];
                    $from = $p['payment_from'];
                }
                $type_p_p = $p['type_payment'];
            }
            $a['client_paid'] = array_sum($c_pay_t_arr);
            $a['partner_get'] = array_sum($p_pay_t_arr);
            $a['client_paid_type'] = $type_p_c;
            $a['partner_get_type'] = $type_p_p;
            $a['lost_partner'] = $a['partner_summ'] - $a['partner_get'];
            $a['lost_client'] = $a['client_summ'] - $a['client_paid'];
            $a['ak_by_dif_c_p'] = $a['client_paid'] - $a['partner_get'];
            $a['ak_by_history'] = $ak;
            $a['ak_getted_f'] = $from;
            //$a = $temp_ticket_info;
            return $a;
        }

    public function getFinanceFullInfoByTicket($ticket_id){
        $temp_ticket_info = $this->getTicketInfo($ticket_id);
        foreach($temp_ticket_info['car_list'] as $wc){
            foreach($wc['car_setted'] as $sc){
                $p_t_arr[] = $sc['endPriceSettedTS'];
            }
            $c_t_arr[] = $wc['confirmed']['final'];
        }
        $data['partner_summ'] = array_sum($p_t_arr);
        $data['client_summ'] = array_sum($c_t_arr);
        $data['ak_summ'] = $data['client_summ'] - $data['partner_summ'];
        $data['client_paid'] = "";
        $data['partner_get'] = "";
        $data['partner_hold'] = "";
        $data['client_hold'] = "";
        $data['gotten_ak'] = "";
        $data['iteration'] = [];
        $data['client_incoming'] = 0;
        $data['client_outcoming'] = 0;
        $data['partner_incoming'] = 0;
        $data['partner_outcoming'] = 0;
        $data['manager_name'] = $temp_ticket_info['manager_info']['nickname'];
        $data['status'] = $temp_ticket_info['status_ticket'];
        $data['data_add'] = date('d.m.Y',strtotime($temp_ticket_info['time_add']));
        $data['client_name'] = $temp_ticket_info['nick_client'];
        $data['work_city'] = $temp_ticket_info['ticket_city'];
        
        foreach ($temp_ticket_info['car_list'] as $key => $temp) {
            foreach ($temp['car_setted'] as $key => $car) {
                $temp_list_partner[] = $car['owner_info']['name'];
            }
        }

        $data['partner_name'] = implode('<br>',$temp_list_partner);
        unset($temp_ticket_info);
        $payment_list = $this->getPaymentListNative($ticket_id);
        $data['payment_list'] = $payment_list;
        foreach($payment_list as $key=>$pay){
            $type = $pay['payment_from'];
            $data[$type.'_'.strtolower($pay['stream']).'coming'] += $pay['summ'];

            if($pay['payment_from'] == 'client'){
                //проверяем на первый поступивший платеж от клиента
                    if($data['client_paid'] == ""){
                        //записываем данные по нашей комиссии
                        $data['iteration'][] = 21;
                        //записываем долги клиенту, если мы получили не всё бабло, или нам, если мы получили сверху
                        if($pay['summ']>$data['client_summ']){
                            $data['client_hold'] = "- ".($pay['summ'] - $data['client_summ']);
                        }elseif($pay['summ']<$data['client_summ']){
                            $data['client_hold'] = "+ ".($data['client_summ'] - $pay['summ']);
                        }elseif($pay['summ'] == $data['client_summ']){
                            $data['client_hold'] = "0";
                        }

                        $data['client_paid'] = $pay['summ'];
                        if($data['partner_get'] == ''){
                            $data['partner_hold'] = "- ".($data['partner_summ']);
                        }else{
                            $data['partner_hold'] = "- ".($data['partner_get'] - $data['partner_summ']);
                        }
                    }elseif($data['client_paid'] != ""){
                        $data['iteration'][] = 17;
                        //записываем данные по нашей комиссии

                        if($pay['stream'] == 'In'){
                            $data['iteration'][] = 16;
                            if(($pay['summ']+$data['client_paid'])>$data['client_summ']){
                                $data['client_hold'] = "- ".(($pay['summ']+$data['client_paid']) - $data['client_summ']);
                            }elseif(($pay['summ']+$data['client_paid'])<$data['client_summ']){
                                $data['client_hold'] = "+ ".($data['client_summ'] - ($pay['summ']+$data['client_paid']));
                            }elseif(($pay['summ']+$data['client_paid']) == $data['client_summ']){
                                $data['client_hold'] = "0";
                            }

                            $data['client_paid'] += $pay['summ'];
                        }elseif($pay['stream'] == 'Out'){
                            $data['iteration'][] = 20;
                            $data['client_paid'] -= $pay['summ'];
                            if(($pay['summ']!=$data['client_paid'])&&($data['client_paid']>0)){
                                if($data['client_paid']>$data['client_summ']){
                                    $data['iteration'][] = 22;
                                    $data['client_hold'] = "- ".($data['client_paid'] - $data['client_summ']);
                                }elseif($data['client_paid']<$data['client_summ']){
                                    $data['iteration'][] = 23;
                                    $data['client_hold'] = "+ ".($data['client_summ'] - $data['client_paid']);
                                }elseif($data['client_paid'] == $data['client_summ']){
                                    $data['iteration'][] = 24;
                                    $data['client_hold'] = "0";
                                }
                            }elseif(($data['client_paid'] == 0)&&($pay['stream'] == 'Out')){
                                if($data['partner_get'] == 0){
                                    $data['partner_hold'] = 0;
                                }else{
                                    $data['partner_hold'] = "+ ".$data['partner_get'];
                                }
                                $data['client_hold'] = 0;
                                $data['gotten_ak'] = 0;
                            }
                        }
                        if(($pay['summ']!=$data['client_paid'])&&($data['client_paid']>0)){
                            $data['iteration'][] = 32;
                            $data['check_sum_p'] = $data['partner_get'];
                            if($data['partner_get']>$data['partner_summ']){
                                $data['iteration'][] = 35;
                                $data['partner_hold'] = "+ ".($data['partner_summ'] - $data['partner_get']);
                            }elseif($data['partner_get']<$data['partner_summ']){
                                $data['iteration'][] = 36;
                                $data['partner_hold'] = "- ".($data['partner_summ'] - $data['partner_get']);
                                $data['check_sum_p'] = $data['partner_hold'];
                            }elseif($data['partner_get'] == $data['partner_summ']){
                                $data['iteration'][] = 37;
                                $data['partner_hold'] = 0;
                            }
                        }elseif(($data['client_paid'] == 0)&&($pay['stream'] == 'Out')){
                            if($data['partner_get'] == 0){
                                $data['partner_hold'] = 0;
                            }
                            $data['client_hold'] = 0;
                            $data['gotten_ak'] = 0;
                        }
                    }

                switch ($pay['type_payment']) {
                    case 'Водителю с АК':
                        if($data['partner_get'] == ""){
                            $data['iteration'][] = 44;
                             if($pay['summ']<$data['partner_summ']){
                                $data['partner_get'] += $pay['summ'];
                            }elseif($pay['summ']>$data['partner_summ']){
                                $data['partner_get'] += $pay['summ'];
                            }elseif($pay['summ'] == $data['partner_summ']){
                                $data['partner_get'] = $data['partner_summ'];
                            }
                        }elseif($data['partner_get']!=''){
                            if(($data['partner_get']+$pay['summ'])<$data['partner_summ']){
                                $data['iteration'][] = 39;
                                $data['partner_get'] += $pay['summ'];
                            }elseif(($data['partner_get']+$pay['summ'])>$data['partner_summ']){
                                $data['iteration'][] = 40;
                                $data['partner_get'] += $pay['summ'];
                                $data['check_sum_p'] = $data['partner_get'];
                            }elseif(($data['partner_get']+$pay['summ']) == $data['partner_summ']){
                                $data['iteration'][] = 41;
                                $data['partner_get'] = $data['partner_summ'];
                            }
                        }

                        if($data['gotten_ak']!=$data['ak_summ']){
                            if($data['partner_get']>$data['partner_summ']){
                                $ak_diff = (($data['gotten_ak']!='')||($data['gotten_ak']!=0))?($data['ak_summ']-$data['gotten_ak']):0;
                                $data['partner_hold'] = "+ ".($data['partner_get'] - $data['partner_summ']);
                            }elseif($data['partner_get']<$data['partner_summ']){
                                $data['partner_hold'] = "- ".(($data['partner_summ'] - $data['partner_get'])+($data['ak_summ']-$data['gotten_ak']));
                            }elseif($data['partner_get'] == $data['partner_summ']){
                                $data['partner_hold'] = "+ ".($data['ak_summ']-$data['gotten_ak']);
                            }
                        }else{
                            if($data['partner_get']>$data['partner_summ']){
                                $data['partner_hold'] = "+ ".($data['partner_summ'] - $data['partner_get']);
                            }elseif($data['partner_get']<$data['partner_summ']){
                                $data['partner_hold'] = "- ".($data['partner_summ'] - $data['partner_get']);
                            }elseif($data['partner_get'] == $data['partner_summ']){
                                $data['partner_hold'] = 0;
                            }
                        }
                        break;
                    case 'Водителю без АК':
                        if($data['partner_get'] == ""){
                             $data['iteration'][] = 43;
                             $data['partner_get'] = $pay['summ'];
                        }elseif($data['partner_get']!=''){
                            $data['iteration'][] = 42;
                            $data['partner_get'] += $pay['summ'];
                        }

                        if($data['partner_get']>$data['partner_summ']){
                            $data['partner_hold'] = "+ ".($data['partner_summ'] - $data['partner_get']);
                        }elseif($data['partner_get']<$data['partner_summ']){
                            $data['partner_hold'] = "- ".($data['partner_summ'] - $data['partner_get']);
                        }elseif($data['partner_get'] == $data['partner_summ']){
                            $data['partner_hold'] = 0;
                        }
                        break;               
                    default:
                        $data['iteration'][] = 15;
                        if($data['client_paid'] == ""){
                           if($pay['summ']>$data['ak_summ']){
                                //если больше то фиксируем нашу ак
                                $data['gotten_ak'] = $data['ak_summ'];
                            }elseif($pay['summ']<$data['ak_summ']){
                                //если меньше, то запихиваем полученное в ак 
                                $data['gotten_ak'] = $pay['summ'];
                            }elseif($pay['summ'] == $data['ak_summ']){
                                $data['gotten_ak'] = $data['ak_summ'];
                            } 
                        }elseif($data['client_paid'] != ""){
                            if($data['gotten_ak'] == ''){
                                if($pay['summ']>$data['ak_summ']){
                                    //если больше то фиксируем нашу ак
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }elseif($pay['summ']<$data['ak_summ']){
                                    //если меньше, то запихиваем полученное в ак 
                                    $data['gotten_ak'] = $pay['summ'];
                                }elseif($pay['summ'] == $data['ak_summ']){
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }
                            }else{
                                if(($pay['summ']+$data['gotten_ak'])>$data['ak_summ']){
                                    //если больше то фиксируем нашу ак
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }elseif(($pay['summ']+$data['gotten_ak'])<$data['ak_summ']){
                                    //если меньше, то запихиваем полученное в ак 
                                    $data['gotten_ak'] += $pay['summ'];
                                }elseif(($pay['summ']+$data['gotten_ak']) == $data['ak_summ']){
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }
                            }
                        }
                        if(($pay['summ']!=$data['client_paid'])&&($data['client_paid']>0)){
                            $data['iteration'][] = 31;
                            if($data['partner_get']>$data['partner_summ']){
                                $data['partner_hold'] = "+ ".($data['partner_summ'] - $data['partner_get']);
                            }elseif($data['partner_get']<$data['partner_summ']){
                                $data['partner_hold'] = "- ".($data['partner_summ'] - $data['partner_get']);
                            }elseif($data['partner_get'] == $data['partner_summ']){
                                $data['partner_hold'] = 0;
                            }
                        }elseif(($data['client_paid'] == 0)&&($pay['stream'] == 'Out')){
                            if(($data['partner_get'] == 0)||($data['partner_get'] == '')){
                                $data['partner_hold'] = 0;
                            }else{
                                $data['partner_hold'] = "+ ".$data['partner_get'];
                            }
                            $data['client_hold'] = 0;
                            $data['gotten_ak'] = 0;
                        }
                        break;
                }
            }elseif($pay['payment_from'] == 'partner'){
                //записываем долги клиенту, если мы получили не всё бабло, или нам, если мы получили сверху
                if(($data['client_paid']!='')||($data['client_paid']!=0)){
                    $data['iteration'][] = 33;
                    if($data['partner_get'] == ""){
                        if($pay['summ']>$data['partner_summ']){
                            $data['partner_hold'] = "+ ".($pay['summ'] - $data['partner_summ']);
                        }elseif($pay['summ']<$data['partner_summ']){
                            $data['partner_hold'] = "- ".($data['partner_summ'] - $pay['summ']);
                        }elseif($pay['summ'] == $data['partner_summ']){
                            $data['partner_hold'] = "0";
                        }
                        if($pay['stream'] == 'Out'){
                            $data['partner_get'] = $pay['summ'];
                        }elseif($pay['stream'] == 'In'){
                            $data['partner_get'] -= $pay['summ'];
                        }
                    }elseif($data['partner_get'] != ""){

                        if($pay['stream'] == 'Out'){
                            if(($pay['summ']+$data['partner_get'])>$data['partner_summ']){
                                $data['iteration'][] = 25;
                                $data['partner_hold'] = "+ ".(($pay['summ']+$data['partner_get']) - $data['partner_summ']);
                            }elseif(($pay['summ']+$data['partner_get'])<$data['partner_summ']){
                                $data['iteration'][] = 26;
                                $data['partner_hold'] = "- ".($data['partner_summ'] - ($pay['summ']+$data['partner_get']));
                            }elseif(($pay['summ']+$data['partner_get']) == $data['partner_summ']){
                                $data['iteration'][] = 27;
                                $data['partner_hold'] = "0";
                            }
                            $data['iteration'][] = 37;
                            $data['partner_get'] += $pay['summ'];
                        }elseif($pay['stream'] == 'In'){
                            $data['iteration'][] = 38;
                            $data['partner_get'] -= $pay['summ'];

                            if($data['partner_get']>$data['partner_summ']){
                                $data['iteration'][] = 28;
                                $data['partner_hold'] = "+ ".($data['partner_get'] - $data['partner_summ']);
                            }elseif($data['partner_get']<$data['partner_summ']){
                                $data['iteration'][] = 29;
                                $data['partner_hold'] = "- ".($data['partner_summ'] - $data['partner_get']);
                            }elseif($data['partner_get'] == $data['partner_summ']){
                                $data['iteration'][] = 30;
                                $data['partner_hold'] = "0";
                            }                        
                        }
                    }
                    switch ($pay['type_payment']) {
                        case 'АК':
                            $data['iteration'][] = 7;
                            if($data['gotten_ak'] == ''){
                                if($pay['summ']>$data['ak_summ']){
                                    //если больше то фиксируем нашу ак
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }elseif($pay['summ']<$data['ak_summ']){
                                    //если меньше, то запихиваем полученное в ак 
                                    $data['gotten_ak'] = $pay['summ'];
                                }elseif($pay['summ'] == $data['ak_summ']){
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }
                                $data['iteration'][] = 8;
                            }else{
                                if(($pay['summ']+$data['gotten_ak'])>$data['ak_summ']){
                                    //если больше то фиксируем нашу ак
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }elseif(($pay['summ']+$data['gotten_ak'])<$data['ak_summ']){
                                    //если меньше, то запихиваем полученное в ак 
                                    $data['gotten_ak'] += $pay['summ'];
                                }elseif(($pay['summ']+$data['gotten_ak']) == $data['ak_summ']){
                                    $data['gotten_ak'] = $data['ak_summ'];
                                }

                                $data['iteration'][] = 9;
                            }
                            if($data['client_summ'] == $data['client_paid']){
                                $data['client_hold'] = "0";
                                if(($data['gotten_ak'] != $data['ak_summ'])&&($data['partner_get'] == $data['partner_summ'])){
                                    $data['partner_hold'] = "+ ".($data['ak_summ']-$data['gotten_ak']);
                                }elseif(($data['gotten_ak'] != $data['ak_summ'])&&($data['partner_get'] > $data['partner_summ'])){
                                    $data['partner_hold'] = "+ ".($data['ak_summ']-$data['gotten_ak']);
                                }elseif(($data['gotten_ak'] == $data['ak_summ'])&&($data['partner_get'] == $data['partner_summ'])){
                                  $data['partner_hold'] = "0";  
                                }
                            }elseif($data['partner_get'] == $data['partner_summ']){
                                $data['partner_hold'] = "0";
                                if(($data['gotten_ak'] != $data['ak_summ'])&&($data['client_summ'] == $data['client_paid'])){
                                    $data['client_hold'] = "+ ".($data['ak_summ']-$data['gotten_ak']);
                                }elseif(($data['gotten_ak'] != $data['ak_summ'])&&($data['client_paid'] > $data['client_summ'])){
                                    $data['client_hold'] = "+ ".($data['ak_summ']-$data['gotten_ak']);
                                }elseif(($data['gotten_ak'] == $data['ak_summ'])&&($data['client_summ'] == $data['client_paid'])){
                                  $data['client_hold'] = "0";  
                                }
                            }
                            break;                    
                        default:
                            break;
                    }
                }else{
                    $data['iteration'][] = 34;
                    /*if(($data['partner_get']=='')&&($data['client_paid'] == '')){
                        $data['partner_get'] = $pay['summ'];
                    }*/
                    $data['partner_hold'] = "+ ".$data['partner_get'];
                    //if(($data['client_paid'] == 0)&&)
                    if(($pay['stream'] == 'In')&&($data['client_paid'] == 0)){
                        $data['iteration'][] = 50;
                        $data['partner_get'] -= $pay['summ'];

                        if($data['partner_get']>0){
                            $data['iteration'][] = 51;
                            $data['partner_hold'] = "+ ".$data['partner_get'];
                        }elseif($data['partner_get']<0){
                            $data['iteration'][] = 52;
                            $data['partner_hold'] = "- ".$data['partner_get'];
                        }elseif($data['partner_get'] == 0){
                            $data['iteration'][] = 53;
                            $data['partner_hold'] = "0";
                        }                        
                    }

                    if(($pay['stream'] == 'In')&&($pay['type_payment'] == 'АК')){
                        if($data['gotten_ak'] == ''){
                            if($pay['summ']>$data['ak_summ']){
                                //если больше то фиксируем нашу ак
                                $data['gotten_ak'] = $data['ak_summ'];
                            }elseif($pay['summ']<$data['ak_summ']){
                                //если меньше, то запихиваем полученное в ак 
                                $data['gotten_ak'] = $pay['summ'];
                            }elseif($pay['summ'] == $data['ak_summ']){
                                $data['gotten_ak'] = $data['ak_summ'];
                            }
                            $data['iteration'][] = 8;
                        }else{
                            if(($pay['summ']+$data['gotten_ak'])>$data['ak_summ']){
                                //если больше то фиксируем нашу ак
                                $data['gotten_ak'] = $data['ak_summ'];
                            }elseif(($pay['summ']+$data['gotten_ak'])<$data['ak_summ']){
                                //если меньше, то запихиваем полученное в ак 
                                $data['gotten_ak'] += $pay['summ'];
                            }elseif(($pay['summ']+$data['gotten_ak']) == $data['ak_summ']){
                                $data['gotten_ak'] = $data['ak_summ'];
                            }

                            $data['iteration'][] = 9;
                        }

                        if(($data['gotten_ak'] != $data['ak_summ'])&&($data['partner_get'] == $data['partner_summ'])){
                            $data['partner_hold'] = "+ ".($data['ak_summ']-$data['gotten_ak']);
                        }elseif(($data['gotten_ak'] != $data['ak_summ'])&&($data['partner_get'] > $data['partner_summ'])){
                            $data['partner_hold'] = "+ ".($data['ak_summ']-$data['gotten_ak']);
                        }elseif(($data['gotten_ak'] == $data['ak_summ'])&&($data['partner_get'] == $data['partner_summ'])){
                          $data['partner_hold'] = "0";  
                        }
                    }
                }
            }
        }

        $data['ak'] = ($data['gotten_ak'] == "")?0:$data['gotten_ak'];

        if(($data['client_incoming'] == 0)&&($data['partner_outcoming'] == 0)&&($data['ak'] == 0)){
            $data['client_hold'] = '+ '.$data['client_summ'];
            $data['partner_hold'] = '- '.$data['partner_summ'];
        }

        return $data;
    }

    public function getFinancePartOfTicket($ticket_id){
        $temp_ticket_info = $this->getTicketInfo($ticket_id);
        foreach($temp_ticket_info['car_list'] as $wc){
            foreach($wc['car_setted'] as $sc){
                $p_t_arr[] = $sc['endPriceSettedTS'];
            }
            $c_t_arr[] = $wc['confirmed']['final'];
        }

        $data['partner_summ'] = array_sum($p_t_arr);
        $data['client_summ'] = array_sum($c_t_arr);
        $data['ak_summ'] = $data['client_summ'] - $data['partner_summ'];
        $data['ak'] = 0;
        $data['incoming']['nal'] = 0;
        $data['incoming']['cart'] = 0;
        $data['incoming']['without_nal'] = 0;
        $data['incoming']['final'] = 0;

        $data['outcoming']['nal'] = 0;
        $data['outcoming']['cart'] = 0;
        $data['outcoming']['without_nal'] = 0;
        $data['outcoming']['final'] = 0;

        $temp_d['client_incoming']['nal'] = 0;
        $temp_d['client_incoming']['cart'] = 0;
        $temp_d['client_incoming']['without_nal'] = 0;

        $temp_d['client_outcoming']['nal'] = 0;
        $temp_d['client_outcoming']['cart'] = 0;
        $temp_d['client_outcoming']['without_nal'] = 0;

        $temp_d['partner_incoming']['nal'] = 0;
        $temp_d['partner_incoming']['cart'] = 0;
        $temp_d['partner_incoming']['without_nal'] = 0;

        $temp_d['partner_outcoming']['nal'] = 0;
        $temp_d['partner_outcoming']['cart'] = 0;
        $temp_d['partner_outcoming']['without_nal'] = 0;

        $data['partner_hold'] = 0;
        $data['client_hold'] = 0;
        $data['manager_name'] = $temp_ticket_info['manager_info']['nickname'];
        $data['status'] = $temp_ticket_info['status_ticket'];
        $data['data_add'] = date('d.m.Y',strtotime($temp_ticket_info['time_add']));
        unset($temp_ticket_info);

        $temp_payment_h = $this->getPaymentListNative($ticket_id);
        foreach ($temp_payment_h as $key => $payments) {
            if(($payments['type_payment']!= 'Водителю с АК')&&($payments['type_payment']!= 'Водителю без АК')){
                switch ($payments['form']) {
                    case 'Наличные':
                        $payments['form'] = 'nal';
                        break;
                    case 'Карта':
                        $payments['form'] = 'cart';
                        break;
                    case 'Безналичный с НДС':
                        $payments['form'] = 'without_nal';
                        break;
                    case 'Безналичный без НДС':
                        $payments['form'] = 'without_nal';
                        break;
                }

                $type = $payments['payment_from'];
                $temp_d[$type.'_'.strtolower($payments['stream']).'coming'][$payments['form']] += $payments['summ'];

                $client_summ = array_sum(array($temp_d['client_incoming']['nal'],$temp_d['client_incoming']['cart'],$temp_d['client_incoming']['without_nal']));
                $partner_summ = array_sum(array($temp_d['partner_outcoming']['nal'],$temp_d['partner_outcoming']['cart'],$temp_d['partner_outcoming']['without_nal']));
                switch ($payments['type_payment']){
                    case 'Полная':
                        if($type == 'client'){
                            if(($client_summ > $data['ak_summ'])&&($data['client_summ'] == $client_summ)){
                               $data['client_hold'] = 0;
                               $data['ak'] = $data['ak_summ'];
                            }else{
                                $data['client_hold'] = '+ '.($data['client_summ']-$client_summ);
                            }
                        }elseif($type == 'partner'){
                           if(($partner_summ > $data['ak_summ'])&&($data['partner_summ'] == $partner_summ)){
                                $data['partner_hold'] = 0;
                                $data['ak'] = $data['ak_summ'];
                            }else{
                                $data['partner_hold'] = '- '.($data['partner_summ']-$partner_summ);
                            }
                        }
                        break;
                    case 'Частичная':
                        if($type == 'client'){
                            if($client_summ > $data['ak_summ']){
                                $data['ak'] = $data['ak_summ'];
                            }else{
                                $data['ak'] = 0;
                            }
                            $data['client_hold'] = '+ '.($data['client_summ'] - $client_summ);
                        }elseif($type == 'partner'){
                            if($partner_summ > $data['ak_summ']){
                                $data['ak'] = $data['ak_summ'];
                            }else{
                                $data['ak'] = 0;
                            }
                            $data['partner_hold'] = '- '.($data['partner_summ'] - $partner_summ); 
                        }
                        break;
                    case 'AK':
                            $data['ak'] = $data[$type.'_'.strtolower($payments['stream']).'coming'][$payments['form']];
                        break;
                }
            }
        }

        $data['incoming']['nal'] = $temp_d['client_incoming']['nal'] + $temp_d['partner_incoming']['nal'];
        $data['incoming']['cart'] = $temp_d['client_incoming']['cart'] + $temp_d['partner_incoming']['cart'];
        $data['incoming']['without_nal'] = $temp_d['client_incoming']['without_nal'] + $temp_d['partner_incoming']['without_nal'];
        $data['incoming']['final'] = array_sum(array($data['incoming']['nal'],$data['incoming']['cart'],$data['incoming']['without_nal']));
        $data['outcoming']['nal'] = $temp_d['client_outcoming']['nal'] + $temp_d['partner_outcoming']['nal'];
        $data['outcoming']['cart'] = $temp_d['client_outcoming']['cart'] + $temp_d['partner_outcoming']['cart'];
        $data['outcoming']['without_nal'] = $temp_d['client_outcoming']['without_nal'] + $temp_d['partner_outcoming']['without_nal'];
        $data['outcoming']['final'] = array_sum(array($data['outcoming']['nal'],$data['outcoming']['cart'],$data['outcoming']['without_nal']));
        $data['dif'] = $data['incoming']['final'] - $data['outcoming']['final'];

        return $data;
    }

    public function getListTicketReport($begin,$end,$city){
        $sql = ("SELECT id FROM srm_procat_ticketProcat WHERE id!='0' and (status_ticket != 'Отказ' and status_ticket != 'Новая заявка' and status_ticket != 'Принята в работу' and status_ticket != 'Отправлено КП')");
        if(($begin != '')&&($end != '')){
            $begin = date('Y-m-d H:i',strtotime($begin));
            $end = date('Y-m-d H:i',strtotime($end)+86300);
            $sql.= " and time_add BETWEEN '{$begin}' and '{$end}'";
        }
        if($city != ''){
            $sql .= " and ticket_city LIKE '%{$city}%'";
        }
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $cash_array = $this->getFinanceFullInfoByTicket($trash['id']);
            $data[$trash['id']] = $cash_array;
            unset($cash_array);
        }
        //krsort($data);
        return $data;
    }

    public function getFinListByTickets($begin,$end,$city){
        $sql = ("SELECT id FROM srm_procat_ticketProcat WHERE id!='0' and (status_ticket != 'Отказ' and status_ticket != 'Новая заявка' and status_ticket != 'Принята в работу' and status_ticket != 'Отправлено КП')");
        if(($begin != '')&&($end != '')){
            $begin = date('Y-m-d H:i',strtotime($begin));
            $end = date('Y-m-d H:i',strtotime($end)+86300);
            $sql.= " and time_add BETWEEN '{$begin}' and '{$end}'";
        }
        if($city!=''){
            $sql .= " and ticket_city LIKE '%{$city}%'";
        }
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $cash_array = $this->getFinancePartOfTicket($trash['id']);
            $data[$trash['id']] = $cash_array;
            unset($cash_array);
        }
        //krsort($data);
        return $data;
    }

    public function getFinReportByDays($begin,$end,$city){
        $sql = ("SELECT srm_procat_ticketProcat.ticket_city,srm_procat_ticketPaymentList.* FROM srm_procat_ticketPaymentList LEFT JOIN srm_procat_ticketProcat ON srm_procat_ticketPaymentList.ticket_id = srm_procat_ticketProcat.id WHERE srm_procat_ticketPaymentList.is_delete = '0' and (srm_procat_ticketPaymentList.type_payment != 'Водителю с АК' and srm_procat_ticketPaymentList.type_payment != 'Водителю без АК') ");
        if(($begin != '')&&($end != '')){
            $begin = date('Y-m-d H:i',strtotime($begin));
            $end = date('Y-m-d H:i',strtotime($end)+86300);
            $sql.= " and srm_procat_ticketPaymentList.data BETWEEN '{$begin}' and '{$end}'";
        }
        if($city!=''){
            $sql .= " and srm_procat_ticketProcat.ticket_city LIKE '%{$city}%'";
        }
        $sql .= "ORDER BY srm_procat_ticketPaymentList.data ASC";
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['data'] = date('d.m.Y',strtotime($trash['data']));
            $temp[$trash['data']][] = $trash;
        }

        foreach ($temp as $keys_lvl) {
            $temp_data['incoming']['nal'] = 0;
            $temp_data['incoming']['cart'] = 0;
            $temp_data['incoming']['without_nal'] = 0;
            $temp_data['incoming']['final'] = 0;

            $temp_data['outcoming']['nal'] = 0;
            $temp_data['outcoming']['cart'] = 0;
            $temp_data['outcoming']['without_nal'] = 0;
            $temp_data['outcoming']['final'] = 0;

            $temp_d['client_incoming']['nal'] = 0;
            $temp_d['client_incoming']['cart'] = 0;
            $temp_d['client_incoming']['without_nal'] = 0;

            $temp_d['client_outcoming']['nal'] = 0;
            $temp_d['client_outcoming']['cart'] = 0;
            $temp_d['client_outcoming']['without_nal'] = 0;

            $temp_d['partner_incoming']['nal'] = 0;
            $temp_d['partner_incoming']['cart'] = 0;
            $temp_d['partner_incoming']['without_nal'] = 0;

            $temp_d['partner_outcoming']['nal'] = 0;
            $temp_d['partner_outcoming']['cart'] = 0;
            $temp_d['partner_outcoming']['without_nal'] = 0;
            $temp_d['day'] = '';

            foreach ($keys_lvl as $key => $pay) {
                switch ($pay['form']) {
                    case 'Наличные':
                        $pay['form'] = 'nal';
                        break;
                    case 'Карта':
                        $pay['form'] = 'cart';
                        break;
                    case 'Безналичный с НДС':
                        $pay['form'] = 'without_nal';
                        break;
                    case 'Безналичный без НДС':
                        $pay['form'] = 'without_nal';
                        break;
                }

                $type = $pay['payment_from'];
                $temp_d[$type.'_'.strtolower($pay['stream']).'coming'][$pay['form']] += $pay['summ'];

                $client_summ = array_sum(array($temp_d['client_incoming']['nal'],$temp_d['client_incoming']['cart'],$temp_d['client_incoming']['without_nal']));
                $partner_summ = array_sum(array($temp_d['partner_outcoming']['nal'],$temp_d['partner_outcoming']['cart'],$temp_d['partner_outcoming']['without_nal']));
                $temp_d['day'] = date('d.m.Y',strtotime($pay['data']));
            }

            $temp_data['incoming']['nal'] = $temp_d['client_incoming']['nal'] + $temp_d['partner_incoming']['nal'];
            $temp_data['incoming']['cart'] = $temp_d['client_incoming']['cart'] + $temp_d['partner_incoming']['cart'];
            $temp_data['incoming']['without_nal'] = $temp_d['client_incoming']['without_nal'] + $temp_d['partner_incoming']['without_nal'];
            $temp_data['incoming']['final'] = array_sum(array($temp_data['incoming']['nal'],$temp_data['incoming']['cart'],$temp_data['incoming']['without_nal']));
            $temp_data['outcoming']['nal'] = $temp_d['client_outcoming']['nal'] + $temp_d['partner_outcoming']['nal'];
            $temp_data['outcoming']['cart'] = $temp_d['client_outcoming']['cart'] + $temp_d['partner_outcoming']['cart'];
            $temp_data['outcoming']['without_nal'] = $temp_d['client_outcoming']['without_nal'] + $temp_d['partner_outcoming']['without_nal'];
            $temp_data['outcoming']['final'] = array_sum(array($temp_data['outcoming']['nal'],$temp_data['outcoming']['cart'],$temp_data['outcoming']['without_nal']));
            $temp_data['dif'] = $temp_data['incoming']['final'] - $temp_data['outcoming']['final'];
            $temp_data['day'] = $temp_d['day'];
            $data[] = $temp_data;
            unset($temp_data);
        }
        
        return $data;
    }

    public function getReportByTicketsByTypeTSNStatus($begin,$end,$city){
        cmsCore::loadClass('auto_use');
        $auto_obj = new cmsAuto_use();
        $type_ts_list = $auto_obj->getListOfTypeCars();
        $status_procat = $this->getProcatStatuses();
        array_unshift($status_procat, 'Новая заявка','Принята в работу');
        $sql = ("SELECT id,status_ticket FROM srm_procat_ticketProcat WHERE id!='0'");
        if(($begin != '')&&($end != '')){
            $begin = date('Y-m-d H:i',strtotime($begin));
            $end = date('Y-m-d H:i',strtotime($end)+86300);
            $sql.= " and time_add BETWEEN '{$begin}' and '{$end}'";
        }
        if($city != ''){
            $sql .= " and ticket_city LIKE '%{$city}%'";
        }
        $result = $this->inDB->query($sql);
        
        while($trash = $this->inDB->fetch_assoc($result)){
            $temp_car_arr = $this->getListWishedCarForTicketProcat($trash['id']);
            foreach ($temp_car_arr as $key => $car){
                $type_ts = $car['type_ts'];
                foreach($type_ts_list as $type){
                    foreach ($status_procat as $key => $status){
                        if(($status === $trash['status_ticket'])&&($type == $type_ts)){
                            $data[$type][$status] +=1;
                        }else{
                            if(!isset($data[$type][$status])){
                                $data[$type][$status] = 0;
                            }
                        }
                    }
                }
                unset($type_ts);
            }
            unset($temp_car_arr);
        }
        //$data['statut_list'] = $status_procat;
        return $data;
    }

    public function getReportsTableData($begin,$end,$city){
        $arr['fin_rep_by_t'] = $this->getListTicketReport($begin,$end,$city);
        $arr['fin_full'] = $this->getFinListByTickets($begin,$end,$city);
        $arr['fin_full_day'] = $this->getFinReportByDays($begin,$end,$city);
        $arr['report_by_tickets'] = $this->getReportByTicketsByTypeTSNStatus($begin,$end,$city);
        $arr['motiv_report'] = $this->getReportMotivation($begin,$end);
        $arr['rent_report'] = $this->getRentReportData($begin,$end);
        $arr['refuse_report'] = $this->getRefusedTicketReport($begin,$end,$city);
        return $arr;
    }

    public function getDataRFT($type_ts,$status,$city){
        $sql = ("SELECT ticket.*,car.type_ts,car.mark_ts,car.model_ts FROM srm_procat_ticketProcat as ticket LEFT JOIN srm_procat_carsWishForTicketProcat as car ON ticket.id = car.ticket_id WHERE car.type_ts ='{$type_ts}' and ticket.status_ticket = '{$status}' and ticket.ticket_city LIKE '{$city}'");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
            $trash['car'] = $trash['type_ts']." ".$trash['mark_ts']." ".$trash['model_ts'];
            $trash['type_client'] = ($trash['type_client'] == 'fiz')?'Физ. лицо':'Юр. Лицо';
            $data[] = $trash;            
        }
        return $data;

    }

    public function getDataFRBD($type,$form,$day){
        $type = ($type == 'incoming')?'In':'Out';
        $begin = date('Y-m-d H:i',strtotime($day));
        $end = date('Y-m-d H:i',strtotime($day)+86000);
        $sql = ("SELECT srm_procat_ticketPaymentList.*,srm_procat_ticketProcat.ticket_city FROM srm_procat_ticketPaymentList INNER JOIN srm_procat_ticketProcat ON srm_procat_ticketPaymentList.ticket_id = srm_procat_ticketProcat.id WHERE srm_procat_ticketPaymentList.stream = '{$type}' and srm_procat_ticketPaymentList.data BETWEEN '{$begin}' and '{$end}' and (srm_procat_ticketPaymentList.type_payment != 'Водителю с АК' and srm_procat_ticketPaymentList.type_payment != 'Водителю без АК')");
        switch ($form) {
            case 'cart':
                $sql .= " and srm_procat_ticketPaymentList.form = 'Карта'";
                break;
            case 'nal':
                $sql .= " and srm_procat_ticketPaymentList.form = 'Наличные'";
                break;
            case 'without_nal':
                $sql .= " and (srm_procat_ticketPaymentList.form = 'Безналичный с НДС' or srm_procat_ticketPaymentList.form = 'Безналичный без НДС')";
                break;            
            default:
                break;
        }
        $sql .= " and is_delete != '1'";
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['data'] = date('d.m.Y',strtotime($trash['data']));
            $type = ($trash['payment_from'] == 'client')?"клиент":"партнер";
            $stream = ($trash['stream'] == 'In')?'Входящий от ':'Исходящий ';
            $type .= ($trash['stream'] == 'In')?'а':'у';
            $trash['payment_from_line'] = $stream.$type;
            $data[] = $trash;
        }
        return $data;
    }

    public function addClientDocumentExchange($arr){
        $set = implode(', ',prepareSQL($arr));
        $sql = ("INSERT INTO srm_procat_clientExchangeDocument SET {$set}");
        $result = $this->inDB->query($sql);
    }

    public function getDataAboutExchange($id){
        $sql = ("SELECT * FROM srm_procat_clientExchangeDocument WHERE client_id = '{$id}'");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['data'] = date('d.m.Y',strtotime($trash['data']));
            $data[] = $trash;
        }
        return $data;
    }

    public function updateClientPostAddress($array,$id){
        $set = implode(', ',prepareSQL($array));
        $sql = ("UPDATE srm_users SET {$set} WHERE id='{$id}'");
        $result = $this->inDB->query($sql);
    }

    public function closePartnerCallbacks($ticket_id,$id_partner){
        $sql = ("UPDATE srm_procat_carsListArendaByWishCar SET worked = 'y' WHERE type= 'partner' and ticket_id = '{$ticket_id}' and id_obj ='{$id_partner}'");
        $result = $this->inDB->query($sql);
    }

    public function getSettedTSOwnerId($id_setted){
        $sql = ("SELECT id_car FROM srm_procat_carsListArendaByWishCar WHERE id = '{$id_setted}'");
        $result = $this->inDB->query($sql);
        $data = $this->inDB->fetch_assoc($result);
        cmsCore::loadModel('partner');
        $model_cars = new cms_model_partner();
        $car_info = $model_cars->show_car($data['id_car']);
        $owner_id = $car_info['id_owner'];
        return $owner_id;
    }

    public function getPartnerDataAboutConfRoute($id_route){
        $sql = ("SELECT * FROM srm_procat_ticketPartnerRoutePayment WHERE id_route = '{$id_route}'");
        $result = $this->inDB->query($sql);
        if($this->inDB->num_rows($result)){
            while($trash = $this->inDB->fetch_assoc($result)){
                $data = $trash;
            }
            return $data;
        }else{
            return "nothing";
        }
    }

    public function getPartnerRouteList($id_wish,$car_id){
        $list_routes_by_wish = $this->getListConfirmedRouteForPartner($id_wish);
        $getInfoAboutSettedCar = $this->getSettedAutoBySettedId($car_id);
        foreach($list_routes_by_wish as $key=>$route){
            //$car_id
            $temp = $this->getPartnerDataAboutConfRoute($route['id']);
            $list_routes_by_wish[$key]['car_setted_info'] = $getInfoAboutSettedCar;
            if($temp != 'nothing'){
                $list_routes_by_wish[$key]['partnerDataRoute']['price'] = $temp['price'];
                
                if($route['service_type'] == ''){
                    $begin = strtotime($route['begin'])/3600;
                    $end = strtotime($route['end'])/3600;
                    if($begin>$end){
                        $hour_way = ($end-$begin)+24;
                    }elseif($end>$begin){
                        $hour_way = $end-$begin;
                    }
                    $list_routes_by_wish[$key]['partnerDataRoute']['hours'] = $hour_way;
                    $list_routes_by_wish[$key]['partnerDataRoute']['add_hours'] = $route['add_hours'];
                    
                    $hour_way += $route['add_hours'];
                    $list_routes_by_wish[$key]['partnerDataRoute']['full_summ'] = round($hour_way*$temp['price']);
                }else{
                    $list_routes_by_wish[$key]['partnerDataRoute']['full_summ'] = $temp['price'];
                }
                if($car_id == $temp['car_id']){
                    $list_routes_by_wish[$key]['partnerDataRoute']['setted'] = 'yes';
                }
            }  
        }
        foreach ($list_routes_by_wish as $key => $temp){
            $type_check = (strstr($getInfoAboutSettedCar['type'],$temp['type_ts'])!=false)?'y':'n';
            $mark_check = (strstr($getInfoAboutSettedCar['mark'],$temp['marka_ts'])!=false)?'y':'n';
            $model_check = (strstr($getInfoAboutSettedCar['model'],$temp['model_ts'])!=false)?'y':'n';
            if((($type_check == 'y')&&($mark_check == 'y')&&($model_check == 'y'))||(($type_check == 'y')&&($mark_check == 'y')&&($model_check != 'y'))){
                $data[] = $temp;
            }
        }
        return $data;
    }

    public function countTicketByClientId($user_id){
        $sql = ("SELECT count(id) as count_t FROM srm_procat_ticketProcat WHERE user_id = '{$user_id}'");
        $result = $this->inDB->query($sql);
        $trash = $this->inDB->fetch_assoc($result);
        return $trash['count_t'];
    }

    public function addPartnerRoutePaymentInfo($arr,$id_route,$car_id,$type_route){
        $sql_check = ("SELECT id FROM srm_procat_ticketPartnerRoutePayment WHERE id_route = '{$id_route}' and type_route = '{$type_route}'");
        $result_check = $this->inDB->query($sql_check);
        if(!$this->inDB->num_rows($result_check)){
            $set = implode(', ',prepareSQL($arr));
            $sql = ("INSERT INTO srm_procat_ticketPartnerRoutePayment SET {$set}");
            $result = $this->inDB->query($sql);
        }else{
            $set = implode(', ',prepareSQL($arr));
            $sql = ("UPDATE srm_procat_ticketPartnerRoutePayment SET {$set} WHERE id_route = '{$id_route}' and car_id = '{$car_id}' and type_route = '{$type_route}'");
            $result = $this->inDB->query($sql);
        }
        
    }

    public function deletePartnerRoutePaymentInfo($id_route,$car_id){
        $sql = ("DELETE FROM srm_procat_ticketPartnerRoutePayment WHERE id_route = '{$id_route}' and car_id = '{$car_id}'");
        $result = $this->inDB->query($sql);
    }

    public function deletePartnerRoutePaymentInfoByCarID($car_id,$arr_id_routes){

        $sql = ("DELETE FROM srm_procat_ticketPartnerRoutePayment WHERE car_id = '{$car_id}'");
        if($arr_id_routes!=''){
            $sql .= " and (id_route = '{$arr_id_routes[0]}'";
            for($i=1;$i<count($arr_id_routes);$i++){
                $sql.= " OR id_route = '{$arr_id_routes[$i]}'";
            }
            $sql .= ") ";
        }
        $result = $this->inDB->query($sql);
        
    }

    public function getDataWorkPartnerByCarId($id_car,$id_wish){
        $sql = ("SELECT srm_procat_routeList_confirmed.begin,srm_procat_routeList_confirmed.end,srm_procat_routeList_confirmed.data FROM srm_procat_ticketPartnerRoutePayment INNER JOIN srm_procat_routeList_confirmed ON srm_procat_ticketPartnerRoutePayment.id_route = srm_procat_routeList_confirmed.id WHERE srm_procat_ticketPartnerRoutePayment.car_id = '{$id_car}' and srm_procat_routeList_confirmed.id_wishcar = '{$id_wish}' ORDER BY srm_procat_routeList_confirmed.data ASC");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['begin'] = date('H:i',strtotime($trash['begin']));
            $trash['end'] = date('H:i',strtotime($trash['end']));
            $trash['data'] = date('d.m.Y',strtotime($trash['data']));
            $line = "<strong>".$trash['data']."</strong> ".$trash['begin']."-".$trash['end'];
            $data[] = $line;
        }

        return array_unique($data);
    }

    public function getDataAboutPricesOfPartner($id_car,$id_wish){
        $sql = ("SELECT srm_procat_ticketPartnerRoutePayment.price as price,
                        srm_procat_routeList_confirmed.begin,
                        srm_procat_routeList_confirmed.end,
                        srm_procat_routeList_confirmed.transfer_confirmed,
                        srm_procat_routeList_confirmed.service_type,
                        srm_procat_routeList_confirmed.add_hours FROM srm_procat_ticketPartnerRoutePayment INNER JOIN srm_procat_routeList_confirmed ON srm_procat_ticketPartnerRoutePayment.id_route = srm_procat_routeList_confirmed.id WHERE srm_procat_ticketPartnerRoutePayment.car_id = '{$id_car}' and srm_procat_routeList_confirmed.id_wishcar = '{$id_wish}' ORDER BY srm_procat_routeList_confirmed.data ASC");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            if($trash['service_type'] == ''){
                $begin = strtotime($trash['begin'])/3600;
                $end = strtotime($trash['end'])/3600;
                if($begin>$end){
                    $hour_way = ($end-$begin)+24;
                }elseif($end>$begin){
                    $hour_way = $end-$begin;
                }                
                $hour_way += $trash['add_hours'];
                $trash['full_summ'] = round($hour_way*$trash['price']);
            }else{
                $trash['full_summ'] = $trash['price'];
            }
            $ar_price[] = $trash['price'];
            $ar_fullPrice[] = $trash['full_summ'];
        }
        $data['linePriceSettedTS'] = implode(', ',array_unique($ar_price));
        $data['fullPriceSettedTS'] = array_sum($ar_fullPrice);
        return $data;
    }

    public function addExpensesOrHangOver($arr){
        $set = implode(', ', prepareSQL($arr));
        $sql = ("INSERT INTO srm_procat_expenses SET {$set}");
        $result = $this->inDB->query($sql);
    }

    public function getExpenses(){
        $sql = ("SELECT * FROM srm_procat_expenses WHERE type = 'expenses'");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['data_expense'] = date('d.m.Y',strtotime($trash['date']));
            $data[] = $trash;
        }
        return $data;
    }

    public function getExpensesByDay($day){
        $day = date('Y-m-d',strtotime($day));
        $sql = ("SELECT * FROM srm_procat_expenses WHERE srm_procat_expenses.date = '{$day}' and type = 'expenses'");
        $result = $this->inDB->query($sql);
        while ($trash = $this->inDB->fetch_assoc($result)){
            $trash['date'] = date('d.m.Y',strtotime($trash['date']));
            $data[] = $trash;
        }
        return $data;
    }

    public function getHangoversByDay($day){
        $day = date('Y-m-d',strtotime($day));
        $sql = ("SELECT * FROM srm_procat_expenses WHERE srm_procat_expenses.date = '{$day}' and type = 'hangover'");
        $result = $this->inDB->query($sql);
        while ($trash = $this->inDB->fetch_assoc($result)){
            $trash['date'] = date('d.m.Y',strtotime($trash['date']));
            $data[] = $trash;
        }
        return $data;
    }

    public function getExpensesByDayNType($day,$type){
        switch ($type) {
            case 'nal':
                $type = 'Наличные';
                break;
            case 'cart':
                $type = 'Карта';
                break;
            case 'without_nal':
                $type = 'Безналичный';
                break;
        }
        $day = date('Y-m-d',strtotime($day));
        $sql = ("SELECT * FROM srm_procat_expenses WHERE srm_procat_expenses.date = '{$day}' and source_money = '{$type}' and type ='expenses'");
        $result = $this->inDB->query($sql);
        while ($trash = $this->inDB->fetch_assoc($result)){
            $trash['date'] = date('d.m.Y',strtotime($trash['date']));
            $data[] = $trash;
        }
        return $data;
    }

    public function getHangOversByDayNType($day,$type){
        switch ($type) {
            case 'nal':
                $type = 'Наличные';
                break;
            case 'cart':
                $type = 'Карта';
                break;
        }
        $day = date('Y-m-d',strtotime($day));
        $sql = ("SELECT * FROM srm_procat_expenses WHERE srm_procat_expenses.date = '{$day}' and source_hangover = '{$type}' and type ='hangover'");
        $result = $this->inDB->query($sql);
        while ($trash = $this->inDB->fetch_assoc($result)){
            $trash['date'] = date('d.m.Y',strtotime($trash['date']));
            $data[] = $trash;
        }
        return $data;
    }

    public function getExpenseById($id){
        $sql = ("SELECT * FROM srm_procat_expenses WHERE id = '{$id}' and type = 'expenses'");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['date'] = date('d.m.Y',strtotime($trash['date']));
            $data = $trash;
        }
        return $data;
    }

    public function getHangoverById($id){
        $sql = ("SELECT * FROM srm_procat_expenses WHERE id = '{$id}' and type = 'hangover'");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['date'] = date('d.m.Y',strtotime($trash['date']));
            $data = $trash;
        }
        return $data;
    }

    public function deleteExpenseOrHangOver($id){
        $sql = ("DELETE FROM srm_procat_expenses WHERE id = '{$id}'");
        $result = $this->inDB->query($sql);
    }

    public function editExpesesOrHangOver($arr,$id){
        $sql = ("UPDATE srm_procat_expenses SET type = '{$arr['type']}',
                                                name = '{$arr['name']}',
                                                summ = '{$arr['summ']}',
                                                srm_procat_expenses.date = '{$arr['date']}',
                                                source_money = '{$arr['source_money']}',
                                                comment = '{$arr['comment']}',
                                                city = '{$arr['city']}'
                                            WHERE id = '{$id}'");
        $result = $this->inDB->query($sql);
        
    }

    public function changeManagerForTicket($manager_id,$ticket_id){
        $sql = ("UPDATE srm_procat_ticketProcat SET id_control = '{$manager_id}' WHERE id = '{$ticket_id}'");
        $this->inDB->query($sql);
    }

    public function getListControllers(){
        $sql = ("SELECT id,nickname FROM srm_users WHERE group_id = '7' and is_deleted = '0' and is_locked = '0' ORDER BY nickname ASC");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $data[] = $trash;
        }
        return $data;
    }

    public function getHangovers(){
        $sql = ("SELECT * FROM srm_procat_expenses WHERE type = 'hangover'");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['data_hangover'] = date('d.m.Y',strtotime($trash['date']));
            $trash['source_hangover'] = $trash['source_money'];
            unset($trash['source_money']);
            $data[] = $trash;
        }
        return $data;
    }

    public function getListIdOfRouteByWishCarId($wish_id){
        $sql = ("SELECT id FROM srm_procat_routeList_confirmed WHERE id_wishcar = '{$wish_id}'");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $data[] = $trash['id'];
        }
        return $data;
    }

    public function getReportMotivation($begin='',$end=''){
        if(($begin!='')&&($end!='')){
            $cur_year_begin = date('Y',strtotime($begin));
            $cur_month_begin = date('m',strtotime($begin));
            $cur_year_end = date('Y',strtotime($end));
            $cur_month_end = date('m',strtotime($end));
            $last_day_month = date('t',time());
            $current_month_begin = $cur_year_begin."-".$cur_month_begin."-01";
            $current_month_end = $cur_year_end."-".$cur_month_end."-".$last_day_month;
        }else{
            $cur_year = date('Y');
            $cur_month = date('m');
            $last_day_month = date('t',time());
            $current_month_begin = $cur_year."-".$cur_month."-01";
            $current_month_end = $cur_year."-".$cur_month."-".$last_day_month;
        }
        $sql = ("SELECT srm_procat_ticketProcat.id,
                     srm_procat_ticketProcat.id_control,
                     srm_procat_ticketProcat.ticket_city,
                     srm_procat_ticketProcat.time_add,
                     srm_procat_routeList_confirmed.data
                FROM srm_procat_ticketPaymentList INNER JOIN srm_procat_ticketProcat
                ON srm_procat_ticketPaymentList.ticket_id = srm_procat_ticketProcat.id 
                INNER JOIN srm_procat_carsWishForTicketProcat 
                ON srm_procat_carsWishForTicketProcat.ticket_id = srm_procat_ticketProcat.id 
                INNER JOIN srm_procat_routeList_confirmed 
                ON srm_procat_routeList_confirmed.id_wishcar = srm_procat_carsWishForTicketProcat.id 
                WHERE srm_procat_ticketPaymentList.is_delete !='1'
                 and payment_from = 'client'
                 and (srm_procat_ticketProcat.status_ticket = 'Документооборот' OR
                      srm_procat_ticketProcat.status_ticket = 'Ожидание' OR
                      srm_procat_ticketProcat.status_ticket = 'Подтверждено' OR
                      srm_procat_ticketProcat.status_ticket = 'Закрыта' OR
                      srm_procat_ticketProcat.status_ticket = 'Расчет')
            GROUP BY srm_procat_ticketPaymentList.ticket_id
            HAVING srm_procat_routeList_confirmed.data BETWEEN '{$current_month_begin}' and '{$current_month_end}'
            ORDER BY srm_procat_ticketProcat.id ASC");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
                $temp_ticket_info = $this->getTicketInfo($trash['id']);
                foreach($temp_ticket_info['car_list'] as $wc){
                    foreach($wc['car_setted'] as $sc){
                        $p_t_arr[] = $sc['endPriceSettedTS'];
                    }
                    $c_t_arr[] = $wc['confirmed']['final'];
                }

                $temp_finance_data = $this->getFinanceFullInfoByTicket($trash['id']);
                $trash['got_ak'] = ($temp_finance_data['gotten_ak']!='')?$temp_finance_data['gotten_ak']:'0';
                $t['partner_summ'] = array_sum($p_t_arr);
                $t['client_summ'] = array_sum($c_t_arr);
                $trash['ak_summ'] = $t['client_summ'] - $t['partner_summ'];
                $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
                $trash['data'] = date('d.m.Y',strtotime($trash['data']));
                $trash['manager_info'] = ($trash['id_control']!='0')?$this->getUserInfo($trash['id_control']):'';
                unset($p_t_arr);
                unset($c_t_arr);
                $data[] = $trash;
        }
        return $data;
    }

    public function getListServicesForTicket(){
        $sql = ("SELECT name FROM srm_procat_ticketServicesList");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $data[] = $trash['name'];
        }
        return $data;
    }


    public function getPartnerSetterCarInfo($id_car,$id_wish){
        cmsCore::loadModel('partner');
        $model_cars = new cms_model_partner();
        $car_info = $model_cars->show_car($id_car);
        $trash['type_ts'] = $car_info['type_vehicle'];
        $trash['mark'] = $car_info['mark'];
        $trash['model'] = $car_info['model']." ".$car_info['generation'];
        $trash['body_car'] = $car_info['body_car'];
        $trash['year'] = $car_info['year'];
        $trash['color'] = $car_info['color'];
        $trash['owner_id'] = $car_info['id_owner'];
        $trash['owner_info']= $this->getInfoOwner($trash['owner_id']);
        $trash['gos_nomer'] = implode(' ',array($car_info['f_nom_part'],$car_info['s_nom_part'],$car_info['th_nom_part'],$car_info['nom_region']));
        $sql = ("SELECT status FROM srm_procat_carsListArendaByWishCar WHERE id_car = '{$id_car}' and id_wishcar = '{$id_wish}'");
        $result = $this->inDB->query($sql);
        $tempo = $this->inDB->fetch_assoc($result);
        $trash['status'] = $tempo['status'];
        $data[] = $trash;
        return $data;
    }

    public function getRefusedTicketReport($begin='',$end='',$city=''){
        $sql = ("SELECT id,time_add,reason_cancel,ticket_city FROM srm_procat_ticketProcat WHERE status_ticket = 'Отказ'");
        if(($begin!='')&&($end!='')){
            $begin = date('Y-m-d',strtotime($begin));
            $end = date('Y-m-d',strtotime($end));
            $sql .= " and time_add BETWEEN '{$begin}' and '{$end}'";
        }
        if($city!=''){
            $sql .=" and ticket_city LIKE '{$city}'";
        }
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['time_add'] = date('d.m.Y H:i',strtotime($trash['time_add']));
            $data[] = $trash;
        }

        return $data;
    }

    public function getRentReportData($begin,$end){
        $arr_status = array('Закрыта','Документооборот','Расчет','Ожидание','Подтверждено');

        $data['ak_summ_spb'] = $this->getSummAKbyPeriod('Санкт-Петербург',$arr_status,'got',$begin,$end);
        $data['ak_summ_moscow'] = $this->getSummAKbyPeriod('Москва',$arr_status,'got',$begin,$end);
        $arr_status = array('Согласовано');
        $data['hold_spb'] = $this->getSummAKbyPeriod('Санкт-Петербург',$arr_status,'notgot',$begin,$end);
        $data['hold_moscow'] = $this->getSummAKbyPeriod('Москва',$arr_status,'notgot',$begin,$end);
        $data['expenses_spb'] = $this->getInfoAboutExpences('Санкт-Петербург',$begin,$end);
        $data['expenses_moscow'] = $this->getInfoAboutExpences('Москва',$begin,$end);
        $data['profit_spb'] = $data['ak_summ_spb']-$data['expenses_spb'];
        $data['profit_moscow'] = $data['ak_summ_moscow']-$data['expenses_moscow'];

        return $data;
    }

    public function getSummAKbyPeriod($city,$arr_stat,$type,$begin,$end){
        $sql = ("SELECT id FROM srm_procat_ticketProcat WHERE id!='0' and ticket_city LIKE '%{$city}%'");
        if($arr_stat!=''){
            $first = $arr_stat[0];
            array_shift($arr_stat);
            if(count($arr_stat)>1){
                $text = " and (status_ticket = '{$first}' or status_ticket = '";
                $text .= implode("' or status_ticket = '",$arr_stat);
                $text .= "')";
            }else{
                $text = " and status_ticket = '{$first}'";
            }
            $sql.= $text;
        }else{
            $sql.= "and (status_ticket = 'Закрыта' or status_ticket = 'Документооборот' or status_ticket = 'Расчет' or status_ticket = 'Ожидание')";
        }
        if(($begin != '')&&($end != '')){
            $begin = date('Y-m-d H:i',strtotime($begin));
            $end = date('Y-m-d H:i',strtotime($end)+86300);
            $sql.= " and time_add BETWEEN '{$begin}' and '{$end}'";
        }
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $cash_array = $this->getFinanceFullInfoByTicket($trash['id']);
            if($type == 'got'){
                $ak_summ[] = $cash_array['gotten_ak'];
            }elseif($type == 'notgot'){
                $ak_summ[] = $cash_array['ak_summ'];
            }
            unset($cash_array);
        }
        return array_sum($ak_summ);
    }

    public function getInfoAboutExpences($city,$begin,$end){
        $sql = ("SELECT summ FROM srm_procat_expenses WHERE type = 'expenses' and city = '{$city}'");
        if(($begin != '')&&($end != '')){
            $begin = date('Y-m-d',strtotime($begin));
            $end = date('Y-m-d',strtotime($end));
            $sql.= " and date BETWEEN '{$begin}' and '{$end}'";
        }
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $summ_expenses[] = $trash['summ'];
        }

        return array_sum($summ_expenses);
    }

    public function getListEmailClient(){
        $sql = ("SELECT nick_client,type_client,contact_face,email FROM srm_procat_ticketProcat WHERE email <>'' GROUP BY email ORDER BY type_client DESC");
        $result = $this->inDB->query($sql);
        while($trash = $this->inDB->fetch_assoc($result)){
            $trash['type_client'] = ($trash['type_client'] == 'ur')?'Юр. лицо':'Физ. лицо';
            $data[] = $trash;
        }

        return $data;
    }

    public function deleteWishCar($wishcar){
        $sql = ("DELETE FROM srm_procat_carsWishForTicketProcat WHERE id = '{$wishcar}'");
        $result = $this->inDB->query($sql);
        //
    }

    public function getTicketDataForUrik($ticket_id){
        $data = $this->getTicketInfo($ticket_id);
        unset($data['last_client_callback']);
        unset($data['came_from']);
        unset($data['reason_cancel']);
        unset($data['rate_closed_task']);
        unset($data['type_client']);
        foreach ($data['car_list'] as $key => $car) {
            unset($data['car_list'][$key]['id']);
            unset($data['car_list'][$key]['type_ts']);
            unset($data['car_list'][$key]['mark_ts']);
            unset($data['car_list'][$key]['model_ts']);
            unset($data['car_list'][$key]['color_ts']);
            unset($data['car_list'][$key]['ticket_id']);
            unset($data['car_list'][$key]['confirmed_short']);
            unset($data['car_list'][$key]['confirmed']['id']);
            unset($data['car_list'][$key]['confirmed']['id_wishcar']);
            unset($data['car_list'][$key]['confirmed']['partner_id']);
            unset($data['car_list'][$key]['confirmed']['transfer_confirmed']);
            foreach ($car['car_setted'] as $key => $setted) {
                $temp_setted['gos_nomer'][] = $setted['gosnomer'];
                $temp_setted['name_dr'][] = $setted['name_dr'];
                $temp_setted['phone_dr'][] = $setted['phone_dr'];
            }
            $data['car_list'][$key]['confirmed']['driver_name'] = implode(' | ',$temp_setted['name_dr']);
            $data['car_list'][$key]['confirmed']['gos_nomer'] = implode(' | ',$temp_setted['gos_nomer']);
            $data['car_list'][$key]['confirmed']['phone_dr'] = implode(' | ',$temp_setted['phone_dr']);
            unset($temp_setted);
            unset($data['car_list'][$key]['car_setted']);
        }

        return $data;
    }

  }