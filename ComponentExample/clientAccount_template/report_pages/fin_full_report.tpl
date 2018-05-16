<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			<th>Дата</th>
			<th>№ заявки</th>
			<th>Статус заявки</th>
			<th>Приход наличный</th>
			<th>Приход карта</th>
			<th>Приход безналичный</th>
			<th>ИТОГО приход</th>
			<th>Расход наличный</th>
			<th>Расход карта</th>
			<th>Расход безналичный</th>
			<th>ИТОГО расход</th>
		</thead>
		<tbody style="text-align: center;" id="fin_rep_full">
			{foreach item=elem key=key from=$fin_part}			
			<tr>
				<td>{$elem.data_add}</td>
				<td><a href="/clientAccount/ticket_procat/{$key}" target="_blank">{$key}</a></td>				
				<td>{$elem.status}</td>
				<td>{$elem.incoming.nal}</td>
				<td>{$elem.incoming.cart}</td>
				<td>{$elem.incoming.without_nal}</td>
				<td>{$elem.incoming.final}</td>
				<td>{$elem.outcoming.nal}</td>
				<td>{$elem.outcoming.cart}</td>
				<td>{$elem.outcoming.without_nal}</td>
				<td>{$elem.outcoming.final}</td>
			</tr>
			{/foreach}
			<tr>
				<td colspan="3"><strong>Итого</strong></td>
				<td>{$final_p_line.in_nal}</td>
				<td>{$final_p_line.in_cart}</td>
				<td>{$final_p_line.in_without_nal}</td>
				<td>{$final_p_line.in_final}</td>
				<td>{$final_p_line.out_nal}</td>
				<td>{$final_p_line.out_cart}</td>
				<td>{$final_p_line.out_without_nal}</td>
				<td>{$final_p_line.out_final}</td>
				<!-- <td colspan="1">{$final_fin_rep}</td> -->
			</tr>
		</tbody>
	</table>
</div>