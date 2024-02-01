<?php

include 'connect.php';
$userId=$_POST['Userid'];
$sql = "SELECT * FROM waitinglist WHERE userId=$userId";
$result = $conn->query($sql);
  $array= array();
while($row = mysqli_fetch_assoc($result)) {
   $array[]=$row;
 }
 
echo json_encode($array);
