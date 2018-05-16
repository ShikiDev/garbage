<div class="row x_panel">
	<div class="col-md-12 col-md-12">
		<h3>Расходы и сдача денег</h3>
	</div>
</div>


<div class="row">
	<div class="col-md-12 col-lg-offset-1 col-lg-10">
		<ul class="nav nav-tabs">
		  <li class="active"><a data-toggle="tab" href="#expense" onclick="$('#expense_list').show(); $('#hangover_list').hide();">Расходы</a></li>
		  <li><a data-toggle="tab" href="#hangover" onclick="$('#hangover_list').show(); $('#expense_list').hide();">Сдача</a></li>
		</ul>
		
		
		<div class="tab-content">
			<div id="expense" class="tab-pane fade in active">
				<div class="row">
					<div class="col-md-12 col-lg-8">
						<div class="row x_panel">
							<input type="hidden" id="type_expense" value="add">
							<input type="hidden" id="id_exp" value="">
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Наименование расхода</span>
									<select id="name_expense">
										<option value=""></option>
										<option value="Мобильный телефон">Мобильный телефон</option>
										<option value="IP телефония">IP телефония</option>
										<option value="Реклама">Реклама</option>
										<option value="Сайт">Сайт</option>
										<option value="Бонус">Бонус</option>
									</select>
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Сумма</span>
									<input type="text" id="summ_expense">
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Источник</span>
									<select id="source_money">
										<option value=""></option>
										<option value="Карта">Карта</option>
										<option value="Наличные">Наличные</option>
										<option value="Безналичный">Безналичный</option>
									</select>
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Дата</span>
									<input type="text" id="data_expense" class="picker_usial">
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Комментарий</span>
									<textarea id="comment_expense"></textarea>
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Город</span>
									<select id="city_expense">
										<option value="">Не выбрано</option>
										<option value="Санкт-Петербург">Санкт-Петербург</option>
										<option value="Москва">Москва</option>
									</select>
								</div>
							</div>
							<div class="col-md-10">
								<button type="button" class="btn btn_red" onclick="addExpenses();">Добавить расход</button>
							</div>
						</div> 
					</div>	
				</div>
			</div>
			<div id="hangover" class="tab-pane fade in">
				<div class="row">
					<div class="col-md-12 col-lg-8">
						<div class="row x_panel">
							<input type="hidden" id="type_hangover" value="add">
							<input type="hidden" id="id_hangover">
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Сумма</span>
									<input type="text" id="summ_hangover">
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Источник сдачи</span>
									<select id="source_hangover">
										<option value=""></option>
										<option value="Карта">Карта</option>
										<option value="Наличные">Наличные</option>
									</select>
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Дата</span>
									<input type="text" id="data_hangover" class="picker_usial">
								</div>
							</div>
							<div class="col-md-10">
								<div class="input-group">
									<span class="input-group-addon">Комментарий</span>
									<textarea id="comment_hangover"></textarea>
								</div>
							</div>
							<div class="col-md-10">
								<button type="button" class="btn btn_red" onclick="setHangOver();">Сохранить</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>	
