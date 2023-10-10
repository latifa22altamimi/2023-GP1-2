<?php

include 'connect.php';
$visitorId= $_GET['Userid'];

$sql = "SELECT * FROM reservation WHERE visitorId= $visitorId";
$result = $conn->query($sql);
 $list = mysqli_fetch_assoc($result);
      
  
  echo json_encode($list);
?>