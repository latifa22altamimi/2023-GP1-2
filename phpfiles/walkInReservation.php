<?php
include 'connect.php';

$id = $_POST['id'];
$date = $_POST['date'];
$startTime = $_POST['time'];
$VehicleType = $_POST['VehicleType'];
$DrivingType = $_POST['DrivingType'];
$DriverGender = $_POST['DriverGender'];
$visitorName = $_POST['visitorName'];
$Vnumber = $_POST['Vnumber'];

// Fetch ReservationDur from parameters
$sql= "SELECT TDuration FROM tawaf";
$result = $conn->query($sql);
$tawafDurations = [];
$allTimes = []; // Array of time strings
while ($ro2 = $result->fetch_assoc()) {
    $tawafDurations[] = $ro2;
}

foreach ($tawafDurations as $time) {
   $allTimes[]= $time['TDuration'];
    
}
// Function to convert time string to seconds
function timeToSeconds($time) {
    $parts = explode(':', $time);
    return $parts[0] * 3600 + $parts[1] * 60;
}
// Convert each time string to seconds and calculate total sum
$totalSeconds = 0;
foreach ($allTimes as $time) {
    $totalSeconds += timeToSeconds($time);
}

// Calculate the average in seconds
$averageSeconds = $totalSeconds / count($allTimes);

// Convert average back to time format (hours:minutes)
$hours = floor($averageSeconds / 3600);
$minutes = floor(($averageSeconds % 3600) / 60);
$AvgTime = sprintf('%02d:%02d', $hours, $minutes); // Average from tawaf duration

// Calculate expected finish time
list($startHour, $startMinute, $startPeriod) = explode(':', $startTime);
$startHour = intval($startHour);
$startMinute = intval($startMinute);
$startPeriod = strtoupper(trim($startPeriod));
list($avgHour, $avgMinute) = explode(':', $AvgTime);
$avgHour = intval($avgHour);
$avgMinute = intval($avgMinute);
$totalMinutes = $startHour * 60 + $startMinute + $avgHour * 60 + $avgMinute;
$hours = floor($totalMinutes / 60) % 12;
$minutes = $totalMinutes % 60;
$period = ($startPeriod == 'AM' && $hours >= 12) || ($startPeriod == 'PM' && $hours < 12) ? 'PM' : 'AM';
if ($period == 'PM') {
    $hours += 12;
}
$ExpectFinishTime = sprintf("%02d:%02d %s", $hours, $minutes, $period);

// Fetch available vehicles count
$sqlSingle = "SELECT TotalNumberofVehicles FROM parameters WHERE VehicleType='Single' AND VehicleDedicatedTo='walkIn'";
$resultSingle = mysqli_query($conn, $sqlSingle);
$rowSingle = mysqli_fetch_assoc($resultSingle);
$numSingle = $rowSingle['TotalNumberofVehicles'];

$sqlDouble = "SELECT TotalNumberofVehicles FROM parameters WHERE VehicleType='Double' AND VehicleDedicatedTo='walkIn'";
$resultDouble = mysqli_query($conn, $sqlDouble);
$rowDouble = mysqli_fetch_assoc($resultDouble);
$numDouble = $rowDouble['TotalNumberofVehicles'];

// Fetch vehicle ID based on provided VehicleType
$sqlVehicle = "SELECT vehicleId FROM vehicle WHERE VehicleType='$VehicleType'";
$resultVehicle = mysqli_query($conn, $sqlVehicle);
$rowVehicle = mysqli_fetch_assoc($resultVehicle);
$vehicleId = $rowVehicle['vehicleId'];

// Fetch reservations in the same day
$sqlReservations = "SELECT r.*, v.VehicleType
                    FROM reservation r
                    INNER JOIN vehicle v ON r.VehicleId = v.vehicleId
                    WHERE r.date='$date' AND r.Status='Active'";
$resultReservations = mysqli_query($conn, $sqlReservations);
$reservationsInSameDay = [];
while ($rowReservation = mysqli_fetch_assoc($resultReservations)) {
    $reservationsInSameDay[] = $rowReservation;
}

// Decrement available vehicle count based on reservations
foreach ($reservationsInSameDay as $reservation) {
    $vehicleType = $reservation['VehicleType'];
    if ($vehicleType == "Single") {
        $numSingle--;
    } elseif ($vehicleType == "Double") {
        $numDouble--;
    }
}

$response = array();
if (($VehicleType == "Single" && $numSingle > 0) || ($VehicleType == "Double" && $numDouble > 0)) {
    // Insert into reservation table
    $sqlInsertReservation = "INSERT INTO reservation(date, time, VehicleId, drivingType, driverGender, Status, userId) 
                             VALUES ('$date', '$startTime', '$vehicleId', '$DrivingType', '$DriverGender', 'Active', '$id')";
    $resultInsertReservation = mysqli_query($conn, $sqlInsertReservation);
    if ($resultInsertReservation) {
        // Retrieve the last inserted reservation ID
        $reservationId = mysqli_insert_id($conn);

        // Insert into managerreservation table
        $sqlInsertManagerReservation = "INSERT INTO managerreservation(reservationId, visitorName, VphoneNumber, ExpectedFinishTime) 
                                        VALUES ('$reservationId', '$visitorName', '$Vnumber', '$ExpectFinishTime')";
        $resultInsertManagerReservation = mysqli_query($conn, $sqlInsertManagerReservation);
        if ($resultInsertManagerReservation) {
            if ($VehicleType == "Single") {
                $numSingle--;
            } elseif ($VehicleType == "Double") {
                $numDouble--;
            }
        } else {
            // Handle error inserting into managerreservation table
            $response['error'] = "Error inserting into managerreservation table: " . mysqli_error($conn);
        }
    } else {
        // Handle error inserting into reservation table
        $response['error'] = "Error inserting into reservation table: " . mysqli_error($conn);
    }
} else {
    // Handle case when no available vehicles
}