</div>
	<div id="expense_list">
		<div class="row">
			<div class="col-md-12 col-lg-offset-1 col-lg-8">
				<div class="x_panel">
					<table class="table">
						<thead>
							<th>Название</th>
							<th>Сумма</th>
							<th>Источник расхода</th>
							<th>Дата</th>
							<th>Комментарий</th>
							<th>Город</th>
							<th colspan="2"></th>
						</thead>
						<tbody id="list_expenses">
							{foreach item=expense key=key from=$list}
								<tr>
									<td>{$expense.name}</td>
									<td>{$expense.summ}</td>
									<td>{$expense.source_money}</td>
									<td>{$expense.data_expense}</td>
									<td>{$expense.comment}</td>
									<td>{$expense.city}</td>
									<td><i class="fa fa-pencil fa-lg" style="cursor: pointer;" data-id_exp="{$expense.id}" onclick="getExpense(this);"></i></td>
									<td><i class="fa fa-remove fa-lg" style="cursor: pointer;" data-id_exp="{$expense.id}" onclick="deleteExpense(this);"></i></td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div id="hangover_list">
		<div class="row">
			<div class="col-md-12 col-lg-offset-1 col-lg-8">
				<div class="x_panel">
					<table class="table">
						<thead>
							<th>Дата</th>
							<th>Сумма</th>
							<th>Источник сдачи</th>
							<th>Комментарий</th>
							<th colspan="2"></th>
						</thead>
						<tbody id="list_hangovers">
							{foreach item=hangover key=key from=$list_ho}
							<tr>
								<td>{$hangover.data_hangover}</td>
								<td>{$hangover.summ}</td>
								<td>{$hangover.source_hangover}</td>
								<td>{$hangover.comment}</td>
								<td><i class="fa fa-pencil fa-lg" style="cursor: pointer;" data-id_hangover="{$hangover.id}" onclick="getHangover(this);"></i></td>
								<td><i class="fa fa-remove fa-lg" style="cursor: pointer;" data-id_hangover="{$hangover.id}" onclick="deleteHangover(this);"></i></td>
							</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
	$(document).ready(function(){
		$('#hangover_list').hide();
	});

	$('.picker_usial').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:  '{$date_current}',
        format:'d.m.Y',
        timepicker:false
    });

	function addExpenses(){
		var name = $('#name_expense option:selected').val();
		var summ = $('#summ_expense').val();
		var data = $('#data_expense').val();
		var source_money = $('#source_money option:selected').val();
		var comm = $('#comment_expense').val();
		var type_exp  = $('#type_expense').val();
		var id_exp = $('#id_exp').val();
		var city_expense = $('#city_expense').val();
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxReportsTickets.php',
				data:{action:'expensesAdd',name:name,summ:summ,data:data,source_money:source_money,comm:comm,type_exp:type_exp,id_exp:id_exp,city_expense:city_expense},
				cache:false,
				success:function(responce){
					$('#list_expenses').html(responce);
					$('#name_expense option[value=""]').prop('selected',true);
					$('#summ_expense').val('');
					$('#data_expense').val('');
					$('#source_money option[value=""]').prop('selected',true);
					$('#comment_expense').val('');
					$('#city_expense option[value=""]').prop('selected',true);
					$('#type_expense').val('add');
					$('#id_exp').val('');
				}
			})
		{/literal}
	}

	function getExpense(e){
		var id_exp = e.dataset['id_exp'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxReportsTickets.php',
				data:{action:'getExpense',id_exp:id_exp},
				cache:false,
				success:function(responce){
					var res = JSON.parse(responce);
					$('#name_expense option[value="'+res['name']+'"]').prop('selected',true);
					$('#summ_expense').val(res['summ']);
					$('#data_expense').val(res['date']);
					$('#source_money option[value="'+res['source_money']+'"]').prop('selected',true);
					$('#comment_expense').val(res['comment']);
					$('#city_expense option[value="'+res['city']+'"]').prop('selected',true);
					$('#type_expense').val('edit');
					$('#id_exp').val(id_exp);
				}
			});
		{/literal}
	}

	function deleteExpense(e){
		var id_exp = e.dataset['id_exp'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxReportsTickets.php',
				data:{action:'expenseDelete',id_exp:id_exp},
				cache:false,
				success:function(responce){
					window.location.reload();
				}
			});
		{/literal}
	}

	function setHangOver(){
		var id_hangover = $('#id_hangover').val();
		var type_hangover = $('#type_hangover').val();
		var summ_hangover = $('#summ_hangover').val();
		var data_hangover = $('#data_hangover').val();
		var source_hangover = $('#source_hangover option:selected').val();
		var comment_hangover = $('#comment_hangover').val();
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxReportsTickets.php',
				data:{action:'setHangOver',id_hangover:id_hangover,type_hangover:type_hangover,summ:summ_hangover,source_hangover:source_hangover,comment_hangover:comment_hangover,data_hangover:data_hangover},
				cache:false,
				success:function(responce){
					$('#list_hangovers').html(responce);
					$('#summ_hangover').val('');
					$('#source_hangover option[value=""]').prop('selected',true);
					$('#comment_hangover').val('');
					$('#type_hangover').val('add');
					$('#id_hangover').val('');
				}
			});
		{/literal}
	}

	function getHangover(e){
		var id_hangover = e.dataset['id_hangover'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxReportsTickets.php',
				data:{action:'getHangover',id_hangover:id_hangover},
				cache:false,
				success:function(responce){
					var res = JSON.parse(responce);
					$('#summ_hangover').val(res['summ']);
					$('#data_hangover').val(res['date']);
					$('#source_hangover option[value="'+res['source_money']+'"]').prop('selected',true);
					$('#comment_hangover').val(res['comment']);
					$('#type_hangover').val('edit');
					$('#id_hangover').val(id_hangover);
				}
			});
		{/literal}
	}

	function deleteHangover(e){
		var id_hangover = e.dataset['id_hangover'];
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxReportsTickets.php',
				data:{action:'deleteHangover',id_hangover:id_hangover},
				cache:false,
				success:function(responce){
					window.location.reload();
				}
			});
		{/literal}
	}
</script>