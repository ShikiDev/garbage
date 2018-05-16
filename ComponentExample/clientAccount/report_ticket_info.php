<?php
$inCore->loadModel('clientAccount');
$model_ca = new cms_model_clientAccount();

$fin_arr = $model_ca->getListTicketReport();
$fin_part = $model_ca->getFinListByTickets();
$fin_part_days = $model_ca->getFinReportByDays();
$report_by_tickets_spb = $model_ca->getReportByTicketsByTypeTSNStatus('','','Санкт-Петербург');
$report_by_tickets_moscow = $model_ca->getReportByTicketsByTypeTSNStatus('','','Москва');
$report_motivation = $model_ca->getReportMotivation();
$report_refuse_ticket = $model_ca->getRefusedTicketReport();
$report_rent = $model_ca->getRentReportData();
//print_arr($fin_arr);
$status_procat = $model_ca->getProcatStatuses();
array_unshift($status_procat, 'Новая заявка','Принята в работу');

$final = 0;
$final_days = 0;

foreach ($fin_arr as $k => $f) {
	//print_arr($f);
	if(strstr($f['client_hold'],'+')){
		$hold['client_plus_hold'] += (int)str_replace('+','',$f['client_hold']);
	}elseif(strstr($f['client_hold'],'-')){
		$hold['client_minus_hold'] += (int)str_replace('-','',$f['client_hold']);
	}

	if(strstr($f['partner_hold'],'+')){
		$hold['partner_plus_hold'] += (int)str_replace('+','',$f['partner_hold']);
	}elseif(strstr($f['partner_hold'],'-')){
		$hold['partner_minus_hold'] += (int)str_replace('-','',$f['partner_hold']);
	}
	$final_line['client_summ_fin'] += $f['client_summ'];
	$final_line['partner_summ_fin'] += $f['partner_summ'];
	$final_line['ak_summ_fin'] += $f['ak_summ'];
	$final_line['ak_fin'] += $f['ak'];
	$final_line['client_incoming_fin'] += $f['client_incoming'];
	$final_line['partner_incoming_fin'] += $f['partner_incoming'];
	$final_line['client_outcoming_fin'] += $f['client_outcoming'];
	$final_line['partner_outcoming_fin'] += $f['partner_outcoming'];
}

foreach($fin_part as $key => $fin){
	$final += $fin['dif'];
	$final_p_line['in_nal'] += $fin['incoming']['nal'];
	$final_p_line['in_cart'] += $fin['incoming']['cart'];
	$final_p_line['in_without_nal'] += $fin['incoming']['without_nal'];
	$final_p_line['in_final'] += $fin['incoming']['final'];
	$final_p_line['out_nal'] += $fin['outcoming']['nal'];
	$final_p_line['out_cart'] += $fin['outcoming']['cart'];
	$final_p_line['out_without_nal'] += $fin['outcoming']['without_nal'];
	$final_p_line['out_final'] += $fin['outcoming']['final'];
}

foreach($fin_part_days as $i => $fin){
	$temp_holder = $model_ca->getExpensesByDay($fin['day']);
	$temp_hangover = $model_ca->getHangoversByDay($fin['day']);
	//print_arr($temp_holder);
	foreach($temp_holder as $temp){
		switch ($temp['source_money']) {
	        case 'Наличные':
	            $pay = 'nal';
	            break;
	        case 'Карта':
	            $pay = 'cart';
	            break;
	        case 'Безналичный':
                $pay = 'without_nal';
                break;
	    }
		$fin_part_days[$i]['outcoming'][$pay] += $temp['summ'];
		$fin_part_days[$i]['outcoming']['final'] += $temp['summ'];
		$pay = '';
	}

	foreach ($temp_hangover as $key => $temp) {
		switch ($temp['source_money']) {
	        case 'Карта':
	            $pay = 'cart';
	            break;
	        default:
	        	$pay = '';
	        	break;
	    }
	    $fin_part_days[$i]['outcoming'][$pay] += $temp['summ'];
	    if($pay!= ''){
			$fin_part_days[$i]['outcoming']['final'] += $temp['summ'];
	    }
		$fin_part_days[$i]['hangover'] = $temp['summ'];
		$pay = '';
	}
}

foreach ($report_by_tickets_spb as $i => $types_val_spb) {
	$temp_arr_a = $types_val_spb;
	$trio_temp_a = 0;
	foreach($temp_arr_a as $statuses=>$values){
		if(($statuses == 'Документооборот')||($statuses == 'Ожидание')||($statuses == 'Подтверждено')||($statuses == 'Закрыта')||($statuses == 'Расчет')){
			$trio_temp_a +=$values;
		}
	}
	$sum_status_tickets_spb[$i]['summ'] = array_sum($temp_arr_a);
	$sum_status_tickets_spb[$i]['success'] = round(($trio_temp_a/array_sum($temp_arr_a))*100,2);
}

foreach ($report_by_tickets_moscow as $j => $types_val_moscow) {
	$temp_arr_b = $types_val_moscow;
	$trio_temp_b = 0;
	foreach($temp_arr_b as $statuses=>$values){
		if(($statuses == 'Документооборот')||($statuses == 'Ожидание')||($statuses == 'Подтверждено')||($statuses == 'Закрыта')||($statuses == 'Расчет')){
			$trio_temp_b +=$values;
		}
	}
	$sum_status_tickets_moscow[$j]['summ'] = array_sum($temp_arr_b);
	$sum_status_tickets_moscow[$j]['success'] = round(($trio_temp_b/array_sum($temp_arr_b))*100,2);
}


//print_arr($fin_arr);
//print_arr($fin_part);
//print_arr($report_by_tickets);
//print_arr($fin_part_days);

cmsPage::initTemplate('clientAccount_template', "report_ticket_info")->
assign('fin_arr',$fin_arr)->
assign('fin_part',$fin_part)->
assign('final_fin_rep',$final)->
assign('fin_part_days',$fin_part_days)->
assign('final_days',$final_days)->
assign('report_by_tickets_spb',$report_by_tickets_spb)->
assign('report_by_tickets_moscow',$report_by_tickets_moscow)->
assign('status_procat',$status_procat)->
assign('hold',$hold)->
assign('final_line',$final_line)->
assign('final_p_line',$final_p_line)->
assign('report_refuse_ticket',$report_refuse_ticket)->
assign('sum_status_tickets_spb',$sum_status_tickets_spb)->
assign('sum_status_tickets_moscow',$sum_status_tickets_moscow)->
assign('report_motivation',$report_motivation)->
assign('report_rent',$report_rent)->
display("report_ticket_info.tpl");