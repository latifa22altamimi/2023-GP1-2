<?php

include 'connect.php';
 
        $id= $_GET['id'];
        $select= "UPDATE users SET status=1 WHERE id=$id";
        $result= mysqli_query($conn, $select);
        
        if($result){
            echo json_encode("Your Email has been verified successfully,you can sign in now!");
            
        }
        else{
        
            echo json_encode("Couldn't verify your email for some reason, Sorry.");
        }