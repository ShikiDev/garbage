<?php
	function routes_clientAccount(){
		$routes[] = array('_uri'=>'/clientAccount\/newClient$/i',
						  'do'=>'new');
		$routes[] = array('_uri'=>'/clientAccount\/addTicketProcat$/i',
						  'do'=>'addProcatTicket');
		$routes[] = array('_uri'=>'/clientAccount\/listTicketProcat$/i',
						  'do'=>'listTicketProcat');
		$routes[] = array('_uri'=>'/clientAccount\/listClient$/i',
						  'do'=>'listClient');
		$routes[] = array('_uri'=>'/clientAccount\/editClient\/([0-9]+)$/i',
						  'do'=>'editClient',
						  1=>'id_client');
		$routes[] = array('_uri'=>'/clientAccount\/ticket_procat\/([0-9]+)$/i',
						 'do'=>'show_ticket',
						 1=>'ticket_id');
		$routes[] = array('_uri'=>'/clientAccount\/list_ticket_procat$/i',
						 'do'=>'list_ticket');
		$routes[] = array('_uri'=>'/clientAccount\/preset_car\/([0-9]+)$/i',
						  'do'=>'preset_car',
						  1=>'ticket_id');
		$routes[] = array('_uri'=>'/clientAccount\/print_ticket_preset_waylist$/i',
						  'do'=>'preset_waylist_print');
		$routes[] = array('_uri'=>'/clientAccount\/client_cabinet\/([0-9]+)$/i',
						  1=>'client_id',
						  'do'=>'client_cabinet');
		$routes[] = array('_uri'=>'/clientAccount\/print_ticket_dogovor$/i',
						  'do'=>'print_ticket_dogovor');
		$routes[] = array('_uri'=>'/clientAccount\/consult_page$/i',
						  'do'=>'consultate');
		$routes[] = array('_uri'=>'/clientAccount\/reports_ticket_info$/i',
						  'do'=>'reports_info');
		$routes[] = array('_uri'=>'/clientAccount\/expenses$/i',
						  'do'=>'expenses');
		$routes[] = array('_uri'=>'/clientAccount\/dse$/i',
						  'do'=>'dl_some_excel');
		$routes[] = array('_uri'=>'/clientAccount\/testodrom$/i',
						  'do'=>'testodrom');
		return $routes;
	}