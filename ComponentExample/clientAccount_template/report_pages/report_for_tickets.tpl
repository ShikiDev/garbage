<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading" id="headerFirstBlock">
				<strong>Отчет по заявкам. Город СПб</strong>
			</div>
			<div class="panel-body">
				<table class="table table-bordered">
					<thead>
						<th></th>
						{foreach item=stat key=key from=$status_procat}
						<th>{$stat}</th>
						{/foreach}
						<th>ИТОГО</th>
						<th>КФ Успеха</th>
					</thead>
					<tbody style="text-align: center;" id="report_by_tic">
						{foreach item=data key=i from=$report_by_tickets_spb}
						<tr>
							<td>{$i}</td>
							{foreach item=static key=key from=$data}
								<td><i class="pointer" data-typets="{$i}" data-status="{$key}" data-city="Санкт-Петербург" data-target="#additionalInfoAbout" data-toggle="modal" onclick="getDataForRFT(this);">{$static}</i></td>
							{/foreach}
							<td>{$sum_status_tickets_spb[$i]['summ']}</td>
							<td>{$sum_status_tickets_spb[$i]['success']}</td>
						</tr>
						{/foreach}
					</tbody>
				</table>				
			</div>
		</div>					
	</div>
</div>		
<div class="row" id="hideSecondBlock" style="display: block;">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<strong>Отчет по заявкам. Город Москва</strong>
			</div>
			<div class="panel-body">
				<table class="table table-bordered">
					<thead>
						<th></th>
						{foreach item=stat key=key from=$status_procat}
						<th>{$stat}</th>
						{/foreach}
						<th>ИТОГО</th>
						<th>КФ Успеха</th>
					</thead>
					<tbody>
						{foreach item=data key=i from=$report_by_tickets_moscow}
						<tr>
							<td>{$i}</td>
							{foreach item=static key=key from=$data}
								<td><i class="pointer" data-typets="{$i}" data-status="{$key}" data-city="Москва" data-target="#additionalInfoAbout" data-toggle="modal" onclick="getDataForRFT(this);">{$static}</i></td>
							{/foreach}
							<td>{$sum_status_tickets_moscow[$i]['summ']}</td>
							<td>{$sum_status_tickets_moscow[$i]['success']}</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		</div>		
	</div>
</div>