<?php
include 'connect.php';
$id=$_POST['id'];
$Rid=$_POST['Rid'];
$waitingName= $_POST['Name'];
$waitingNumber=$_POST['PhoneNumber'];
$VehicleType=$_POST['VehicleType'];
echo json_encode($id);
$s ="INSERT INTO reservation (Status,VphoneNumber,visitorName,VehicleType,userId) VALUES ('Waiting','".$waitingNumber."','".$waitingName."','".$VehicleType."','".$id."')";

$result2 = mysqli_query($conn, $s);