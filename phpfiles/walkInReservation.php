<?php
include 'connect.php';
$id = $_POST['id'];
$date = $_POST['date'];
$startTime =$_POST['time'];
$VehicleType = $_POST['VehicleType'];
$DrivingType = $_POST['DrivingType'];
$DriverGender = $_POST['DriverGender'];
$visitorName = $_POST['visitorName'];
$Vnumber = $_POST['Vnumber'];

$sqlDur = "SELECT ReservationDur FROM parameters WHERE ParametersId=1";
$resultDur = mysqli_query($conn, $sqlDur);
$rowDur = mysqli_fetch_assoc($resultDur);

$AvgTime = $rowDur['ReservationDur']; //get the average from tawaf duration


// Parse the start time
list($startHour, $startMinute, $startPeriod) = explode(':', $startTime);
$startHour = intval($startHour);
$startMinute = intval($startMinute);
$startPeriod = strtoupper(trim($startPeriod));

// Parse the average time
list($avgHour, $avgMinute) = explode(':', $AvgTime);
$avgHour = intval($avgHour);
$avgMinute = intval($avgMinute);

// Calculate the expected finish time
$totalMinutes = $startHour * 60 + $startMinute + $avgHour * 60 + $avgMinute;
$hours = floor($totalMinutes / 60) % 12;
$minutes = $totalMinutes % 60;
$period = ($startPeriod == 'AM' && $hours >= 12) || ($startPeriod == 'PM' && $hours < 12) ? 'PM' : 'AM';

// Adjust hours for PM period
if ($period == 'PM') {
    $hours += 12;
}

// Format the expected finish time
$ExpectFinishTime = sprintf("%02d:%02d %s", $hours, $minutes, $period);

echo json_encode($ExpectFinishTime);

$sql = "SELECT NumOfSWalkInVehicles, NumOfDWalkInVehicles FROM parameters WHERE ParametersId=1";
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
    $s ="INSERT INTO reservation (date,startTime,ExpectFinishTime,VehicleType,drivingType,driverGender,Status,userId,visitorName,VphoneNumber) VALUES ('".$date."','".$startTime."','".$ExpectFinishTime."','".$VehicleType."','".$DrivingType."','".$DriverGender."','Active','".$id."','".$visitorName."','".$Vnumber."')";

    $result2 = mysqli_query($conn, $s);

    if ($VehicleType == "Single") {
        $numSingle--;
    } elseif ($VehicleType == "Double") {
        $numDouble--;
    }
} 


    
