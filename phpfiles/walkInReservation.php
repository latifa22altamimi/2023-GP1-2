<?php
include 'connect.php';
$id = $_POST['id'];
$date = $_POST['date'];
$time = $_POST['time'];
$VehicleType = $_POST['VehicleType'];
$DrivingType = $_POST['DrivingType'];
$DriverGender = $_POST['DriverGender'];
$visitorName = $_POST['visitorName'];
$Vnumber = $_POST['Vnumber'];

$sql = "SELECT NumOfSWalkInVehicles, NumOfDWalkInVehicles FROM rehaabweb_parameters WHERE ParametersId=1";
$result1 = mysqli_query($conn, $sql);
$row = mysqli_fetch_assoc($result1);

$numDouble = $row['NumOfDWalkInVehicles'];
$numSingle = $row['NumOfSWalkInVehicles'];

$sql2= "SELECT * FROM reservation WHERE date='$date' AND slotId IS NULL AND Status='Active'";
$result4 = $conn->query($sql2);
$ReservationInSameDay = [];
while ($ro2 = $result4->fetch_assoc()) {
    $ReservationInSameDay[] = $ro2;
}

foreach ($ReservationInSameDay as $reservation) {
    if ($reservation['VehicleType'] == "Single") {
        $numSingle--;
    } elseif ($reservation['VehicleType'] == "Double") {
        $numDouble--;
    }
}
$response= array();
if (($VehicleType == "Single" && $numSingle > 0) || ($VehicleType == "Double" && $numDouble > 0)) {
    $s ="INSERT INTO reservation (date,startTime,VehicleType,drivingType,driverGender,Status,userId,visitorName,VphoneNumber) VALUES ('".$date."','".$time."','".$VehicleType."','".$DrivingType."','".$DriverGender."','Active','".$id."','".$visitorName."','".$Vnumber."')";

    $result2 = mysqli_query($conn, $s);

    if ($VehicleType == "Single") {
        $numSingle--;
    } elseif ($VehicleType == "Double") {
        $numDouble--;
    }
} else {
    $response = ($VehicleType == "Single") ? json_encode([0 => "unavailableSingle"]): json_encode([0 => "unavailableDouble"]);
    echo j$response;

}


    
