<?php

include 'connect.php';
$visitorId= $_GET['Userid'];

$sql = "SELECT * FROM reservation WHERE visitorId=$vistiorId";
$result = $conn->query($sql);
 $list = mysqli_fetch_assoc($result);
      
  foreach ($list as $array){
  echo json_encode($array);
  }