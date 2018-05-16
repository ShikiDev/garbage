<link rel="stylesheet" type="text/css" href="../../templates/callcenter/css/tickets_style.css?123">
<div class="x_content">
	<div class="row">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12">
					<div class="x_panel">
						<h3><a href="/clientAccount/ticket_procat/{$listWishes.id}">Наработки к заявке №{$listWishes.id} <br><small>Нажмите на нее для возвращения к заявке</small></a></h3>
						<input type="hidden" id="line_preset_car" value="{$line_preset_car}">
						<input type="hidden" id="ticket_city" value="{$ticket_city}">
					</div>
				</div>
			</div>
			{foreach item=car key=key from=$listWishes.car_list}
				<div class="row">
					<div class="col-md-12">
						<div class="x_panel">
							<div class="row">
								<div class="col-md-12">
									<h3>Заказанное ТС №{$key+1}</h3>
								</div>
							</div>	
							<div class="row">
								<div class="col-md-12">
									<table class="table">
										<thead>
											<th>ТС</th>
											<th>Даты аренды</th>
											<th>Уточнение по срокам</th>
											<th>Аналог</th>
											<th>Кол-во ТС</th>
											<th>Комментарий по ТС</th>
											<th>Авто без водителя</th>
										</thead>
										<tbody>
											<tr>
												<td>
													{$car.type_ts}<br>
													{$car.mark_ts} {$car.model_ts}
												</td>
												<td>{$car.begin_procat} - {$car.end_procat}</td>
												<td>
													{$car.begin_time} {$car.begin_place}<br>
													{$car.end_time} {$car.end_place}
												</td>
												<td>{if $car.analog == 'y'}
													Да
													{else}
													Нет
													{/if}
												</td>
												<td>{$car.count_ts}</td>
												<td>{$car.comment_ts}</td>
												<td>{$car.auto_without_driver}</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<br>
							<div class="row">
								<div class="col-md-12">
									{if $preset_array[$key]!=''}
									<h4>Варианты ТС для работы на заявке</h4>
									<table class="table">
										<thead>
											<th>ТС</th>
											<th>Цвет</th>
											<th>Год</th>
											<th>Класс</th>
											<th>Гос. номер</th>
											<th>Партнер</th>
											<th>Условия</th>
											<th>Предоплата</th>
											<th>Комментарии по договоренностям</th>
											<th>Дата следующего звонка</th>
											<th>Статус наработки</th>
											<th colspan="2"></th>
										</thead>
										<tbody>
											{foreach item=precar key=i from=$preset_array[$key]}
												<tr style="{if $precar.dialog_info.status_preset == 'work'}background-color:#5dffbd; color:#000 !important; font-weight: bold;{elseif $precar.dialog_info.status_preset == 'ready'}background-color:#d9f8ff;color:#000; font-weight: bold;{elseif $precar.dialog_info.status_preset == 'think'}background-color:#fffdb3;color:#000; font-weight: bold;
													{elseif $precar.dialog_info.status_preset == 'busy'}background-color:#ffd9d9;{/if}">
													<td><a href="/partner/proprietor_{$precar.car_info.id_owner}/cart_ts_{$precar.car_info.id}.html" target="_blank" style="font-weight: bold; cursor: pointer;">{$precar.car_info.type_vehicle}<br>{$precar.car_info.mark} {$precar.car_info.model}<br>{$precar.car_info.body_car}<br>Салон: {$precar.car_info.material} {$precar.car_info.color_material}</a></td>
													<td>{$precar.car_info.color}</td>
													<td>{$precar.car_info.year}</td>
													<td>{$precar.car_info.class}</td>
													<td>{$precar.car_info.f_nom_part}{$precar.car_info.s_nom_part}{$precar.car_info.th_nom_part}{$precar.car_info.nom_region}</td>
													<td>
													<a href="/partner/cart_proprietor/{$precar.owner_info.id}.html" target="_blank" style="font-weight: bold; cursor: pointer;">
														{$precar.owner_info.name}<br>
														Телефон: {$precar.owner_info.tel}<br>
														E-mail: {$precar.owner_info.e_mail}<br>
													</a>
													</td>
													<td><b>Последнее оговоренное:</b><br>
													 <strong>Ставка</strong> <span style="font-weight: bold; color:red;">{$precar.dialog_info.price_per_hour}</span><br>
													 <strong>Кол-во часов</strong> {$precar.dialog_info.hour_work}<br>
													 <strong>Кол-во доп. часов</strong> {$precar.dialog_info.hours_add_work}<br>
													 <strong>Итого к оплате</strong> {$precar.dialog_info.fullcost}<br>
													</td>
													<td>{$precar.dialog_info.predoplata}</td>
													<td>{$precar.dialog_info.comment}</td>
													<td>{$precar.dialog_info.date_next_call}</td>
													<td>
													{if $precar.dialog_info.status_preset == "work"} Работает
													{elseif $precar.dialog_info.status_preset == "ready"} Готов к работе									
													{elseif $precar.dialog_info.status_preset == "think"} Думает
													{elseif $precar.dialog_info.status_preset == "busy"} Занят									
													{/if}</td>
													<td><i class="fa fa-pencil" data-presetid="{$precar['car_info']['id']}" data-ownerid="{$precar.car_info.id_owner}" data-stavka="{$precar.dialog_info.price_per_hour}" data-predoplata="{$precar.dialog_info.predoplata}" data-comment="{$precar.dialog_info.comment}" data-nextcall="{$precar.dialog_info.date_next_call}" data-status="{$precar.dialog_info.status_preset}" data-washid="{$car.id}" style="cursor:pointer;" data-toggle='modal' data-target='#correctPresetWorkRule' onclick="correctPresetWorkRule(this);"></i></td>
													<td><i class="fa fa-remove" data-presetid="{$precar['car_info']['id']}" style="cursor:pointer;" data-toggle='modal' data-target="#deletePreset" onclick="deletePresetFormShow(this);"></i></td>
												</tr>
											{/foreach}
										</tbody>
									</table>
									{else}
									{/if}
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="no_data_block" data-toggle="modal" data-target="#choosePrepareCar" data-awd="{$car.auto_without_driver}" data-wishid='{$car.id}' onclick="getIdWishCar(this);">
			                        	<span>Выберите автомобиль </span>
			                    	</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			{/foreach}
		</div>
	</div>
