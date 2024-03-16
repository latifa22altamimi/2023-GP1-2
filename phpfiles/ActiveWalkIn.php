<?php


include 'connect.php';


$sql = "SELECT TotalNumberOfVehicles FROM parameters WHERE VehicleDedicatedTo='walkIn'";
$result = $conn->query($sql);

$NumOfWalkInVehicles=array(); 
 while($row = mysqli_fetch_assoc($result)){
     $NumOfWalkInVehicles[]=$row;
 }



 $sql2 = "SELECT * FROM reservation WHERE Status='Active' AND reservationId IN (SELECT reservationId FROM managerreservation)";
 $result2 = $conn->query($sql2);
   $ActiveWalkInReservations= array();
 while($row = mysqli_fetch_assoc($result2)) {
    $ActiveWalkInReservations[]=$row;
  }
  $numOfActive=count($ActiveWalkInReservations);
 
$numOfAvailable=($NumOfWalkInVehicles[0]['TotalNumberOfVehicles']+$NumOfWalkInVehicles[1]['TotalNumberOfVehicles'])-$numOfActive;
$TotalVehicles=($NumOfWalkInVehicles[0]['TotalNumberOfVehicles']+$NumOfWalkInVehicles[1]['TotalNumberOfVehicles']);

$value2 = (int)$NumOfWalkInVehicles[0]['TotalNumberOfVehicles'];
  $value3 = (int)$NumOfWalkInVehicles[1]['TotalNumberOfVehicles'];

if ($numOfActive == $TotalVehicles) {
  echo json_encode([0 => "Unavailable", 1 => $value2, 2 => $value3]);
} else {
  
  

  echo json_encode([0 => "Available", 1 => $numOfAvailable, 2 => $value2, 3 => $value3]);
}
