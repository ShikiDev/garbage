<div class="x-content">
	<div class="row">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12">
					<div class="x_panel">
						
						{if $client.tag == '18'}<a href="/clientAccount/editClient/{$client_id}" target="_blank" style="float: right;"><button type="button" class="btn btn-default">Редактировать</button></a>{/if}
						<button type="button" style="float: right;" class="btn btn-default" data-toggle="modal" data-target="#{if $client.tag == '21'}correctFizDataForClient{else}correctUrDataForClient{/if}" data-type="{if $check_req == 'y'}edit{elseif $check_req == 'n'}add{/if}" onclick="openFormForRequisites(this);">{if $check_req == 'y'}Редактирование{elseif $check_req == 'n'}Добавить{/if} реквезиты</button>
						<button class="btn btn-default" style="float: right;" data-target="#clientDocExchange" data-toggle="modal" onclick="getDataAboutExchange();">Документооборот с клиентом</button>
						<button type="button" style="float: right;" class="btn btn-default" data-target="#clientPostAddress" data-toggle="modal">Контакты</button>
						<h4>Кабинет клиента {$client.name}</h4>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="x_panel">
						<div class="row">
							<div class="col-md-6 col-lg-4">
								{if $dog_data !=''}
									<ul class="list-group">
										<li class="list-group-item"><strong>Номер договора</strong><span style="float: right;">{$dog_data.num_dogovor}</span></li>
										<li class="list-group-item"><strong>Дата договора</strong><span style="float: right;">{$dog_data.data_dogovor}</span></li>
									</ul>
								{elseif $dog_data_fiz!='' && $dog_data == ''}
									<ul class="list-group">
										<li class="list-group-item"><strong>Номер договора</strong><span style="float: right;">{$dog_data_fiz.num_dogovor}</span></li>
										<li class="list-group-item"><strong>Дата договора</strong><span style="float: right;">{$dog_data_fiz.data_dogovor}</span></li>
									</ul>
								{/if}
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-md-12">
								{if $requisites!=''}
									{if $client.tag == '18'}
									<div class="panel panel-default">
						  				<div class="panel-heading">Реквезиты клиента</div>
						  				<div class="panel-body">
						  					<ul class="list-group">
											    <li class="list-group-item"><strong>Наименование компании: </strong><span style="float: right;">{$requisites.name_ur}</span></li>
											    <li class="list-group-item"><strong>ИНН: </strong><span style="float: right;">{$requisites.inn}</span></li>
											    <li class="list-group-item"><strong>КПП: </strong><span style="float: right;">{$requisites.kpp}</span></li>
											    <li class="list-group-item"><strong>ОГРН: </strong><span style="float: right;">{$requisites.ogrn}</span></li>
											    <li class="list-group-item"><strong>Юридический адрес: </strong><span style="float: right;">{$requisites.ur_address}</span></li>
											    <li class="list-group-item"><strong>Расчетный счет: </strong><span style="float: right;">{$requisites.rk_ur}</span></li>
											    <li class="list-group-item"><strong>Наименование банка: </strong><span style="float: right;">{$requisites.name_bank}</span></li>
											    <li class="list-group-item"><strong>БИК: </strong><span style="float: right;">{$requisites.bik}</span></li>
											    <li class="list-group-item"><strong>Корреспондентский счет: </strong><span style="float: right;">{$requisites.ks_ur}</span></li>
											    <li class="list-group-item"><strong>Имя ген. директора: </strong><span style="float: right;">{$requisites.gen_dir_name}</span></li>
											</ul>
						  				</div>
						  			</div>
						  			{elseif $client.tag == '21'}
						  			<div class="panel panel-default">
						  				<div class="panel-heading">Реквезиты клиента</div>
						  				<div class="panel-body">
						  					<ul class="list-group">
											    <li class="list-group-item"><strong>ФИО: </strong><span style="float: right;">{$requisites.fio}</span></li>
											    <li class="list-group-item"><strong>Номер и серия паспорта: </strong><span style="float: right;">{$requisites.nomer_passport} {$requisites.seria_passport}</span></li>
											    <li class="list-group-item"><strong>Дата выдачи: </strong><span style="float: right;">{$requisites.data_get}</span></li>
											    <li class="list-group-item"><strong>Кем выдан: </strong><span style="float: right;">{$requisites.who_give}</span></li>
											    <li class="list-group-item"><strong>Код подразделения: </strong><span style="float: right;">{$requisites.code_podraz}</span></li>
											    <li class="list-group-item"><strong>Место прописки: </strong><span style="float: right;">{$requisites.location_reg}</span></li>
											    <li class="list-group-item"><strong>Место рождения: </strong><span style="float: right;">{$requisites.placeborn}</span></li>
											    <li class="list-group-item"><strong>Дата рождения: </strong><span style="float: right;">{$requisites.data_born}</span></li>
											</ul>
						  				</div>
						  			</div>
						  			{/if}
					  			{/if}
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="panel panel-default">
					  <div class="panel-heading">Заявки клиента</div>
					  <div class="panel-body">
						  <div class="row">
						  	<div class="col-md-12">
						  		<table class="table">
						  			<thead>
						  				<th>Номер</th>
						  				<th>Статус</th>
						  				<th>Закрепленный менеджер</th>
						  			</thead>
						  			<tbody>
						  				{foreach item=ticket key=key from=$list_ticket}
						  				<tr>
						  					<td><a href="/clientAccount/ticket_procat/{$ticket.id}">№ {$ticket.id}</a></td>
						  					<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{$ticket.status_ticket}</a></td>
						  					<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{$ticket.manager_info.nickname}</a></td>
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
	</div>
