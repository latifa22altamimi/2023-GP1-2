<?php 
include 'connect.php';
$sql = "SELECT * FROM  markers";
$result = $conn->query($sql);
$ro2 = mysqli_fetch_assoc($result);
echo json_encode($ro2);