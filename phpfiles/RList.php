<?php

include 'connect.php';
$userId=$_POST['Userid'];
$sql = "SELECT r.*, t.time FROM reservation r JOIN timeslots t ON r.slotId = t.slotId WHERE userId=$userId";
$result = $conn->query($sql);
  $array= array();
while($row = mysqli_fetch_assoc($result)) {
   $array[]=$row;
 }
 
echo json_encode($array);
