<?php

include 'connect.php';
$visitorId=44;
//$_GET['Userid'];/////////we need to recieve it from SendingID php page
$sql = "SELECT * FROM reservation WHERE visitorId=$visitorId";
$result = $conn->query($sql);
  $array= array();
while($row = mysqli_fetch_assoc($result)) {
   $array[]=$row;
 }
 
echo json_encode($array);
