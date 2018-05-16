<style type="text/css">
	.status_yellow{
		color: #000 !important;
		background: #ffec8b;
		border:1px solid #000;
		padding: 7px 10px;
		margin: auto !important;
		font-size: 11pt;

	}
	.status_pink{
		color: #000 !important;
		background: #fdd3f2;
		border:1px solid #fff;
		padding: 7px 10px;
		font-size: 11pt;

	}
	.status_green_light{
		color: #000 !important;
		background: #92ffd7;
		padding: 7px 10px;
		border:1px solid #fff;
		font-size: 11pt;

	}
	.status_green_dark{
		color: #f5ebeb !important;
		background: #508846;
		padding: 7px 10px;
		border:1px solid #000;
		font-size: 11pt;

	}
	.status_red{
		color: #f5ebeb !important;
		background: #e24a4a;
		padding: 7px 10px;
		border:1px solid #000;
		font-size: 11pt;

	}
	.status_gray{
		padding: 7px 10px;
		font-size: 11pt;
	}
	.status_white{
		color: #000 !important;
		background: #fff;
		padding: 7px 10px;
		border:1px solid #fff;
		font-size: 11pt;

	}
	.status_blue{
		color: #000 !important;
		background: #9ad3ff;
		padding: 7px 10px;
		border:1px solid #fff;
		font-size: 11pt;

	}
	.status_purple{
		color: #000 !important;
		background: #bf83ff;
		padding: 7px 10px;
		border:1px solid #fff;
		font-size: 11pt;

	}

	.status_cherry{
		color: #000 !important;
		background: #e65a5a;
		padding: 7px 10px;
		border:1px solid #fff;
		font-size: 11pt;
	}
</style>

