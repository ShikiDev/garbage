<link rel="stylesheet" type="text/css" href="../../templates/callcenter/css/tickets_style.css?123">
<style type="text/css">
	.gray{
		background: #d0d0d0 !important;
	}
	.green{
		background: #aae082 !important;
	}
	.calculate_btn{
		min-width: 25px;
		font-size: 12pt !important;
		margin: 2px;
		padding: 10px 25px !important;
	}
	.display_calculate_block{
		min-width: 150px !important;
		max-width: 265px !important;
		min-height: 80px !important;
		border: 2px solid #4794cf !important;
	}
	#text_block{
		font-size: 20pt !important;
		min-height: 75px;
	}
	#result_calculating{
		padding: 35px 45px;
		font-size: 20pt !important;
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
					<div class="col-md-5">
						<h3>Заявка № {$ticket_info.id}</h3>
						{if $ticket_info.id_control == '0'}
						<button type="button" class="btn_red" onclick="getThisTicketInWork();">Принять в работу</button>
						{/if}
						<input type="hidden" id="ticket_id" value="{$ticket_info.id}">
						<input type="hidden" id="carList" value="{$ticket_info.list}">
						<input type="hidden" id="owner_ticket" value="{$ticket_info.user_id}">
						<input type="hidden" id="client_phone" value="{$ticket_info.tel}">
						<input type="hidden" id="curr_control" value="{$ticket_info.manager_info.nickname}">
					</div>
					<div class="col-md-7">
						{if $group_id!='18'}
						<div style="float: right;">
							<div style=" min-width:200px; max-width: 650px;">
								<button type="button" class="btn btn_blue" data-toggle="modal" data-target="#calculator"> Калькулятор</button>
								{if $ticket_info.type_client == 'fiz'}
									<button type="button" class="btn btn_blue"  data-toggle="modal" data-target="#pickTicketToUrFace">Перевести заявку к юр. лицу</button>
									<button type="button" class="btn btn_blue" data-toggle="modal" data-target="#formRequisitesForFizFace" >Реквизиты физ. лица</button>
									{if $ticket_info.user_id == 0}<button type="button" class="btn btn_blue" data-toggle="modal" data-target="#createCabinetForFizFace">Каб. Физ. (Не работает)</button>{/if}
								{else if $ticket_info.type_client == 'ur'}
								<button type="button" style="float: right;" class="btn btn_blue" data-toggle="modal" data-target="#correctUrDataForClient" data-type="{if $check_req == 'y'}edit{elseif $check_req == 'n'}add{/if}" onclick="openFormForRequisites(this);">{if $check_req == 'y'}Редактирование{elseif $check_req == 'n'}Добавить{/if} реквизиты</button>
								{/if}
							</div>
						</div>
						{/if}
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
							<legend>Заказчик <button type="button" class="btn btn_blue" data-toggle="modal" data-target="#editAccountOfTicket" id="edit_button" style="float: right;">Редактировать</button></legend>
							<ul class="list-group">
							  <li class="list-group-item">
							  	<strong>Наименование заказчика: </strong>
							  	{if $ticket_info.type_client == 'ur'}<a href="/clientAccount/client_cabinet/{$ticket_info.user_id}" target="_blank" style="cursor: pointer;"><span style="float: right;">{$ticket_info.nick_client}</span></a>
							  	{elseif $ticket_info.type_client == 'fiz'}<span style="float: right;">{$ticket_info.nick_client}</span>
							  	{/if}
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
							  {if $group_id!='18'}<li class="list-group-item">
							  	<strong>Тип клиента: </strong>
							  	<span style="float: right;" id="form_payment">{if $ticket_info.type_client == 'ur'}Юридическое лицо{elseif $ticket_info.type_client == 'fiz'}Физическое лицо{/if}</span>
							  </li>{/if}
							  <li class="list-group-item">
							  	<strong>Город</strong>
							  	<span style="float: right;">{$ticket_info.ticket_city}</span>
							  </li>
							  <li class="list-group-item">
							  	<strong>Клиент узнал о нас из </strong>
							  	<span style="float: right;">{$ticket_info.came_from}</span>
							  </li>
							</ul>
						</fieldset>
						<div class="table-responsive">
							<table class="table-bordered table">
								<thead>
									<th>Клиент</th>
									<th>Партнер</th>
									<th>АК</th>
									<th>Получено АК</th>
								</thead>
								<tbody>
									<tr>
										<td>
										{if $short_finance_info.client_summ!= ''}{$short_finance_info.client_summ}
											 {if $short_finance_info.client_hold !=''||$short_finance_info.client_hold != 0}
											 	({$short_finance_info.client_hold})
											 {/if}
										{else} - {/if}</td>
										<td>
										{if $short_finance_info.partner_summ!=''}{$short_finance_info.partner_summ}
											 	( {$short_finance_info.partner_hold})
										{else} - {/if}</td>
										<td>{if $short_finance_info.ak_summ!=''}{$short_finance_info.ak_summ}{else} - {/if}</td>
										<td>{if $short_finance_info.ak!=''}{$short_finance_info.ak}{else}-{/if}</td>
									</tr>
								</tbody>
							</table>
						</div>
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
								  		<span style="float: right;">{if $ticket_info.id_control != '0'}{if $ticket_info.ticket_city == 'Санкт-Петербург'} +7 (812) 648-83-52{elseif $ticket_info.ticket_city == 'Москва'}+7 (495) 177-83-52{/if}{else}{/if}</span>
								  	</li>
								  	<li class="list-group-item">
								  		<strong>Дата создания заявки: </strong>
								  		<span style="float: right;">{$ticket_info.time_add}</span>
								  	</li>
								  	<li class="list-group-item">
										<div id="block_status_ticket">
											<strong>Статус заявки: </strong>
									  		<span class="label label-default status_{$ticket_info.color_status}">{$ticket_info.status_ticket} {if $ticket_info.status_ticket == 'Отказ'}(Причина: {$ticket_info.reason_cancel} ){/if}</span>
										</div>
								  	</li>
								  	<li class="list-group-item">
								  		<strong>Последний callback клиенту</strong>
								  		<span style="float: right;font-weight: bold;font-size: 11pt;" id="last_client_callback_line">{$ticket_info.last_client_callback}</span>
								  	</li>
								</ul>
						</fieldset>
						<br>
						{if $group!='18'}
						<button type="button" class="btn btn_blue" onclick="printDogovorForClient();">Печать договора</button>
						<button type="button" class="btn btn_blue" data-toggle="modal" data-target="#preprintTicketPresetWaylist" onclick="printForClient();" >Печать заявки</button>
						<button data-target="#modalCommentTicket" class="btn btn_blue" data-toggle="modal" style="float: right;" onclick="$('#type_callback_client').val('add');"><i class="fa fa-phone fa-lg"></i></button>
						{/if}
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12 col-md-12 col-lg-10 col-lg-offset-1">
			{if $group_id != '18'}
			<div class="row">
				<div class="col-lg-6">
					{if $getListPayment_client!='' || getListPayment_partner !=''}
					<div class="row">
						<div class="col-md-12">
							<div class="x_panel">
								<div class="x_title">
									<h2>Инфо по платежам клиента</h2>
									<ul class="nav navbar-right panel_toolbox">
										<li>
											<a class="collapse-link">
												<i class="fa fa-chevron-up"></i>
											</a>
										</li>
									</ul>
									<button type="button" class="btn btn_blue" data-target="#setPaymentInfo" data-type="client" style="float: right; padding:2px;" data-toggle="modal" onclick="getPredata(this);">Добавить платеж</button>
									<div class="clearfix"></div>
								</div>
								<div class="x_content">
									<div class="row">
										<div class="col-md-12">
											<div style="overflow-x: auto;">
												<table class="table">
													<thead>
														<th>Платеж</th>
														<th>Тип платежа</th>
														<th>Форма платежа</th>
														<th>Дата платежа</th>
														<th>Сумма</th>
														<th>Комментарий</th>
														<th colspan="2"></th>
													</thead>
													<tbody>
														{foreach item=payment key=key from=$getListPayment.client}
														<tr>
															<td>{$payment.payment_from_line}</td>
															<td>{$payment.type_payment}</td>
															<td>{$payment.form}</td>
															<td>{$payment.data}</td>
															<td>{$payment.summ}</td>
															<td>{$payment.comment}</td>
															<td><i class="fa fa-pencil fa-lg" style="cursor: pointer;" data-id="{$payment.id}" data-target="#setPaymentInfo" data-toggle="modal" onclick="editPayment(this);"></i></td>
															<td><i class="fa fa-remove fa-lg" style="cursor: pointer;" data-id="{$payment.id}" onclick="deletePayment(this);"></i></td>
														</tr>
														{/foreach}
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-12">
							<div class="x_panel">
								<div class="x_title">
									<h2>Инфо по платежам Партнера</h2>
									<ul class="nav navbar-right panel_toolbox">
										<li>
											<a class="collapse-link">
												<i class="fa fa-chevron-up"></i>
											</a>
										</li>
									</ul>
									<button type="button" class="btn btn_blue" data-target="#setPaymentInfo" data-type="partner" onclick="getPredata(this);" style="float: right; padding:2px;" data-toggle="modal">Добавить платеж</button>
									<div class="clearfix"></div>
								</div>
								<div class="x_content">
									<div class="row">
										<div class="col-md-12">
											<div style="overflow-x: auto;">
												<table class="table">
													<thead>
														<th>Платеж</th>
														<th>Тип платежа</th>
														<th>Форма платежа</th>
														<th>Дата платежа</th>
														<th>Сумма</th>
														<th>Комментарий</th>
														<th colspan="2"></th>							
													</thead>
													<tbody>
														{foreach item=payment key=key from=$getListPayment.partner}
														<tr>
															<td>{$payment.payment_from_line}</td>
															<td>{$payment.type_payment}</td>
															<td>{$payment.form}</td>
															<td>{$payment.data}</td>
															<td>{$payment.summ}</td>
															<td>{$payment.comment}</td>
															<td><i class="fa fa-pencil fa-lg" style="cursor: pointer;" data-id="{$payment.id}" data-target="#setPaymentInfo" data-toggle="modal" onclick="editPayment(this);"></i></td>
															<td><i class="fa fa-remove fa-lg" style="cursor: pointer;" data-id="{$payment.id}" onclick="deletePayment(this);"></i></td>
														</tr>
														{/foreach}
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
						
					{/if}
				</div>
				<div class="col-lg-6">
					<div class="x_panel"">
						<div class="x_title">
							<h2>Заметки</h2>
							<ul class="nav navbar-right panel_toolbox">
								<li>
									<a class="collapse-link">
										<i class="fa fa-chevron-up"></i>
									</a>
								</li>
							</ul>
							<div class="clearfix"></div>
						</div>
						<div class="x_content"">
							<div class="row">
								<div class="col-md-12">
									<div class="row">
										<div class="col-md-12">
											<div class="input-group">
												<span class="input-group-addon">Комментарий</span>
												<textarea id="comment_about_ticket" class="form-control"></textarea>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<button type="button" class="btn btn_blue" onclick="saveCommentAboutTicket();">Сохранить</button>
										</div>
									</div>
								</div> 
							</div>
							<hr>
							<div class="row">
								<div class="col-md-12">
									<div style="max-height: 300px; overflow-y: scroll; overflow-x: hidden; min-height: 100px;">
										{foreach item=comment key=key from=$commentAboutTicketList}
											<div class="row">
												<div class="col-md-12">
													<div class="x_panel">
														<div class="x_title">
															<label>Автор: <strong>{$comment.user_name}</strong></label>
															<div style="float: right;">Дата оставления: <label>{$comment.data_add}</label></div>
														</div>
														<div class="x_content">
															<label>Комментарий:</label><br>
															<div class="row">
																<div class="col-md-8">
																	{$comment.comment}
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										{/foreach}
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			{/if}
			<div class="x_panel">
				<div class="row">
					<div class="col-md-12 x_header_line">
						<h2>Условия аренды</h2>
						<button class="btn btn_red" style="float: right;" data-target="#addWishCarToTicket" data-toggle="modal" >Добавить ТС к заявке</button>
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
									<div class="col-md-offset-10 col-md-2 col-lg-offset-10 col-lg-2">
										<button type="hidden" class="btn_red" data-wc="{$cars.id}" onclick="deleteWCFromTicket(this);" style="float: right;margin-bottom: 15px;">Удалить ТС</button>
									</div>
								</div>
								<div class="row">
									<div class="col-lg-6 col-md-12">
										<div class="row">
											<div class="x_panel">
												<div class="row">
													<div class="col-md-12">
														<fieldset>
															<div class="x_header_line">
																<h4>ТС № {$key+1}</h4>
																<button class="btn btn_blue side_text" style="cursor: pointer;" data-toggle="modal" data-target="#modalEdit" data-keyline="{$cars.id}" onclick="editLine(this);"><i class="fa fa-pencil fa-lg"></i></button>
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
										{if group_id != '18'}
											{if $cars.confirmed ==''}
												<div class="no_data_block" data-toggle="modal" data-target="#confirmedTSProcatModal" data-wishid="{$cars.id}" onclick="getwickidCarToConfirm(this);">
													<span>Согласование условий</span>
												</div>
											{else}
											<div class="x_panel">
												<div class="row">
													<div class="col-md-12">
														<fieldset>
															<div class="x_header_line">
																<h4>Согласованные условия</h4>
																<button class="btn btn_blue side_text" style="cursor: pointer;" data-wishid="{$cars.id}" data-line="{$cars.confirmed_short}" data-toggle="modal" data-target="#confirmedTSProcatModal" onclick="editConfirmedTSnRoute(this);"><i class="fa fa-pencil fa-lg"></i></button>
															</div>
															<br><br>
															<span class="btm_line"><label>Траспорт: </label><span class="side_text" style="text-align: right;">{$cars.confirmed.car_list}</span><br></span>
															<span class="btm_line"><label>Ставка/Цена за проект: </label><span class="side_text">{$cars.confirmed.all_priceses}</span><br></span>
															<span class="btm_line"><label>Форма оплаты: </label><span class="side_text">{$cars.confirmed.form_payment}</span><br></span>
															<span class="btm_line"><label>Кол-во часов: </label><span class="side_text">{$cars.confirmed.hours}</span><br></span>
															<span class="btm_line"><label>Кол-во доп. часов: </label><span class="side_text">{$cars.confirmed.add_hours}</span><br></span>
															<span class="btm_line_last"><label>Итого к оплате: </label><span class="side_text">{$cars.confirmed.final}</span><br></span>
														</fieldset>
													</div>
												</div>
											</div>
											{/if}
										{/if}
										</div>
									</div>
								</div>
														
								{if $cars.setted_car == '0'&&$group_id != '18'}
								<div class="no_data_block" onclick="window.open('/clientAccount/preset_car/{$ticket_info.id}');">
									<span>Перейти к наработкам по заявке</span>
									<!-- <a href="/clientAccount/preset_car/{$ticket_info.id}" target="_blank">
									</a> -->
								</div>
								<!-- <div class="no_data_block" data-toggle="modal" data-target="#chooseAutoProcatModal" data-wishid='{$cars.id}' onclick="getIdWishCar(this);">
		                        	<span>Выберите автомобиль (прикрепление ТС партнера) </span>
		                    	</div> -->
								{elseif $cars.setted_car != '0'}
								<div class="x_panel">
									<h4>Прикрепленное ТС</h4>
									<br>
									<table class="table">
										<thead>
											<th>ТС</th>
											{if $group_id != '18'}<th>Партнер</th>{/if}
											<th>Ставка</th>
											<th>Стоимость</th>
											<th>Договоренность по оплате</th>
											<th>Статус</th>
											<th>CALLBACK</th>
											<th>Даты работы</th>
											<th>Данные по водителю</th>
											<th colspan="3"></th>
										</thead>
										<tbody>
											{foreach item=setted key=i from=$cars.car_setted}
											<tr>
												<td><a href="/partner/proprietor_{$setted.owner_id}/cart_ts_{$setted.id_car}.html" style="font-weight: bold;" target="_blank">{$setted.type_ts}<br>{$setted.mark} <br> {$setted.model} <br> {$setted.year} <br> {$setted.color} <br> {$setted.gosnomer}</a></td>
												{if $group_id != '18'}<td><a href="/partner/cart_proprietor/{$setted.owner_info.id}.html"><span style="font-weight: bold;">{$setted.owner_info.name}<br>{$setted.owner_info.tel}{if $setted.last_form_payment == 'Карта'}<br>{$setted.owner_info.cart_info}{/if}</span></a></td>{/if}
												<td>{if $setted.linePriceSettedTS!=''}{$setted.linePriceSettedTS}{/if}</td>
												<td>
												{if $setted.endPriceSettedTS!='0'&&$group_id!='18'}{$setted.endPriceSettedTS}{/if}
												{if $setted.fullPriceSettedTS!='0'&&$group_id!='18'&& $setted.fullPriceSettedTS != $setted.endPriceSettedTS}{$setted.fullPriceSettedTS}{/if}</td>
												<td>{if $group_id !='18'}{if $setted.predoplata_dialog !=''}{$setted.predoplata_dialog}{else}{$setted.predoplata}{/if}{/if}</td>
												<td>{$setted.status}</td>
												<td><span style="font-weight: bold;">{$setted.last_partner_callback}</span></td>
												<td>
													{if $setted.list_work_data_sec!=''}
														{foreach item=l key=key from=$setted.list_work_data_sec}
															<span>{$l}</span><br>
														{/foreach}
													{else}
													<strong>Не установлены</strong>
													{/if}
												</td>
												<td>{if $setted.name_dr!=''}{$setted.name_dr}{else}На согласовании{/if} <br> {if $setted.phone_dr!=''}{$setted.phone_dr}{else}На согласовании{/if}</td>
												<td>
												{if $group_id!='18'}
												<i class="fa fa-phone fa-lg" data-toggle="modal" data-partnerlastcallback="{$setted.last_partner_callback}" data-partnerid="{$setted.owner_id}" data-target="#callbackWithPartner" style="cursor:pointer;" data-settedcarid="{$setted.id}" onclick="formDataForCallbackPartnerModule(this);"></i>
												{/if}
												</td>
												<td>
												{if $group_id!='18'}<i class="fa fa-pencil fa-lg" data-toggle="modal" data-namets="{$setted.mark} {$setted.model} {$setted.year}" data-settedid="{$setted.id}" data-arr="{$setted.price_for_car}|{$setted.count_hours}|{$setted.count_hours_ad}|{$setted.endPriceSettedTS}|{$setted.name_dr}|{$setted.phone_dr}|{$setted.gosnomer}|{$setted.predoplata}|{$setted.owner_id}|{$setted.form_payment_partner}" data-car_setted_id="{$setted.id_car}" data-wishid="{$cars.id}" data-target="#editSettedTS" style="cursor:pointer;" onclick='showModelEditTS(this);'></i>{/if}
												</td>
												<td>
												{if $group_id!='18'}
												<i class="fa fa-remove fa-lg" data-toggle="modal" data-namets="{$setted.mark} {$setted.model} {$setted.year}" data-settedid="{$setted.id}" data-settedcarid="{$setted.id_car}" data-target="#removeSettedTS" style="cursor:pointer;" data-wishid='{$cars.id}' onclick='showModelRemoveTS(this);'></i>
												{/if}
												</td>
											</tr>
											{/foreach}
										</tbody>
									</table>
									<br>
										{if $group_id!='18'}
				                    		<div class="no_data_block">
												<a href="/clientAccount/preset_car/{$ticket_info.id}" target="_blank">
													<span>Перейти к подбору</span>
												</a>
											</div>
										{/if}
								</div>
								{/if}
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

	<div id="addWishCarToTicket" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Добавление ТС к заявке</h4>
					<input type="hidden" id="wishid_edit">
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Тип ТС</span>
								<select id="type_ts_new" onchange="ts_type_onchange_new();">
									<option value="">Не выбрано</option>
									{foreach item=ts key=key from=$type_ts}
									<option value="{$ts}">{$ts}</option>
									{/foreach}
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Марка</span>
								<div id="mark_ts_new"></div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Модель</span>
								<div id="model_ts_new"></div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Цвет TC</span>
								<input type="text" id="color_ts_new">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Кол-во мест</span>
								<input type="text" id="count_places_new">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Начало аренды</span>
								<input type="text" class="picker_usial" id="begin_arenda_ts_new">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Окончание аренды</span>
								<input type="text" class="picker_usial" id="end_arenda_ts_new">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Время начала</span>
								<input type="text" class="mask_time" id="begintime_arenda_ts_new">
							</div>
						</div>
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Время окончания</span>
								<input type="text" class="mask_time" id="endtime_arenda_ts_new">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Маршрут</span>
								<textarea id="route_desc_ts_new"></textarea>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Аналог</span>
								<select id="analog_ts_new">
									<option value=""></option>
		                            <option value="y">Да</option>
		                            <option value="n">Нет</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Кол-во ТС</span>
								<input type="text" id="count_ts_new">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Комментарий по ТС</span>
								<textarea id="comment_ts_new"></textarea>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="checkbox">
								<label>
									<input type="checkbox" id="auto_without_driver_new"> Авто без водителя
								</label>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="checkbox">
								<label>
									<input type="checkbox" id="transfer_ts_new"> Трансфер
								</label>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" onclick="addLineOfArr();">Сохранить</button>
				</div>	
			</div>
		</div>
	</div>

	<div id="modalEdit" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Редактирование автомобиля в заявке</h4>
					<input type="hidden" id="wishid_edit">
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Тип ТС</span>
								<select id="type_ts" onchange="ts_type_onchange();">
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Марка</span>
								<div id="mark_ts"></div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Модель</span>
								<div id="model_ts"></div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Цвет TC</span>
								<input type="text" id="color_ts">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Кол-во мест</span>
								<input type="text" id="count_places_ts">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Начало аренды</span>
								<input type="text" class="picker_usial" id="begin_arenda_ts">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Окончание аренды</span>
								<input type="text" class="picker_usial" id="end_arenda_ts">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Время начала</span>
								<input type="text" class="mask_time" id="begintime_arenda_ts">
							</div>
						</div>
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Время окончания</span>
								<input type="text" class="mask_time" id="endtime_arenda_ts">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Маршрут</span>
								<textarea id="route_desc_ts"></textarea>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Аналог</span>
								<select id="analog_ts">
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Кол-во ТС</span>
								<input type="text" id="count_ts">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Комментарий по ТС</span>
								<textarea id="comment_ts"></textarea>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="checkbox">
								<label>
									<input type="checkbox" id="auto_without_driver"> Авто без водителя
								</label>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="checkbox">
								<label>
									<input type="checkbox" id="transfer_ts"> Трансфер
								</label>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" onclick="editLineOfArr();">Сохранить</button>
				</div>	
			</div>
		</div>
	</div>

	<div id="editSettedTS" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Корректировки к прикрепленному ТС <b id="nameTSedit"></b></h4>
					<input type="hidden" id="partner_id_setted">
				</div>
				<div class="modal-body">
					<div class="con_route_partner">
						<div id="blocks_partner"></div>
					</div>
					<br>
					<div class="row">
						<div class="col-md-12 col-lg-6">
							<div class="input-group">
								<span class="input-group-addon" style="background-color: #8610d4 !important; color: #fff !important;">Итого к выплате с учетом корректировок</span>
								<input type="text" class="form-control" id="endPriceSettedTS">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-lg-5">
							<div class="input-group">
								<span class="input-group-addon">Договоренность по оплате</span>
								<input type="text" id="predoplata_setted_ts">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-lg-6">
							<div class="input-group">
								<span class="input-group-addon">Форма оплаты</span>
								<select id="form_payment_partner">
									<option value="">Не выбрано</option>
									<option value="Наличные">Наличные</option>
									<option value="Карта">Карта</option>
									<option value="Безналичный с НДС">Безналичный с НДС</option>
									<option value="Безналичный без НДС">Безналичный без НДС</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-lg-5">
							<div class="input-group">
								<span class="input-group-addon">Имя водителя</span>
								<input type="text" class="form-control" id="nameDrSettedTS">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-lg-5">
							<div class="input-group">
								<span class="input-group-addon">Телефон водителя</span>
								<input type="text" class="form-control phone_mask" id="phoneDrSettedTS">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12 col-lg-5">
							<div class="input-group">
								<span class="input-group-addon">Гос Номер</span>
								<input type="text" class="form-control" id="gosNomerSettedTS">
							</div>
						</div>
					</div>
					<input type="hidden" id="idCarEdit">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn_red"  style="float:right;"  onclick="editSettedTS();">Сохранить</button>
				</div>
			</div>
		</div>
	</div>

	<div id="removeSettedTS" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Снятие с заявки ТС <b id="nameTSremove"></b></h4>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12">
							<div class="alert alert-warning">
								<strong>Внимание!</strong><span>Вы точно хотите снять <b id="nameTS"></b> с заявки.</span>
							</div>
							<input type="hidden" id="idCarRemove">
							<input type="hidden" id="wishCar">
							<input type="hidden" id="car_id_setted">
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Введите комментарий:</span>
								<textarea id="comment_delete"></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" onclick="removeSettedTS();">Сохранить</button>
				</div>
			</div>
		</div>
	</div>

	<div id="modalCommentTicket" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
	        		<h4 class="modal-title">Комментарий по заявке</h4>
	        		<input type="hidden" id="type_callback_client">
	        		<input type="hidden" id="id_callback_client">
				</div>
				<div class="modal-body">
					<ul class="nav nav-tabs">
					  <li><a data-toggle="tab" href="#fin_client">Каллбеки с клиентом</a></li>
					</ul>
					<div class="tab-content">
						<div id="fin_client" class="tab-pane fade in active">
							<div class="row">
								<div class="col-md-12">
									<div class="x_panel">
										<div class="row">
											<div class="col-lg-6">
												<div class="input-group">
													<span class="input-group-addon">Комментарий</span>
													<textarea id="comment_fin"></textarea>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-6">
												<div class="input-group">
													<span class="input-group-addon">Дата перезвона</span>
													<input type="text" class="picker_time" id="data_call_fin">
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-6">
												<div class="input-group">
													<span class="input-group-addon">Статус заявки</span>
													<select id="status_ticket" class="form-control" onchange="reasonCancelShow();">
														<option value="">Не выбран</option>
														{foreach item=status key=key from=$status_procat}
											  			<option value="{$status}">{$status}</option>
											  			{/foreach}
													</select>
												</div>
											</div>
											<div class="rateClosedTicket">
												<div class="col-lg-6">
													<div class="input-group">
														<span class="input-group-addon">Оценка работы</span>
														<select id="rate_ticket">
															<option value="" selected>Не выбрано</option>
															<option value="Отлично">Отлично</option>
															<option value="Хорошо">Хорошо</option>
															<option value="Удовлетворительно">Удовлетворительно</option>
															<option value="Неудовлетворительно">Неудовлетворительно</option>
														</select>
													</div>
												</div>
											</div>
											<div class="reason_cancel_block">
												<div class="col-lg-6">
													<div class="input-group">
														<span class="input-group-addon">Причина отказа</span>
														<select id="reason_cancel">
															<option value="" selected></option>
															<option value="Дорого">Дорого</option>
															<option value="Нет авто">Нет авто</option>
															<option value="Перезвонит сам">Перезвонит сам</option>
															<option value="Не дозвониться">Не дозвониться</option>
															<option value="Не актуальн">Не актуально</option>
															<option value="Заказали у конкурента">Заказали у конкурента</option>
															<option value="Отмена заказа">Отмена заказа</option>
															<option value="Иное">Иное</option>
														</select>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<button class="btn btn_blue" style="float: right;" onclick="sendFinCallbackClient();">Сохранить</button>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div id="fin_callback_history_client">
										<table class="table">
											<thead>
												<th>Дата разговора</th>
												<th>Дата каллбека</th>
												<th>Тип предоплаты</th>
												<th>Сумма</th>
												<th>Форма оплаты</th>
												<th>Комментарии</th>
												<th>Callback оставил</th>
												<th></th>
											</thead>
											<tbody>
												{foreach item=finclient key=key from=$list_callback_finclient}
													<tr>
														<td>{$finclient.date_add}</td>
														<td>{$finclient.date_callback}</td>
														<td>{$finclient.preorder_type}</td>
														<td>{$finclient.summ}</td>
														<td>{$finclient.payment_form}</td>
														<td>{$finclient.comment}</td>
														<td>{$finclient.name_face}</td>
														<td><i class="fa fa-pencil" data-id_callback="{$finclient.id}" style="cursor: pointer;" onclick="getCallClientForEdit(this);"></i></td>
													</tr>
												{/foreach}
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>	
					</div>
				</div>
				<div class="modal-footer">
				</div>
			</div>
		</div>
	</div>

	<div id="confirmedTSProcatModal" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Согласованное ТС</h4>
					<input type="hidden" id="confirmForWishCar">
					<input type="hidden" id="typeSaveRoute">
					<input type="hidden" id="idLineRoute">
				</div>
				<div class="modal-body">
					<button id="buttonAddRoute" class="btn btn_blue" style="float: right;" type="button">Добавить маршрут</button>
					<div class="row x_panel route_block">
						<div class="col-lg-12">
							<div class="row">
								<div class="col-md-12 col-lg-4">
									<div class="input-group">
										<span class="input-group-addon">ТС</span>
										<select id="type_ts_comm_off_confirm">
											<option value=""></option>
											{foreach item=type key=key from=$type_ts}
											<option value="{$type}">{$type}</option>
											{/foreach}
										</select>
									</div>
								</div>
								<div class="col-md-12 col-lg-4">
									<div class="input-group">
										<span class="input-group-addon">Марка</span>
										<div id="marka_ts_confirm">
											<select id="marka_ts_sel_confirm">
												<option value="">Не выбрана</option>
												{foreach item=mark key=key from=$marka_list}
												<option value="{$mark}">{$mark}</option>
												{/foreach}
											</select>
										</div>
										<div id="marka_bus_confirm">
											<select id="marka_bus_sel_confirm">
												<option value="">Не выбрана</option>
											</select>
										</div>
										<div id="marka_usual_confirm">
											<input id="marka_usual_sel_confirm" type="text" value="">
										</div>
									</div>
								</div>
								<div class="col-md-12 col-lg-4">
									<div class="input-group">
										<span class="input-group-addon">Модель</span>
										<div id="model_ts_box_confirm">
											<select id="model_ts_sel_confirm">
												<option value=""></option>
											</select>
										</div>
										<div id="model_bus_confirm">
											<select id="model_bus_sel_confirm">
												<option value=""></option>
											</select>
										</div>
										<div id="model_usual_confirm">
											<input id="model_usual_sel_confirm" type="text" value="">
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Цена за проект/Цена за услугу</span>
										<input type="text" id="priceTSCommOffer_confirm">
									</div>
								</div>
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Форма оплаты</span>
										<select id="formPaymentCommercOffer_confirm" class="form-control">
											<option value=""></option>
											<option value="Наличные" {if $ticket_info.form_payment == 'Наличные'}selected{/if}>Наличные</option>
											<option value="Карта" {if $ticket_info.form_payment == 'Карта'}selected{/if}>Карта</option>
											<option value="Безналичный с НДС" {if $ticket_info.form_payment == 'Безналичный с НДС'}selected{/if}>Безналичный с НДС</option>
											<option value="Безналичный без НДС" {if $ticket_info.form_payment == 'Безналичный без НДС'}selected{/if}>Безналичный без НДС</option>
										</select>
									</div>
								</div>
							</div>
							<div class="row">
								<!-- <div class="col-md-12 col-lg-6">
									<div class="checkbox">
										<label>
											<input type="checkbox" id="transfer_confirmed"> {if $cars.auto_without_driver == 'Да'}в сутки{else}Трансфер{/if}
										</label>
									</div>
								</div> -->
								<div class="col-md-12 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">Услуги</span>
										<select id="services_ticket">
											<option value="">Не выбрано</option>
											{foreach item=service key=key from=$list_services}
												<option value="{$service}">{$service}</option>
											{/foreach}
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-12">
							<hr>
							<div class="row">
								<div class="col-md-6">
									<div class="input-group">
										<span class="input-group-addon">Дата</span>
										<input type="text" id="data_route" class="picker_usial" >
									</div>
								</div>
								<div class="col-md-6">
									<div class="input-group">
										<span class="input-group-addon">Часы подачи:</span>
										<input type="text" id="addHours_route">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-6">
									<div class="input-group">
										<span class="input-group-addon">Начало</span>
										<input type="text" id="begintime_route" class="mask_time" >
									</div>
								</div>
								<div class="col-md-6">
									<div class="input-group">
										<span class="input-group-addon">Окончание</span>
										<input type="text" id="endtime_route" >
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Маршрут</span>
										<textarea id="route_desc"></textarea>
									</div>
								</div>
								<div class="col-md-12">
									<label>
										<input type="checkbox" id="itwasaday_route"> Считать, как сутки
									</label>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<button type="button" class="btn btn_blue" onclick="addRoute();" style="float:right;">Сохранить</button>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="row">
								<div class="col-md-12">
									<h2>Согласованный маршрут</h2>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="block_confirmed_waylists">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<!-- <button type="button" class="btn_blue" onclick="formFromRouteToWaylist();">Перевести маршруты в путевые листы</button> -->
					<button type="button" style="float: right;" class="btn btn_red" onclick="window.location.reload();">Сохранить</button>
				</div>
			</div>
		</div>
	</div>

	<div id="callbackWithPartner" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h2>Callback with partner</h2>
					<input type="hidden" id="partner_id">
					<input type="hidden" id="setted_car_id">
					<input type="hidden" id="type_callback_partner">
					<input type="hidden" id="id_callback_partner">
					<input type="hidden" id="last_partner_callback">
				</div>
				<div class="modal-body">
					<ul class="nav nav-tabs">
					  <li><a data-toggle="tab" href="#fin_partner">Callback с партнером</a></li>
					</ul>
					<div class="tab-content">
						<div id="fin_partner" class="tab-pane fade in active">
							<div class="row">
								<div class="col-md-12">
									<div class="x_panel">
										<div class="row">
											<div class="col-lg-6">
												<div class="input-group">
													<span class="input-group-addon">Комментарий</span>
													<textarea id="comment_finpartner"></textarea>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-6">
												<div class="input-group">
													<span class="input-group-addon">Статус партнера</span>
													<select id="partner_statuses" class="form-control">
														<option value="">Не выбран</option>
														{foreach item=status key=key from=$partner_statuses}
														<option value="{$status}">{$status}</option>
														{/foreach}
													</select>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-lg-6">
												<div class="input-group">
													<span class="input-group-addon">Дата перезвона</span>
													<input type="text" class="picker_time" id="data_call_finpartner">
												</div>
											</div>
										</div>
										<div class="row">
											<button class="btn btn_blue" style="float: right;" onclick="sendFinCallbackPartner();">Сохранить</button>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="finpartner_callbacks"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
				</div>
			</div>
		</div>
	</div>

	<div id="preprintTicketPresetWaylist" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Предпечать Заявки</h4>
					<input type="hidden" id="partnerid">
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Договор для: </span>
								<select id="dfor">
									<option value="client" selected>Клиенту</option>
									<option value="partner">Партнеру</option>
								</select>
							</div>
						</div>
					</div>
					<div class="row show_partner">
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Партнер</span>
								<select id="partner_print_id" onchange="show_partner_req_list();">
									<option value=""></option>
									{foreach item=owner key=key from=$listOwner}
									<option value="{$owner.id}">{$owner.name}</option>
									{/foreach}
								</select>
							</div>
						</div>
					</div>
					<div class="row p_req">
						<div class="col-md-6">
							<div class="input-group">
								<span class="input-group-addon">Реквизиты партнера</span>
								<select id="list_req_partner"></select>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn_blue" onclick="print_preset_waylist();">Печать</button>
				</div>
			</div>
		</div>
	</div>

	<div id="pickTicketToUrFace" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Прикрепить заявку к юридическому лицу</h4>
				</div>
				<div class="modal-body">
					<div class="row" id="formChooseUrFace">
						<div class="col-md-12">
							<button type="button" class="btn btn_blue" id="addNewUrFace">Добавить лицо</button>
							<hr><strong>или</strong><br>
							<div class="input-group">
								<span class="input-group-addon">Выбрать лицо</span>
								<select name="id_face" id="face_id" onchange="pickUrFaceToTicket();">
									<option value="" selected>Не выбран</option>
									{foreach item=face key=key from=$urface}
									<option value="{$face.id}">{$face.nickname}</option>
									{/foreach}
								</select>
							</div>
						</div>
					</div>
					<div class="row" id="formAddNewUrFace">
						<div class="col-md-12 col-lg-6">
