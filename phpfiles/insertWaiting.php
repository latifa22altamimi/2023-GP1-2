<?php
include 'connect.php';
$id=$_POST['id'];
$Rid=$_POST['Rid'];
$waitingName= $_POST['Name'];
$waitingNumber=$_POST['PhoneNumber'];
$VehicleType=$_POST['VehicleType'];
$ExpectUseTime=$_POST['ExpectUseTime'];
echo json_encode($ExpectUseTime);
$s ="INSERT INTO reservation (Status,VphoneNumber,ExpectUseTime,visitorName,VehicleType,userId) VALUES ('Waiting','".$waitingNumber."','".$ExpectUseTime."','".$waitingName."','".$VehicleType."','".$id."')";

$result2 = mysqli_query($conn, $s);