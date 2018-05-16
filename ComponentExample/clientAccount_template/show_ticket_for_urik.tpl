<link rel="stylesheet" type="text/css" href="../../templates/callcenter/css/tickets_style.css?123">
<style type="text/css">
	.gray{
		background: #d0d0d0 !important;
	}
	.green{
		background: #aae082 !important;
	}
	.status_yellow{
		color: #000 !important;
		background: #ffec8b;
		border:1px solid #000;
		padding: 7px 10px;
		margin: auto !important;
		float: right;
		font-size: 11pt;
	}

	.status_pink{
		color: #000 !important;
		background: #fdd3f2;
		border:1px solid #fff;
		padding: 7px 10px;
		float: right;
		font-size: 11pt;

	}
	.status_green_light{
		color: #000 !important;
		background: #92ffd7;
		padding: 7px 10px;
		border:1px solid #fff;
		float: right;
		font-size: 11pt;

	}
	.status_green_dark{
		color: #f5ebeb !important;
		background: #508846;
		padding: 7px 10px;
		border:1px solid #000;
		float: right;
		font-size: 11pt;

	}
	.status_red{
		color: #f5ebeb !important;
		background: #e24a4a;
		padding: 7px 10px;
		border:1px solid #000;
		float: right;
		font-size: 11pt;

	}
	.status_gray{
		padding: 7px 10px;
		float: right;
		font-size: 11pt;
	}
	.status_white{
		color: #000 !important;
		background: #fff;
		padding: 7px 10px;
		border:1px solid #fff;
		float: right;
		font-size: 11pt;

	}
	.status_blue{
		color: #000 !important;
		background: #9ad3ff;
		padding: 7px 10px;
		border:1px solid #fff;
		float: right;
		font-size: 11pt;

	}
	.status_purple{
		color: #000 !important;
		background: #bf83ff;
		padding: 7px 10px;
		border:1px solid #fff;
		float: right;
		font-size: 11pt;

	}

	.status_cherry{
		color: #000 !important;
		background: #e65a5a;
		padding: 7px 10px;
		border:1px solid #fff;
		font-size: 11pt;
		float: right;
	}

	.final_info{
		font-weight: bold;
		font-size: 14pt;
		color:#245179;
	}

	.line_final hr{
		margin-top: 20px;
    	margin-bottom: 20px;
    	border: 0;
    	border-top: 2px solid #3379b8 !important;
	}

	.usual_type{
		font-weight: normal;
		font-size: 11pt;
	}
