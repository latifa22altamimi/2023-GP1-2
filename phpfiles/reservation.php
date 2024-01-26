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
$slots = "SELECT slotId FROM timeslots WHERE time='$time'";
$slotIdResult =  mysqli_query($conn, $slots);
$row = mysqli_fetch_assoc($slotIdResult);
$slotId = $row['slotId'];

$s ="INSERT INTO reservation (date,VehicleType,drivingType,driverGender,Status,userId,visitorName,VphoneNumber,slotId) VALUES ('".$date."','".$VehicleType."','".$DrivingType."','".$DriverGender."','Confirmed','".$id."','".$visitorName."','".$Vnumber."','".$slotId."')";

$result2 = mysqli_query($conn, $s);
