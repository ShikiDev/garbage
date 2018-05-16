<div class="x_content">
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<div class="row">
					{foreach item=elem key=key from=$count_element_first}
						<div class="col-md-12 col-lg-6">
							<div class="input-group">
								<span class="input-group-addon">{$key+1}</span>
								<input type="text" class="cef" value="{$key+1}">
							</div>
						</div>
					{/foreach}
				</div>
				<hr>
				<div class="row">
					{foreach item=elem key=key from=$count_element_second}
						<div class="col-md-12 col-lg-6">
							<div class="input-group">
								<span class="input-group-addon">{$key+1}</span>
								<input type="text" class="ces" value="{$key+1}">
							</div>
						</div>
					{/foreach}
				</div>
				<hr>
				<div class="row">
					{foreach item=elem key=key from=$count_element_third}
						<div class="col-md-12 col-lg-6">
							<div class="input-group">
								<span class="input-group-addon">{$key+1}</span>
								<input type="text" class="cet" value="{$key+1}">
							</div>
						</div>
					{/foreach}
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<div id="block_1"></div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<div id="block_2"></div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<div class="x_panel">
				<div id="block_3"></div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function (e) {
		var cef = $('.cef');
		var ces = $('.ces');
		var cet = $('.cet');
		/*console.log(cef);
		console.log(ces);
		console.log(cet);*/
		$.each(cef,function(index,elem){
			console.log($(elem).val());
		});

		$.each(ces,function(index,elem){
			console.log($(elem).val());
		});

		$.each(cet,function(index,elem){
			console.log($(elem).val());
		});
	});
</script>