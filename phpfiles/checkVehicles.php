<?php
include 'connect.php';

// Get the vehicle type from the POST data
$VehicleType = $_POST['VehicleType'];

// Fetch the total number of available vehicles for Single or Double type
$sqlSingleOrDouble = "SELECT TotalNumberofVehicles 
                      FROM parameters 
                      WHERE VehicleType='$VehicleType' AND VehicleDedicatedTo='walkIn'";
$resultSingleOrDouble = mysqli_query($conn, $sqlSingleOrDouble);
if (!$resultSingleOrDouble) {
    echo "Error: " . mysqli_error($conn);
} else {
    // Continue processing the result
}

$rowSingleOrDouble = mysqli_fetch_assoc($resultSingleOrDouble);

$numVehicles = $rowSingleOrDouble['TotalNumberofVehicles'];

// Fetch active walk-in reservations for the provided vehicle type
$sqlReservations = "SELECT r.*, v.VehicleType , m.*
                    FROM reservation r INNER JOIN managerreservation m ON r.reservationId = m.reservationId
                    INNER JOIN vehicle v ON r.VehicleId = v.vehicleId 
                    WHERE r.Status='Active' AND v.VehicleType='$VehicleType'";
$resultReservations = mysqli_query($conn, $sqlReservations);
$ActiveWalkInReservations = [];
while ($rowReservation = mysqli_fetch_assoc($resultReservations)) {
    $ActiveWalkInReservations[] = $rowReservation;
}

// Count the number of active reservations for the provided vehicle type
$numOfActive = count($ActiveWalkInReservations);

// Check availability and construct response
if ($numOfActive == $numVehicles) {
    $response = json_encode(["Unavailable" . $VehicleType]);
} else {
    $response = json_encode(["Available"]);
}

// Output the response
echo $response;
?>