<!-- 							<div class="row">
								<div class="col-md-12">
									<div class="input-group" id="field_login_for_user">
										<span class="input-group-addon">Логин</span>
										<input type="text" id="loginurface">
									</div>
								</div>
							</div> -->
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Наименование лица</span>
										<input type="text" id="nameurface">
									</div>
								</div>
							</div>
							<div class="row">
								<button type="button" class="btn btn_blue" onclick="addUrFace();">Добавить</button>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
				</div>
			</div>
		</div>
	</div>

	<div id="editAccountOfTicket" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Редактирование данных по заказчику</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12">
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Наименование компании</span>
										<input type="text" id="nickname_client">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Контактное лицо</span>
										<input type="text" id="contact_face_name">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Телефон</span>
										<input type="text" id="phone_client" class="phone_mask">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">E-mail</span>
										<input type="text" id="email_client">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Форма оплаты</span>
										<select id="form_payment_client">
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
										<span class="input-group-addon">Бюджет Клиента</span>
										<input type="text" id="client_budget">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Город</span>
										<select id="ticket_city">
											<option value=""></option>
											<option value="Санкт-Петербург">Санкт-Петербург</option>
											<option value="Москва">Москва</option>
										</select>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Откуда вы о нас узнали?</span>
										<select id="came_from">
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
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn_blue" onclick="editAcccountTicketData();">Сохранить</button>
				</div>
			</div>
		</div>
	</div>

	<div id="formRequisitesForFizFace" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Реквизиты физ. лица</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12 col-lg-6">
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">ФИО: </span>
										<input type="text" id="fio_fiz" value="{$getFizFaceRequisites.fio}">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Номер паспорта: </span>
										<input type="text" id="np_fiz" value="{$getFizFaceRequisites.nomer_passport}">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Серия паспорта: </span>
										<input type="text" id="sp_fiz" value="{$getFizFaceRequisites.seria_passport}">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Дата выдачи: </span>
										<input type="text" class="picker_usial" id="dg_fiz" value="{$getFizFaceRequisites.data_get}">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Дата рождения: </span>
										<input type="text" class="picker_usial" id="db_fiz" value="{$getFizFaceRequisites.data_born}">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Кем выдан: </span>
										<input type="text" id="wg_fiz" value="{$getFizFaceRequisites.who_give}">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Код подразделения: </span>
										<input type="text" id="cp_fiz" value="{$getFizFaceRequisites.code_podraz}">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Место прописки: </span>
										<textarea id="lr_fiz">{$getFizFaceRequisites.location_reg}</textarea>
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Место рождения: </span>
										<input type="text" id="pb_fiz" value="{$getFizFaceRequisites.placeborn}">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn_blue" onclick="saveFizFaceRequisites();">Сохранить</button>
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

	<div id="calculator" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h2>Калькулятор</h2>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-6">
							<div class="row">
								<div class="col-md-12">
									<div class="display_calculate_block">
										<!-- <p class="text_block"></p> -->
										<input type="text" id="text_block">
									</div>
								</div>
							</div>
							<div id="calculator_button_block">
								<div class="row">
									<div class="col-md-12">
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>9</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>8</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>7</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='sign'>/</button>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>4</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>5</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>6</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='sign'>*</button>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>1</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>2</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>3</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='sign'>-</button>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<button type="button" class="btn btn_blue calculate_btn" data-type='percent'>%</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='number'>0</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='sign'>+</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type='calculate'>=</button>
									</div>
								</div>
								<div class="row">
									<div class="col-md-6">
										<button type="button" class="btn btn_blue calculate_btn" data-type="cancel">Сброс</button>
										<button type="button" class="btn btn_blue calculate_btn" data-type="backstep"><i class="fa fa-long-arrow-left fa-lg"></i></button>
									</div>
								</div>
							</div>
						</div>
					</div>
					<hr>
					<div class="row">
						<div class="col-md-7 col-lg-6">
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Сумма заказа</span>
										<input type="text" id="price_event">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Налоговый процент</span>
										<input type="text" id="nalog_percent">
									</div>
								</div>
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Наша надбавка</span>
										<input type="text" id="our_percent">
									</div>
								</div>
								<div class="col-md-12">
									<div id="result_calculating"></div>
								</div>
								<div class="col-md-12">
									<button type="button" class="btn btn_blue" onclick="calculate_summ();">Посчитать</button>
								</div>
							</div>
						</div>
					</div>	
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn_blue" data-dismiss="modal">Закрыть</button>
				</div>
			</div>
		</div>
	</div>

	<div id="setPaymentInfo" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Добавить платеж</h4>
					<input type="hidden" id="payment_from">
					<input type="hidden" id="type_operation">
					<input type="hidden" id="editlinepay">
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Платеж</span>
								<select id="stream">
									<option value="" selected></option>
									<option value="In">Входящий</option>
									<option value="Out">Исходящий</option>
								</select>
							</div>
						</div>
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Тип платежа</span>
								<select id="type_pay">
									<option value="" selected></option>
									<option value="Полная">Полная</option>
									<option value="Частичная">Частичная</option>
									<option value="Водителю без АК">Водителю без АК</option>
									<option value="Водителю с АК">Водителю с АК</option>
									<option value="АК">АК</option>
								</select>
							</div>
						</div>
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Форма платежа</span>
								<select id="form">
									<option value=""></option>
									<option value="Наличные">Наличные</option>
									<option value="Карта">Карта</option>
									<option value="Безналичный с НДС">Безналичный с НДС</option>
									<option value="Безналичный без НДС">Безналичный без НДС</option>
								</select>
							</div>
						</div>
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Дата платежа</span>
								<input type="text" id="data" class="picker_time">
							</div>
						</div>
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Сумма</span>
								<input type="text" id="summ">
							</div>
						</div>
						<div class="col-md-12">
							<div class="input-group">
								<span class="input-group-addon">Комментарий</span>
								<textarea id="comment_payment"></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn_blue" onclick="savePaymentInfo();" style="float: right;">Сохранить</button>
				</div>
			</div>
		</div>
	</div>

	<div id="createCabinetForFizFace" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4>Прикрепить заявку к кабинету Физ. лица</h4>
				</div>
				<div class="modal-body">
					<div class="row" id="create_or_pin_block">
						<div class="col-lg-12">
							<button type="button" class="btn btn_blue" id="addNewFizFace">Создать кабинет</button>
							<hr><strong>или</strong><br>
							<div class="input-group">
								<span class="input-group-addon">Выбрать физ. лицо</span>
								<select name="id_face_fiz" id="face_fiz_id" onchange="pickFizFaceToTicket();">
									<option value="" selected>Не выбран</option>
									{foreach item=face key=key from=$fizface}
									<option value="{$face.id}">{$face.nickname}</option>
									{/foreach}
								</select>
							</div>
						</div>
					</div>
					<div class="row" id="create_cabinet_for_fiz_face" style="display: none;">
						<input type="hidden" id="email_fiz_face" value="{$ticket_info.email}">
						<div class="col-lg-12">
							<div class="input-group">
								<span class="input-group-addon">Телефон</span>
								<input type="text" id="loginfizface">
							</div>
						</div>
						<div class="col-lg-12">
							<div class="input-group">
								<span class="input-group-addon">Имя/Физ лица</span>
								<input type="text" id="nickfizface">
							</div>
						</div>
						<div class="col-lg-12">
							<button type="button" class="btn_blue" onclick="addFizFace();">Сохранить</button>
							<button type="button" class="btn btn_blue" data-dismiss="modal">Закрыть</button>
						</div>
					</div>
				</div>
				<div class="modal-footer"></div>
			</div>
		</div>
	</div>

