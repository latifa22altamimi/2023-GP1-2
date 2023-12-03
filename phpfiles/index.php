<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$sql3 = "SELECT NumOfVehicles from adminpram";
$result4 = $conn->query($sql3);
$row2 = $result4->fetch_assoc();
$sql = "SELECT NumOfSingleV from adminpram";
$result = $conn->query($sql);
$sql45 = "SELECT NumOfDoubleV from adminpram";
$result30 = $conn->query($sql45);
$s = "SELECT id from vehicle";
$result2 = $conn->query($s);
$rowCount = mysqli_num_rows($result2);
$row = $result->fetch_assoc();
$row30 = $result30-> fetch_assoc();
$numOfD= $row2['NumOfVehicles'] - $row['NumOfSingleV'];

  // output data of each row
      if($rowCount==0 || $rowCount < $row2['NumOfVehicles'] ){
          echo $row['NumOfSingleV'];
      for($i=0; $i<$row['NumOfSingleV']-$rowCount ;$i++){
          
          $SQ = "INSERT INTO `vehicle`(`VehicleType`, `Vehiclestatus`) VALUES ('Single','Avaliable')";
          $result3 = $conn->query($SQ);

          
}}
      if($rowCount==0 || $rowCount < $row2['NumOfVehicles'] ){

      for($x=0; $x<$numOfD-$row30['NumOfDoubleV']  ;$x++){
                    $S = "INSERT INTO `vehicle`(`VehicleType`, `Vehiclestatus`) VALUES ('Double','Avaliable')";
          $result5 = $conn->query($S);

      }}
  $print = "SELECT * From vehicle Where Vehiclestatus = 'Avaliable'";
  $res= $conn->query($print);
  while($ro2 = mysqli_fetch_assoc($res)){
      $data[]=$ro2;
      
  }
  echo json_encode($data);



$conn->close();