</div>

<div id="choosePrepareCar" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Коммерческие предложения</h4>
				<input type="hidden" id="awd_search">
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-12">
						<div class="row">
			                <div class="col-md-3">
			                    <div class="input-group">
			                        <span class="input-group-addon">Класс</span>
			                        <select name="class_list" id="class_list">
			                            <option value="">Не выбрана</option>
			                            {foreach item=class key=key from=$class_list}
			                            <option value="{$class}" {if $selectClass == $class}selected{/if}>{$class}</option>
			                            {/foreach}
			                        </select>
			                    </div>
			                </div>
			                <div class="col-md-3">
			                    <div class="input-group">
			                        <span class="input-group-addon">Марка</span>
			                        <select name="mark_list" id="mark_list" onchange="select_Model_zayvka();">
			                            <option value="">Не выбрана</option>
			                        </select>
			                    </div>
			                </div>
			                <div class="col-md-3">
			                    <div id="model_list"></div>
			                </div>
			                <div class="col-md-3">
			                	<div id="gen_list_block">
			                		<div class="input-group">
			                			<span class="input-group-addon">Поколение</span>
			                			<select id="gen_list">
			                				<option value="">Не выбрано</option>
			                				<option value="W212">W212</option>
			                				<option value="W213">W213</option>
			                			</select>
			                		</div>
			                	</div>
			                </div>
			            </div>
			            <div class="row">
			                <div class="col-md-1 col-md-offset-11">
			                <button type="button" class="btn btn_blue" onclick="searchAuto();" style="float: right;">Показать</button>
			                </div>
			            </div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<div id="result_search_car"></div>
						<input type="hidden" id="wishcar">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn_blue" style="float: right;" onclick="setCheckedPreset();">Прикрепить</button>
			</div>
		</div>
	</div>
</div>

