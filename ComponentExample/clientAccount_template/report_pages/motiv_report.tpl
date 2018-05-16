<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			<th>№ заявки</th>
			<th>Дата создания заявки</th>
			<th>Дата начала работы</th>
			<th>Начисленной АК</th>
			<th>Полученной АК</th>
			<th>Диспетчер</th>
		</thead>
		<tbody id="motiv">
			{foreach item=mot key=key from=$report_motivation}
			<tr>
				<td><a href="/clientAccount/ticket_procat/{$mot.id}" target="_blank">{$mot.id}</a></td>
				<td>{$mot.time_add}</td>
				<td>{$mot.data}</td>
				<td>{$mot.ak_summ}</td>
				<td>{$mot.got_ak}</td>
				<td>{$mot.manager_info.nickname}</td>
			</tr>
			{/foreach}
		</tbody>
	</table>
</div>