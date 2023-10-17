<?php
include 'connect.php';
  
$date= $_POST['date'];
$time= $_POST['time'];
$VehicleType= $_POST['VehicleType'];
$DrivingType= $_POST['DrivingType'];
$DriverGender= $_POST['DriverGender'];



$id=44; //user id
//echo $VehicleType;
$print = "SELECT id From reservation Where time='$time' AND VehicleType ='$VehicleType' AND date='$date'";
$result = mysqli_query($conn, $print);
$numOfRows = mysqli_num_rows($result);
    
$s= "SELECT Number FROM vehicle WHERE time='$time'";
$result1 = mysqli_query($conn, $s);
$row= mysqli_fetch_assoc($result1);
$number= $row["Number"];

if($numOfRows < $number){
    if($numOfRows== $number-1){
        $s ="INSERT INTO reservation (date,time,VehicleType,drivingType,driverGender,Status,visitorId) VALUES ('".$date."','".$time."','".$VehicleType."','".$DrivingType."','".$DriverGender."','Confirmed','".$id."')";

$result2 = mysqli_query($conn, $s);
 $resJson = array("time" => "$time", "date" => "$date");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
    }
    else{
        $s ="INSERT INTO reservation (date,time,VehicleType,drivingType,driverGender,Status,visitorId) VALUES ('".$date."','".$time."','".$VehicleType."','".$DrivingType."','".$DriverGender."','Confirmed','".$id."')";

$result2 = mysqli_query($conn, $s);
    }
}

