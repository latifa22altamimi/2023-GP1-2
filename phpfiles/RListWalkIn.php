<?php
include 'connect.php';
$userId = 44;//$_POST['Userid'];
$sql = "SELECT *
FROM reservation
INNER JOIN managerreservation ON reservation.reservationId = managerreservation.reservationId
INNER JOIN users ON reservation.userId = users.userId
INNER JOIN vehicle ON reservation.VehicleId = vehicle.vehicleId
WHERE reservation.userId = $userId";
$result = $conn->query($sql);
$array = array();

while ($row = mysqli_fetch_assoc($result)) {
   $array[] = $row;
  
}

echo json_encode($array);