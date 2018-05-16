<div class="table-responsive">
	<table class="table sortTable2 table-bordered">
		<thead>
			<th>Дата</th>
			<th>Приход наличный</th>
			<th>Приход карта</th>
			<th>Приход безналичный</th>
			<th>ИТОГО приход</th>
			<th>Расход наличный</th>
			<th>Расход карта</th>
			<th>Расход безналичный</th>
			<th>ИТОГО расход</th>
			<th>Сдача бабла</th>
		</thead>
		<tbody style="text-align: center;" id="fin_rep_full_by_day">
			{foreach item=elem key=key from=$fin_part_days}			
			<tr>
				<td>{$elem.day}</td>
				<td><i class="pointer" data-type="incoming" data-target="#additionalInfoAbout" data-toggle="modal" data-form="nal" data-day="{$elem.day}" onclick="getDataForFRBD(this);">{$elem.incoming.nal}</i></td>
				<td><i class="pointer" data-type="incoming" data-target="#additionalInfoAbout" data-toggle="modal" data-form="cart" data-day="{$elem.day}" onclick="getDataForFRBD(this);">{$elem.incoming.cart}</i></td>
				<td><i class="pointer" data-type="incoming" data-target="#additionalInfoAbout" data-toggle="modal" data-form="without_nal" data-day="{$elem.day}" onclick="getDataForFRBD(this);">{$elem.incoming.without_nal}</i></td>
				<td>{$elem.incoming.final}</td>
				<td><i class="pointer" data-type="outcoming" data-target="#additionalInfoAbout" data-toggle="modal" data-form="nal" data-day="{$elem.day}" onclick="getDataForFRBD(this);">{$elem.outcoming.nal}</i></td>
				<td><i class="pointer" data-type="outcoming" data-target="#additionalInfoAbout" data-toggle="modal" data-form="cart" data-day="{$elem.day}" onclick="getDataForFRBD(this);">{$elem.outcoming.cart}</i></td>
				<td><i class="pointer" data-type="outcoming" data-target="#additionalInfoAbout" data-toggle="modal" data-form="without_nal" data-day="{$elem.day}" onclick="getDataForFRBD(this);">{$elem.outcoming.without_nal}</i></td>
				<td>{$elem.outcoming.final}</td>
				<td>{if $elem.hangover !=''||$elem.hangover !=0}{$elem.hangover}{else} - {/if}</td>
			</tr>
			{/foreach}
		</tbody>
	</table>
</div>