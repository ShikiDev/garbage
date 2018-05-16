<div class="x-content">
	<div class="row">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-10 col-md-offset-1 col-lg-6 col-lg-offset-3">
					<div class="x_panel">
						<h3>Редактирование кабинета клиента {$client_info.nickname}</h3>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-10 col-md-offset-1 col-lg-6 col-lg-offset-3">
					<div class="x_panel">
						<form method="POST" id="newClientForm">
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Логин клиента</span>
										<input type="text" name="login_client" id="login_client" value="{$client_info.login}">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Наименование клиента</span>
										<input type="text" name="nick_client" value="{$client_info.nickname}">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<button type="button" onclick="generatePass();">Сгенерировать пароль</button>
									</div>
								</div>
							</div>
							<div class="row linePass">
								<div class="col-md-12">
									<div class="input-group">
										<span class="input-group-addon">Пароль</span>
										<input type="text" name="pass_client" id="setPass" value="{$client_info.passClientShow}">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="input-group">
										<button type="button" onclick='location.href="/clientAccount/newClient"' class="btn btn-default">Сбросить</button>
										<button type="button" onclick="checkBeforeSubmit();" class="btn btn-default">Изменить</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	function generatePass(){
		var result = '';
		var words = '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
		var max_position = words.length - 1;
			for( i = 0; i < 10; ++i ) {
				position = Math.floor ( Math.random() * max_position );
				result = result + words.substring(position, position + 1);
			}
		$('#setPass').val(result);
	}

	function checkBeforeSubmit(){
		var login_client = $('#login_client').val();
		var pass_client = $('#setPass').val();
		var check_login = ((login_client != undefined)&&(login_client != null)&&(login_client))?true:false;
		var check_pass = ((pass_client != undefined)&&(pass_client != null)&&(pass_client))?true:false;
		if((check_login)&&(check_pass)){
			$('#newClientForm').submit();
		}else if((!check_login)&&(check_pass)){
			alert('Вы не указали логин для кабинета клиента! Укажите логин');
		}else if((check_login)&&(!check_pass)){
			alert('Вы не указали пароль для кабинета клиента! Укажите пароль или сгенерируйте с помощью кнопки "Сгенерировать пароль"');
		}
	}
</script>