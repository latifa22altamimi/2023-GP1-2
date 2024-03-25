<?php


include 'connect.php';


$sql = "SELECT TotalNumberOfVehicles FROM parameters WHERE VehicleDedicatedTo='walkIn'";
$result = $conn->query($sql);

$NumOfWalkInVehicles=array(); 
 while($row = mysqli_fetch_assoc($result)){
     $NumOfWalkInVehicles[]=$row;
 }



 $sql2 = "SELECT r.*, v.VehicleType 
 FROM reservation AS r
 JOIN managerreservation AS mr ON r.reservationId = mr.reservationId
 JOIN vehicle AS v ON r.vehicleId = v.vehicleId
 WHERE r.Status = 'Active'";

$result2 = $conn->query($sql2);
$ActiveWalkInReservations = array();
$activeSingleCount = 0;
$activeDoubleCount = 0;

while ($row = mysqli_fetch_assoc($result2)) {
$ActiveWalkInReservations[] = $row;

if ($row['VehicleType'] === 'Single') {
$activeSingleCount++;
} elseif ($row['VehicleType'] === 'Double') {
$activeDoubleCount++;
}
}

$numOfActiveSingle = $activeSingleCount;
$numOfActiveDouble = $activeDoubleCount;
$totalActive=(int)$numOfActiveDouble+(int)$numOfActiveSingle;

 $availableDouble=$NumOfWalkInVehicles[0]['TotalNumberOfVehicles']-$numOfActiveDouble;
 $availableSingle=$NumOfWalkInVehicles[1]['TotalNumberOfVehicles']-$numOfActiveSingle;

$numOfAvailable=$availableDouble+$availableSingle;
$TotalVehicles=($NumOfWalkInVehicles[0]['TotalNumberOfVehicles']+$NumOfWalkInVehicles[1]['TotalNumberOfVehicles']);

$value2 = (int)$NumOfWalkInVehicles[0]['TotalNumberOfVehicles'];
  $value3 = (int)$NumOfWalkInVehicles[1]['TotalNumberOfVehicles'];

if (($numOfActiveDouble+$numOfActiveSingle) == $TotalVehicles) {
  echo json_encode([0 => "Unavailable", 1 => $value2, 2 => $value3, 3 => $availableDouble, 4 => $availableSingle, 5 => $totalActive]);
} else {
  
  

  echo json_encode([0 => "Available", 1 => $numOfAvailable, 2 => $value2, 3 => $value3, 4 => $availableDouble, 5 => $availableSingle, 6=> $totalActive]);
}
