<div class="row">
	<div div class="col-lg-12">
		<div class="row x_panel">
			<div class="col-md-12">
				<button type="button" style="float:right;" class="btn btn_blue" onclick="show_add_consult();"><i class="fa fa-plus-square"></i> Добавить</button>
				<h2>Консультационные звонки</h2>
			</div>
		</div>
		<div class="row add_consult_data" style="display: none;">
			<div class="col-lg-6">
				<div class="x_panel">
					<div class="col-md-12">
						<input type="hidden" id="type_save">
						<input type="hidden" id="id_edit_line">
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Имя клиента :</span>
									<input type="text" id="name_client">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Телефон :</span>
									<input type="text" id="telephone">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">E-mail :</span>
									<input type="text" id="email">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Даты мероприятия :</span>
									<input type="text" id="datas_event">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Заказываемое авто:</span>
									<textarea id="car_wish"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Маршрут :</span>
									<textarea id="route"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="input-group">
									<span class="input-group-addon">Комментарий :</span>
									<textarea id="comment"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<button type="button" class="btn btn_blue" onclick="saveConsultData();">Сохранить</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row x_panel">
			<div class="col-md-12">
				{if $consult_list != ''}
					<table class="table">
						<thead>
							<th>№</th>
							<th>Дата обращения</th>
							<th>Имя</th>
							<th>Телефон/E-mail</th>
							<th>Планируемые даты</th>
							<th>Планируемое ТС</th>
							<th>Маршрут</th>
							<th>Комментарии</th>
							<th colspan="1"></th>
						</thead>
						<tbody>
							{foreach item=list key=key from=$consult_list}
							<tr>
								<td>{$key+1}</td>
								<td>{$list.data}</td>
								<td>{$list.client_name}</td>
								<td><label>Телефон:</label>{$list.telephone}<br><label>E-mail:</label>{$list.email}</td>
								<td>{$list.data_work}</td>
								<td>{$list.car_wish}</td>
								<td>{$list.route}</td>
								<td>{$list.comment}</td>
								<td><i class="fa fa-pencil fa-lg" style="margin-right: 20px; cursor: pointer;" data-id="{$list.id}" onclick="getLineConsultForEdit(this);"></i><i class="fa fa-remove fa-lg" style="margin-right: 0; cursor: pointer;" data-id="{$list.id}" onclick="deleteLineConsult(this);"></i></td>
							</tr>
							{/foreach}
						</tbody>
					</table>
				{else}
				<div class="row">
					<div class="col-md-6">
						<div class="alert alert-info">
						  <strong>Info!</strong> Не найдено консультационных звонков.
						</div>
					</div>
				</div>					
				{/if}
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$('#telephone').mask("8 (999) 999-99-99");
	});

	function show_add_consult(){
		$('.add_consult_data').show();
		$('#type_save').val('add');
		$('#name_client').val('');
		$('#telephone').val('');
		$('#email').val('');
		$('#comment').val('');
		$('#datas_event').val('');
		$('#route').val('');
		$('#car_wish').val('');
		$('#id_edit_line').val('');
	}

	function saveConsultData(){
		var name_client = $('#name_client').val();
		var telephone = $('#telephone').val();
		var email = $('#email').val();
		var comment = $('#comment').val();
		var email = $('#email').val();
		var route = $('#route').val();
		var data_work = $('#datas_event').val();
		var car_wish = $('#car_wish').val();
		var type_save = $('#type_save').val();
		var action = (type_save == 'edit')?"editConsult":"addConsult";
		var id_line = (($('#id_edit_line').val()!=undefined)&&($('#id_edit_line').val()!=false))?$('#id_edit_line').val():"";
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForConsult.php',
				data:{action:action,name_client:name_client,telephone:telephone,email:email,comment:comment,id_line:id_line,route:route,car_wish:car_wish,data_work:data_work},
				cache:false,
				success:function(){
					window.location.reload();
				}
			});
		{/literal}
	}

	function getLineConsultForEdit(e){
		var id = e.dataset['id'];
		console.log(id);
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForConsult.php',
				data:{action:'getLineConsultData',id:id},
				cache:false,
				success:function(responce){
					var temp = JSON.parse(responce);
					console.log(temp);
					$('#name_client').val(temp['client_name']);
					$('#telephone').val(temp['telephone']);
					$('#email').val(temp['email']);
					$('#datas_event').val(temp['data_work']);
					$('#route').val(temp['route']);
					$('#car_wish').val(temp['car_wish']);
					$('#comment').val(temp['comment']);
					$('#type_save').val('edit');
					$('.add_consult_data').show();
					$('#id_edit_line').val(id);
				}
			})
		{/literal}
	}

	function deleteLineConsult(e){
		var id = e.dataset['id'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForConsult.php',
				data:{action:'deleteLineFromConsultList',id:id},
				cache:false,
				success:function(){
					window.location.reload();
				}
			});
		{/literal}
	}
</script>