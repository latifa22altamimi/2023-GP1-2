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
$select = "SELECT vehicleId FROM vehicle WHERE VehicleType='$VehicleType'";
$VehicleIdres =  mysqli_query($conn, $select);
$row = mysqli_fetch_assoc($VehicleIdres);
$vehicleId = $row['vehicleId'];



$s ="INSERT INTO reservation (date, time, VehicleId, drivingType, driverGender, Status, userId) VALUES ('".$date."','".$time."','".$vehicleId."','".$DrivingType."','".$DriverGender."','Confirmed','".$id."')";

$result2 = mysqli_query($conn, $s);