<script type="text/javascript">


	    var leftoperand="";
		var rightoperand="";
		var operation="";
		var last_success_key = "";

	function addLineOfArr(){
		var auto_without_driver = $('#auto_without_driver_new:checked').val();
		var transfer_ts = $('#transfer_ts_new:checked').val();
		var arrayAddLine = {};
    	arrayAddLine.type_ts = $('#type_ts_new option:selected').val();
    	arrayAddLine.mark_ts = $('#sel_mark_val option:selected').val();
    	arrayAddLine.model_ts = $('#sel_model_val option:selected').val();
    	arrayAddLine.begin = $('#begin_arenda_ts_new').val();
    	arrayAddLine.end = $('#end_arenda_ts_new').val();
    	arrayAddLine.begintime = $('#begintime_arenda_ts_new').val();
    	arrayAddLine.endtime = $('#endtime_arenda_ts_new').val();
    	arrayAddLine.route_desc_ts = $('#route_desc_ts_new').val();
    	arrayAddLine.analog = $('#analog_ts_new').val();
    	arrayAddLine.countts = $('#count_ts_new').val();
    	arrayAddLine.commentts = $('#comment_ts_new').val();
    	arrayAddLine.ticket_id = $('#ticket_id').val();
    	arrayAddLine.color_ts = $('#color_ts_new').val();
    	arrayAddLine.count_places = $('#count_places_new').val();
    	arrayAddLine.auto_without_driver = (auto_without_driver == 'on')?'y':'n';
    	arrayAddLine.transfer_ts = (transfer_ts == 'on')?'y':'n';
    	console.log(arrayAddLine);
    	{literal}
    		$.ajax({
    				type:'POST',
    				url:'/core/ajax/ajaxForAutoClass.php',
    				data:{action:'addWishCarLine',arrayAddLine:arrayAddLine},
    				cache:false,
    				success:function(responce){
    					window.location.reload();
    					//console.log(responce);
    				}
    		});
    	{/literal}
	}

	function getThisTicketInWork(){
		var control_id = {$user_id};
		var ticket_id = $('#ticket_id').val();
		{literal}
			$.ajax({
					type:'POST',
					url: '/core/ajax/ajaxForAutoClass.php',
					data:{action:'setInController',control_id:control_id,ticket_id:ticket_id},
					cache:false,
					success:function(respnce){
						window.location.reload();
					}
			});
		{/literal}
	}

	function editLine(e){
		var lineKey = e.dataset['keyline'];
		{literal}
			$.ajax({
					type:'POST',
					url: '/core/ajax/ajaxForAutoClass.php',
					data:{action:'editLineCarList',key:lineKey},
					cache:false,
					success: function(responce){
						var result_arr = JSON.parse(responce);
						//console.log(result_arr);
						$('#wishid_edit').val(lineKey);
						type_ts_car(result_arr['type_ts']);
						type_mark_car(result_arr['type_ts'],result_arr['mark_ts']);
						type_model_car(result_arr['type_ts'],result_arr['mark_ts'],result_arr['model_ts']);
						$('#ts_wishcar_type').val(result_arr['type_ts']);
						$('#ts_wishcar_mark').val(result_arr['mark_ts']);
						$('#ts_wishcar_model').val(result_arr['model_ts']);
						$('#begin_arenda_ts').val(result_arr['begin_procat']);
						$('#begintime_arenda_ts').val(result_arr['begin_time']);
						$('#count_places_ts').val(result_arr['count_places']);
						$('#color_ts').val(result_arr['color_ts']);
						$('#end_arenda_ts').val(result_arr['end_procat']);
						if(result_arr['transfer'] == 'y'){
						}else{
							$('#endtime_arenda_ts').val(result_arr['end_time']);
						}
						$('#route_desc_ts').val(result_arr['route']);					
						type_analog(result_arr['analog']);
						$('#count_ts').val(result_arr['count_ts']);
						$('#comment_ts').val(result_arr['comment_ts']);
						if(result_arr['transfer'] == 'y'){
							$('#transfer_ts').prop('checked',true);
						}
						
					}
			});
		{/literal}
	}

	function type_ts_car(type){
		var t_ts = type;
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'selectTypeTS',type:t_ts},
					cache:false,
					success: function(responce){
						$('#type_ts').html(responce);
					}
			});
		{/literal}
	}

	function type_mark_car(type,mark){
		var t_ts = type;
		var mark_ts = mark;
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'selectMarkTS',type:t_ts,mark:mark_ts},
					cache:false,
					success: function(responce){
						$('#mark_ts').html(responce);
					}
			});
		{/literal}
	}

	function type_model_car(type,mark,model){
		var t_ts = type;
		var mark_ts = mark;
		var model_ts = model;
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'selectModelTS',type:t_ts,mark:mark_ts,model:model_ts},
					cache:false,
					success: function(responce){
						$('#model_ts').show();
						$('#model_ts').html(responce);
					}
			});
		{/literal}
	}

	function type_mark_car_new(type,mark){
		var t_ts = type;
		var mark_ts = mark;
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'selectMarkTSnew',type:t_ts,mark:mark_ts},
					cache:false,
					success: function(responce){
						$('#mark_ts_new').html(responce);
					}
			});
		{/literal}
	}

	function getModelBlock(){
		var mark = $('#marka_ts option:selected').val();
		var type_ts = $('#type_ts_new option:selected').val();
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajaxForAutoClass.php',
				data:{action:'getModelBlock',mark,type_ts},
				cache:false,
				success:function(responce){
					$('#model_ts_new').html(responce);
				}
			});
		{/literal}
	}

	function type_model_car_new(type,mark,model){
		var t_ts = type;
		var mark_ts = mark;
		var model_ts = model;
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'selectModelTS',type:t_ts,mark:mark_ts,model:model_ts},
					cache:false,
					success: function(responce){
						$('#model_ts_new').show();
						$('#model_ts_new').html(responce);
					}
			});
		{/literal}
	}

	function type_analog(anal){
		var analog = anal;
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'analog',analog:analog},
					cache:false,
					success: function(responce){
						$('#analog_ts').html(responce);
						//console.log(responce);
					}
			});
		{/literal}
	}

	function getWaylistProcat(e){
		var id_waylist = e.dataset['idwaylist'];
		var key = e.dataset['block'];
		$('#wayListId_'+key).val(id_waylist);
		$('#data_event_'+key).val(e.dataset['dataevent']);
		if(e.dataset['itwasaday'] == 'y'){
			$('#itwasaday_'+key).prop("checked",true);
		}
		$('#begin_event_'+key).val(e.dataset['beginevent']);
		$('#end_event_'+key).val(e.dataset['endevent']);
		$('#place_get_'+key).val(e.dataset['placeget']);
		$('#place_out_'+key).val(e.dataset['placeout']);
		$('#linkedList_'+key+' option[value="'+e.dataset['idcar']+'"]').prop('selected',true);
		$('.form_waylist_procat_'+key).show();
		$('#wayListType_'+key).val('edit');
	}

	function editWaylistProcat(e){
		var key = e;
		var id_waylist = $('#wayListId_'+key).val();
		var data_event = $('#data_event_'+key).val();
		var itwasaday = $('#itwasaday_'+key).val();
		var begintime = $('#begin_event_'+key).val();
		var endtime = $('#end_event_'+key).val();
		var placeget = $('#place_get_'+key).val();
		var placeout = $('#place_out_'+key).val();
		var wishid = $('#wishidforwaylist_'+key).val();
		var settedTS = $('#linkedList_'+key+' option:selected').val();
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'editWaylistProcat',id:id_waylist,data_event:data_event,itwasaday:itwasaday,begintime:begintime,endtime:endtime,placeget:placeget,placeout:placeout,settedTS:settedTS, wishid:wishid},
					cache:false,
					success:function(responce){
						window.location.reload();
					}
			});
		{/literal}
	}

	function deleteWaylistProcat(e){
		var id_waylist = e.dataset['idwaylist'];
		var key = e.dataset['block'];
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'deleteWaylistProcat',id:id_waylist},
					cache:false,
					success:function(responce){
						window.location.reload();
						//console.log(responce);
					}
			});
		{/literal}
	}

	function pickCarToWishes(){
		var car_id = $('#car_id').val();
		var carWishId = $('#carWishId').val();
		var begin_work = $('#data_begin_work').val();
		var end_work = $('#data_end_work').val();
		if((car_id!='')&&(carWishId!='')&&(begin_work!='')&&(end_work!='')){
			{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'pickCarToProcat',car_id:car_id,carWishId:carWishId,begin_work:begin_work,end_work:end_work},
				cache:false,
				success:function(responce){
					//console.log(responce);
					window.location.reload();
				}

			});
			{/literal}
		}else{
			alert('Имееются не заполненные поля! Заполните их для продолжения');
		}
	}

	function saveWaylistProcat(e){
		var type = $('#wayListType_'+e).val();
		if(type == 'edit'){
			editWaylistProcat(e);
		}else if(type == 'add'){
			addWaylistProcat(e);
		}	
	}

	function searchAuto(){
		var cl_ts = $('#class_list option:selected').val();
		var	m_ts = $('#mark_list option:selected').text();
		var mod_ts = $('#model_list option:selected').val();
		var class_ts = ((cl_ts!=null)&&(cl_ts!=undefined))?cl_ts:'';
		var mark_ts = ((m_ts!=null)&&(m_ts!=undefined))?m_ts:'';
		var model_ts = ((mod_ts!=null)&&(mod_ts!=undefined))?mod_ts:'';

		{literal}
			$.ajax({
				type:"POST",
				url:"/core/ajax/ajaxForAutoClass.php",
				data:{action:'searchCarsForProcat',class_ts:class_ts,mark_ts:mark_ts,model_ts:model_ts},
				cache: false,
				success: function(responce){
					$('#result_search_ts').html(responce);
				}
			});
		{/literal}
	}

	$('#class_list').on('change',function(){
        var class_n = $('#class_list option:selected').val();
        getMarks(class_n);
    });

    function getMarks(class_val){
        var class_name = class_val;
        {literal}
            $.ajax({
                type: "POST",
                url: "/core/ajax/ticket_ajax.php",
                data: {action:'getMarkByClass',class_name:class_name},
                cache: false,
                success: function(responce){
                    $('#mark_list').html(responce);
                }
            });
        {/literal}
    }

    function select_Model_zayvka(){
        var mark = $('#mark_list option:selected').text();
        var class_name = $('#class_list option:selected').val();
        var model = '';
        //alert(mark);
        {literal}
         $.ajax({
             type: "POST",
             url: "../../core/ajax/ajaxForAutoClass.php",
             data: { action: 'searchModel' , mark: mark , model:model,class_name:class_name},
             cache: false,
             success: function (responce){$('#model_list').html(responce);}
         });
        {/literal}
    }

    function getString(e){
    	$('#car_id').val(e.dataset['id']);

    	var sinko = e.parentNode;
        var papka = sinko.parentNode;
        var otche = papka.parentNode;
        for (var i=0;i<otche.children.length;i++){
            otche.children[i].style.cssText="";
        }
        papka.style.cssText="background-color: #60c57b; \
        color: #fff !important; \
        ";
    }

    function showWayList(e){
        $('.form_waylist_procat_'+e).show();
        $('#wayListType_'+e).val('add');
    }

    $('.picker_usial').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:  '{$date_current}',
        format:'d.m.Y',
        timepicker:false
    });

    //dont understand how it should work

    $('.picker_time').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:  '{$date_current}',
        format:'d.m.Y H:i'
    });

    $('#count_hours').on('change',function(){
    	var price = $('#priceSettedTS').val();
    	var h = $('#count_hours').val();
    	var h_ad = $('#count_hours_add').val();
    		getSummPriceTS(price,h,h_ad,'setted');
    });

    $('#count_hours_add').on('change',function(){
    	var price = $('#priceSettedTS').val();
    	var h = $('#count_hours').val();
    	var h_ad = $('#count_hours_add').val();
    		getSummPriceTS(price,h,h_ad,'setted');
    });

    $('#priceSettedTS').on('change',function(){
    	var price = $('#priceSettedTS').val();
    	var h = $('#count_hours').val();
    	var h_ad = $('#count_hours_add').val();
    		getSummPriceTS(price,h,h_ad,'setted');
    });

    function editSettedTS(){
    	var id_edit = $('#idCarEdit').val();
    	var partner_id = $('#partner_id_setted').val();
    	var priceSettedTS = $('#priceSettedTS').val();
    	var endPriceSettedTS = $('#endPriceSettedTS').val();
    	var count_hours = $('#count_hours').val();
    	var count_hours_add = $('#count_hours_add').val();
    	var nameDrSettedTS = $('#nameDrSettedTS').val();
    	var phoneDrSettedTS = $('#phoneDrSettedTS').val();
    	var gosNomerSettedTS = $('#gosNomerSettedTS').val();
    	var predoplata_uslovia = $('#predoplata_setted_ts').val();
    	var form_payment_partner = $("#form_payment_partner option:selected").val();
    	var array_prices = $(".priceForRoute");
    	var arr_length = array_prices.length;

    	var checked_route = [];
    	var unchecke_route = [];

    	{literal}
    	$('input[name="routeVerifPartnerList"]').each(function(){
    		if($(this).prop('checked') == true){
    			checked_route.push($(this).val());
    		}else{
    			unchecke_route.push($(this).val());
    		}
		});

		var line_checked_route = checked_route.join("|");
		var line_unchecked_route = unchecke_route.join("|");
    	

		$.ajax({
			type:'POST',
			url:'/core/ajax/ajaxForAutoClass.php',
			data:{action:'editSettedTS',id_edit:id_edit,price:priceSettedTS,namedr:nameDrSettedTS,phonedr:phoneDrSettedTS,count_hours:count_hours,count_hours_add:count_hours_add,endPriceSettedTS:endPriceSettedTS,gosNomerSettedTS:gosNomerSettedTS, predoplata_uslovia:predoplata_uslovia,line_checked_route:line_checked_route,line_unchecked_route:line_unchecked_route,partner_id:partner_id,form_payment_partner:form_payment_partner},
			cache:false,
			success:function(responce){
				last_success_key = "money_key_"+(arr_length - 1);
				for(var i = 0; i<arr_length;i++){
		    		var tr = $(array_prices[i]).data('tr');
		    		var car_id = $(array_prices[i]).data('car_id');
		    		var selector = $(array_prices[i]).data('selector');
		    		var route_id = $(array_prices[i]).data('route_id');
		    		savePartnerRouteList(tr,car_id,selector,route_id);
		    	}
			}
		});
    	{/literal}   
    }

    function removeSettedTS(){
    	var id_remove = $('#idCarRemove').val();
    	var wishCar_id = $('#wishCar').val();
    	var comment_remove = $('#comment_delete').val();
    	var ticket_id = $("#ticket_id").val();
    	var setted_car_id = $('#car_id_setted').val();
    	
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'removeSettedTS',id_remove:id_remove,id_wish:wishCar_id, comment_remove:comment_remove,ticket_id:ticket_id,setted_car_id:setted_car_id},
    			cache:false,
    			success:function(responce){
    				window.location.reload();
    				//console.log(responce);
    			}
    		});
    	{/literal}
    }

    function showModelEditTS(e){
    	var namets = e.dataset['namets'];
    	var id_car = e.dataset['settedid'];
    	var arr = e.dataset['arr'];
    	var wishid = e.dataset['wishid'];
    	var car_setted_id = e.dataset['car_setted_id'];
    	var array = arr.split('|');
    	//console.log(array);
    	$('#nameTSedit').text(namets);
    	$('#idCarEdit').val(id_car);
    	$('#priceSettedTS').val(array[0]);
    	$('#count_hours').val(array[1]);
    	$('#count_hours_add').val(array[2]);
    	$('#endPriceSettedTS').val(array[3]);
    	$('#nameDrSettedTS').val(array[4]);
    	$('#phoneDrSettedTS').val(array[5]);
    	$('#gosNomerSettedTS').val(array[6]);
    	$('#predoplata_setted_ts').val(array[7]);
    	$('#partner_id_setted').val(array[8]);
    	$('#form_payment_partner option[value="'+array[9]+'"]').prop('selected',true);
    	getRouteListForPartner(wishid,array[8]);
    	getRouteBlockForPartner(wishid,array[8],car_setted_id);
    }

    function showModelRemoveTS(e){
    	var namets = e.dataset['namets'];
    	var id_car = e.dataset['settedid'];
    	var wish_id_car = e.dataset['wishid'];
    	var car_id_setted = e.dataset['settedcarid'];
    	$('#nameTS').text(namets);
    	$('#idCarRemove').val(id_car);
    	$('#nameTSremove').val(namets);
    	$('#wishCar').val(wish_id_car);
    	$('#car_id_setted').val(car_id_setted);
    }

    function getIdWishCar(e){
    	$('#carWishId').val(e.dataset['wishid']);
    	var begin = e.dataset['beginarend'];
    	var end = e.dataset['endarend'];
    	$('#makeHeaderModal').text('Предложение ТС для заявки № c '+begin+' по '+end);
    	$('#car_id').val('');
		$('#data_begin_work').val('');
		$('#data_end_work').val('');
		$('#result_search_ts').html('');
		$('#class_list option[value=""]').prop('selected',true);
		$('#mark_list').html('');
		$('#model_list').html('');
    }

    $('#marka_ts_sel').on('change',function(){
		var mark = $('#marka_ts_sel option:selected').val();
		{literal}
		$.ajax({
			type:'POST',
			url: '/core/ajax/ajaxForAutoClass.php',
			data:{action:'getModelListTs',mark:mark},
			cache:false,
			success:function(responce){
				$('#model_ts_box').show();
				$('#model_bus').hide();
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
				$('#model_bus').show();
				$('#model_ts_box').hide();
				$('#model_bus_sel').html(responce);
			}
		});
		{/literal}
	});

	$('#marka_ts_sel_confirm').on('change',function(){
		var mark = $('#marka_ts_sel_confirm option:selected').val();
		{literal}
		$.ajax({
			type:'POST',
			url: '/core/ajax/ajaxForAutoClass.php',
			data:{action:'getModelListTs',mark:mark},
			cache:false,
			success:function(responce){
				$('#model_ts_box_confirm').show();
				$('#model_bus_confirm').hide();
				//console.log(responce);
				$('#model_ts_sel_confirm').html(responce);
			}
		});
		{/literal}
	});

	$('#marka_bus_sel_confirm').on('change',function(){
		var mark = $('#marka_bus_sel_confirm option:selected').val();
		var type = $('#type_ts_comm_off_confirm option:selected').val();
		console.log('через onchange marka_bus_sel ');
		{literal}
		$.ajax({
			type:'POST',
			url: '/core/ajax/ajaxForAutoClass.php',
			data:{action:'selectModelTS',mark:mark,type:type},
			cache:false,
			success:function(responce){
				$('#model_bus_confirm').show();
				$('#model_ts_box_confirm').hide();
				$('#model_bus_sel_confirm').html(responce);
			}
		});
		{/literal}
	});

    function getSummPriceTS(price,hours,hours_add,type){
    	if(type ==  'setted'){
    		if((price!='0')&&(hours!='0')&&(hours_add!='0')){
    			$('#endPriceSettedTS').val(+price*(+hours + +hours_add));
    		}
    	}else if(type == 'offer'){
    		if((price!='0')&&(hours!='0')&&(hours_add!='0')){
    			$('#finalPriceCommOffer').val(+price*(+hours + +hours_add));
    		}
    	}else if(type == 'confirm'){
    		if((price!='0')&&(hours!='0')&&(hours_add!='0')){
    			$('#finalPriceCommOffer_confirm').val(+price*(+hours + +hours_add));
    		}
    	}
    }

    $('#type_ts_comm_off').on('change',function(){
		var type = $('#type_ts_comm_off option:selected').val();
		showFieldByTypes(type);
	});

	$('#type_ts_comm_off_confirm').on('change',function(){
		var type = $('#type_ts_comm_off_confirm option:selected').val();
		showFieldByTypes(type);
		if((type == 'Автобус')||(type == 'Микроавтобус')||(type == 'Минивэн')){
			showListBusesMark(type);
		}
	});

	function showListBusesMark(type){
		console.log(type);
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'selectMarkTS',type:type},
				cache:false,
				success:function(responce){
					$('#marka_bus_sel_confirm').html(responce);
				}
			});
		{/literal}
	}

    function showFieldByTypes(type){
    	if(type == 'Автомобиль'){
			$('#marka_ts').show();
			$('#marka_bus').hide();
			$('#marka_usual').hide();
			$('#model_ts_box').show();
			$('#model_bus').hide();
			$('#model_usual').hide();
			$('#marka_ts_confirm').show();
			$('#marka_bus_confirm').hide();
			$('#marka_usual_confirm').hide();
			$('#model_ts_box_confirm').show();
			$('#model_bus_confirm').hide();
			$('#model_usual_confirm').hide();
		}else if((type == 'Автобус')||(type == 'Микроавтобус')){
			$('#marka_ts').hide();
			$('#marka_bus').show();
			$('#marka_usual').hide();
			$('#model_ts_box').hide();
			$('#model_bus').show();
			$('#model_usual').hide();
			$('#marka_ts_confirm').hide();
			$('#marka_bus_confirm').show();
			$('#marka_usual_confirm').hide();
			$('#model_ts_box_confirm').hide();
			$('#model_bus_confirm').show();
			$('#model_usual_confirm').hide();
		}else if(type == 'Минивэн'){
			$('#marka_ts').hide();
			$('#marka_bus').show();
			$('#marka_usual').hide();
			$('#model_ts_box').hide();
			$('#model_bus').show();
			$('#model_usual').hide();
			$('#marka_ts_confirm').hide();
			$('#marka_bus_confirm').show();
			$('#marka_usual_confirm').hide();
			$('#model_ts_box_confirm').hide();
			$('#model_bus_confirm').show();
			$('#model_usual_confirm').hide();
		}else if(type == ''){
			$('#marka_ts').hide();
			$('#marka_bus').hide();
			$('#marka_usual').hide();
			$('#model_ts_box').hide();
			$('#model_bus').hide();
			$('#model_usual').hide();
			$('#marka_ts_confirm').hide();
			$('#marka_bus_confirm').hide();
			$('#marka_usual_confirm').hide();
			$('#model_ts_box_confirm').hide();
			$('#model_bus_confirm').hide();
			$('#model_usual_confirm').hide();
		}else{
			$('#marka_ts').hide();
			$('#marka_bus').hide();
			$('#marka_usual').show();
			$('#model_ts_box').hide();
			$('#model_bus').hide();
			$('#model_usual').show();
			$('#marka_ts_confirm').hide();
			$('#marka_bus_confirm').hide();
			$('#marka_usual_confirm').show();
			$('#model_ts_box_confirm').hide();
			$('#model_bus_confirm').hide();
			$('#model_usual_confirm').show();
		}
    }

    function formDataForCommercOffer(){
    	var type = $('#type_ts_comm_off option:selected').val();
		showFieldByTypes(type);
		$('#priceTSCommOffer').val('');
		var form_payment = $('#form_payment').text();
    	$('#formPaymentCommercOffer [value="'+form_payment+'"]').prop('selected',true);
    	$('#countHoursCommOffer').val('');
    	$('#countHoursAddCommOffer').val('');
    	$('#finalPriceCommOffer').val('');
    }

    $('#countHoursCommOffer').on('change',function(){
    	var price = $('#priceTSCommOffer').val();
    	var h = $('#countHoursCommOffer').val();
    	var h_ad = $('#countHoursAddCommOffer').val();
    		getSummPriceTS(price,h,h_ad,'offer');
    });

    $('#countHoursAddCommOffer').on('change',function(){
    	var price = $('#priceTSCommOffer').val();
    	var h = $('#countHoursCommOffer').val();
    	var h_ad = $('#countHoursAddCommOffer').val();
    		getSummPriceTS(price,h,h_ad,'offer');
    });

    $('#priceTSCommOffer').on('change',function(){
    	var price = $('#priceTSCommOffer').val();
    	var h = $('#countHoursCommOffer').val();
    	var h_ad = $('#countHoursAddCommOffer').val();
    		getSummPriceTS(price,h,h_ad,'offer');
    });

    $('#countHoursCommOffer_confirm').on('change',function(){
    	var price = $('#priceTSCommOffer_confirm').val();
    	var h = $('#countHoursCommOffer_confirm').val();
    	var h_ad = $('#countHoursAddCommOffer_confirm').val();
    		getSummPriceTS(price,h,h_ad,'confirm');
    });

    $('#countHoursAddCommOffer_confirm').on('change',function(){
    	var price = $('#priceTSCommOffer_confirm').val();
    	var h = $('#countHoursCommOffer_confirm').val();
    	var h_ad = $('#countHoursAddCommOffer_confirm').val();
    		getSummPriceTS(price,h,h_ad,'confirm');
    });

    $('#priceTSCommOffer_confirm').on('change',function(){
    	var price = $('#priceTSCommOffer_confirm').val();
    	var h = $('#countHoursCommOffer_confirm').val();
    	var h_ad = $('#countHoursAddCommOffer_confirm').val();
    		getSummPriceTS(price,h,h_ad,'confirm');
    });

    $(document).ready(function(){
    	var count_car = {$count_car_wish}; 

    	$('.p_req').hide();
    	//console.log(count_car);
    	$.mask.definitions['r'] = "[А-Я]";
    	$('.phone_mask').mask("8 (999) 999-99-99");
    	$('.mask_time').mask("99:99");
    	$('#cp_fiz').mask("999-999");
    	$('#dg_fiz').mask("99.99.9999");
    	$('#db_fiz').mask("99.99.9999");
    	$('#loginfizface').mask("89999999999");
    	$('.gosnomer_mask').mask("r 999 rr 999");
    	$('#marka_ts').hide();
		$('#marka_bus').hide();
		$('#marka_usual').hide();
		$('#model_ts').hide();
		$('#model_bus').hide();
		$('#model_usual').hide();
		$('#marka_ts_confirm').hide();
		$('.show_partner').hide();
		$('#marka_bus_confirm').hide();
		$('#marka_usual_confirm').hide();
		$('#model_ts_confirm').hide();
		$('#model_bus_confirm').hide();
		$('#model_usual_confirm').hide();
		$('.reason_cancel_block').hide();
		$('.rateClosedTicket').hide();
		$('#sendcommoffbut').hide();
		for(var i=0; i<count_car; i++){
			$('.form_waylist_procat_'+i).hide();
		}
		$('#list_status_ticket').hide();
		$('#formAddNewUrFace').hide();
    });

    function addCarToCommercOffer(){
    	var type_ts_offer = $('#type_ts_comm_off option:selected').val();
    	var wishCarid = $('#wishCarListSel option:selected').val();
    	var marka_ts_val = '';
    	var model_ts_val = '';
    	if(type_ts_offer == "Автомобиль"){
    		marka_ts_val = $('#marka_ts_sel option:selected').val();
    		model_ts_val = $('#model_ts_sel option:selected').val();
    	}else if((type_ts_offer == "Автобус")||(type_ts_offer == "Микроавтобус")){
    		marka_ts_val = $('#marka_bus_sel option:selected').val();
    		model_ts_val = $('#model_bus_sel option:selected').val();
    	}else if(type_ts_offer == 'Минивэн'){
    		marka_ts_val = $('#marka_bus_sel option:selected').val();
    		model_ts_val = $('#model_bus_sel option:selected').val();
    	}else{
    		marka_ts_val = $('#marka_usual_sel option:selected').val();
    		model_ts_val = $('#model_usual_sel option:selected').val();
    	}

    	var priceTSCommOffer = $('#priceTSCommOffer').val();
    	var formPaymentCommercOffer = $('#formPaymentCommercOffer').val();
    	var countHoursCommOffer = $('#countHoursCommOffer').val();
    	var countHoursAddCommOffer = $('#countHoursAddCommOffer').val();
    	var finalPriceCommOffer = $('#finalPriceCommOffer').val();
    	var offerString = $('#offerString').val();
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'../../core/ajax/ajaxForAutoClass.php',
    			data:{action:'addCarToCommercOffer',wishCarid:wishCarid,type_ts_offer:type_ts_offer,marka_ts_val:marka_ts_val,model_ts_val:model_ts_val,priceTSCommOffer:priceTSCommOffer,formPaymentCommercOffer:formPaymentCommercOffer,countHoursCommOffer:countHoursCommOffer,countHoursAddCommOffer:countHoursAddCommOffer,finalPriceCommOffer:finalPriceCommOffer,offerString:offerString},
    			cache:false,
    			success:function(responce){
    				$('#offerString').val(responce);
    				formingDataForShowingCommercOffer();
    			}
    		});
    	{/literal}
    }

    function formingDataForShowingCommercOffer(){
    	var offerline = $('#offerString').val();
    	{literal}
    		$.ajax({
    				type:'POST',
    				url:'../../core/ajax/ajaxForAutoClass.php',
    				data:{action:'formDataForShowinCO',offerline:offerline},
    				cache:false,
    				success: function(responce){
    					$('.listCommerc').html(responce);
    					$('#sendcommoffbut').show();
    				}
    		});
    	{/literal}
    }

    function sendCommercOffer(){
    	var offerstr = $('#offerString').val();
    	var ticket_id = $('#ticket_id').val();
    	{literal}
    		$.ajax({
    				type:'POST',
    				url:'../../core/ajax/ajaxForAutoClass.php',
    				data:{action:'sendCommercOffer',offerstr:offerstr,ticket_id:ticket_id},
    				cache:false,
    				success: function(responce){
    					window.location.reload();
    				}
    		});
    	{/literal}
    }

    function addWaylistProcat(e){
    	var key = e;
    	var ticket_id = $('#ticket_id').val();
    	var data_waylist = $('#data_event_'+key).val();
    	var aday_waylist = $('#itwasaday_'+key).val();
    	var begintime_waylist = $('#begin_event_'+key).val();
    	var endtime_waylist = $('#end_event_'+key).val();
    	var placeget_waylist = $('#place_get_'+key).val();
    	var placeout_waylist = $('#place_out_'+key).val();
    	var wishid = $('#wishidforwaylist_'+key).val();
    	var linkedTS = $('#linkedList_'+key+' option:selected').val();
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'addWaylistProcat',ticket_id:ticket_id,data:data_waylist,aday:aday_waylist,begintime:begintime_waylist,endtime:endtime_waylist,placeget:placeget_waylist,placeout:placeout_waylist,wishid:wishid,settedTS:linkedTS},
    			cache:false,
    			success:function(responce){
    				window.location.reload();
    				//console.log(responce);
    			}
    		});
    	{/literal}
    }

    $('#list_status_ticket').on('change',function(){
    	var ticket_id = $('#ticket_id').val();
    	var status = $('#list_status_ticket option:selected').val();
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'changeTicketStatus',ticket_id:ticket_id,status:status},
    			cache:false,
    			success:function(){
    				window.location.reload();
    			}
    		});
    	{/literal}
    });

    function ts_type_onchange(){
    	var type_ts = $('#type_ts option:selected').val();
    	//console.log(type_ts);
    	type_mark_car(type_ts,'');
    	switch(type_ts){
    		case 'Автомобиль': break;
    		case 'Автобус': break;
    		case 'Микроавтобус': break;
    		default:
    			type_model_car(type_ts,'','');
    	}
    }

    function ts_type_onchange_new(){
    	var type_ts = $('#type_ts_new option:selected').val();
    	//console.log(type_ts);
    	type_mark_car_new(type_ts,'');
    	/*switch(type_ts){
    		case 'Автомобиль': break;
    		case 'Автобус': break;
    		case 'Микроавтобус': break;
    		default:
    			type_model_car_new(type_ts,'','');
    	}*/
    }

    function ts_mark_onchange(){
    	var type_ts = $('#type_ts option:selected').val();
    	var mark_ts = $('#sel_mark_val option:selected').val();
    	//console.log(type_ts);
    	type_model_car(type_ts,mark_ts,'');
    }

    function ts_mark_onchange_new(){
    	var type_ts = $('#type_ts_new option:selected').val();
    	var mark_ts = $('#sel_mark_val option:selected').val();
    	console.log(type_ts+' '+mark_ts);
    	type_model_car_new(type_ts,mark_ts,'');
    }

    function editLineOfArr(){
    	var auto_without_driver = $('#auto_without_driver:checked').val();
    	var transfer_ts = $('#transfer_ts:checked').val();
    	var arrayEditLine = {};
    	arrayEditLine.type_ts = $('#type_ts option:selected').val();
    	arrayEditLine.mark_ts = $('#mark_ts option:selected').val();
    	arrayEditLine.model_ts = $('#model_ts option:selected').val();
    	arrayEditLine.begin = $('#begin_arenda_ts').val();
    	arrayEditLine.end = $('#end_arenda_ts').val();
    	arrayEditLine.begintime = $('#begintime_arenda_ts').val();
    	arrayEditLine.endtime = $('#endtime_arenda_ts').val();
    	arrayEditLine.route_desc_ts = $('#route_desc_ts').val();
    	arrayEditLine.analog = $('#analog_ts').val();
    	arrayEditLine.countts = $('#count_ts').val();
    	arrayEditLine.commentts = $('#comment_ts').val();
    	arrayEditLine.color_ts = $('#color_ts').val();
    	arrayEditLine.count_places = $('#count_places_ts').val();
    	arrayEditLine.auto_without_driver = (auto_without_driver == 'on')?'y':'n';
    	arrayEditLine.transfer_ts = (transfer_ts == 'on')?'y':'n';
    	var id_wishcar = $('#wishid_edit').val();

    	{literal}
    		$.ajax({
    				type:'POST',
    				url:'/core/ajax/ajaxForAutoClass.php',
    				data:{action:'editWishCarLine',arrayEditLine:arrayEditLine,id:id_wishcar},
    				cache:false,
    				success:function(responce){
    					window.location.reload();
    				}
    		});
    	{/literal}
    }

    function getwickidCarToConfirm(e){
    	$('#confirmForWishCar').val(e.dataset['wishid']);
    	$('#id_confirm').val('');
    	var wishid = e.dataset['wishid'];
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'getSettedAuto',id:wishid},
    			cache:false,
    			success:function(responce){
    				var arr = JSON.parse(responce);
    				//console.log(arr);
    				$('#type_ts_comm_off_confirm option[value="'+arr['type']+'"]').prop('selected',true);
    				showFieldByTypes(arr['type']);
    				type_mark_ts_confirmed(arr['type'],arr['mark']);
    				type_model_ts_confirmed(arr['type'],arr['mark'],arr['model']);
    				$('#buttonAddRoute').hide();
    			}
    		})
    	{/literal}
    	$('#type_ts_comm_off_confirm option[value=""]').prop('selected',true);
    	$("#priceTSCommOffer_confirm").val('');
    	$("#formPaymentCommercOffer_confirm option[value='']").prop('selected',true);
    	$("#countHoursCommOffer_confirm").val('');
    	$("#countHoursAddCommOffer_confirm").val('');
    	$("#finalPriceCommOffer_confirm").val('');
    	var val = $('#form_payment').text();
    	$("#formPaymentCommercOffer_confirm option[value='"+val+"']").prop('selected',true);
    	//$('.route_block').hide();
    	getConfirmedRouteList(e.dataset['wishid']);
    	getWishCarRoute(e.dataset['wishid']);
    	$('#typeSaveRoute').val('add');
    }

    $('#addRouteButton').on('click',function(){
    	$('.route_list').show();
    });

    function addRoute(){
    	//$('.route_list').hide();
    	var type_ts = $('#type_ts_comm_off_confirm option:selected').val();
    	var marka_ts = '';
    	var model_ts = '';
    	if(type_ts == "Автомобиль"){
    		marka_ts = $('#marka_ts_sel_confirm option:selected').val();
    		model_ts = $('#model_ts_sel_confirm option:selected').val();
    	}else if((type_ts == "Автобус")||(type_ts == "Микроавтобус")){
    		marka_ts = $('#marka_bus_sel_confirm option:selected').val();
    		model_ts = $('#model_bus_sel_confirm option:selected').val();
    	}else if(type_ts == "Минивэн"){
    		marka_ts = $('#marka_bus_sel_confirm option:selected').val();
    		model_ts = $('#model_bus_sel_confirm option:selected').val();
    	}else{
    		marka_ts = $('#marka_usual_sel_confirm option:selected').val();
    		model_ts = $('#model_usual_sel_confirm option:selected').val();
    	}

    	var price = $('#priceTSCommOffer_confirm').val();
    	var form_payment = $('#formPaymentCommercOffer_confirm option:selected').val();
    	var data = $('#data_route').val();
    	var wishcar_id_conf = $('#confirmForWishCar').val();
    	var begint = $('#begintime_route').val();
    	var endt = $('#endtime_route').val();
    	var route_desc = $('#route_desc').val();
    	var itwasaday_route = ($('#itwasaday_route').is(':checked'))?'on':'';
    	var addHours_route = $('#addHours_route').val();
    	var typeSaveRoute = $('#typeSaveRoute').val();
    	var idLineRoute = $('#idLineRoute').val();
    	var transfer_confirmed = ($('#transfer_confirmed').is(':checked'))?'on':'';
    	var services_ticket = $('#services_ticket option:selected').val();
    	//console.log(itwasaday_route);
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'addRoutForConfirmed',wishcar_id_conf:wishcar_id_conf,data:data,begin:begint,end:endt,route_desc:route_desc,itwasaday:itwasaday_route,add_hours:addHours_route,type_ts:type_ts,marka_ts:marka_ts,model_ts:model_ts,price:price,form_payment:form_payment,typeSaveRoute:typeSaveRoute,idLineRoute:idLineRoute,transfer_confirmed:transfer_confirmed,services_ticket:services_ticket},
    			cache:false,
    			success:function(responce){
    				var route_info_arr = JSON.parse(responce);
    				$('.block_confirmed_waylists').html(route_info_arr[0]);
    				$("#countHoursCommOffer_confirm").val(route_info_arr[1]);
    				$("#countHoursAddCommOffer_confirm").val(route_info_arr[2]);
    				$('#data_route').val('');
    				$('#begintime_route').val('');
    				$('#endtime_route').val('');
    				$('#route_desc').val('');
    				$('#itwasaday_route').val('');
    				$('#addHours_route').val('');
    				$('#buttonAddRoute').show();
    				$('#services_ticket option[value=""]').prop('selected',true);
    				$('.route_block').hide();
    			}
    		});
    	{/literal}
    }

    function saveConfirmTS(){
    	var type_ts_confirm = $('#type_ts_comm_off_confirm option:selected').val();
    	var wishCarid = $('#confirmForWishCar').val();
    	var marka_ts_confirm = '';
    	var model_ts_confirm = '';
    	if(type_ts_confirm == "Автомобиль"){
    		marka_ts_confirm = $('#marka_ts_sel_confirm option:selected').val();
    		model_ts_confirm = $('#model_ts_sel_confirm option:selected').val();
    	}else if((type_ts_confirm == "Автобус")||(type_ts_confirm == "Микроавтобус")){
    		marka_ts_confirm = $('#marka_bus_sel_confirm option:selected').val();
    		model_ts_confirm = $('#model_bus_sel_confirm option:selected').val();
    	}else{
    		marka_ts_confirm = $('#marka_usual_sel_confirm option:selected').val();
    		model_ts_confirm = $('#model_usual_sel_confirm option:selected').val();
    	}

    	var priceTSConfirm = $('#priceTSCommOffer_confirm').val();
    	var formPaymentConfirm = $('#formPaymentCommercOffer_confirm').val();
    	var countHoursConfirm = $('#countHoursCommOffer_confirm').val();
    	var countHoursAddConfirm = $('#countHoursAddCommOffer_confirm').val();
    	var finalPriceConfirm = $('#finalPriceCommOffer_confirm').val();

    	{literal}
    	$.ajax({
    		type:'POST',
    		url:'/core/ajax/ajaxForAutoClass.php',
    		data:{action:'saveConfirmTS',type_ts_confirm:type_ts_confirm,wishid:wishCarid,marka:marka_ts_confirm,model:model_ts_confirm,price:priceTSConfirm,form_payment:formPaymentConfirm,hours:countHoursConfirm,add_hours:countHoursAddConfirm,final:finalPriceConfirm},
    		cache:false,
    		success: function(responce){
    			window.location.reload();
    		}
    	});
    	{/literal}
    }

    function editConfirmedTSnRoute(e){
    	var str = e.dataset['line'];
    	console.log(str);
    	var arr = str.split('|');
    	$('#id_confirm').val(arr[0]);
    	$('#confirmForWishCar').val(arr[1]);
    	getConfirmedRouteList(arr[1]);
    	$('.route_block').hide();
    	$('#buttonAddRoute').show();
    	//getWishCarRoute(arr[1]);
    }

    $('#buttonAddRoute').on('click',function(){
    	$('.route_block').show();
    	$('#buttonAddRoute').hide();
    	if($('#typeSaveRoute').val() == ''){
    		$('#typeSaveRoute').val('add');
    	}

    	var val = $('#form_payment').text();
    	$("#formPaymentCommercOffer_confirm option[value='"+val+"']").prop('selected',true);
    });

	function type_mark_ts_confirmed(type,mark){
		var t_ts = type;
		var mark_ts = mark;
		console.log(type+' '+mark);
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'selectMarkTSConfirmed',type:t_ts,mark:mark_ts},
					cache:false,
					success: function(responce){
						switch(t_ts){
							case 'Автомобиль':
								$("#marka_ts_confirm").show();
								$("#marka_ts_sel_confirm").html(responce);
								break;
							case 'Автобус':
								$("#marka_bus_confirm").show();
								$("#marka_bus_sel_confirm").html(responce);
								break;
							case 'Микроавтобус':
								$("#marka_bus_confirm").show();
								$("#marka_bus_sel_confirm").html(responce);
								break;
							case 'Минивэн':
								$("#marka_bus_confirm").show();
								$("#marka_bus_sel_confirm").html(responce);
								break;
							default:
								$("#marka_usual_confirm").show();
								$("#marka_usual_confirm").html(responce);
								break;
						}
					}
			});
		{/literal}
	}

	function type_model_ts_confirmed(type,mark,model){
		var t_ts = type;
		var mark_ts = mark;
		var model_ts = model;
		console.log('через type_model_ts_confirmed ');
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'selectModelTSConfirmed',type:t_ts,mark:mark_ts,model:model_ts},
					cache:false,
					success: function(responce){
						switch(t_ts){
							case 'Автомобиль':
								$("#model_ts_sel_confirm").html(responce);
								break;
							case 'Автобус':
								$("#model_bus_sel_confirm").html(responce);
								break;
							case 'Микроавтобус':
								$("#model_bus_sel_confirm").html(responce);
								//console.log(responce);
								break;
							case 'Минивэн':
								$("#model_bus_sel_confirm").html(responce);
								//console.log(responce);
								break;
							default:
								$("#model_usual_confirm").html(responce);
								break;
						}
					}
			});
		{/literal}
	}

	function getConfirmedRouteList(id_wishcar){
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getConfirmedRouteList',id_wishcar:id_wishcar},
				cache:false,
				success:function(responce){
					var route_info_arr = JSON.parse(responce);
    				$('.block_confirmed_waylists').html(route_info_arr[0]);
    				$("#countHoursCommOffer_confirm").val(route_info_arr[1]);
    				$("#countHoursAddCommOffer_confirm").val(route_info_arr[2]);
				}
			});
		{/literal}
	}

	function removeRouteLine(e){
		var id_line = e.dataset['id_line'];
		var id_wish = e.dataset['id_wish'];
		{literal}
			$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'removeRouteLine',id:id_line},
					cache:false,
					success:function(responce){
						getConfirmedRouteList(id_wish);
					}
			});
		{/literal}
	}

	function formDataForCallbackPartnerModule(e){
		//console.log(e);
		$('#partner_id').val(e.dataset['partnerid']);
		$('#setted_car_id').val(e.dataset['settedcarid']);
		$('#type_callback_partner').val('add');
		$('#last_partner_callback').val(e.dataset['partnerlastcallback']);
		getPartnerCallbacks(e.dataset['partnerid']);
	}

	function sendFinCallbackClient(){
		var user_id = {$user_id};
		var owner_ticket = $('#owner_ticket').val();
		var id_ticket = $('#ticket_id').val();
		var preorder_type = "";/*$('#predoplata_type option:selected').val();*/
		var preorder_sum = "";/*$('#predoplata_sum').val();*/
		var data_call = $('#data_call_fin').val();
		var payment_form = ""; /*$('#payment_form_fin').val();*/
		var comment = $('#comment_fin').val();
		var status = $('#status_ticket').val();
		var data_finclient = "";/*$('#data_payment_finclient').val();*/
		var type_callback = $('#type_callback_client').val();
		var id_callback_client = $('#id_callback_client').val();
		var client_phone = $('#client_phone').val();
		var last_callback_client = $('#last_client_callback_line').text();
		var close_old_callback = "";
		var reason_cancel = $('#reason_cancel option:selected').val();
		var rate_ticket = $('#rate_ticket option:selected').val();
		//console.log(last_callback_client);
		if((status != 'Отказ')||((status == 'Отказ')&&(reason_cancel!= ''))){
			{literal}
				if(comment!=''){
					if((last_callback_client!='Не установлен')&&(type_callback!='edit')){
						//console.log('herererererere');
						if(confirm("Закрыть существующий callback на "+last_callback_client+" ?")){
							close_old_callback = 'y';					
						}else{
							close_old_callback = 'n';
						}

						$.ajax({
								type:'POST',
								url:'/core/ajax/ajaxForAutoClass.php',
								data:{action:"sendFinCallbackClient",user_id:user_id,ticket_id:id_ticket,preorder_type:preorder_type,preorder_sum:preorder_sum,data_call:data_call,comment:comment, payment_form:payment_form,owner_ticket:owner_ticket,status:status,data_finclient:data_finclient,type_callback:type_callback,id_callback_client:id_callback_client,client_phone:client_phone,close_old_callback:close_old_callback,reason_cancel:reason_cancel, rate_ticket:rate_ticket},
								cache:false,
								success:function(responce){
									window.location.reload();
								}
							});
					}else if((last_callback_client=='Не установлен')&&((data_call == '')||(data_call == null)||(data_call == undefined))){
						if(confirm("Вы не установили callback. Хотите продолжить?")){
							$.ajax({
								type:'POST',
								url:'/core/ajax/ajaxForAutoClass.php',
								data:{action:"sendFinCallbackClient",user_id:user_id,ticket_id:id_ticket,preorder_type:preorder_type,preorder_sum:preorder_sum,data_call:data_call,comment:comment, payment_form:payment_form,owner_ticket:owner_ticket,status:status,data_finclient:data_finclient,type_callback:type_callback,id_callback_client:id_callback_client,client_phone:client_phone,close_old_callback:close_old_callback,reason_cancel:reason_cancel, rate_ticket:rate_ticket},
								cache:false,
								success:function(responce){
									window.location.reload();
								}
							});
						}else{				
						}
					}else{
						$.ajax({
							type:'POST',
							url:'/core/ajax/ajaxForAutoClass.php',
							data:{action:"sendFinCallbackClient",user_id:user_id,ticket_id:id_ticket,preorder_type:preorder_type,preorder_sum:preorder_sum,data_call:data_call,comment:comment, payment_form:payment_form,owner_ticket:owner_ticket,status:status,data_finclient:data_finclient,type_callback:type_callback,id_callback_client:id_callback_client,client_phone:client_phone,close_old_callback:close_old_callback,reason_cancel:reason_cancel, rate_ticket:rate_ticket},
							cache:false,
							success:function(responce){
								window.location.reload();
							}
						});
					}
				}else{
					alert("Вы не указали комментарий!");
				}
			{/literal}
		}else{
			alert("Вы не указали причину отказа.");
		}
	}

	/*function sendCallbackPartner() {
		var user_id = {$user_id};
		var partner_id = $('#partner_id').val();
		var ticket_id = $('#ticket_id').val();
		var next_call_partner = $('#next_call_partner').val();
		var block_comment_partner = $('#block_comment_partner').val();
		var owner_ticket = $('#owner_ticket').val();
		{literal}
		$.ajax({
			type:'POST',
			url:'/core/ajax/ajaxForAutoClass.php',
			data:{action:"sendCallbackPartner", ticket_id:ticket_id,partner_id:partner_id, date_callback:next_call_partner, comment:block_comment_partner, owner_ticket:owner_ticket, user_id:user_id},
			cache:false,
			success:function(responce){
				window.location.reload();
			}
		});
		{/literal}
	}*/

	function sendFinCallbackPartner() {
		var partner_id = $('#partner_id').val();
		var settedcarid = $('#setted_car_id').val();
		var ticket_id = $('#ticket_id').val();
		var user_id = {$user_id};
		var preorder_type = "";/*$('#predoplata_type_partner option:selected').val();*/
		var preorder_sum = "";/*$('#predoplata_sum_partner').val();*/
		var data_call = $('#data_call_finpartner').val();
		var payment_form = "";/*$('#payment_form_finpartner').val();*/
		var comment = $('#comment_finpartner').val();
		var status = $('#partner_statuses').val();
		var data_payment = "";/*$('#data_payment_finpanter').val();*/
		var type_callback = $('#type_callback_partner').val();
		var id_callback = $('#id_callback_partner').val();
		var last_callback_partner = $('#last_partner_callback').val();
		var close_old_callback = "";
		{literal}
		if(comment!= ''){
			if((last_callback_partner!='Не установлен')&&(type_callback!='edit')){
					//console.log('herererererere');
					if(confirm("Закрыть существующий callback на "+last_callback_partner+" ?")){
						close_old_callback = 'y';					
					}else{
						close_old_callback = 'n';
					}

					$.ajax({
						type:'POST',
						url:'/core/ajax/ajaxForAutoClass.php',
						data:{action:"sendFinCallbackPartner", ticket_id:ticket_id,partner_id:partner_id, preorder_type:preorder_type, predoplata_sum:preorder_sum, data_call:data_call, payment_form:payment_form, comment:comment, user_id:user_id, status:status, settedcarid:settedcarid,data_payment:data_payment,id_callback:id_callback,type_callback:type_callback,close_old_callback:close_old_callback},
						cache:false,
						success:function(responce){
							window.location.reload();
							//console.log(responce);
						}
					});
				}else if((last_callback_partner=='Не установлен')&&((data_call == '')||(data_call == null)||(data_call == undefined))){
					if(confirm("Вы не установили callback. Хотите продолжить?")){
						$.ajax({
							type:'POST',
							url:'/core/ajax/ajaxForAutoClass.php',
							data:{action:"sendFinCallbackPartner", ticket_id:ticket_id,partner_id:partner_id, preorder_type:preorder_type, predoplata_sum:preorder_sum, data_call:data_call, payment_form:payment_form, comment:comment, user_id:user_id, status:status, settedcarid:settedcarid,data_payment:data_payment,id_callback:id_callback,type_callback:type_callback,close_old_callback:close_old_callback},
							cache:false,
							success:function(responce){
								window.location.reload();
								//console.log(responce);
							}
						});
					}else{				
					}
				}else{
					$.ajax({
							type:'POST',
							url:'/core/ajax/ajaxForAutoClass.php',
							data:{action:"sendFinCallbackPartner", ticket_id:ticket_id,partner_id:partner_id, preorder_type:preorder_type, predoplata_sum:preorder_sum, data_call:data_call, payment_form:payment_form, comment:comment, user_id:user_id, status:status, settedcarid:settedcarid,data_payment:data_payment,id_callback:id_callback,type_callback:type_callback,close_old_callback:close_old_callback},
							cache:false,
							success:function(responce){
								window.location.reload();
								//console.log(responce);
							}
						});
				}
		}else{
			alert("Вы не указали комментарий!");
		}
		{/literal}
	}

	function getPartnerCallbacks(id){
		var ticket_id = $('#ticket_id').val();
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:"getPartnerCallbacks",partner_id:id,ticket_id:ticket_id},
				cache:false,
				success:function(responce){
					//var blocks = JSON.parse(responce);
					//console.log(blocks);
					//$('.partner_callbacks').html(responce);
					//$('.finpartner_callbacks').html(blocks[1]);
					//console.log(blocks[2]);
					$('.finpartner_callbacks').html(responce);
				}
			});
		{/literal}
	}

	function print_preset_waylist(){
		var ticket_id = $('#ticket_id').val();
		var formpayment = "";
		var nom_dog = "";
		var data_dog = $('#dd').val();
		var dfor = $('#dfor option:selected').val();
		var partner_req = $('#list_req_partner option:selected').val();
		var id_p = "";
		var req_id = "";
		if(dfor == 'partner'){
			var partnerid = $('#partner_print_id option:selected').val();
			id_p = '&partnerid='+partnerid;
			req_id = '&p_req_id='+partner_req;
		}else{
			id_p = '';
			req_id = "";
		}
		var action = "";
		if(ticket_id != ''){
			//&formpayment="+formpayment+"&nd="+nom_dog+"&dd="+data_dog+"
			action = "/clientAccount/print_ticket_preset_waylist?ticket_id="+ticket_id+"&dfor="+dfor+id_p+req_id;
		}
		console.log(action);
		window.open(action);
	}

	function getWindowForPartnerPrint(e){
		var p_id = e.dataset['partnerid'];
		$('#partnerid').val(p_id);
		$('#dfor option[value="partner"]').prop('selected',true);
		$('#form_payment_for_print option[value=""]').prop('selected',true);
		$('#nd').val('');
		$('#dd').val('');
	}

	function printForClient(){
		$('#dfor option[value=""]').prop('selected',true);
		$('#form_payment_for_print option[value=""]').prop('selected',true);
		$('#nd').val('');
		$('#dd').val('');
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

	$('#addNewUrFace').on('click',function(){
		$('#formAddNewUrFace').show();
		$('#formChooseUrFace').hide();
	});

	function addUrFace(){
		var password = generatePass();
    	var login = password;
    	var name = $('#nameurface').val();
    	var ticket_id = $('#ticket_id').val();
    	{literal}
    		$.ajax({
    			type:"POST",
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"addNewUrFaceFromTicket",login:login,name:name,password:password,ticket_id:ticket_id},
    			cache:false,
    			success:function(responce){
    				window.location.reload();
    			}
    		});
    	{/literal}
    }

    function addFizFace(){
		var password = $('#loginfizface').val();
		var email_fiz_face = $('#email_fiz_face').val();
    	var login = password;
    	var name = $('#nickfizface').val();
    	var ticket_id = $('#ticket_id').val();
    	{literal}
    		$.ajax({
    			type:"POST",
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"addNewFizFaceFromTicket",login:login,name:name,password:password,ticket_id:ticket_id,email_fiz_face:email_fiz_face},
    			cache:false,
    			success:function(responce){
    				window.location.reload();
    			}
    		});
    	{/literal}
    }

    function pickUrFaceToTicket(){
    	var ticket_id = $('#ticket_id').val();
    	var face_id = $('#face_id option:selected').val();
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"pickTicketToExistedUrFace",ticket_id:ticket_id,face_id:face_id},
    			cache:false,
    			success:function(responce){
    				window.location.reload();
    				//console.log(responce);
    			}
    		});
    	{/literal}
    }

    function pickFizFaceToTicket(){
    	var ticket_id = $('#ticket_id').val();
    	var face_id = $('#face_fiz_id option:selected').val();
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"pickTicketToExistedFizFace",ticket_id:ticket_id,face_id:face_id},
    			cache:false,
    			success:function(responce){
    				window.location.reload();
    				//console.log(responce);
    			}
    		});
    	{/literal}
    }

    function editAcccountTicketData(){
    	var ticket_id = $('#ticket_id').val();
    	var nick_face = $('#nickname_client').val();
    	var cont_face = $('#contact_face_name').val();
    	var phone_client = $('#phone_client').val();
    	var email_client = $('#email_client').val();
    	var form_payment_client = $('#form_payment_client').val();
    	var client_budget = $('#client_budget').val();
    	var ticket_city = $('#ticket_city option:selected').val();
    	var came_from = $('#came_from option:selected').val();
    	{literal}
    		$.ajax({
    			type:"POST",
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"editAcccountTicketData",ticket_id:ticket_id,nick_face:nick_face,cont_face:cont_face,phone_client:phone_client,email_client:email_client,form_payment_client:form_payment_client,client_budget:client_budget,ticket_city:ticket_city,came_from:came_from},
    			cache:false,
    			success:function(){
    				window.location.reload();
    			}
    		})
    	{/literal}
    }

    $('#edit_button').on('click',function(){
    	var n_c = '{$ticket_info['nick_client']}';
    	var c_f = '{$ticket_info['contact_face']}';
    	var ph_c = "{$ticket_info['tel']}";
    	var e_c = "{$ticket_info['email']}";
    	var p_c = "{$ticket_info['type_payment']}";
    	var b_c = "{$ticket_info['client_budget']}";
    	var t_c = "{$ticket_info['ticket_city']}";

    	$('#nickname_client').val(n_c);
    	$('#contact_face_name').val(c_f);
    	$('#phone_client').val(ph_c);
    	$('#email_client').val(e_c);
    	$('#client_budget').val(b_c);
    	$('#ticket_city option[value="'+t_c+'"]').prop('selected',true);
    	$('#form_payment_client option[value="'+p_c+'"]').prop('selected',true);
    });

    function formFromRouteToWaylist(){
    	var id_wishcar = $('#confirmForWishCar').val();
    	var id_confirmed = $('#id_confirm').val();
    	var ticket_id = $('#ticket_id').val();

    	{literal}
    		$.ajax({
    			type:"POST",
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"formFromRouteToWaylist",wish_id:id_wishcar,id_confirm:id_confirmed,ticket_id:ticket_id},
    			cache:false,
    			success: function(responce){
    				window.location.reload();
    				//console.log(responce);
    			}
    		});
    	{/literal}
    }

    function saveFizFaceRequisites(){
    	var ticket_id = $("#ticket_id").val();
    	var fio_fiz = $('#fio_fiz').val();
    	var nomer_passport = $('#np_fiz').val();
    	var seria_passport = $('#sp_fiz').val();
    	var data_get = $('#dg_fiz').val();
    	var data_born = $('#db_fiz').val();
    	var who_give = $('#wg_fiz').val();
    	var code_podraz = $('#cp_fiz').val();
    	var location_reg = $('#lr_fiz').val();
    	var placeborn = $('#pb_fiz').val();
    	
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:"/core/ajax/ajaxForAutoClass.php",
    			data:{action:"saveFizFaceRequisites",fio:fio_fiz,nomer_passport:nomer_passport,seria_passport:seria_passport,data_get:data_get,data_born:data_born,who_give:who_give,code_podraz:code_podraz,ticket_id:ticket_id,placeborn:placeborn,location_reg:location_reg},
    			cache:false,
    			success:function(){
    				window.location.reload();
    			}
    		});
    	{/literal}
    }

    function saveCommentAboutTicket() {
    	var ticket_id = $('#ticket_id').val();
    	var comment = $('#comment_about_ticket').val();
    	var user_id = {$user_id};
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'saveCommentAboutTicket',ticket_id:ticket_id,comment:comment,user_id:user_id},
    			cache:false,
    			success:function(responce){
    				window.location.reload();
    			}
    		});
    	{/literal}
    }

	function getWishCarRoute(id) {
		console.log(id);
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getWishCarRoute',wishid:id},
				cache:false,
				success:function(responce){
					var arr = JSON.parse(responce);
					console.log(arr);
					$('#data_route').val(arr[0]);
					$('#begintime_route').val(arr[1]);
					if(arr[2] != 'Трансфер'){
						$('#endtime_route').addClass('mask_time');
					}else{
						$('#endtime_route').removeClass('mask_time');
					}
					$('#endtime_route').val(arr[2]);
					$('#route_desc').val(arr[3]);
				}
			});
		{/literal}
	}

	function getCopyThisRoute(e){
		var id = e.dataset['id_line'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getCopyThisRoute',id:id},
				cache:false,
				success:function(responce){
					//console.log(responce);
					var arr = JSON.parse(responce);
					console.log(arr);
					var type_ts = arr['type_ts'];
					$('#type_ts_comm_off_confirm option[value="'+type_ts+'"]').val();

			    	type_mark_ts_confirmed(type_ts,arr['marka_ts']);
	    			type_model_ts_confirmed(type_ts,arr['marka_ts'],arr['model_ts']);

			    	$('#priceTSCommOffer_confirm').val(arr['price']);
			    	$('#formPaymentCommercOffer_confirm option[value="'+arr['form_payment']+'"]').prop('selected',true);
			    	$('#data_route').val(arr['data']);
			    	$('#confirmForWishCar').val(arr['id_wishcar']);
			    	$('#begintime_route').val(arr['begin']);
			    	if(arr['end'] != 'Трансфер'){
						$('#endtime_route').addClass('mask_time');
					}else{
						$('#endtime_route').removeClass('mask_time');
					}
					if(arr['service_type']  != ''){
						$('#services_ticket option[value="'+arr['service_type']+'"]').prop('selected',true);
					}
			    	$('#endtime_route').val(arr['end']);
			    	$('#route_desc').val(arr['route_desc']);
			    	 if(arr['itwasaday'] == 'y'){
			    	 	$('#itwasaday_route').prop('checked',true);
			    	 }
			    	$('#addHours_route').val(arr['add_hours']);
			    	$('.route_block').show();
			    	$('#buttonAddRoute').hide();
			    	$('#typeSaveRoute').val('add');
				}
			})
		{/literal}
	}

	function editThisRoute(e){
		var id = e.dataset['id_line'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'editThisRoute',id:id},
				cache:false,
				success:function(responce){
					//console.log(responce);
					var arr = JSON.parse(responce);
					console.log(arr);
					var type_ts = arr['type_ts'];
					$('#type_ts_comm_off_confirm option[value="'+type_ts+'"]').prop('selected',true);
			    	type_mark_ts_confirmed(type_ts,arr['marka_ts']);
	    			type_model_ts_confirmed(type_ts,arr['marka_ts'],arr['model_ts']);

			    	$('#priceTSCommOffer_confirm').val(arr['price']);
			    	$('#formPaymentCommercOffer_confirm option[value="'+arr['form_payment']+'"]').prop('selected',true);
			    	$('#data_route').val(arr['data']);
			    	$('#confirmForWishCar').val(arr['id_wishcar']);
			    	$('#begintime_route').val(arr['begin']);
			    	$('#endtime_route').val(arr['end']);
			    	$('#route_desc').val(arr['route_desc']);
			    	 if(arr['itwasaday'] == 'y'){
			    	 	$('#itwasaday_route').prop('checked',true);
			    	 }
			    	 if(arr['service_type'] != ''){
						$('#services_ticket option[value="'+arr['service_type']+'"]').prop('selected',true);
					 }
			    	$('#addHours_route').val(arr['add_hours']);
			    	$('.route_block').show();
			    	$('#buttonAddRoute').hide();
			    	$('#typeSaveRoute').val('edit');
			    	$('#idLineRoute').val(id);
				}
			})
		{/literal}
	}

	{literal}
	$('#dfor').on('change',function(){
		if($('#dfor option:selected').val() == 'partner'){
			$('.show_partner').show();
		}
	});
	{/literal}

	function getRouteListForPartner(e,b){
		var wishid = e;
		var partner_id = b;
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getRouteListForPartner',wishid:wishid,partner_id:partner_id},
				cache:false,
				success:function(responce){
					$('#route_list_for_partner').html(responce);
				}
			});
		{/literal}
	}

	function printDogovorForClient(){
		var ticket_id = $('#ticket_id').val();
		var url_line = "/clientAccount/print_ticket_dogovor?";
		url_line += "ticket_id="+ticket_id;
		window.open(url_line);
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

	function getCallClientForEdit(e){
		var id = e.dataset['id_callback'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getCallClientForEdit',id:id},
				cache:false,
				success:function(responce){
					$('#type_callback_client').val('edit');
					$('#id_callback_client').val(id);
					var arr = JSON.parse(responce);
					$('#comment_fin').val(arr['comment']);
					$('#data_call_fin').val(arr['date_callback']);
					//$('#predoplata_type option[value="'+arr['preorder_type']+'"]').prop('selected',true);
					//$('#payment_form_fin option[value="'+arr['payment_form']+'"]').prop('selected',true);
					//$('#predoplata_sum').val(arr['summ']);
					//$('#data_payment_finclient').val(arr['date_summ_pay']);
				}
			})
		{/literal}
	}

	function getCallPartnerForEdit(e){
		var id = e.dataset['id_callback'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getCallClientForEdit',id:id},
				cache:false,
				success:function(responce){
					$('#type_callback_partner').val('edit');
					$('#id_callback_partner').val(id);
					var arr = JSON.parse(responce);
					console.log()
					$('#comment_finpartner').val(arr['comment']);
					$('#data_call_finpartner').val(arr['date_callback']);
					//$('#predoplata_type option[value="'+arr['preorder_type']+'"]').prop('selected',true);
					//$('#payment_form_finpartner option[value="'+arr['payment_form']+'"]').prop('selected',true);
					//$('#predoplata_sum_partner').val(arr['summ']);
					//$('#data_payment_finpanter').val(arr['date_summ_pay']);
				}
			})
		{/literal}
	}

	function calculate_summ(){
		var summ = $('#price_event').val();
		var nalog = $('#nalog_percent').val();
		var our_percent = $('#our_percent').val();
		var nadbavka = Math.ceil((+summ*((+our_percent + 100)/100))*((+nalog + 100)/100));
		var final = nadbavka;
		$('#result_calculating').text(final);
	}
	//catcher button click event
	$('#calculator_button_block button').on('click',function(){
		var value_btn = $(this).text(); 
		var type_btn = $(this).data('type');
		setValueToOperand(value_btn,type_btn);
	});

	$('#text_block').on('change',function(){
		var text_val = $(this).val();
		var sign_reg = /[-+*/]/g;
		var check_text_sign = text_val.match(sign_reg);
		if(check_text_sign != ""){
			var arr = text_val.split(check_text_sign);
			leftoperand = arr[0];
			rightoperand = arr[1];
			operation = " "+check_text_sign;
			operation = operation.substr(1);
		}else{
			leftoperand = text_val;
		}
	});

	//
	function setValueToOperand(value,type){
		console.log(leftoperand+" "+operation+" "+rightoperand+" "+value+" "+type);
		var line = "";
		switch(type){
			case "number":
				if((leftoperand == "")||(operation == "")){
					if(leftoperand.length <11){
						leftoperand += value;
					}else if(leftoperand == "blocked"){
						break;
					}else{
						break;
					}
				}else if((leftoperand != "")&&(operation != "")){
					if(rightoperand.length <11){
						rightoperand +=value;
					}else if(rightoperand == "blocked"){
						break;
					}else{
						break;
					}
				}
				
				break;
			case "sign":
				if(operation.length<1){
					if(operation != "blocked"){
						operation += value;
					}else{
						break;
					}
				}
				break;
			case "calculate":
				line = getResultOperation(leftoperand,rightoperand,operation);
				leftoperand = "blocked";
				rightoperand = "blocked";
				operation = "blocked";
				$('#text_block').val(line);
				break;
			case "percent":
				console.log("left: "+leftoperand+" right: "+rightoperand);
				if((leftoperand != "")||(rightoperand != "")){
					line = getResultPercentOperation(leftoperand,rightoperand,operation);
					if(line != ""){
						leftoperand = "blocked";
						rightoperand = "blocked";
						operation = "blocked";
						$('#text_block').val(line);
					}else{
						leftoperand = "";
						rightoperand = "";
						operation = "";
						$('#text_block').val("");
					}
				}else{
					line = "";
					leftoperand = "";
					rightoperand = "";
					operation = "";
					$('#text_block').val("");
				}
				break;
			case "cancel":
				leftoperand = "";
				operation = "";
				rightoperand = "";
				break;
			case "backstep":
				if((leftoperand == "")||(operation == "")){
					leftoperand = leftoperand.substr(0,leftoperand.length-1);
				}else if((leftoperand != "")&&(operation != "")){
					rightoperand = rightoperand.substr(0,rightoperand.length-1);
				}
				break;
		}
		if((line == "")&&(leftoperand!="blocked")&&(rightoperand!="blocked")&&(operation!="blocked")){
			line = leftoperand+operation+rightoperand;
			$('#text_block').val(line);
		}
	}

	function getResultOperation(a,b,op){
		var result_line = "";
		console.log(typeof op);
		switch(op){
			case "+":
			result = +a + +b;
			result_line = a+op+b+" = "+result;
				break;
			case "-":
			result = +a - +b;
			result_line = a+op+b+" = "+result;
				break;
			case "/":
			result = +a / +b;
			result = Math.ceil(result);
			result_line = a+op+b+" = "+result;
				break;
			case "*":
			result = +a * +b;
			result_line = a+op+b+" = "+result;
				break;
			default:
				console.log(op+" "+operation);
				break;
		}
		return result_line;
	}

	function getResultPercentOperation(a,b,op){
		console.log(op);
		switch(op){
			case "+":
			result = +a + ((+a/100)* +b);
			result = Math.ceil(result);
			result_line = a+op+b+"% = "+result;
				break;
			case "-":
			result = +a - ((+a/100)* +b);
			result = Math.ceil(result);
			result_line = a+op+b+"% = "+result;
				break;
			case "*":
			result = (+a/100)* +b;
			result = Math.ceil(result);
			result_line = a+op+b+"% = "+result;
				break;
			default:
				result_line = "";
				break;
		}
		console.log(result_line);
		return result_line;
	}

	function show_partner_req_list(){
		var type_selected = $('#dfor option:selected').val();
		var partner_id = $('#partner_print_id option:selected').val();
		console.log(type_selected+' '+partner_id);
		if(type_selected == 'partner'){
			$('.p_req').show();
			{literal}
				$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'getListRequesitesOfPartner',partner_id:partner_id},
					cache:false,
					success:function(responce){
						$('#list_req_partner').html(responce);
					}
				});
			{/literal}
		}
	}

	function savePaymentInfo(){
		var payment_from = $('#payment_from').val();
		var stream = $('#stream').val();
		var type_pay = $('#type_pay').val();
		var form = $('#form').val();
		var data = $('#data').val();
		var summ = $('#summ').val();
		var ticket_id = $('#ticket_id').val();
		var type_operation = $('#type_operation').val();
		var edit_line = $('#editlinepay').val();
		var comment_payment = $('#comment_payment').val();
		var action = "";
		var user_id = {$user_id};
		if(type_operation == 'add'){
			action = 'addPayment';
		}else if(type_operation == 'edit'){
			action = 'editPayment';
		}

		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:action,payment_from:payment_from,stream:stream,type_pay:type_pay,form:form,data:data,summ:summ,ticket_id:ticket_id,type_operation:type_operation,edit_line:edit_line,comment_payment:comment_payment,user_id:user_id},
				cache:false,
				success:function(responce){
					window.location.reload();
					//console.log(responce);
				}
			});
		{/literal}
	}

	function getPredata(e){
		$('#payment_from').val(e.dataset['type']);
		$('#type_operation').val("add");
		$('#payment_from option[value=""]').prop('selected',true);
		$('#stream option[value=""]').prop('selected',true);
		$('#type_pay option[value=""]').prop('selected',true);
		$('#form option[value=""]').prop('selected',true);
		$('#data').val('');
		$('#summ').val('');
		$('#comment_payment').val('');
	}

	function editPayment(e){
		var id = e.dataset['id'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getLinePayment',id:id},
				cache:false,
				success:function(responce){
					var arr = JSON.parse(responce);
					$('#payment_from option[value="'+arr['payment_from']+'"]').prop('selected',true);
					$('#stream option[value="'+arr['stream']+'"]').prop('selected',true);
					$('#type_pay option[value="'+arr['type_payment']+'"]').prop('selected',true);
					$('#form option[value="'+arr['form']+'"]').prop('selected',true);
					$('#data').val(arr['data']);
					$('#summ').val(arr['summ']);
					$('#comment_payment').val(arr['comment']);
					$('#type_operation').val('edit');
					$('#editlinepay').val(id);
				}
			});
		{/literal}
	}

	function deletePayment(e){
		var id = e.dataset['id'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'deletePayment',id:id},
				cache:false,
				success:function(responce){
					window.location.reload();
				}
			});
		{/literal}
	}

	function getRouteBlockForPartner(a,b,c){
		var wishid = a;
		var partnerid = b;
		var car_id = c;
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getRouteBlockForPartner',wishid:wishid,partnerid:partnerid,car_id:car_id},
				cache:false,
				success:function(responce){
					console.log(responce);
					$('#blocks_partner').html(responce);
				}
			});
		{/literal}
	}

	function reasonCancelShow(){
		if($('#status_ticket option:selected').val() == 'Отказ'){
			$('.reason_cancel_block').show();
			$('.rateClosedTicket').hide();
		}else if($('#status_ticket option:selected').val() == 'Закрыта'){
			$('.rateClosedTicket').show();
			$('.reason_cancel_block').hide();
		}else{
			$('.rateClosedTicket').hide();
			$('.reason_cancel_block').hide();
		}		
	}

	function savePartnerRouteList(tr,car_id,selector,route_id){
		var type_route = tr;
		var car_id = car_id;
		var selector = selector;
		var value_field = $('#'+selector).val();
		var route_id = route_id;
		console.log(type_route+' '+car_id+' '+value_field+' '+route_id);
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'savePartnerRouteList',type_route:type_route,car_id:car_id,money:value_field,route_id:route_id},
				cache:false,
				success:function(responce){
					if(selector == last_success_key){
		    			window.location.reload();
			    	}else{
			    		//console.log(last_success_key);
			    		//console.log(selector);
			    	}
				}
			});
		{/literal}
	}

	$('#setted_control span').on('click',function(){
		$('#setted_control').hide();
		$('#list_control').show();
		$('#list_controller').focus();
	});

	$('#list_controller').on('change',function(){
		var curr_control  = $('#curr_control').val();
		var selected_id = $('#list_controller option:selected').val();
		var selected_name = $('#list_controller option:selected').text();
		var ticket_id = $('#ticket_id').val();
		var user_id = {$user_id};
		console.log(curr_control+" "+selected_name);
		if(curr_control!=selected_name){
			console.log('yeah');
			{literal}
				$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'editController',id_control:selected_id,ticket_id:ticket_id,user_id:user_id},
					cache:false,
					success:function(){
						window.location.reload();
					}
				});
			{/literal}
		}else{
			console.log('nope');
			$('#setted_control').show();
			$('#list_control').hide();
		}
	});

	$('#addNewFizFace').on('click',function(){
		$('#create_or_pin_block').hide();
		$('#create_cabinet_for_fiz_face').show();
	});

	function deleteWCFromTicket(e){
		var wc = e.dataset['wc'];
		var ticket_id = $('#ticket_id').val();
		var check_reshimost = "";
		check_reshimost = confirm("Вы точно хотите удалить машину с заявки?");
		{literal}
			if(check_reshimost){
				$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'DelWCFT',wc:wc},
					cache:false,
					success:function(responce){
						window.location.reload();
						//console.log(responce);
					}
				});
			}else{

			}
		{/literal}
	}
</script>    