<div id="correctPresetWorkRule" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Поиск партнеров для наработки по заказу</h4>
				<input type="hidden" id="preset_car_id">
				<input type="hidden" id="wishcarid">
				<input type="hidden" id="owner_id">
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-12">
						<div class="x_panel">
							<div class="x_title" style="height: auto;">
								<h2>Инфо по заказываемой машине</h2>
								<ul class="nav navbar-right panel_toolbox">
									<li>
										<a class="collapse-link">
											<i class="fa fa-chevron-down"></i>
										</a>
									</li>
								</ul>
								<div class="clearfix"></div>
							</div>
							<div class="x_content" style="display: none;">
								<div class="row">
									<div class="col-md-12 col-lg-6">
										<ul class="list-group">
											<li class="list-group-item disabled">Инфо по маршруту</li>
											<li class="list-group-item"><strong>Даты работы</strong><span style="float: right;" id="data_work"></span></li>
											<li class="list-group-item" style="min-height: 50px;"><strong>Время и место работы</strong><span style="float: right;" id="where_work"></span></li>
											<!-- <li class="list-group-item"><span id=""></span></li> -->
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="x_panel">
						<div class="col-md-6">
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Ставка</span>
										<input type="text" id="price_per_hour">
									</div>
								</div>
							</div>
							<!-- <div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Кол-во часов</span>
										<input type="text" id="count_hours_work">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Кол-во доп. часов</span>
										<input type="text" id="count_add_hours_work">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Итого к оплате</span>
										<input type="text" id="full_cost">
									</div>
								</div>
							</div> -->
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Договоренность по оплате</span>
										<input type="text" id="predoplata_preset">
									</div>	
								</div>
							</div>
							<!-- <div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Дата следующего звонка</span>
										<input type="text" id="date_next_call" class="picker_usial">
									</div>	
								</div>
							</div> -->
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Комментарии</span>
										<textarea id="comment_preset"></textarea>
									</div>	
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Статус наработки</span>
										<select id="status_preset">
											<option value=""></option>
											<option value="work">Работает</option>
											<option value="ready">Готов работать</option>
											<option value="think">Думает</option>
											<option value="busy">Занят</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-12">
							<button type="button" class="btn btn_blue" style="float: right;" onclick="saveDialogPreset();">Сохранить</button>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<div class="history_dialog_box"></div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>

