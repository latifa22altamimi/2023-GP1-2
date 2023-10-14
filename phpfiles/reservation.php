<?php
include 'connect.php';
  
$date= $_POST['date'];
$time= $_POST['time'];
$VehicleType= $_POST['VehicleType'];
$DrivingType= $_POST['DrivingType'];
$DriverGender= $_POST['DriverGender'];



$id=44; //user id
//echo $VehicleType;
$print = "SELECT id From vehicle Where Vehiclestatus = 'Avaliable' AND VehicleType ='Single'";
$result = mysqli_query($conn, $print);
$row = mysqli_fetch_assoc($result);
    $vehicleId= $row['id'];
    
    



$s ="INSERT INTO reservation (date,time,vehicleId,drivingType,driverGender,Status,visitorId) VALUES ('".$date."','".$time."','".$vehicleId."','".$DrivingType."','".$DriverGender."','Confirmed','".$id."')";

$result2 = mysqli_query($conn, $s);

//$count= mysqli_num_rows($result2);

if($result2){
$s2="UPDATE `vehicle` SET `Vehiclestatus`='booked' WHERE id='".$vehicleId."'";
$result3 = mysqli_query($conn, $s2);
echo json_encode("Success");
}
 else {


   echo json_encode("Fail");
    //bad request
   /* $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);*/
	 //echo json_encode($count, JSON_UNESCAPED_UNICODE);
}