</div>

<div id="correctUrDataForClient" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Работа с реквезитами клиента</h4>
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

<div id="correctFizDataForClient" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Работа с реквезитами клиента</h4>
				<input type="hidden" id="type_correct">
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">ФИО: </span>
							<input type="text" id="fio_fiz" value="{$requisites.fio}">
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Номер паспорта: </span>
							<input type="text" id="np_fiz" value="{$requisites.nomer_passport}">
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Серия паспорта: </span>
							<input type="text" id="sp_fiz" value="{$requisites.seria_passport}">
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Дата выдачи: </span>
							<input type="text" class="picker_usial" id="dg_fiz" value="{$requisites.data_get}">
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Кем выдан: </span>
							<input type="text" id="wg_fiz" value="{$requisites.who_give}">
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Код подразделения: </span>
							<input type="text" id="cp_fiz" value="{$requisites.code_podraz}">
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Место прописки: </span>
							<textarea id="lr_fiz">{$requisites.location_reg}</textarea>
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Место рождения: </span>
							<input type="text" id="pb_fiz" value="{$requisites.placeborn}">
						</div>
					</div>
					<div class="col-md-12">
						<div class="input-group">
							<span class="input-group-addon">Дата рождения: </span>
							<input type="text" class="picker_usial" id="db_fiz" value="{$requisites.data_born}">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
				<button type="button" class="btn btn_blue" onclick="sendFizDataClient();" style="float: right;">Сохранить</button>
			</div>
		</div>
	</div>	
</div>

<div id="clientDocExchange" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Документооборот с клиентом</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-10 col-lg-5">
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">№ заявки</span>
									<select id="ticket_id">
										<option value="" selected></option>
										{foreach item=ticket key=key from=$list_ticket}
										<option value="{$ticket.id}">№ {$ticket.id}</option>
										{/foreach}
									</select>
								</div>
							</div>
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Комментарий</span>
									<textarea id="comment_exchange"></textarea>
								</div>
							</div>
							<div class="col-md-12">
								<button type="button" class="btn btn_blue" onclick="saveClientExchange();">Сохранить</button>
							</div>
						</div>
					</div>
				</div>
				<br>
				<div class="row">
					<div class="col-md-12">
						<div id="history_exchange">
							<table class="table">
								<thead>
									<th>Дата</th>
									<th>Номер заявки</th>
									<th>Комментарий</th>
								</thead>
								<tbody>
									
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Сохранить</button>
			</div>
		</div>
	</div>
</div>

