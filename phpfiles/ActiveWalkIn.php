<?php


include 'connect.php';


$sql = "SELECT NumOfWalkInVehicles FROM parameters WHERE ParametersId=1";
$result = $conn->query($sql);

$NumOfWalkInVehicles=array(); 
 while($row = mysqli_fetch_assoc($result)){
     $NumOfWalkInVehicles[]=$row;
 }

 $sql2 = "SELECT * FROM reservation WHERE Status='Active' AND slotId IS NULL";
 $result2 = $conn->query($sql2);
   $ActiveWalkInReservations= array();
 while($row = mysqli_fetch_assoc($result2)) {
    $ActiveWalkInReservations[]=$row;
  }
  $numOfActive=count($ActiveWalkInReservations);
if($numOfActive==$NumOfWalkInVehicles[0]['NumOfWalkInVehicles']){
    echo json_encode([0 => "Unavailable"]);
}else{
  echo json_encode([0 => "Available"]);
}