</style>
<div class="x-content">
	<div class="row">
		<div class="col-md-12 col-lg-10 col-lg-offset-1">
			<div class="x_panel">
				<div class="row">
					<div class="col-md-6">
						<h3>Заявка № {$ticket_info.id}</h3>
						<input type="hidden" id="ticket_id" value="{$ticket_info.id}">
						<input type="hidden" id="carList" value="{$ticket_info.list}">
						<input type="hidden" id="owner_ticket" value="{$ticket_info.user_id}">
						<input type="hidden" id="client_phone" value="{$ticket_info.tel}">
						<input type="hidden" id="curr_control" value="{$ticket_info.manager_info.nickname}">
					</div>
					<div class="col-md-6">
						<button type="button" style="float: right;" class="btn btn_blue" data-toggle="modal" data-target="#correctUrDataForClient" data-type="{if $check_req == 'y'}edit{elseif $check_req == 'n'}add{/if}" onclick="openFormForRequisites(this);">{if $check_req == 'y'}Редактирование{elseif $check_req == 'n'}Добавить{/if} реквизиты</button>
					</div>
				</div>
			</div>			
		</div>
	</div>
	<div class="row">
		<div class="col-md-12 col-lg-10 col-lg-offset-1">
			<div class="x_panel">
				<div class="row">
					<div class="col-md-6">
						<fieldset>
							<legend>Заказчик </legend>
							<ul class="list-group">
							  <li class="list-group-item">
							  	<strong>Наименование заказчика: </strong>
							  	<span style="float: right;">{$ticket_info.nick_client}</span>
							  </li>
							  <li class="list-group-item">
							  	<strong>Контактное лицо: </strong>
							  	<span style="float: right;">{$ticket_info.contact_face}</span>
							  </li>
							  <li class="list-group-item">
							  	<strong>Телефон: </strong>
							  	<span style="float: right;">{$ticket_info.tel}</span>
							  </li>
							  <li class="list-group-item">
							  	<strong>E-mail: </strong>
							  	<span style="float: right;">{$ticket_info.email}</span>
							  </li>
							  <li class="list-group-item">
							  	<strong>Форма оплаты: </strong>
							  	<span style="float: right;" id="form_payment">{$ticket_info.type_payment}</span>
							  </li>
							  <li class="list-group-item">
							  	<strong>Бюджет клиента</strong>
							  	<span style="float: right;">{$ticket_info.client_budget}</span>
							  </li>
							  <li class="list-group-item">
							  	<strong>Город</strong>
							  	<span style="float: right;">{$ticket_info.ticket_city}</span>
							  </li>
							</ul>
						</fieldset>
					</div>
					<div class="col-md-6">
						<fieldset>
							<legend>Исполнитель</legend>
							<ul class="list-group">
								<li class="list-group-item">
									<div id='setted_control'>
								  		<strong>Личный менеджер: </strong>
								  		<span style="float: right;">{if $ticket_info.id_control != '0'}{$ticket_info.manager_info.nickname}{else}{/if}</span>
								  	</div>
							  		<div id="list_control" style="display: none;">
							  			<div class="input-group">
							  				<span class="input-group-addon">Новый менеджер</span>
							  				<select id="list_controller">
							  					<option value="" selected></option>
							  					{foreach item=con key=key from=$list_controller}
							  					<option value="{$con.id}">{$con.nickname}</option>
							  					{/foreach}
							  				</select>
							  			</div>
							  		</div>
							  	</li>
							  	<li class="list-group-item">
							  		<strong>Телефон менеджера: </strong>
							  		<span style="float: right;">{if $ticket_info.ticket_city == 'Санкт-Петербург'} +7 (812) 648-83-52{elseif $ticket_info.ticket_city == 'Москва'}+7 (495) 177-83-52{/if}</span>
							  	</li>
							  	<li class="list-group-item">
							  		<strong>Дата создания заявки: </strong>
							  		<span style="float: right;">{$ticket_info.time_add}</span>
							  	</li>
							  	<li class="list-group-item">
									<div id="block_status_ticket">
										<strong>Статус заявки: </strong>
								  		<span class="label label-default status_{$ticket_info.color_status}">{$ticket_info.status_ticket}</span>
									</div>
							  	</li>
							</ul>
						</fieldset>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-10 col-lg-offset-1">
			<div class="x_panel">
				<div class="row">
					<div class="col-md-12 x_header_line">
						<h2>Условия аренды</h2>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					{foreach item=cars key=key from=$ticket_info.car_list}
					<div class="row">
						<div class="col-md-12">
							<div class="x_box">
								<div class="row">
									<div class="col-lg-6 col-md-12">
										<div class="row">
											<div class="x_panel">
												<div class="row">
													<div class="col-md-12">
														<fieldset>
															<div class="x_header_line">
																<h4>ТС № {$key+1}</h4>
															</div>
															<br><br>
																<span class="btm_line"><label>Транспорт: </label><span class="side_text">{$cars.type_ts} {$cars.mark_ts} {$cars.model_ts} {$cars.color_ts}</span><br></span>
																<span class="btm_line"><label>Кол-во мест: </label><span class="side_text">{$cars.count_places}</span><br></span>
																<span class="btm_line"><label>Период аренды:</label><span class="side_text">{$cars.begin_procat} - {$cars.end_procat}</span><br></span>
																<span class="btm_line"><label>Время начала и окончания:</label><span class="side_text">{$cars.begin_time} {if $cars.transfer == 'y'}{if $cars.auto_without_driver == 'Да'}Сутки{else}Трансфер{/if}{else}{if $cars.end_time != '00:00'}{$cars.end_time}{/if}{/if}</span><br></span>
																<span class="btm_line"><label>Маршрут:</label><span class="side_text">{$cars.route}</span><br></span>
																<span class="btm_line"><label>Аналог:</label><span class="side_text">{if $cars.analog == 'y'}Да{elseif $cars.analog == 'n'}Нет{else}{/if}</span><br></span>
																<span class="btm_line"><label>Кол-во ТС:</label><span class="side_text">{$cars.count_ts}</span><br></span>
																<span class="btm_line"><label>Комментарий по ТС:</label><span class="side_text">{$cars.comment_ts}</span><br></span>
																<span class="btm_line_last"><label>Авто без водителя:</label><span class="side_text">{$cars.auto_without_driver}</span></span>
														</fieldset>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="col-lg-6 col-md-12">
										<div class="row">
											<div class="x_panel">
												<div class="row">
													<div class="col-md-12">
														<fieldset>
															<div class="x_header_line">
																<h4>Согласованные условия</h4>
															</div>
															<br><br>
															<span class="btm_line"><label>Траспорт: </label><span class="side_text" style="text-align: right;">{$cars.confirmed.car_list}</span><br></span>
															<span class="btm_line"><label>Ставка/Цена за проект: </label><span class="side_text">{$cars.confirmed.all_priceses}</span><br></span>
															<span class="btm_line"><label>Форма оплаты: </label><span class="side_text">{$cars.confirmed.form_payment}</span><br></span>
															<span class="btm_line"><label>Кол-во часов: </label><span class="side_text">{$cars.confirmed.hours}</span><br></span>
															<span class="btm_line"><label>Кол-во доп. часов: </label><span class="side_text">{$cars.confirmed.add_hours}</span><br></span>
															<span class="btm_line_last"><label>Итого к оплате: </label><span class="side_text">{$cars.confirmed.final}</span><br></span>
															<span class="btm_line_last"><label>Имя водителя: </label><span class="side_text">{$cars.confirmed.driver_name}</span><br></span>
															<span class="btm_line_last"><label>Номер телефона: </label><span class="side_text">{$cars.confirmed.phone_dr}</span><br></span>
															<span class="btm_line_last"><label>Гос номер: </label><span class="side_text">{$cars.confirmed.gos_nomer}</span><br></span>
														</fieldset>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<br>
							</div>
						</div>
					</div>
					<br>
					{/foreach}
					<div class="row">
						<div class="col-md-12">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

	<div id="correctUrDataForClient" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Работа с реквизитами клиента</h4>
					<input type="hidden" id="type_correct">
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12 col-lg-8">
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Наименование компании</span>
										<input type="text" id="name_ur">
									</div>
								</div>
								<div class="col-md-6">
									<div class="input-group">
										<span class="input-group-addon">Тип организации</span>
										<select id="type_ur">
											<option value=""></option>
											<option value="ИП">ИП</option>
											<option value="ООО">ООО</option>
											<option value="ОАО">ОАО</option>
											<option value="ЗАО">ЗАО</option>
											<option value="АО">АО</option>
										</select>
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">В лице</span>
										<input type="text" id="face_of_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Имя лица</span>
										<input type="text" id="gen_dir_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">На основании</span>
										<input type="text" id="action_by_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">ИНН</span>
										<input type="text" id="inn_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">КПП</span>
										<input type="text" id="kpp_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">ОГРН</span>
										<input type="text" id="orgn_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Юридический адрес</span>
										<input type="text" id="ur_address">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Наименование банка</span>
										<input type="text" id="name_bank">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Расчетный счет</span>
										<input type="text" id="rk_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">БИК</span>
										<input type="text" id="bik_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Корреспондетский счет</span>
										<input type="text" id="ks_ur">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Должность (Им. падеж)</span>
										<input type="text" id="face_of_ur_imin_pod">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Подписант</span>
										<input type="text" id="podpisant">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
					<button type="button" class="btn btn_blue" onclick="sendUrDataClient();" style="float: right;">Сохранить</button>
				</div>
			</div>
		</div>	
	</div>

