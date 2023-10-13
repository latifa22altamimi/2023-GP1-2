<?php
include 'connect.php';
if (
    isset($_POST["VehicleType"])
    && isset($_POST["DrivingType"])
    && isset($_POST["DriverGender"])
 
           
) {   
$date= $_POST['date'];
$time= $_POST['time'];
$VehicleType= $_POST['VehicleType'];
$DrivingType= $_POST['DrivingType'];
$DriverGender= $_POST['DriverGender'];




$id=40; //user id
echo $VehicleType;
$print = "SELECT id From vehicle Where Vehiclestatus = 'Avaliable' AND VehicleType =$VehicleType";
$result = $conn->query($print);
$row = mysqli_fetch_assoc($result);
    $vehicleId= $row[0]['id'];
    
    



$s ="INSERT INTO `reservation`( `date`, `time`, `vehicleId`, `drivingType`, `driverGender`, `Status`, `visitorId`) VALUES ('$date','$time','$vehicleId','$DrivingType','$DriverGender','Confirmed','$id')";

$result2 = $conn->query($s);

$s2="UPDATE `vehicle` SET`Vehiclestatus`='booked' WHERE id=$vehicleId";
$result3 = $conn->query($s2);
}
 else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
	 //echo json_encode($count, JSON_UNESCAPED_UNICODE);
}