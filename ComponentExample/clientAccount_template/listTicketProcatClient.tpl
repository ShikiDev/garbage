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
<div class="x_content">
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<a href="/clientAccount/addTicketProcat" target="_blank"><button class="btn_blue" type="button" style="float: right;">Создать заявку</button></a>
				<h3>Здравствуйте, {$nickname}</h3>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<div class="row">
					<div class="col-md-12" id='count_ticket'>
						<h4>Найдено заявок {$counter_ticket}</h4>
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
									<th>Личный менеджер по заявке</th>
									<th>Телефон менеджера</th>
									<th>Статус заявки</th>
								</thead>
								<tbody>
									{foreach item=ticket key=key from=$list_ticket_procat}
									<tr>
										<td>{$ticket.id}</td>
										<td><a href="{if $group_id == '18'}/clientAccount/ticket_procat/{$ticket.id}{else}{/if}">{$ticket.time_add}</a></td>
										<td><a href="{if $group_id == '18'}/clientAccount/ticket_procat/{$ticket.id}{else}{/if}">{$ticket.ticket_city}</a></td>
										<td><a href="{if $group_id == '18'}/clientAccount/ticket_procat/{$ticket.id}{else}{/if}">{$ticket.controller.nickname}</a></td>
										<td><a href="{if $group_id == '18'}/clientAccount/ticket_procat/{$ticket.id}{else}{/if}">{$ticket.controller.phone}</a></td>
										<td><a href="{if $group_id == '18'}/clientAccount/ticket_procat/{$ticket.id}{else}{/if}"><span class="label label-default status_{$ticket.color_status}">{$ticket.status_ticket}</span></a></td>
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