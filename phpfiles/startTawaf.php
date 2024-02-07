<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$Rid=$_POST['Rid'];
$select1= "SELECT Status FROM reservation WHERE reservationId=$Rid";
$result1= mysqli_query($conn, $select);
$row = mysqli_fetch_assoc($result1);
if($row["Status"]=="Confirmed"){
$select= "UPDATE `reservation` SET `Status`='Active' WHERE reservationId=$Rid";
$result= mysqli_query($conn, $select);
}
if($result){
    echo json_encode("started successfully");
    
}else{
    echo json_encode("Error in starting Tawaf");
}
?>
