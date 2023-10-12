<?php

include 'connect.php';
$visitorId=$_GET['Userid'];
$sql = "SELECT * FROM reservation WHERE visitorId=$visitorId";
$result = $conn->query($sql);
  $array= array();

while($row = mysqli_fetch_assoc($result)) {
   $array[]=$row;
 }
 
echo json_encode($array);
