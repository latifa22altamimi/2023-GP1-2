<?php

include 'connect.php';
 
        $id= $_GET['id'];
        $select= "UPDATE users SET status=1 WHERE id=$id";
        $result= mysqli_query($conn, $select);
        
        if($result){
            echo json_encode("verify successful,you can log in now");
            
        }
        else{
        
            echo json_encode("not verified");
        }