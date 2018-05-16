<div class="x-content">
	<div class="row">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12">
					<div class="x_panel">
						<div class="row">
							<div class="col-md-12">
								<h3>Список кабинетов клиентов</h3>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<ul class="nav nav-tabs">
					  <li class="active"><a data-toggle="tab" href="#ur">Юридические лица</a></li>
					  <li><a data-toggle="tab" href="#fiz">Физические лица</a></li>
					</ul>

					<div class="tab-content">
					  	<div id="ur" class="tab-pane fade in active">
						    <div class="x_panel">
								<div class="row">
									<div class="col-md-12">
										<table class="table">
											<thead>
												<th>Наименование</th>
												<th>Кол-во заявок</th>
												<th>Статус аккаунта</th>
												<th colspan="2"></th>
											</thead>
											<tbody>
												{foreach item=acc key=key from=$listAccounts}
													<tr>
														<td><a href="/clientAccount/client_cabinet/{$acc.id}" target="_blank">{$acc.nickname} (логин: {$acc.login})</a></td>
														<td>{$acc.col_ticket}</td>
														<td>{if $acc.is_locked == 0&&$acc.is_deleted == 0}Активен{else}Заблокирован{/if}</td>
														<td></td>
														<td></td>
													</tr>
												{/foreach}
											</tbody>
										</table>
									</div>
								</div>
							</div>
					  	</div>
					  	<div id="fiz" class="tab-pane fade">
						    <div class="x_panel">
									<div class="row">
										<div class="col-md-12">
											<table class="table">
												<thead>
													<th>Наименование</th>
													<th>Кол-во заявок</th>
													<th>Статус аккаунта</th>
													<th colspan="2"></th>
												</thead>
												<tbody>
													{foreach item=acc key=key from=$listAccountsFiz}
														<tr>
															<td><a href="/clientAccount/client_cabinet/{$acc.id}" target="_blank">{$acc.nickname} (логин: {$acc.login})</a></td>
															<td>{$acc.col_ticket}</td>
															<td>{if $acc.is_locked == 0&&$acc.is_deleted == 0}Активен{else}Заблокирован{/if}</td>
															<td></td>
															<td></td>
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
			</div>
		</div>
	</div>
</div>