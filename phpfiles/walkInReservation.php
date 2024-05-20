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
$rId = $_POST['rId'];
$Status = $_POST['Status'];

// Fetch ReservationDur from parameters
$sql = "SELECT TDuration FROM tawaf";
$result = $conn->query($sql);
$tawafDurations = [];
while ($ro2 = $result->fetch_assoc()) {
    $tawafDurations[] = $ro2['TDuration'];
}

// Function to convert time string to seconds
function timeToSeconds($time) {
    $parts = explode(':', $time);
    $hours = intval($parts[0]);
    $minutes = intval($parts[1]);
    return $hours * 3600 + $minutes * 60;
}

// Convert each time string to seconds
$tawafDurationsSeconds = [];
foreach ($tawafDurations as $time) {
    $tawafDurationsSeconds[] = timeToSeconds($time);
}

// Calculate the average in seconds
$totalSeconds = array_sum($tawafDurationsSeconds);
$averageSeconds = $totalSeconds / count($tawafDurationsSeconds);

// Convert average back to time format (hours:minutes)
$hours = floor($averageSeconds / 3600);
$minutes = floor(($averageSeconds % 3600) / 60);
$AvgTime = sprintf('%02d:%02d', $hours, $minutes); // Average from tawaf duration

// Calculate expected finish time
list($startHourMinute, $startPeriod) = explode(' ', $startTime);
list($startHour, $startMinute) = explode(':', $startHourMinute);
$startHour = intval($startHour);
$startMinute = intval($startMinute);
$startPeriod = strtoupper(trim($startPeriod));

// Adjust start hour if it's PM
if ($startPeriod === 'PM') {
    if ($startHour != 12) {
        $startHour += 12;
    } else {
        $startHour = 0; // Adjust for 12:00 PM (noon)
    }
} else {
    if ($startHour == 12) {
        $startHour = 0; // Adjust for 12:00 AM (midnight)
    }
}

list($avgHour, $avgMinute) = explode(':', $AvgTime);
$avgHour = intval($avgHour);
$avgMinute = intval($avgMinute);

// Calculate total minutes and convert to total hours and minutes
$totalMinutes = $startHour * 60 + $startMinute + $avgHour * 60 + $avgMinute;
$hours = floor($totalMinutes / 60);
$minutes = $totalMinutes % 60;

// Adjust hours to wrap around every 24 hours and format AM/PM
$finalHour = $hours % 12;
$finalHour = ($finalHour === 0) ? 12 : $finalHour; // Adjust for 12-hour format
$period = ($hours >= 12) ? 'PM' : 'AM';

$ExpectFinishTime = sprintf("%02d:%02d %s", $finalHour, $minutes, $period);

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
$sqlReservations =  "SELECT r.*, v.VehicleType
FROM reservation r
INNER JOIN vehicle v ON r.VehicleId = v.vehicleId
INNER JOIN managerreservation m ON r.reservationId = m.reservationId
WHERE r.VehicleId = '$vehicleId'
AND r.Status = 'Active'
AND r.date = '$date'";
$resultReservations = mysqli_query($conn, $sqlReservations);
$reservationsInSameDay = [];
while ($rowReservation = mysqli_fetch_assoc($resultReservations)) {
    $reservationsInSameDay[] = $rowReservation;
}
echo json_encode($reservationsInSameDay);
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
if($Status=="Active"){
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
} else{
     // Handle case when no available vehicles
     echo json_encode("broke mafe vehicles");
}
}else if($Status=="Waiting"){
    // Insert into reservation table 
    $sqlInsertReservation = "INSERT INTO reservation(date, time, VehicleId, drivingType, driverGender, Status, userId) 
                             VALUES ('$date', '$startTime', '$vehicleId', '$DrivingType', '$DriverGender', 'Waiting', '$id')";
    $resultInsertReservation = mysqli_query($conn, $sqlInsertReservation);
    if ($resultInsertReservation) {
        // Retrieve the last inserted reservation ID
        $reservationId = mysqli_insert_id($conn);

        // Insert into managerreservation table
        $sqlInsertManagerReservation = "INSERT INTO managerreservation(reservationId, visitorName, VphoneNumber, ExpectedFinishTime) 
                                        VALUES ('$reservationId', '$visitorName', '$Vnumber', '$ExpectFinishTime')";
        $resultInsertManagerReservation = mysqli_query($conn, $sqlInsertManagerReservation);
        if ($resultInsertManagerReservation) {
            //sucess
            $query = "
            UPDATE managerreservation
            SET ReservedForWaiting = '$reservationId'
            WHERE reservationId = '$rId'
          ";
          
          $result = mysqli_query($conn, $query);
                echo json_encode("changed reservedforwaiting to 1");
        } else {
            // Handle error inserting into managerreservation table
            $response['error'] = "Error inserting into managerreservation table: " . mysqli_error($conn);
        }
    } else {
        // Handle error inserting into reservation table
        $response['error'] = "Error inserting into reservation table: " . mysqli_error($conn);
    }
}
