<?php
include 'connect.php';
$id=$_POST['id'];
$date= $_POST['date'];
$time= $_POST['time'];
$VehicleType= $_POST['VehicleType'];
$DrivingType= $_POST['DrivingType'];
$DriverGender= $_POST['DriverGender'];
$visitorName= $_POST['visitorName'];
$Vnumber=$_POST['Vnumber'];


$s ="INSERT INTO reservation (date,VehicleType,drivingType,driverGender,Status,userId,visitorName,VphoneNumber) VALUES ('".$date."','".$VehicleType."','".$DrivingType."','".$DriverGender."','Active','".$id."','".$visitorName."','".$Vnumber."')";

$result2 = mysqli_query($conn, $s);
