<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$Rid=$_POST['Rid'];
$select= "UPDATE `reservation` SET `Status`='Completed' WHERE reservationId=$Rid";
$result= mysqli_query($conn, $select);
if($result){
    echo json_encode("checked out successfully");
    
}else{
    echo json_encode("Error in Checking out");
}
?>