<div id="deletePreset" class="modal fada">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4>Удаление наработки</h4>
				<input type="hidden" id="preset_car_id_for_delete">
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-12">
						Вы точно хотите удалить данную наработку?
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" style="float: right;" class="btn btn-default" onclick="deletePreset();">Сохранить</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$('#gen_list_block').hide();
	});
	function getIdWishCar(e){
		var id = e.dataset['wishid'];
		var awd = e.dataset['awd'];
		$('#wishcar').val(id);
		$('#awd_search').val(awd);
	}

	function select_Model_zayvka(){
        var mark = $('#mark_list option:selected').text();
        var class_name = $('#class_list option:selected').val();
        var awd_search = $('#awd_search').val();
        var city = $('#ticket_city').val();
        var model = '';
        //alert(mark);
        {literal}
         $.ajax({
             type: "POST",
             url: "../../core/ajax/ajaxForAutoClass.php",
             data: { action: 'searchModel' , mark: mark , model:model,class_name:class_name,awd_search:awd_search,city:city},
             cache: false,
             success: function (responce){$('#model_list').html(responce);}
         });
        {/literal}
    }

    $('#class_list').on('change',function(){
        var class_n = $('#class_list option:selected').val();
        getMarks(class_n);
    });

    function getMarks(class_val){
        var class_name = class_val;
        var awd_search = $('#awd_search').val();
        var city = $('#ticket_city').val();
        {literal}
            $.ajax({
                type: "POST",
                url: "/core/ajax/ticket_ajax.php",
                data: {action:'getMarkByClass',class_name:class_name,awd_search:awd_search,city:city},
                cache: false,
                success: function(responce){
                    $('#mark_list').html(responce);
                }
            });
        {/literal}
    }

    function searchAuto(){
		var cl_ts = $('#class_list option:selected').val();
		var	m_ts = $('#mark_list option:selected').text();
		var mod_ts = $('#model_list option:selected').val();
		var class_ts = ((cl_ts!=null)&&(cl_ts!=undefined))?cl_ts:'';
		var mark_ts = ((m_ts!=null)&&(m_ts!=undefined))?m_ts:'';
		var model_ts = ((mod_ts!=null)&&(mod_ts!=undefined))?mod_ts:'';
		var line_preset_car = $('#line_preset_car').val();
		var awd_search = $('#awd_search').val();
		var gen_list =$('#gen_list').val();
		var city = $('#ticket_city').val();
		gen_list = ((gen_list!='')&&(gen_list!=undefined)&&(gen_list!=null))?gen_list:'';
		{literal}
			$.ajax({
				type:"POST",
				url:"/core/ajax/ajaxForAutoClass.php",
				data:{action:'searchCarsForProcat',class_ts:class_ts,mark_ts:mark_ts,model_ts:model_ts,line_preset_car:line_preset_car,awd_search:awd_search,gen_list:gen_list,city:city},
				cache: false,
				success: function(responce){
					$('#result_search_car').html(responce);
				}
			});
		{/literal}
	}

	function getString(e){
		var id_preset_car = e;
		var id_wishcar_for_preset = $('#wishcar').val();
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'savePresetCar',id_preset_car:id_preset_car,wishcar_id:id_wishcar_for_preset},
				cache:false,
				success: function(responce){
					//window.location.reload();
				}
			});
		{/literal}
	}

	function select_Modif(){
		var model_get = $('#model_select option:selected').val();
		if(model_get == 'E-klasse'){
			$('#gen_list_block').show();
		}
	}

	function correctPresetWorkRule(e){
		var presetid = e.dataset['presetid'];
		$('#preset_car_id').val(presetid);
		var wishcar_id = e.dataset['washid'];
		$('#wishcarid').val(wishcar_id);
		$('#owner_id').val(e.dataset['ownerid']);
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'getDialogHistory',presetid:presetid, wishcar_id:wishcar_id},
				cache:false,
				success:function(responce){
					var arr_resp = JSON.parse(responce);
					$('.history_dialog_box').html(arr_resp[0]);
					$('#price_per_hour').val(arr_resp[1]['price_per_hour']);
					$('#count_hours_work').val(arr_resp[1]['hours_work']);
					$('#count_add_hours_work').val(arr_resp[1]['hours_add_work']);
					$('#full_cost').val(arr_resp[1]['fullcost']);
					$('#predoplata_preset').val(arr_resp[1]['predoplata']);
					if((arr_resp[1]['date_next_call']!='0000-00-00 00:00:00')&&(arr_resp[1]['date_next_call']!='1970-01-01 03:00:00')){
						$('#date_next_call').val(arr_resp[1]['date_next_call']);
					}else{}
					
					//$('#comment_preset').val(arr_resp[1]['comment']);

					$('#ts_info').text(arr_resp[2]['type_ts']+' '+arr_resp[2]['mark_ts']+' '+arr_resp[2]['model_ts']);
					var analog_val = "";
						switch(arr_resp[2]['analog']){
							case 'y':
								analog_val = 'Да';
								break;
							case 'n':
								analog_val = 'Нет';
								break;
						}
					$('#analog_ts').text(analog_val);
					$('#comment_ts_wish').text(arr_resp[2]['comment_ts']);
					$('#data_work').text(arr_resp[2]['begin_procat']+' - '+arr_resp[2]['end_procat']);
					$('#where_work').html(arr_resp[2]['begin_time']+' '+arr_resp[2]['begin_place']+' - '+arr_resp[2]['end_time']+' '+arr_resp[2]['end_place']);
					//console.log(arr_resp);
					if(responce!=''){
						$('#but_set_preset').show();
					}
					//console.log(responce);
				}
			});
		{/literal}
	}

	$('.picker_usial').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:'{$date_current}',
        format:'d.m.Y H:i'
    });

    function deletePreset(){
    	var preset_id = $('#preset_car_id_for_delete').val();
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxForAutoClass.php',
    			data:{action:'deletePreset',preset_id:preset_id},
    			cache:false,
    			success:function(){
    				window.location.reload();
    			}
    		});
    	{/literal}
    }

    function deletePresetFormShow(e){
    	$('#preset_car_id_for_delete').val(e.dataset['presetid']);
    }

	function saveDialogPreset(){
		var preset = $('#preset_car_id').val();
		var price = $('#price_per_hour').val();
		var predoplate = $('#predoplata_preset').val();
		var date_next_call = $('#date_next_call').val();
		var comment_preset = $('#comment_preset').val();
		var status_preset = $('#status_preset option:selected').val();
		var wishcar = $('#wishcarid').val();
		var ownerid = $('#owner_id').val();
		var hour_work = $('#count_hours_work').val();
		var hour_add_work = $('#count_add_hours_work').val();
		var full_cost = $('#full_cost').val();

		if((status_preset!='')&&(comment_preset!='')){
			{literal}
				$.ajax({
					type:'POST',
					url:'/core/ajax/ajaxForAutoClass.php',
					data:{action:'saveDialogPreset',preset:preset,wishcar:wishcar,price:price,predoplate:predoplate,date_next_call:date_next_call,comment_preset:comment_preset,status_preset:status_preset,ownerid:ownerid, hour_work:hour_work, hour_add_work:hour_add_work, full_cost:full_cost},
					cache:false,
					success:function(responce){
						if(status_preset == "work"){
							setPresetToTicket();
						}else{
							window.location.reload();
							//console.log(responce);
						}
					}
				});
			{/literal}
		}else{
			alert('Не выбран статус и/или не проставлен Комментарии!');
		}
	}

	function setPresetToTicket(){
		var preset_id = $('#preset_car_id').val();
		var wishid = $('#wishcarid').val();
		var price = $('#price_per_hour').val();
		var hour_work = $('#count_hours_work').val();
		var hour_add_work = $('#count_add_hours_work').val();
		var full_cost = $('#full_cost').val();
		var predoplate = $('#predoplata_preset').val();
		{literal}
			$.ajax({
				type:'POST',
				url:'/core/ajax/ajaxForAutoClass.php',
				data:{action:'set_preset_to_ticket',preset_id:preset_id,wish_id:wishid, price:price, hour_work:hour_work, hour_add_work:hour_add_work, fullcost:full_cost,predoplate:predoplate},
				cache:false,
				success: function(responce){
					window.location.reload();
					//console.log(responce);
				}
			});
		{/literal}
	}

	function setCheckedPreset(){
		{literal}
		$('input[name="checked_car"]:checked').each(function(){
			getString($(this).val());
		});

		setTimeout(function(){
			window.location.reload();
		},1500);
		{/literal}
	}

	function checkThisLine(e){
		console.log(e);
		var sinko = e.parentNode;
        var papka = sinko.parentNode;
        var otche = papka.parentNode;
        var jesus = otche.parentNode;
        for (var i=0;i<jesus.children.length;i++){
            //jesus.children[i].style.cssText="";
        }
        otche.style.cssText="background-color: #60c57b; \
        color: #fff !important; \
        ";
	}

	$(document).ready(function(){
		$('#but_set_preset').hide();
	});

	$('#count_hours_work').on('change',function(){
    	var price = $('#price_per_hour').val();
    	var h = $('#count_hours_work').val();
    	var h_ad = $('#count_add_hours_work').val();
    		getSummPriceTS(price,h,h_ad,'setted');
    });

    $('#count_add_hours_work').on('change',function(){
    	var price = $('#price_per_hour').val();
    	var h = $('#count_hours_work').val();
    	var h_ad = $('#count_add_hours_work').val();
    		getSummPriceTS(price,h,h_ad,'setted');
    });

    $('#price_per_hour').on('change',function(){
    	var price = $('#price_per_hour').val();
    	var h = $('#count_hours_work').val();
    	var h_ad = $('#count_add_hours_work').val();
    		getSummPriceTS(price,h,h_ad,'setted');
    });

    function getSummPriceTS(price,hours,hours_add,type){
    	if(type ==  'setted'){
    		$('#full_cost').val(+price*(+hours + +hours_add));
    	}
    }
</script>