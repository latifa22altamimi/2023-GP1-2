<?php

include 'connect.php';
$v=40;

$sql = "SELECT * FROM reservation WHERE visitorId=$v";
$result = $conn->query($sql);
 $list = mysqli_fetch_assoc($result);
      
  foreach ($list as $array){
  echo json_encode($array);
  }