<script type="text/javascript" src="/templates/callcenter/js/jquery.tablesorter.js"></script>
<div class="x_content">
	<div class="row">
		<div class="col-sm-12 col-md-12">
			<div class="x_panel">
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-12">
						<h3>Список оставленных заявок</h3>
						<button style="float: right;" type="button" class="btn btn_blue" onclick="location.href='/clientAccount/dse';">Выгрузить e-mail</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	{if $group_id!='18'}
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<div class="row">
					<h4>Поиск по заявкам</h4>
				</div>
				<div class="row">
					<div class="col-xs-12 col-md-6 col-lg-4">	
						<div class="input-group">
							<span class="input-group-addon">Поиск по номеру заявки</span>
							<input type="text" id="search_by_id">
						</div>
					</div>
					<div class="col-xs-12 col-md-8 col-lg-4">	
						<div class="input-group">
							<span class="input-group-addon">Поиск по наименованию</span>
							<select id="search_by_client">
								<option value=""></option>
								<option value="fiz">Физ лицо</option>
								{foreach item=ur key=key from=$list_client_ur}	
								<option value="{$ur}">{$ur}</option>
								{/foreach}
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-md-5 col-lg-4">	
						<div class="input-group">
							<span class="input-group-addon">Поиск по телефону</span>
							<input type="text" id="phone">
						</div>
					</div>
					<div class="col-xs-12 col-md-6 col-lg-4">
						<div class="input-group">
							<span class="input-group-addon">Поиск по статусу</span>
							<select id="status_ticket">
								<option value="">Не выбран</option>
								{foreach item=status key=key from=$status_procat}
								<option value="{$status}">{$status}</option>
								{/foreach}
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-md-4 col-lg-4">
						<div class="input-group">
							<span class="input-group-addon">Период с</span>
							<input type="text" id="begin_search" class="picker_usial">
						</div>
					</div>
					<div class="col-xs-12 col-md-4 col-lg-4">
						<div class="input-group">
							<span class="input-group-addon">по</span>
							<input type="text" id="end_search" class="picker_usial">
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-md-8 col-lg-6">
						<div class="input-group">
							<span class="input-group-addon">Поиск по контактному лицу</span>
							<input id="search_con_face" type="text"/>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-md-7 col-lg-4">
						<div class="input-group">
							<span class="input-group-addon">Город</span>
							<select id="city_list">
								<option value="">Не выбран</option>
								<option value="Санкт-Петербург">Санкт-Петербург</option>
								<option value="Москва">Москва</option>
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-md-6 col-lg-5">
						<div class="input-group">
							<span class="input-group-addon">E-mail клиента</span>
							<input type="text" id="search_email">
						</div>
					</div>
				</div>
				<div class="row">
					<button type="button" class="btn btn_blue" onclick="window.location.reload();">Сброс</button>  
					<button type="button" class="btn btn_blue"  onclick="search_ticket_by_param();">Поиск</button>
				</div>
			</div>
		</div>
	</div>
	{/if}
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<div class="row">
					<div class="col-md-12" id='count_ticket'>
						<h3>Найдено заявок {$counter_ticket}</h3>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<div class="result_search">
							<table class="table sortTable" id="ticket_table">
								<thead>
									<th>№</th>
									<th>Дата создания</th>
									<th>Город</th>	
									<th>{if $group_id!='18'}Наименование компании{else}Личный менеджер по заявке{/if}</th>
									<th>{if $group_id!='18'}Телефон и контактное лицо{else}Телефон менеджера{/if}</th>
									<th>Статус заявки</th>
									{if $group_id!='18'}<th>Дата начала работы</th>{/if}
									{if $group_id!='18'}<th>Партнеры в заявке</th>{/if}
									<th>{if $group_id!='18'}Менеджер на заявке{/if}</th>																	
									{if $group_id!='18'}<th>Дата callback клиенту</th>{/if}
								</thead>
								<tbody>
									{foreach item=ticket key=key from=$list_ticket_procat}
									<tr>
										<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{$ticket.id}</a></td>
										<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{$ticket.time_add}</a></td>
										<td>{$ticket.ticket_city}</td>
										<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{if $group_id!='18'}{$ticket.nick_client}{else}{$ticket.controller.nickname}{/if}</a></td>
										<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{if $group_id!='18'}{$ticket.tel} ({$ticket.contact_face}){else}{$ticket.controller.phone}{/if}</a></td>
										<td><a href="/clientAccount/ticket_procat/{$ticket.id}"><span class="label label-default status_{$ticket.color_status}">{$ticket.status_ticket}</span></a></td>
										
										{if $group_id!='18'}
											<td><a href="/clientAccount/ticket_procat/{$ticket.id}">
											{if $ticket.data_start!=''}
												{foreach item=d key=i from= $ticket.data_start}
													{$d} <br>
												{/foreach}
											{else}
											 -
											{/if}
											</a></td>
										{/if}
										{if $group_id!='18'}
											<td><a href="/clientAccount/ticket_procat/{$ticket.id}">
											{if $ticket.partner_work_list!= ''}
												{foreach item=p key=j from= $ticket.partner_work_list}
													{$p} <br>
												{/foreach}
											{/if}
											</a></td>
										{/if}
										<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{$ticket.controller.nickname}</a></td>
										{if $group_id!='18'}<td><a href="/clientAccount/ticket_procat/{$ticket.id}">{$ticket.last_client_callback}</a></td>{/if}
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
<script type="text/javascript">
	$(document).ready(function(){
		{literal}
		$(".sortTable").tablesorter();
		{/literal}
	});
	$('#phone').mask('8 (999) 999-99-99');

	$('.picker_usial').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:  '{$date_current}',
        format:'d.m.Y',
        timepicker:false
    });

	function search_ticket_by_param(){
		var search_id = $('#search_by_id').val();
		var search_client = $('#search_by_client option:selected').val();
		var search_phone = $('#phone').val();
		var search_status = $("#status_ticket option:selected").val();
		var search_con_face = $('#search_con_face').val();
		var search_city_list = $('#city_list option:selected').val();
		var search_begin = $('#begin_search').val();
		var search_end = $('#end_search').val();
		var search_email = $('#search_email').val();
		{literal}
			$.ajax({
				type:'POST',
				url:"../core/ajax/ajaxForAutoClass.php",
				data:{action:"search_ticket_by_param",id:search_id,client:search_client,phone:search_phone,status:search_status,search_con_face:search_con_face,search_city_list:search_city_list,begin:search_begin,end:search_end,email:search_email},
				cache:false,
				success:function(responce){
					var temp_arr = JSON.parse(responce);
					$('.result_search').html(temp_arr['data']);
					$('#count_ticket h3').text('Найдено заявок '+temp_arr['counter']);
				}
			})
		{/literal}
	}
</script>