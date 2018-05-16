<script type="text/javascript" src="/templates/callcenter/js/jquery.tablesorter.js"></script>
<style type="text/css">
	.table-responsive td{
		border:1px solid #d2d2d2 !important;
	}

	.pointer{
		cursor: pointer;
	}
	.hold_plus{
		font-weight: bold;
		color:#3c7500;
		font-size: 11pt;
	}

	.hold_minus{
		font-weight: bold;
		color:#b30808;
		font-size: 11pt;
	}
	.test_box{
		border: 1px solid #000;
		padding: 3px;
		margin: 3px;
	}
</style>
<div class="row">
	<div class="col-md-12">
		<div class="x_panel">
			<h2>Отчеты по заявкам</h2>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<div class="x_panel">
			<div class="row">
				<div class="col-md-6 col-lg-3">
					<div class="input-group">
						<span class="input-group-addon">Период с</span>
						<input type="text" class="picker_usial" id="begin">
					</div>
				</div>
				<div class="col-md-6 col-lg-3">
					<div class="input-group">
						<span class="input-group-addon">по</span>
						<input type="text" class="picker_usial" id="end">
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12 col-lg-3">
					<div class="input-group">
						<span class="input-group-addon">Город</span>
						<select id="search_city">
							<option value=""></option>
							<option value="Санкт-Петербург">Санкт-Петербург</option>
							<option value="Москва">Москва</option>
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-4 col-lg-2">
					<button type="button" class="btn btn-default" style="margin-right: 10px;" onclick="window.location.reload();">Сброс</button>
					<button type="button" class="btn btn_blue" style="margin-right: 10px;" onclick="getData();">Фильтр</button>						
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<ul class="nav nav-tabs">
		  <li class="active"><a data-toggle="tab" href="#finReportByTicket">Финансовый отчет по заявкам</a></li>
		  <li><!-- <a data-toggle="tab" href="#finFullReport">Финансовый отчет</a> --></li>
		  <li><a data-toggle="tab" href="#finFullReportByDays">Финансовый отчет по дням</a></li>
		  <li><a data-toggle="tab" href="#reportForTickets">Отчет по заявкам</a></li>
		  <li><a data-toggle="tab" href="#reportMotivation">Отчет-мотивация</a></li>
		  <li><a data-toggle="tab" href="#reportRefuses">Отчет по отказам</a></li>
		  <li><a data-toggle="tab" href="#reportRent">Отчет рентабельности</a></li>
		</ul>

		<div class="tab-content x_panel">
		  <div id="finReportByTicket" class="tab-pane fade in active">
		    {include file="../clientAccount_template/report_pages/fin_by_tickets.tpl"}
		  </div>
		  <div id="finFullReport" class="tab-pane fade">
		    {include file="../clientAccount_template/report_pages/fin_full_report.tpl"}
		  </div>
		  <div id="finFullReportByDays" class="tab-pane fade">
		    {include file="../clientAccount_template/report_pages/fin_full_report_by_day.tpl"}
		  </div>
		  <div id="reportForTickets" class="tab-pane fade">
		    {include file="../clientAccount_template/report_pages/report_for_tickets.tpl"}
		  </div>
		  <div id="reportMotivation" class="tab-pane fade">
		    {include file="../clientAccount_template/report_pages/motiv_report.tpl"}
		  </div>
		  <div id="reportRefuses" class="tab-pane fade">
		  	<div class="row">
		  		<div class="col-md-12 col-lg-offset-2 col-lg-7">
		  			{include file="../clientAccount_template/report_pages/report_refuse_ticket.tpl"}	
		  		</div>
		  	</div>		  		
		  </div>
		  <div id="reportRent" class="tab-pane fade">
		  	{include file="../clientAccount_template/report_pages/rentable_report.tpl"}
		  </div>
		</div>
	</div>
</div>

<div id="additionalInfoAbout" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h2></h2>
			</div>	
			<div class="modal-body">
				<div id="body_responce">
					
				</div>
				<br>
				<div id="expense_block"></div>
			</div>
			<div class="modal-footer">
				<button type="button" data-dismiss="modal" style="float: right;" class="btn btn_red" >Закрыть</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		{literal}
			$(".sortTable1").tablesorter();
			$(".sortTable2").tablesorter();
		{/literal}
	});

	$('.picker_usial').datetimepicker({
        dayOfWeekStart : 1,
        lang:'ru',
        startDate:  '{$date_current}',
        format:'d.m.Y',
        timepicker:false
    });  

    function getData() {
    	var begin = $('#begin').val();
    	var end = $('#end').val();
    	var city = $('#search_city option:selected').val();
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxReportsTickets.php',
    			data:{action:'getReportsTableData',begin:begin,end:end,city:city},
    			cache:false,
    			success:function (responce) {
    				var arr_tables = JSON.parse(responce);
    				console.log(arr_tables);
    				var count_arr_length = Object.keys(arr_tables).length;
    				var i = 0;
    				var last_key = '';
    				for (var key in arr_tables) {
    					if(i<count_arr_length-1){
    						if(arr_tables[key]!=''){
    							$('#'+key).html(arr_tables[key]);
    						}else{
    							$('#'+key).html("<tr><td></td></tr>");
    						}
    					}else{
    						last_key = key;
    					}
    					i++;
    				}
    				console.log(last_key);
    				$('#hideSecondBlock').hide();
    				console.log(arr_tables[last_key]);
    				$('#headerFirstBlock strong').text("Отчет по заявкам. Город "+arr_tables[last_key]);
    				//console.log(responce);
    				//$('#fin_rep_by_t').html(responce);
    			}
    		});
    	{/literal}
    }

    function getDataForRFT(e){
    	var type_ts = e.dataset['typets'];
    	var status = e.dataset['status'];
    	var city = e.dataset['city'];
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxReportsTickets.php',
    			data:{action:'RFT',type_ts:type_ts,status:status,city:city},
    			cache:false,
    			success:function(responce){
    				var res_arr = JSON.parse(responce);
    				console.log(res_arr);
    				$('.modal-header h2').text(res_arr['header']);
    				$('#body_responce').html(res_arr['body']);
    			}
    		});
    	{/literal}
    }

    function getDataForFRBD(e){
    	var type = e.dataset['type'];
    	var form = e.dataset['form'];
    	var data = e.dataset['day'];
    	{literal}
    		$.ajax({
    			type:'POST',
    			url:'/core/ajax/ajaxReportsTickets.php',
    			data:{action:'FRBD',type:type,form:form,data:data},
    			cache:false,
    			success:function(responce){
    				var res_arr = JSON.parse(responce);
    				console.log(res_arr);
    				$('.modal-header h2').text(res_arr['header']);
    				//console.log(res_arr['body']);
    				$('#body_responce').html(res_arr['body']);
    				$('#expense_block').html(res_arr['expense']);
    			}
    		});
    	{/literal}
    	
    }
</script>
<!-- <script src="../templates/callcenter/clientAccount_template/js/reports_scripts.js"></script -->	
