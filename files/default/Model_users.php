<?php
class Model_users extends CI_Model {
    function __construct() {
        parent::__construct();
    }
    function getFirstNames() {
        // $this->load->database();
        $query = $this->db->query('SELECT firstname FROM users');

        if ($query->num_rows() > 0) {
            return $query->result();
        } else {
            return NULL;
        }
    }

    function getUsers() {
        // $this->load->database();
        $query = $this->db->query('SELECT * FROM users');
        if ($query->num_rows() > 0) {
            return $query->result();
        } else {
            return NULL;
        }
    }
}


?>