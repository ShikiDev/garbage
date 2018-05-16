<link href="/templates/callcenter/css/chosen.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/templates/callcenter/js/chosen.jquery.js"></script>
<div class="x_content">

	<div class="row">
		<div class="col-md-10 col-md-offset-1">
			<div class="x_panel">
				<h3>Отправление заявки</h3>
			</div>
		</div>
	</div>
	
	<form method="POST" onkeypress="if(event.keyCode == 13) return false;" id="formSendTicket">
		<div class="row">
			<div class="col-md-12 col-lg-7 col-lg-offset-1">
				<div class="x_panel">
					<div class="row">
						<div class="col-md-12">
							<div class="row">
								<div class="col-md-12">
									<h4>Условия аренды</h4>
									<input type="hidden" name="carsList" id="carsList" required>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-7">
									<div class="input-group">
										<span class="input-group-addon">Тип транспортного средства</span>
										<select id="type_ts">
											<option value=""></option>
											{foreach item=type key=key from=$type_ts}
											<option value="{$type}">{$type}</option>
											{/foreach}
										</select>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6" id="marka_ts">
									<div class="input-group">
										<span class="input-group-addon">Марка</span>
										<select id="marka_ts_sel">
											<option value="">Выберите Марку</option>
											{foreach item=mark key=key from=$marka_list}
											<option value="{$mark}">{$mark}</option>
											{/foreach}
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="marka_bus">
									<div class="input-group">
										<span class="input-group-addon">Марка</span>
										<select id="marka_bus_sel">
											<option value="">Выберите Марку</option>
											{foreach item=mark key=key from=$marka_list_bus}
											<option value="{$mark}">{$mark}</option>
											{/foreach}
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="marka_minivan">
									<div class="input-group">
										<span class="input-group-addon">Марка</span>
										<select id="marka_minivan_sel">
											<option value="">Выберите Марку</option>
											{foreach item=mark key=key from=$marka_list_minivan}
											<option value="{$mark}">{$mark}</option>
											{/foreach}
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="marka_autobus">
									<div class="input-group">
										<span class="input-group-addon">Марка</span>
										<select id="marka_autobus_sel">
											<option value="">Выберите Марку</option>
											{foreach item=mark key=key from=$marka_list_autobus}
											<option value="{$mark}">{$mark}</option>
											{/foreach}
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="marka_usual">
									<div class="input-group">
										<span class="input-group-addon">Марка</span>
										<input id="marka_usual_sel" type="text" value="">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6" id="model_ts">
									<div class="input-group">
										<span class="input-group-addon">Модель</span>
										<select id="model_ts_sel" onchange="getGeneration();">
											<option value=""></option>
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="model_bus">
									<div class="input-group">
										<span class="input-group-addon">Модель</span>
										<select id="model_bus_sel">
											<option value=""></option>
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="model_minivan">
									<div class="input-group">
										<span class="input-group-addon">Модель</span>
										<select id="model_minivan_sel">
											<option value=""></option>
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="model_autobus">
									<div class="input-group">
										<span class="input-group-addon">Модель</span>
										<select id="model_autobus_sel">
											<option value=""></option>
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-6" id="model_usual">
									<div class="input-group">
										<span class="input-group-addon">Модель</span>
										<input id="model_usual_sel" type="text" value="">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6" id="gen_ts">
									<div class="input-group">
										<span class="input-group-addon">Модификация</span>
										<select id="gen_ts_sel">
											<option value="" selected></option>
										</select>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Цвет ТС</span>
										<input type="text" id="ts_color">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Кол-во мест</span>
										<input type="text" id="count_places">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-7">
									<div class="input-group">
										<span class="input-group-addon">Возможность предоставление аналога</span>
		                                <select class="form-control" id="analog">
		                                	<option value=""></option>
		                                	<option value="y">Да</option>
		                                	<option value="n">Нет</option>
		                                </select>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Период использования с</span>
										<input type="text" class="picker_usial" id="begin">
									</div>
								</div>
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">До</span>
										<input type="text" class="picker_usial" id="end">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Время подачи</span>
										<input type="text" class="form-control mask_time" id="begin_time">
									</div>
								</div>
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Время окончания</span>
										<input type="text" class="form-control mask_time" id="end_time">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="checkbox">
										<label>
											<input type="checkbox" id="trasnfer"> Трансфер
										</label>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Маршрут</span>
										<textarea class="form-control" id="route_ts"></textarea> 
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Количество ТС</span>
										<input type="text" id="count_car">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Пожелание по ТС</span>
										<textarea class="form-control" id="wishes"></textarea>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<label style="cursor: pointer;">
										<input type="checkbox" id="auto_without_driver"> Авто без водителя
									</label>
								</div>
							</div>
							<hr>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<button type="button" class="btn btn-default" onclick="addCarToList();" style="float:right;">Добавить ТС в заказ</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 col-lg-10 col-lg-offset-1">
				<div class="x_panel">
					<div id="showList"></div>
				</div>
			</div>
		</div>
		{if $group_id!='21' && $group_id!='18'}
		<div class="row">
			<div class="col-md-12 col-lg-7 col-lg-offset-1">
				<div class="x_panel">
					<div class="row">
						<div class="col-md-12">
							<h4>Определение клиента</h4>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Выберите тип клиента</span>
								<select id="type_client" name="type_client" required onchange="showClientForm();">
									<option value=""></option>
									<option value="ur">Юридическое лицо</option>
									<option value="fiz">Физическое лицо</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row" id="form_data_client_about">
						<div class="col-md-12">
							<div class="row">
								<div class="col-md-12">
									<button type="button" class="btn btn_blue" data-target="#addNewUrFace" data-toggle="modal">Добавить лицо</button>
									<hr><strong>или</strong><br>
									<div class="input-group">
										<span class="input-group-addon">Выбрать лицо</span>
										<select name="id_face" id="face_id">
											<option value="">Не выбран</option>
										</select>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row" id="looking_for_fiz_client_about">
						<div class="col-md-12">
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Поиск по телефону</span>
										<input type="text" id="phone_looking_for" autocomplete="off">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon"></span>
										<select id="result_search_by_phone" size="10"></select>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		{else}
		<input type="hidden" id="type_client" value="{$group_id}">
		<input type="hidden" name="type_client" value="{if $group_id == '18'}ur{elseif $group_id == '21'}fiz{/if}">
		{/if}
		<div class="row">
			<div class="col-md-12 col-lg-6 col-lg-offset-1">
				<div class="x_panel">
					<div class="row">
						<div class="col-md-12">
							<h4>Дополнительная информация</h4>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Контактное лицо</span>
								<input type="text" name="contact_face" id="contact_face" class="form-control" required value="{if $group_id == '21'}{$name_user}{else}{/if}">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Телефон</span>
								<input type="text" id="phone_mask" name="tel" class="form-control" required value="{if $group_id == '21'}{$phone_user}{else}{/if}">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">E-mail</span>
								<input type="text" name="email" id="email" class="form-control" value="{if $group_id == '21'}{$email_user}{else}{/if}">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Форма оплаты</span>
								<select name="payment" class="form-control">
									<option value=""></option>
									<option value="Наличные">Наличные</option>
									<option value="Карта">Карта</option>
									<option value="Безналичный с НДС">Безналичный с НДС</option>
									<option value="Безналичный без НДС">Безналичный без НДС</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Бюджет клиента</span>
								<input type="text" name="client_budget" class="form-control">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Город</span>
								<select name="ticket_city" id="ticket_city">
				                    <option value=""></option>
				                    <option value="Санкт-Петербург" {if $search_info['work_city'] == 'Санкт-Петербург'}selected{/if}>Санкт-Петербург</option>
				                    <option value="Москва" {if $search_info['work_city'] == 'Москва'}selected{/if}>Москва</option>
				                </select>
							</div>
						</div>
					</div>
					<hr>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Откуда вы о нас узнали?</span>
								<select name="came_from">
									<option value="">Не выбран</option>
									<option value="Yandex">Yandex</option>
									<option value="Google">Google</option>
									<option value="Сайт">Сайт</option>
									<option value="Авито">Авито</option>
									<option value="Повторно">Повторно</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<button type="button" class="btn btn-default" onclick="checkFormBeforeSending();">Отправить заявку</button>
						</div>
					</div>
				</div>
				<br>
				<div class="row">
					<div class="col-md-12" id="show_error" style="display: none;">
						<div class="alert alert-danger alert-dismissable fade in">
						    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
						    <strong>Внимание!</strong><span id="text_error"></span>
						 </div>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<div id="addNewUrFace" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Добавление нового Юр. лица</h4>
				<input type="hidden" id="addclienttype">
			</div>
			<div class="modal-body">
				<!-- <div class="row">
					<div class="col-md-12 col-lg-6">
						<div class="input-group" id="field_login_for_user">
							<span class="input-group-addon">Логин</span>
							<input type="text" id="loginurface">
						</div>
					</div>
				</div> -->
				<div class="row">
					<div class="col-md-12 col-lg-6">
						<div class="input-group">
							<span class="input-group-addon">Наименование лица</span>
							<input type="text" id="nameurface">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" onclick="addUrFace();">Сохранить</button>
				<button type="button" class="btn btn-default" data-dismiss="modal" id="closeModalURFace">Закрыть</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$('#type_ts').on('change',function(){
		var type = $('#type_ts option:selected').val();
		showFieldByTypes(type);
	});

	$('#marka_ts_sel').on('change',function(){
		var mark = $('#marka_ts_sel option:selected').val();
		{literal}
		$.ajax({
			type:'POST',
			url: '/core/ajax/ajaxForAutoClass.php',
			data:{action:'getModelListTs',mark:mark},
			cache:false,
			success:function(responce){
				$('#model_ts_sel').show();
				//console.log(responce);
				$('#model_ts_sel').html(responce);
			}
		});
		{/literal}
	});

	$('#marka_bus_sel').on('change',function(){
		var mark = $('#marka_bus_sel option:selected').val();
		{literal}
		$.ajax({
			type:'POST',
			url: '/core/ajax/ajaxForAutoClass.php',
			data:{action:'getModelListBus',mark:mark},
			cache:false,
			success:function(responce){
				$('#model_bus_sel').show();
				$('#model_bus_sel').html(responce);
			}
		});
		{/literal}
	});

	$('#marka_minivan_sel').on('change',function(){
		var mark = $('#marka_minivan_sel option:selected').val();
		{literal}
		$.ajax({
			type:'POST',
			url: '/core/ajax/ajaxForAutoClass.php',
			data:{action:'getModelListMinivan',mark:mark},
			cache:false,
			success:function(responce){
				$('#model_minivan_sel').show();
				$('#model_minivan_sel').html(responce);
			}
		});
		{/literal}
	});

	$('#marka_autobus_sel').on('change',function(){
		var mark = $('#marka_autobus_sel option:selected').val();
		{literal}
		$.ajax({
			type:'POST',
			url: '/core/ajax/ajaxForAutoClass.php',
			data:{action:'getModelListBigBus',mark:mark},
			cache:false,
			success:function(responce){
				$('#model_autobus_sel').show();
				$('#model_autobus_sel').html(responce);
			}
		});
		{/literal}
	});

    $('.picker_usial').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:  '{$date_current}',
        format:'d.m.Y',
        timepicker:false
    });


    $(document).ready(function(){
    	$("#marka_ts_sel").chosen();
    	$('#marka_ts').hide();
		$('#marka_bus').hide();
		$('#marka_minivan').hide();
		$('#marka_autobus').hide();
		$('#marka_usual').hide();
		$('#model_ts').hide();
		$('#model_bus').hide();
		$('#model_minivan').hide();
		$('#model_usual').hide();
		$('#gen_ts').hide();
		$('#phone_mask').mask("8 (999) 999-99-99");
		//$('#phone_looking_for').mask("8 (999) 999-99-99");
		$('.mask_time').mask("99:99");
		$('#form_data_client_about').hide();
		$('#looking_for_fiz_client_about').hide();
		$('#result_search_by_phone').hide();
		$("#show_error").hide();
		//$("#face_id").chosen();
    });

    function addCarToList(){
    	var typeTS = $('#type_ts option:selected').val();
    	var marka = '';
    	var model = '';
    	var gen = '';
    	if(typeTS == 'Автомобиль'){
			marka = $('#marka_ts option:selected').val();
			model = $('#model_ts option:selected').val();
			gen = $('#gen_ts_sel option:selected').val();
		}else if(typeTS == 'Микроавтобус'){
			marka = $('#marka_bus option:selected').val();
			model = $('#model_bus option:selected').val();
		}else if(typeTS == 'Минивэн'){
			marka = $('#marka_minivan option:selected').val();
			model = $('#model_minivan option:selected').val();
		}else if(typeTS == 'Автобус'){
			marka = $('#marka_autobus option:selected').val();
			model = $('#model_autobus option:selected').val();
		}else{
			marka = $('#marka_usual_sel').val();
			model = $('#model_usual_sel').val();
		}
		var begin = $('#begin').val();
		var end = $('#end').val();
		var begin_time = $('#begin_time').val();
		var end_time = $('#end_time').val();
		var route = $('#route_ts').val();
		var analog = $('#analog option:selected').val();
		var count_car = $('#count_car').val();
		var wishes = $('#wishes').val();
		var auto_without_driver = $('#auto_without_driver:checked').val();
		var trasnfer = $('#trasnfer:checked').val();
		var ts_color = $('#ts_color').val();
		var count_places = $('#count_places').val();

		trasnfer = (trasnfer == 'on')?'y':'n';
		//console.log(auto_without_driver);
		auto_without_driver = (auto_without_driver == 'on')?'y':'n';
		//console.log(auto_without_driver);

		model += " "+gen;
		if((begin!='')&&(typeTS!='')&&(count_places!='')){
			var tempArr = [typeTS,marka,model,begin,end,begin_time,end_time,route,analog,count_car,wishes,auto_without_driver,trasnfer,ts_color,count_places];
			var line = tempArr.join('|');
			saveArr(line);
		}else{
			alert("Вы не указали начало проката, тип ТС или Кол-во мест!");
		}
    }

    function saveArr(str){
    	var existArr = $('#carsList').val();
    	{literal}
    	$.ajax({
    		type:'POST',
    		url:'/core/ajax/ajaxForAutoClass.php',
    		data:{action:'saveArrToInput',string:str,existArr:existArr},
    		cache:false,
			success:function(responce){
				$('#carsList').val(responce);
				showListCar();
				clearFields();
			}
    	});
    	{/literal}
    }

    function showListCar(){
    	var strListCar = $('#carsList').val();
    	{literal}
    	$.ajax({
    		type:'POST',
    		url:'/core/ajax/ajaxForAutoClass.php',
    		data:{action:'showListCar',listCar:strListCar},
    		cache:false,
			success:function(responce){
				$('#showList').html(responce);
				//console.log(responce);
			}
    	});
    	{/literal}
    }


    function removeCar(e){
    	var keyLine = e.dataset['keyline'];
    	var carsList = $('#carsList').val();
    	{literal}
    	$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'removeLineCars',carsList:carsList,keyLine:keyLine},
    			cache:false,
    			success:function(responce){
    				$('#carsList').val(responce);
    				showListCar();
    				//console.log(responce);
    			}
    	});
    	{/literal}
    }

    function clearFields(){
    	$('#type_ts').val('');
		$('#marka_ts_sel').val('');
		$('#model_ts_sel').val('');
		$('#marka_bus_sel').val('');
		$('#model_bus_sel').val('');
		$('#marka_minivan_sel').val('');
		$('#model_minivan_sel').val('');
		$('#marka_autobus_sel').val('');
		$('#model_autobus_sel').val('');
		$('#marka_usual_sel').val('');
		$('#model_usual_sel').val('');
		$('#begin').val('');
		$('#end').val('');
		$('#analog').val('');
		$('#count_car').val('');
		$('#wishes').val('');
		$('#begin_time').val('');
		$('#end_time').val('');
		$('#route_ts').val('');
		var type = '';
		showFieldByTypes(type);
    }

    function showFieldByTypes(type){
    	if(type == 'Автомобиль'){
			$('#marka_ts').show();
			$('#marka_bus').hide();
			$('#marka_minivan').hide();
			$('#marka_usual').hide();
			$('#marka_autobus').hide();
			$('#model_ts').show();
			$('#model_bus').hide();
			$('#model_minivan').hide();
			$('#model_usual').hide();
			$('#model_autobus').hide();
			$('#gen_ts').hide();
		}else if(type == 'Микроавтобус'){
			$('#marka_ts').hide();
			$('#marka_bus').show();
			$('#marka_minivan').hide();
			$('#marka_usual').hide();
			$('#marka_autobus').hide();
			$('#model_ts').hide();
			$('#model_bus').show();
			$('#model_minivan').hide();
			$('#model_usual').hide();
			$('#model_autobus').hide();
			$('#gen_ts').hide();
		}else if(type == 'Минивэн'){
			$('#marka_ts').hide();
			$('#marka_bus').hide();
			$('#marka_minivan').show();
			$('#marka_usual').hide();
			$('#marka_autobus').hide();
			$('#model_ts').hide();
			$('#model_bus').hide();
			$('#model_minivan').show();
			$('#model_usual').hide();
			$('#model_autobus').hide();
			$('#gen_ts').hide();
		}else if(type == 'Автобус'){
			$('#marka_ts').hide();
			$('#marka_bus').hide();
			$('#marka_minivan').hide();
			$('#marka_usual').hide();
			$('#marka_autobus').show();
			$('#model_ts').hide();
			$('#model_bus').hide();
			$('#model_minivan').hide();
			$('#model_usual').hide();
			$('#model_autobus').show();
			$('#gen_ts').hide();
		}else if(type == ''){
			$('#marka_ts').hide();
			$('#marka_bus').hide();
			$('#marka_minivan').hide();
			$('#marka_usual').hide();
			$('#marka_autobus').hide();
			$('#model_ts').hide();
			$('#model_bus').hide();
			$('#model_minivan').hide();
			$('#model_usual').hide();
			$('#model_autobus').hide();
			$('#gen_ts').hide();
		}else{
			$('#marka_ts').hide();
			$('#marka_bus').hide();
			$('#marka_minivan').hide();
			$('#marka_usual').show();
			$('#marka_autobus').hide();
			$('#model_ts').hide();
			$('#model_bus').hide();
			$('#model_minivan').hide();
			$('#model_usual').show();
			$('#model_autobus').hide();
			$('#gen_ts').hide();
		}
    }


    function addUrFace(){
    	
    	var name = $('#nameurface').val();
    	var password = generatePass();
    	var login = password;
    	var type_client = $('#addclienttype').val();
    	{literal}
    		$.ajax({
    			type:"POST",
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"addNewUrFace",login:login,name:name,password:password,type_client:type_client},
    			cache:false,
    			success:function(responce){
    				$('#face_id').html(responce);
    				$('#closeModalURFace').click();
    			}
    		});
    	{/literal}
    }

    function generatePass(){
		var result = '';
		var words = '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
		var max_position = words.length - 1;
			for( i = 0; i < 10; ++i ) {
				position = Math.floor ( Math.random() * max_position );
				result = result + words.substring(position, position + 1);
			}
		return result;
	}

	function showClientForm(){
		var type_client = $('#type_client option:selected').val();
		$('#form_data_client_about').show();
		$('#addclienttype').val(type_client);
		getAccountList(type_client);
		if(type_client == 'ur'){
			$('#form_data_client_about').show();
			$('#looking_for_fiz_client_about').hide();
			$('#presetTypeClient').val('ur');
		}else if(type_client == 'fiz'){
			$('#form_data_client_about').hide();
			$('#looking_for_fiz_client_about').show();
			$('#presetTypeClient').val('fiz');
			//$('#field_login_for_user').hide();
		}
	}

	function getAccountList(type_c){
		{literal}
			$.ajax({
				type:'POST',
				url:"/core/ajax/ajaxForAutoClass.php",
				data:{action:"listAcc",type_client:type_c},
				cache:false,
				success:function(responce){
					$('#face_id').html(responce);
				}
			});
		{/literal}
	}

	$('#phone_looking_for').on("keyup",function(){
		var phone = $('#phone_looking_for').val();
		console.log(phone);
		{literal}
			$.ajax({
				type:"POST",
				url:"/core/ajax/ajaxForAutoClass.php",
				data:{action:"LFByPh",phone:phone},
				cache:false,
				success:function(responce){
					$('#result_search_by_phone').show();
					$('#result_search_by_phone').html(responce);
					//console.log(responce);
				}
			});
		{/literal}
	});

	$('#result_search_by_phone').on("change",function(){
		var line = $('#result_search_by_phone option:selected').val();
		var arr = line.split(',');
		console.log(arr);
		$('#contact_face').val(arr[0]);
		$('#phone_mask').val(arr[1]);
		$('#email').val(arr[2]);
	});

	function checkFormBeforeSending(){
		var type_client = $('#type_client option:selected').val();
		var phone = $('#phone_mask').val();
		var contact_face = $('#contact_face').val();
		var carsList = $('#carsList').val();
		var id_face = $('#face_id').val();
		var ticket_city = $('#ticket_city').val();

		if(phone!= ''){
			if((carsList!='')&&(carsList!=']')){
				if(type_client !=''){
					if((type_client =='ur')&&(id_face == '')){
						show_error_block("Вы добавили или не выбрали Юридическое лицо!");
					}else{
						if(ticket_city!=''){
							$('#formSendTicket').submit();
						}else{
							show_error_block("Вы не выбрали город!");
						}
					}
				}else{
					show_error_block("Вы не выбрали тип клиента!");
				}
			}else{
				show_error_block("Вы не добавили ТС к заказу!");
			}
		}else{
			show_error_block("Вы не указали номер телефона!");
		}
	}

	function show_error_block(text){
		$('#show_error').show();
			{literal}
				$('body').animate({scrollTop:0},4000);
			{/literal}
		$('#text_error').text(text);
		setTimeout(function(){
			$('#show_error').hide(1500);
		},2000);
	}

	function getGeneration(){
		var marka = $('#marka_ts_sel option:selected').val();
		var model = $('#model_ts_sel option:selected').val();
		{literal}
			if(marka == "Mercedes-Benz"){
				$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'getGen',model:model},
					cache:false,
					success:function(responce){
						$('#gen_ts').show();
						$('#gen_ts_sel').html(responce);
					}
				});
			}
		{/literal}
	}
</script>