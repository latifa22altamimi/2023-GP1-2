<?php

include 'connect.php';
$userId=44;//$_POST['Userid'];
$sql = "SELECT * FROM reservation INNER JOIN managerreservation ON reservation.reservationId = managerreservation.reservationId INNER JOIN users ON reservation.userId = $userId INNER JOIN vehicle ON reservation.VehicleId = vehicle.vehicleId";
$result = $conn->query($sql);
  $array= array();
while($row = mysqli_fetch_assoc($result)) {
   $array[]=$row;
 }
 
echo json_encode($array);
