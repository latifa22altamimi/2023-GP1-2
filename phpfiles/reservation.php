<?php
include 'connect.php';
$date= $_POST['date'];
$time= $_POST['time'];
$VehicleType= $_POST['VehicleType'];
$DrivingType= $_POST['DrivingType'];
$DriverGender= $_POST['DriverGender'];

  

$id=44; //user id

        $s ="INSERT INTO reservation (date,time,VehicleType,drivingType,driverGender,Status,visitorId) VALUES ('".$date."','".$time."','".$VehicleType."','".$DrivingType."','".$DriverGender."','Confirmed','".$id."')";

$result2 = mysqli_query($conn, $s);
