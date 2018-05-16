<?php

	cmsCore::loadModel('clientAccount');
	$model = new cms_model_clientAccount();
	$email_client_list = $model->getListEmailClient();

	$path = PATH.'/components/exchange/includes/PHPExcel/Classes/PHPExcel.php';
	require_once $path;
	$row = 0;//номер строки
	$excel = new PHPExcel();//создаем объект библиотеки
	//делаем активной главный лист
	$page = $excel->setActiveSheetIndex(0);

	$page->getColumnDimension('A')->setWidth(5);
	$page->getColumnDimension('B')->setWidth(25);
	$page->getColumnDimension('C')->setWidth(25);
	$page->getColumnDimension('D')->setWidth(20);

	$name_cell = array('A','B','C','D');

	foreach($name_cell as $value){
	    $page->getStyle($value.'1')->getBorders()->getLeft()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	    $page->getStyle($value.'1')->getBorders()->getRight()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	    $page->getStyle($value.'1')->getBorders()->getTop()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	    $page->getStyle($value.'1')->getBorders()->getBottom()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	    $page->getStyle($value.'1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
	}

	$page->setCellValue("A1","Наименования заказчика");
    $page->setCellValue("B1","Контактное лицо");
    $page->setCellValue("C1","E-mail");
    $page->setCellValue("D1","Тип");

    $row = 2;
    $i = 1;//счетчик
    foreach ($email_client_list as $data){
        $page->setCellValue("A".$row,$data['nick_client']);
        $page->setCellValue("B".$row,$data['contact_face']);
        $page->setCellValue("C".$row,$data['email']);
        $page->setCellValue("D".$row,$data['type_client']);
        
        //центрую поля  
	    foreach($name_cell as $value){
	        $page->getStyle($value.$row)->getBorders()->getLeft()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	        $page->getStyle($value.$row)->getBorders()->getRight()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	        //$page->getStyle($value.$row)->getBorders()->getTop()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	        $page->getStyle($value.$row)->getBorders()->getBottom()->applyFromArray(array('style' =>PHPExcel_Style_Border::BORDER_THIN,'color' => array('rgb' => '000000')));
	        $page->getStyle($value.$row)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
	    }
    
        $row++;
        $i++;
    }

    $page->setTitle('Выгрузка E-mail');
        
    $file_name = "list_email.xlsx";
    $writer_excel = PHPExcel_IOFactory::createWriter($excel,'Excel2007');
    $writer_excel->save($file_name);

    ob_end_clean();
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="'.$file_name.'"');
    header('Content-Disposition: attachment; filename="'.$file_name.'"');
    readfile($file_name);
    exit;