<script type="text/javascript">
	function openFormForRequisites(e){
		var type = e.dataset['type'];
		var id_client = $('#owner_ticket').val();
		console.log(id_client);
		if(type == 'add'){
			$('#type_correct').val(type);
		}else{
			{literal}
				$.ajax({
					type:'POST',
					url:"/core/ajax/ajaxForAutoClass.php",
					data:{action:'getRequisitesToEdit',client_id:id_client},
					cache:false,
					success:function(response){
						$('#type_correct').val(type);
						var arr_data = JSON.parse(response);
						var name_ur = $('#name_ur').val();
						
						//console.log(arr_data);
						$('#gen_dir_ur').val(arr_data['gen_dir_name']);
		 				$('#inn_ur').val(arr_data['inn']);
		 				$('#kpp_ur').val(arr_data['kpp']);
						$('#orgn_ur').val(arr_data['ogrn']);
						$('#ur_address').val(arr_data['ur_address']);
						$('#name_bank').val(arr_data['name_bank']);
						$('#name_ur').val(arr_data['name_ur']);
						$('#rk_ur').val(arr_data['rk_ur']);
		 				$('#bik_ur').val(arr_data['bik']);
						$('#ks_ur').val(arr_data['ks_ur']);
						$('#podpisant').val(arr_data['podpisant']);
						$('#type_ur option[value="'+arr_data['type_ur']+'"]').prop('selected',true);
						$('#face_of_ur').val(arr_data['face_comp']);
						$('#action_by_ur').val(arr_data['action_by']);
						$('#face_of_ur_imin_pod').val(arr_data['face_comp_imp']);
					}
				});
			{/literal}
		}
	}

	function sendUrDataClient() {
		var name_ur = $('#name_ur').val();
		var type_ur = $('#type_ur option:selected').val();
		var face_ur = $('#face_of_ur').val();
		var action_by = $('#action_by_ur').val();
		var gen_dir_ur = $('#gen_dir_ur').val();
		var inn_ur = $('#inn_ur').val();
		var kpp_ur = $('#kpp_ur').val();
		var orgn_ur = $('#orgn_ur').val();
		var ur_address = $('#ur_address').val();
		var name_bank = $('#name_bank').val();
		var rk_ur = $('#rk_ur').val();
		var bik_ur = $('#bik_ur').val();
		var ks_ur = $('#ks_ur').val();
		var type_correct = $('#type_correct').val();
		var id_client = $('#owner_ticket').val();
		var face_of_ur_imin_pod = $('#face_of_ur_imin_pod').val();
		var podpisant = $('#podpisant').val();
		{literal}
			$.ajax({
				type:'POST',
				url:"/core/ajax/ajaxForAutoClass.php",
				data:{action:"sendUrDataClient",
						name_ur:name_ur,
						gen_dir_ur:gen_dir_ur,
						inn_ur:inn_ur,
						kpp_ur:kpp_ur,
						orgn_ur:orgn_ur,
						ur_address:ur_address,
						name_bank:name_bank,
						rk_ur:rk_ur,
						bik_ur:bik_ur,
						ks_ur:ks_ur,
						type_corr:type_correct,
						id_client:id_client,
						podpisant:podpisant,
						type_ur:type_ur,
						face_ur:face_ur,
						action_by:action_by,
						face_of_ur_imin_pod:face_of_ur_imin_pod
					},
				cache: false,
				success:function(response){
					//console.log(response);
					window.location.reload();
				}
			});
		{/literal}
	}
</script>    