<div id="clientPostAddress" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Контакты</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-10 col-lg-10">
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Почтовый адрес клиента</span>
									<textarea id="post_address_client">{$client.post_address}</textarea>
								</div>
							</div>
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Контактное лицо</span>
									<input type="text" id="cont_face_client" value="{$client.cont_face}">
								</div>
							</div>
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Телефон</span>
									<input type="text" id="cont_phone_client" class="phone_mask" value="{$client.cont_phone}">
								</div>
							</div>
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">E-mail</span>
									<input type="text" id="cont_phone_email" value="{$client.email}">
								</div>
							</div>
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Номер договора</span>
									<input type="text" id="numDoc_client" value="{$client.num_doc}">
								</div>
							</div>
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Дата заключения</span>
									<input type="text" id="dataNumDoc_client" class="picker_usial" value="{$client.data_doc}">
								</div>
							</div>
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">С кем заключен</span>
									<select id="withWhoDog">
										<option value=""></option>
										<option value="ЕЦА" {if $client.doc_w_h == 'ЕЦА'}selected{/if}>ЕЦА</option>
										<option value="Хорека" {if $client.doc_w_h == 'Хорека'}selected{/if}>Хорека</option>
									</select>
								</div>
							</div>
							<div class="col-md-12">
								<button type="button" class="btn btn_blue" onclick="updateClientPostAddress();">Сохранить</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		$('.phone_mask').mask("8 (999) 999-99-99");
	});

	function openFormForRequisites(e){
		var type = e.dataset['type'];
		var id_client = {$client_id};
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
						
						console.log(arr_data);
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
						$('#action_by_ur').val(arr_data['action_by']);
						$('#type_ur').val(arr_data['type_ur']);
						$('#face_of_ur_imin_pod').val(arr_data['face_comp_imp']);
						$('#face_of_ur').val(arr_data['face_comp']);
						$('#podpisant').val(arr_data['podpisant']);
					}
				});
			{/literal}
		}
	}

	$('.picker_usial').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:  '{$date_current}',
        format:'d.m.Y',
        timepicker:false
    });

	function  sendFizDataClient() {

		var fio_fiz = $('#fio_fiz').val();
		var np_fiz = $('#np_fiz').val();
		var sp_fiz = $('#sp_fiz').val();
		var dg_fiz = $('#dg_fiz').val();
		var wg_fiz = $('#wg_fiz').val();
		var cp_fiz = $('#cp_fiz').val();
		var lr_fiz = $('#lr_fiz').val();
		var pb_fiz = $('#pb_fiz').val();
		var db_fiz = $('#db_fiz').val();
		var type_correct = $('#type_correct').val();
		var id_client = {$client_id};

		{literal}
			$.ajax({
				type:'POST',
				url:"/core/ajax/ajaxForAutoClass.php",
				data:{action:"sendFizDataClient",
						fio_fiz:fio_fiz,
						np_fiz:np_fiz,
						sp_fiz:sp_fiz,
						dg_fiz:dg_fiz,
						wg_fiz:wg_fiz,
						cp_fiz:cp_fiz,
						lr_fiz:lr_fiz,
						pb_fiz:pb_fiz,
						db_fiz:db_fiz,
						type_corr:type_correct,
						id_client:id_client

					},
				cache: false,
				success:function(response){
					console.log(response);
					//window.location.reload();
				}
			});
		{/literal}
	}

	function sendUrDataClient(){
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
		var id_client = {$client_id};
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

	function saveClientExchange(){
		var client_id = {$client_id};
		var ticket_id = $('#ticket_id option:selected').val();
		var comment = $('#comment_exchange').val();
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'addClientDocumentExchange',client_id:client_id,ticket_id:ticket_id,comment:comment},
				cache:false,
				success:function(response){
					getDataAboutExchange();
				}
			});
		{/literal}
	}

	function getDataAboutExchange(){
		var client_id = {$client_id};
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getDataAboutExchange',client_id:client_id},
				cache:false,
				success:function(response){
					$('#history_exchange tbody').html(response);
				}
			});
		{/literal}
	}

	function updateClientPostAddress(){
		var post_address = $('#post_address_client').val();
		var cont_face_client = $('#cont_face_client').val();
		var cont_phone_client = $('#cont_phone_client').val();
		var numDoc_client = $('#numDoc_client').val();
		var dataNumDoc_client = $('#dataNumDoc_client').val();
		var withWhoDog = $('#withWhoDog').val();
		var email = $('#cont_phone_email').val();
		var client_id = {$client_id};
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'updateClientPostAddress',
					  address:post_address,
					  cont_face_client:cont_face_client,
					  cont_phone_client:cont_phone_client,
					  numDoc_client:numDoc_client,
					  dataNumDoc_client:dataNumDoc_client,
					  withWhoDog:withWhoDog,
					  email:email,
					  id:client_id},
				cache:false,
				success:function(response){
					window.location.reload();
				}
			});
		{/literal}
	}
</script>