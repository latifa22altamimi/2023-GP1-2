<?php


include 'connect.php';


$sql = "SELECT NumOfSWalkInVehicles FROM parameters WHERE ParametersId=1";
$result = $conn->query($sql);

$NumOfSWalkInVehicles=array(); 
 while($row = mysqli_fetch_assoc($result)){
     $NumOfSWalkInVehicles[]=$row;
 }

 $sql4 = "SELECT NumOfDWalkInVehicles FROM parameters WHERE ParametersId=1";
$result4 = $conn->query($sql4);

$NumOfDWalkInVehicles=array(); 
 while($row = mysqli_fetch_assoc($result4)){
     $NumOfDWalkInVehicles[]=$row;
 }

 $sql2 = "SELECT * FROM reservation WHERE Status='Active' AND slotId IS NULL";
 $result2 = $conn->query($sql2);
   $ActiveWalkInReservations= array();
 while($row = mysqli_fetch_assoc($result2)) {
    $ActiveWalkInReservations[]=$row;
  }
  $numOfActive=count($ActiveWalkInReservations);
if($numOfActive==($NumOfSWalkInVehicles[0]['NumOfSWalkInVehicles']+$NumOfDWalkInVehicles[0]['NumOfDWalkInVehicles'])){
    echo json_encode([0 => "Unavailable"]);
}else{
  echo json_encode([0 => "Available"]);
}