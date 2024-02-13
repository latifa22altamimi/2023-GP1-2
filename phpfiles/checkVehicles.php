<?php


include 'connect.php';
$VehicleType= $_POST['VehicleType'];

$sql = "SELECT NumOfSWalkInVehicles FROM parameters WHERE ParametersId=1";
$result = $conn->query($sql);

$row2 = mysqli_fetch_assoc($result);

$NumOfSWalkInVehicles=$row2['NumOfSWalkInVehicles'];

 $sql4 = "SELECT NumOfDWalkInVehicles FROM parameters WHERE ParametersId=1";
$result4 = $conn->query($sql4);
$row = mysqli_fetch_assoc($result4);

$NumOfDWalkInVehicles=$row['NumOfDWalkInVehicles'];
 
 $sql2 = "SELECT * FROM reservation WHERE Status='Active' AND slotId IS NULL AND VehicleType='$VehicleType'";
 $result2 = $conn->query($sql2);
   $ActiveWalkInReservations= array();
 while($row = mysqli_fetch_assoc($result2)) {
    $ActiveWalkInReservations[]=$row;
  }
  $numOfActive=count($ActiveWalkInReservations);
if($VehicleType=="Single"&&  $numOfActive==$NumOfSWalkInVehicles){
    $response= json_encode([0 => "UnavailableSingle"]);
}else if($VehicleType=="Double"&&  $numOfActive==$NumOfDWalkInVehicles) {
  $response= json_encode([0 => "UnavailableDouble"]);
}
else{
  $response= json_encode([0 => "Ava"]);
}
echo $response;