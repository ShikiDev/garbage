<?php
/**
 * Created by PhpStorm.
 * User: user
 * Date: 24.01.2018
 * Time: 17:42
 */
/*use \PDO;*/
namespace botCore;


class Database
{
    private $dbHost = 'localhost';
    private $dbUser = '1';
    private $dbPassword = '1';
    private $dbName = '1';
    public $db_conn;

    public function __construct()
    {
        $db_line = "mysql:host=".$this->dbHost.";dbname=".$this->dbName.";charset=utf8";
        $this->db_conn = new \PDO($db_line,$this->dbUser,$this->dbPassword);
    }

    public function insert($table,$arr){
        if(is_array($arr)){
            $line_query = $this->transformArrForQuery($arr);
        }else{
            return false;
        }        
        $result = $this->db_conn->query("INSERT INTO $table SET $line_query");
        if($result){
            return true;
        }else{
            return false;
        }
    }

    public function update($table,$arr,$condition){
        if(is_array($arr)){
            $line_query = $this->transformArrForQuery($arr);
        }else{
            return false;
        }        
        $result = $this->db_conn->query("UPDATE $table SET $line_query WHERE $condition");
        if($result){
            return true;
        }else{
            return false;
        }
    }

    public function select($table,$arr_val,$con){
        $line_query = implode(", ",$arr_val);
        $sql = ("SELECT $line_query FROM $table WHERE $con");
        $result = $this->db_conn->query($sql);
        if($result){
            $data = $result->fetchAll(\PDO::FETCH_ASSOC);
            return $data;
        }else{
            return false;
        }
    }

    public function sql_query($query,$select = false){
        $result = $this->db_conn->query($query);
        if($select){
            while($trash = $this->db_conn->fetch($result)){
                $data[] = $trash;
            }
            return $data;
        }
        return $result;
    }

    private function transformArrForQuery($arr){
        foreach($arr as $key=>$value){
            $query_line[] = " $key = '{$value}'";
        }
        return implode(', ', $query_line);
    }

    public function getAuthorization($chat_id){
        $result = $this->select("srm_botuser_ids",['user_id'],"user_id = '{$chat_id}'");
        if($result){
            return true;
        }else{
            return false;
        }
    }


}