<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$id=44;
$RID =1;
$sql = "SELECT * FROM reservation JOIN vehicle ON reservation.vehicleId = vehicle.id WHERE reservation.visitorId= $id AND reservation.id =$RID";
$result = $conn->query($sql);
 $ro2 = mysqli_fetch_assoc($result);
      
  
  echo json_encode($ro2);

