<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Welcome extends CI_Controller {

	public function index(){
		$this->home();
	}

	public function home(){
		$this->load->model('model_users');
		$data['title'] = 'MVC Cool Title';
		$data['page_header'] = 'Intro to MVC Design';
		$data['firstnames'] = $this->model_users->getFirstNames();
		$data['users'] = $this->model_users->getUsers();
		$this->load->view('welcome_message', $data);
	}
}
?>
