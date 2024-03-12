<?php

include 'connect.php';
$userId=$_POST['Userid'];
$sql = "SELECT * FROM reservation WHERE userId=$userId AND reservationId NOT IN (SELECT reservationId FROM managerreservation)";
$result = $conn->query($sql);
  $array= array();
while($row = mysqli_fetch_assoc($result)) {
   $array[]=$row;
 }
 
echo json_encode($array);
