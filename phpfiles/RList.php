<?php

include 'connect.php';
$visitorId=$_POST['Userid'];
$sql = "SELECT * FROM reservation Join timeslots on reservation.slotId=timeslots.slotId WHERE visitorId=$visitorId";
$result = $conn->query($sql);
  $array= array();
while($row = mysqli_fetch_assoc($result)) {
   $array[]=$row;
 }
 
echo json_encode($array);
