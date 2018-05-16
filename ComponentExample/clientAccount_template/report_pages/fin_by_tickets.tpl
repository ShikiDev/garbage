<div class="table-responsive">
	<table class="table sortTable1 table-bordered">
		<thead>
			<th>№ заявки</th>
			<th>Дата создания</th>
			<th>Город</th>		
			<th>Статус</th>			
			<th>Сумма заказа</th>			
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
			{foreach item=elem key=key from=$fin_arr}
				<tr>
					<td><a href="/clientAccount/ticket_procat/{$key}" target="_blank">{$key}</a></td>
					<td><a href="/clientAccount/ticket_procat/{$key}" target="_blank">{$elem.data_add}</a></td>
					<td>{$elem.work_city}</td>
					<td>{$elem.status}</td>					
					<td>{$elem.client_summ}</td>					
					<td>{$elem.partner_summ}</td>
					<td>{$elem.ak_summ}</td>
					<td>{$elem.ak}</td>
					<td>{$elem.client_incoming}</td>
					<td>{$elem.partner_incoming}</td>
					<td>{$elem.client_outcoming}</td>
					<td>{$elem.partner_outcoming} <br> {$elem['temp_partner_summ_way']}</td>
					<td>{$elem.client_hold}</td>
					<td>{$elem.partner_hold}</td>
					<td>{$elem.manager_name}</td>
					<td>{$elem.client_name}</td>
					<td>{$elem.partner_name}</td>
				</tr>
			{/foreach}
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td>{$final_line.client_summ_fin}</td>
					<td>{$final_line.partner_summ_fin}</td>
					<td>{$final_line.ak_summ_fin}</td>
					<td>{$final_line.ak_fin}</td>
					<td>{$final_line.client_incoming_fin}</td>
					<td>{$final_line.partner_incoming_fin}</td>
					<td>{$final_line.client_outcoming_fin}</td>
					<td>{$final_line.partner_outcoming_fin}</td>
					<td>
					{if $hold.client_plus_hold != '' && $hold.client_minus_hold!=''}
						<i class="hold_plus">+ {$hold.client_plus_hold}</i> / <i class="hold_minus">- {$hold.client_minus_hold}</i>
					{elseif $hold.client_plus_hold != '' && $hold.client_minus_hold == ''}
					 <i class="hold_plus">+{$hold.client_plus_hold}</i>
					{elseif $hold.client_plus_hold == '' && $hold.client_minus_hold!=''}
					 <i class="hold_minus">-{$hold.client_minus_hold}</i>
					{else}{/if}</td>
					<td>
					{if $hold.partner_plus_hold != '' && $hold.partner_minus_hold!=''}
						<i class="hold_plus">+ {$hold.partner_plus_hold}</i> / <i class="hold_minus">- {$hold.partner_minus_hold}</i>
					{elseif $hold.partner_plus_hold != '' && $hold.partner_minus_hold == ''}
					 <i class="hold_plus">+ {$hold.partner_plus_hold}</i>
					{elseif $hold.partner_plus_hold == '' && $hold.partner_minus_hold!=''}
					 <i class="hold_minus">- {$hold.partner_minus_hold}</i>
					{else}{/if}</td>
					<td colspan="3"></td>
				</tr>
		</tbody>
	</table>
</div>