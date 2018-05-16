<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			<th>№ заявки</th>			
			<th>Статус</th>
			<th>Сумма заказа</th>
			<!-- <th>Оплачено клиентом</th> -->
			<th>Сумма партнера</th>
			<th>АК</th>
			<th>Полученная АК</th>
			<th>Входящие клиент</th>
			<th>Входящие партнер</th>
			<th>Исходящие клиент</th>
			<th>Исходящие партнер</th>
			<th>Задолжность клиент</th>
			<th>Задолжность партнер</th>
			<th>Диспетчер</th>
			<th>Клиент</th>
			<th>Партнер</th>
		</thead>
		<tbody style="text-align: center;" id="fin_rep_by_t">
			{foreach item=elem key=key from=$test_lines}
				<tr>
					<td><a href="/clientAccount/ticket_procat/{$key}" target="_blank">{$key}</a></td>
					<td>{$elem.status}</td>
					<td>{$elem.client_summ}</td>
					<!-- <td>{$elem.client_incoming}</td> -->
					<td>{$elem.partner_summ}</td>
					<td>{$elem.ak_summ}</td>
					<td>{$elem.ak}</td>
					<td>{$elem.client_incoming}</td>
					<td>{$elem.partner_incoming}</td>
					<td>{$elem.client_outcoming}</td>
					<td>{$elem.partner_outcoming}</td>
					<td>{$elem.client_hold}</td>
					<td>{$elem.partner_hold}</td>
					<td>{$elem.manager_name}</td>
					<td>{$elem.client_name}</td>
					<td>{$elem.partner_name}</td>
				</tr>
			{/foreach}
		</tbody>
	</table>
</div>