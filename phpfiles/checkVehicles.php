<?php
include 'connect.php';

// Get the vehicle type from the POST data
$VehicleType = $_POST['VehicleType'];

// Fetch the total number of available vehicles for the specified type
$sqlSingleOrDouble = "SELECT TotalNumberofVehicles 
                      FROM parameters 
                      WHERE VehicleType='$VehicleType' AND VehicleDedicatedTo='walkIn'";
$resultSingleOrDouble = mysqli_query($conn, $sqlSingleOrDouble);
if (!$resultSingleOrDouble) {
    echo "Error: " . mysqli_error($conn);
    exit;
}

$rowSingleOrDouble = mysqli_fetch_assoc($resultSingleOrDouble);
$numVehicles = $rowSingleOrDouble['TotalNumberofVehicles'];

// Fetch active reservations managed by a manager for the provided vehicle type
$sqlReservations = "SELECT COUNT(*) AS num_rows
                    FROM reservation AS r
                    JOIN managerreservation AS m ON r.reservationId = m.reservationId
                    WHERE r.Status = 'Active'
                    AND r.VehicleId IN (
                        SELECT v.vehicleId
                        FROM vehicle AS v
                        WHERE v.VehicleType = '$VehicleType'
                    )";
$resultReservations = mysqli_query($conn, $sqlReservations);
if (!$resultReservations) {
    echo "Error: " . mysqli_error($conn);
    exit;
}

$rowReservation = mysqli_fetch_assoc($resultReservations);
$numOfActive = $rowReservation['num_rows'];

// Check availability and construct response
if ($numOfActive >= $numVehicles) {
    $response = json_encode(["Unavailable" => $VehicleType]);
} else {
    $response = json_encode(["Available" => $VehicleType]);
}

// Output the response
echo $response;
?>
