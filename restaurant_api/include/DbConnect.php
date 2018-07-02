<?php
 
/**
 * Handling database connection using mysqli
 *
 * @author Ndimofor Ateh Rosius
 */
class DbConnect {
 
    private $conn;
 
    function __construct() {        
    }
 
    /**
     * Establishing database connection
     * @return database connection handler
     */
    function connect() {
       include_once dirname(__FILE__) . '/Config.php';
 
        // Connecting to mysql database
        $this->conn = new mysqli(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME);
      //  $this->conn->set_charset("utf8");
       // mysql_set_charset('utf8',$this->conn);
 
        // Check for database connection error
        if (mysqli_connect_errno()) {
            echo "Failed to connect to MySQL: " . mysqli_connect_error();
        }
        
        if (!$this->conn->set_charset("utf8")) {
         //   printf("Error loading character set utf8: %s\n", $this->conn->error);
            exit();
         } else {
           // echo "Current character set: %s\n".$this->conn->character_set_name();
         }
         
 
        // returing connection resource
        return $this->conn;
    }
    
 
}
 


