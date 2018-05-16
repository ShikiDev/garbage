<div class="table-responsive">
	<table class="table sortTable1 table-bordered">
		<thead>
			<th>Дата</th>
			<th>№ заявки</th>
			<th>Город</th>
			<th>Причина отказа</th>
		</thead>
		<tbody id="filter_refuse_table">
			{foreach item=refuse key=key from=$report_refuse_ticket}
				<tr>
					<td>{$refuse.time_add}</td>
					<td><a href="/clientAccount/ticket_procat/{$refuse.id}" target="_blank">{$refuse.id}</a></td>
					<td>{$refuse.ticket_city}</td>
					<td>{$refuse.reason_cancel}</td>
				</tr>
			{/foreach}
		</tbody>
	</table>
</div>