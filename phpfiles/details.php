<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$sql = "SELECT reservation.id, reservation.date, reservation.time, reservation.vehicleId, vehicle.VehicleType, reservation.drivingType, reservation.driverGender, reservation.Status, reservation.visitorId FROM reservation JOIN vehicle ON reservation.vehicleId = vehicle.id";
$result = $conn->query($sql);
 while($ro2 = mysqli_fetch_assoc($result)){
     $data[]=$ro2;
 }
      
  
  echo json_encode($data);


