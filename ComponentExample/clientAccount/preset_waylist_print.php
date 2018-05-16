<?php
define('__CORE__',$_SERVER['DOCUMENT_ROOT']);
	$inCore = cmsCore::getInstance();
	$inCore->loadModel('clientAccount');
	$inCore->loadModel('partner');

/*	ini_set('display_errors', 1);
	ini_set('error_reporting', E_ALL);*/

	$model_ca = new cms_model_clientAccount();
	$model_p = new cms_model_partner();

	$ticket_id = cmsCore::request('ticket_id','int',0);
	$formpayment = cmsCore::request('formpayment','str','');
	$nom_dogovor = cmsCore::request('nd','str','');
	$data_dogovor = cmsCore::request('dd','str','');
	$document_for = cmsCore::request('dfor','str','');
	$partner_id = cmsCore::request('partnerid','str','');
	$req_partner_id = cmsCore::request('p_req_id','str','');

	function dateRus($date) {
	    $_date = explode(".", $date);
	    $day = $_date[0];
	    $year = $_date[2];
	    $months = array(
	        "января",
	        "февраля",
	        "марта",
	        "апреля",
	        "мая",
	        "июня",
	        "июля",
	        "августа",
	        "сентября",
	        "октября",
	        "ноября",
	        "декабря"
	    );
	    $month = $months[$_date[1]-1];
	    return "$day $month $year";
	}

	function num2str($inn, $stripkop=false) {
	    $nol = 'ноль';
	    $str[100]= array('','сто','двести','триста','четыреста','пятьсот','шестьсот', 'семьсот', 'восемьсот','девятьсот');
	    $str[11] = array('','десять','одиннадцать','двенадцать','тринадцать', 'четырнадцать','пятнадцать','шестнадцать','семнадцать', 'восемнадцать','девятнадцать','двадцать');
	    $str[10] = array('','десять','двадцать','тридцать','сорок','пятьдесят', 'шестьдесят','семьдесят','восемьдесят','девяносто');
	    $sex = array(
	        array('','один','два','три','четыре','пять','шесть','семь', 'восемь','девять'),// m
	        array('','одна','две','три','четыре','пять','шесть','семь', 'восемь','девять') // f
	    );
	    $forms = array(
	        array('копейка', 'копейки', 'копеек', 1), // 10^-2
	        array('рубль', 'рубля', 'рублей',  0), // 10^ 0
	        array('тысяча', 'тысячи', 'тысяч', 1), // 10^ 3
	        array('миллион', 'миллиона', 'миллионов',  0), // 10^ 6
	        array('миллиард', 'миллиарда', 'миллиардов',  0), // 10^ 9
	        array('триллион', 'триллиона', 'триллионов',  0), // 10^12
	    );
	    $out = $tmp = array();
	    // Поехали!
	    $tmp = explode('.', str_replace(',','.', $inn));
	    $rub = number_format($tmp[ 0], 0,'','-');
	    if ($rub== 0) $out[] = $nol;
	    // нормализация копеек
	    $kop = isset($tmp[1]) ? substr(str_pad($tmp[1], 2, '0', STR_PAD_RIGHT), 0,2) : '00';
	    $segments = explode('-', $rub);
	    $offset = sizeof($segments);
	    if ((int)$rub== 0) { // если 0 рублей
	        $o[] = $nol;
	        $o[] = morph( 0, $forms[1][ 0],$forms[1][1],$forms[1][2]);
	    }
	    else {
	        foreach ($segments as $k=>$lev) {
	            $sexi= (int) $forms[$offset][3]; // определяем род
	            $ri = (int) $lev; // текущий сегмент
	            if ($ri== 0 && $offset>1) {// если сегмент==0 & не последний уровень(там Units)
	                $offset--;
	                continue;
	            }
	            // нормализация
	            $ri = str_pad($ri, 3, '0', STR_PAD_LEFT);
	            // получаем циферки для анализа
	            $r1 = (int)substr($ri, 0,1); //первая цифра
	            $r2 = (int)substr($ri,1,1); //вторая
	            $r3 = (int)substr($ri,2,1); //третья
	            $r22= (int)$r2.$r3; //вторая и третья
	            // разгребаем порядки
	            if ($ri>99) $o[] = $str[100][$r1]; // Сотни
	            if ($r22>20) {// >20
	                $o[] = $str[10][$r2];
	                $o[] = $sex[ $sexi ][$r3];
	            }
	            else { // <=20
	                if ($r22>9) $o[] = $str[11][$r22-9]; // 10-20
	                elseif($r22> 0) $o[] = $sex[ $sexi ][$r3]; // 1-9
	            }
	            // Рубли
	            $o[] = morph($ri, $forms[$offset][ 0],$forms[$offset][1],$forms[$offset][2]);
	            $offset--;
	        }
	    }
	    // Копейки
	    if (!$stripkop) {
	        $o[] = $kop;
	        $o[] = morph($kop,$forms[ 0][ 0],$forms[ 0][1],$forms[ 0][2]);
	    }
	    return preg_replace("/\s{2,}/",' ',implode(' ',$o));
	}

	function morph($n, $f1, $f2, $f5) {
	    $n = abs($n) % 100;
	    $n1= $n % 10;
	    if ($n>10 && $n<20) return $f5;
	    if ($n1>1 && $n1<5) return $f2;
	    if ($n1==1) return $f1;
	    return $f5;
	}



	if($ticket_id != 0){
		$data = $model_ca->getTicketInfo($ticket_id);
		$get_confirmed_waylist = $model_ca->getConfirmedListByTicketId($ticket_id);
		//print_arr(array($get_confirmed_waylist, $formpayment));
		if($data['type_client'] != 'ur'){
			$requesit_comp = array('gen_dir_comp'=>'somedatahere',
                                          'name_company'=>'somedatahere',
                                          'address_comp'=>'somedatahere',
                                          'inn'=>'somedatahere',
                                          'kpp'=>'somedatahere',
                                          'ogrn'=>'somedatahere',
                                          'r_s'=>'somedatahere',
                                          'k_s'=>'somedatahere',
                                          'bik'=>'somedatahere',
                                          'name_bank'=>'somedatahere',
                                          'nds_line'=>'somedatahere',
                                          'short'=>'somedatahere');
		}else{
			$requesit_comp = array('gen_dir_comp'=>'somedatahere',
                                          'name_company'=>'somedatahere',
                                          'address_comp'=>'somedatahere',
                                          'inn'=>'somedatahere',
                                          'kpp'=>'somedatahere',
                                          'ogrn'=>'somedatahere',
                                          'r_s'=>'somedatahere',
                                          'k_s'=>'somedatahere',
                                          'bik'=>'somedatahere',
                                          'name_bank'=>'somedatahere',
                                          'nds_line'=>'somedatahere',
                                          'short'=>'somedatahere');
		}

		if($data['type_client'] == 'ur'){
			$requisites = $model_ca->getRequisitesToEdit($data['user_id']);
			$temp = explode(" ",$requisites['podpisant']);
			$temp[1] = substr($temp[1],0,2).".";
			$temp[2] = substr($temp[2],0,2).". ";
			$requisites['podpisant'] = implode(" ",$temp);
			$requisites['short'] = $requisites['podpisant'];
			$name_doc = "ticket_preset_ur";
			$name_document = "Заявка";
		}else{
			$requisites = $model_ca->getFizFaceRequisites($ticket_id);
			$requisites['phone'] = $data['tel'];
			$requisites['passport'] = $requisites['nomer_passport']." ".$requisites['seria_passport'];
			$temp = explode(" ", $requisites['fio']);
			$temp[1] = substr($temp[1],0,2).".";
			$temp[2] = substr($temp[2],0,2).". ";
			$requisites['short_fio'] = implode(" ",$temp);
			$name_doc = "ticket_preset";
			$name_document = "Заявка";
		}


		if(($partner_id != "")&&($partner_id != 0)){
			$partner_requisites = $model_p->getUrRequisitesByIdReq($req_partner_id);
			$num_doc_partner = $model_p->getNumberDogovorOfPartner($req_partner_id,$partner_id);
			$num_dogovor_p = $num_doc_partner['num_dog'];
			$data_dogovor_p = $num_doc_partner['data_dog'];
			$temp = explode(" ", $partner_requisites['podpisant']);
			$temp[1] = substr($temp[1],0,2).".";
			$temp[2] = substr($temp[2],0,2).".";
			$partner_requisites['short_fio'] = implode(" ",$temp);
			$list_car = $model_p->getListIDCarOfPartner($partner_id);
			$get_confirmed_waylist = $model_ca->getConfirmedListByTicketIdNPartnerId($ticket_id,$list_car);
			//print_arr($get_confirmed_waylist);
			if($partner_requisites!=''){
				$name_doc = "ticket_partner";
				$name_document = "Заявка";
				if(($partner_requisites['type_ur'] == 'ООО')&&($data['type_client'] == 'ur')){
					$requesit_comp['nds_line'] = "НДС не облагается";
				}

				switch ($partner_requisites['typeOrg']) {
					case 'ИП':
						$partner_requisites['face_of_ur_imin_pod'] = "Индивидуальный предприниматель";
						break;
				}
			}else{
				$partner_temp = $model_p->takePartnerInfo('proprietor',$partner_id);
				$partner_info = $partner_temp[0];
				$partner_requisites = array('fio'=>$partner_info['surname']." ".$partner_info['first_name']." ".$partner_info['sec_name'],
											'passport'=>$partner_info['seria_passport']." ".$partner_info['nomer_passport'],
											'who_give'=>$partner_info['who_give'],
											'date_passport'=>$partner_info['data_of_give'],
											'location_reg'=>substr(implode(', ',$partner_info['propiska']),1),
											'phone'=>$partner_info['tel_1'],
											'short_fio'=>$partner_info['surname']." ".substr($partner_info['first_name'],0,2).". ".substr($partner_info['sec_name'],0,2).". ");
				$name_doc = "ticket_partner_fiz";
				$name_document = "Заявка";
			}

				if(($num_doc_partner == '')||($num_doc_partner['forwhom'] == 'Хорека')){
					$requesit_comp = array('gen_dir_comp'=>'somedatahere',
                                          'name_company'=>'somedatahere',
                                          'address_comp'=>'somedatahere',
                                          'inn'=>'somedatahere',
                                          'kpp'=>'somedatahere',
                                          'ogrn'=>'somedatahere',
                                          'r_s'=>'somedatahere',
                                          'k_s'=>'somedatahere',
                                          'bik'=>'somedatahere',
                                          'name_bank'=>'somedatahere',
                                          'nds_line'=>'somedatahere',
                                          'short'=>'somedatahere');
				}else{
					$requesit_comp = array('gen_dir_comp'=>'somedatahere',
                                          'name_company'=>'somedatahere',
                                          'address_comp'=>'somedatahere',
                                          'inn'=>'somedatahere',
                                          'kpp'=>'somedatahere',
                                          'ogrn'=>'somedatahere',
                                          'r_s'=>'somedatahere',
                                          'k_s'=>'somedatahere',
                                          'bik'=>'somedatahere',
                                          'name_bank'=>'somedatahere',
                                          'nds_line'=>'somedatahere',
                                          'short'=>'somedatahere');
				}
		}
		if($data['type_client'] == 'ur'){
			$temp_doc_info = $model_ca->checkExistNumberDog($data['user_id'],$data['type_client']);
		}else{
			$cut_phone = str_replace(array('(',')','-',' '), "", $data['tel']);
			$temp_doc_info = $model_ca->checkExistNumberDog($cut_phone,$data['type_client']);
		}

		if($temp_doc_info == 'n'){
			$last_nom = $model_ca->getLastNumberDog($data['type_client']);
			//print_arr($last_nom);
			if($last_nom == ""){
				$last_nom = 1;
			}else{
				$last_nom ++;
			}
			$num_dogovor = ($data['type_client'] == 'ur')?date('Y')."-".$last_nom."-Ю":date('Y')."-".$last_nom."-Ф";
			if($data['type_client'] == 'ur'){
				$client_id_dog = $data['user_id'];
			}else{
				$client_id_dog = str_replace(array('(',')','-',' '), "", $data['tel']);
			}
			$arr_dog_data = array('type_client'=>$data['type_client'],
								  'num_dogovor'=>$num_dogovor,
								  'data_dogovor'=>date('Y-m-d'),
								  'client_id'=>$client_id_dog
								);
			//print_arr($arr_dog_data);
			$model_ca->addNumberDogovorClient($arr_dog_data);
			$data_dogovor = dateRus(date('d.m.Y'));
			$num_dogovor = $num_dogovor;
		}else{
			$data_dogovor = dateRus($temp_doc_info['data_dogovor']);
			$num_dogovor = $temp_doc_info['num_dogovor'];
		}

		$data_print = date('d.m.Y');
		$counter_routes = count($get_confirmed_waylist);
		$prilojenie = ($data['type_client'] == 'ur')?"Приложение №1":"";

		//print_arr($get_confirmed_waylist);

		include_once __CORE__."/PHPWord/bootstrap.php";
		\PhpOffice\PhpWord\Settings::setTempDir(__CORE__."/tmp");

		$PHPWord = new \PhpOffice\PhpWord\PhpWord();
		$document = new \PhpOffice\PhpWord\TemplateProcessor("tdocuments/".$name_doc.".docx");
		$document->setValue('nd',$num_dogovor);
		$document->setValue('dd',$data_dogovor);
		$document->setValue('nd_p',$num_dogovor_p);
		$document->setValue('dd_p',$data_dogovor_p);
		$document->setValue('today',$data_print);

		//данные по заказчику
		$document->setValue('inn_client',$requisites['inn']);
		$document->setValue('name_client',$requisites['name_ur']);
		$document->setValue('kpp_client',$requisites['kpp']);
		$document->setValue('ogrn_client',$requisites['ogrn']);
		$document->setValue('ur_address_client',$requisites['ur_address']);
		//$document->setValue('fac_address_client',$requisites['address_client']);
		$document->setValue('rs_client',$requisites['rk_ur']);
		$document->setValue('name_bank_client',$requisites['name_bank']);
		$document->setValue('bik_client',$requisites['bik']);
		$document->setValue('ks_client',$requisites['ks_ur']);
		$document->setValue('gen_dir_client',$requisites['gen_dir_name']);
		$document->setValue('gen_dir_short_client',$requisites['short']);
		$document->setValue('type_ur_client',$requisites['type_ur']);
		$document->setValue('face_client_imp',$requisites['face_comp_imp']);
		//реквизиты физика
		$document->setValue('fio',$requisites['fio']);
		$document->setValue('passport',$requisites['passport']);
		$document->setValue('who_give',$requisites['who_give']);
		$document->setValue('date_passport',$requisites['data_get']);
		$document->setValue('location_reg',$requisites['location_reg']);
		$document->setValue('phone',$requisites['phone']);
		$document->setValue('short_fio',$requisites['short_fio']);

		//данные по партнеру
		$document->setValue('inn_partner',$partner_requisites['inn']);
		$document->setValue('name_partner',$partner_requisites['name_comp']);
		$document->setValue('kpp_partner',$partner_requisites['kpp']);
		$document->setValue('ogrn_partner',$partner_requisites['ogrn']);
		$document->setValue('ur_address_partner',$partner_requisites['ur_address_partner']);
		//$document->setValue('fac_address_partner',$partner_requisites['address_partner']);
		$document->setValue('rs_partner',$partner_requisites['r_s']);
		$document->setValue('name_bank_partner',$partner_requisites['name_bank']);
		$document->setValue('bik_partner',$partner_requisites['bik']);
		$document->setValue('ks_partner',$partner_requisites['k_s']);
		$document->setValue('gen_dir_partner',$partner_requisites['short_fio']);
		$document->setValue('face_partner',$partner_requisites['typeOrg']);
		$document->setValue('face_ur_imin_pod',$partner_requisites['face_of_ur_imin_pod']);
		//$document->setValue('gen_dir_short_partner',$partner_requisites['short']);
		//данные по партнеру физику
		$document->setValue('fio_partner',$partner_requisites['fio']);
		$document->setValue('passport_partner',$partner_requisites['passport']);
		$document->setValue('who_give_partner',$partner_requisites['who_give']);
		$document->setValue('date_passport_partner',$partner_requisites['data_get']);
		$document->setValue('location_reg_partner',$partner_requisites['location_reg']);
		$document->setValue('phone_partner',$partner_requisites['phone']);
		$document->setValue('short_fio_partner',$partner_requisites['short_fio']);

		//данные по исполнителю
		$document->setValue('inn_comp',$requesit_comp['inn']);
		$document->setValue('name_comp',$requesit_comp['name_company']);
		$document->setValue('kpp_comp',$requesit_comp['kpp']);
		$document->setValue('ogrn_comp',$requesit_comp['ogrn']);
		$document->setValue('ur_address_comp',$requesit_comp['address_comp']);
		$document->setValue('fac_address_comp',$requesit_comp['address_comp']);
		$document->setValue('rs_comp',$requesit_comp['r_s']);
		$document->setValue('name_bank_comp',$requesit_comp['name_bank']);
		$document->setValue('bik_comp',$requesit_comp['bik']);
		$document->setValue('ks_comp',$requesit_comp['k_s']);
		$document->setValue('gen_dir_comp',$requesit_comp['gen_dir_comp']);
		$document->setValue('gen_dir_short_comp',$requesit_comp['short']);
		$document->setValue('nds_line',$requesit_comp['nds_line']);
		$document->setValue('gen_dir_short_partner',$requesit_comp['short']);
		//данные по запланированному маршруту и расчет стоимости.
		$document->cloneRow('typeTS',$counter_routes);
		$finhours = 0;
		$finalprice = 0;

		foreach ($get_confirmed_waylist as $key => $waylist){
			$i = $key + 1;
			$finhours +=$waylist['hourswork'];
			$finalprice +=$waylist['final_price_per_car'];
			$document->setValue("counter#".$i,$i);
			$document->setValue("typeTS#".$i,(string)$waylist['type_ts']);
			$document->setValue("markmodelTS#".$i,(string)$waylist['marka_ts']." ".$waylist['model_ts']);
			$document->setValue("datawork#".$i,(string)$waylist['data']);
			$document->setValue("beginwork#".$i,(string)$waylist['begin']);
			$document->setValue("endwork#".$i,(string)$waylist['end']);
			$document->setValue("route#".$i,(string)$waylist['route_desc']);
			$document->setValue("addhours#".$i,(string)(($waylist['add_hours']!='')?$waylist['add_hours']:'-'));
			$document->setValue("allhours#".$i,(string)($waylist['hourswork'])?$waylist['hourswork']:'-');
			$document->setValue("priceforhour#".$i,(string)($waylist['price'])?$waylist['price'].".00":'-');
			$document->setValue("pricefin#".$i,(string)$waylist['final_price_per_car'].".00");
		}

		$document->setValue("counterfin",++$i);
		$document->setValue("finhours",($finhours!='0')?$finhours:'');
		$document->setValue("finalprice",$finalprice.".00");

		$document->setValue("plilojenie",$prilojenie);

		//print_arr($document);

		header_remove("");
		$name = "documents/".$name_document.".docx";
		$document->saveAs("$name");
		header("Location: /$name");

	}else{
		cmsCore::redirectBack();
	}