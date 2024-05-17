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
$sqlReservations = "SELECT COUNT(*) AS num_rows
                    FROM reservation AS r
                    WHERE r.Status = 'Active' 
                    AND r.VehicleId IN (
                        SELECT v.vehicleId
                        FROM vehicle AS v
                        WHERE v.VehicleType = '$VehicleType'
                    )
                    AND r.reservationId IN (
                        SELECT m.reservationId
                        FROM managerreservation AS m
                    )";
$resultReservations = mysqli_query($conn, $sqlReservations);
$rowReservation = mysqli_fetch_assoc($resultReservations);

$numOfActive = $rowReservation['num_rows'];

// Check availability and construct response
if ($numOfActive == $numVehicles) {
    $response = json_encode(["Unavailable" . $VehicleType]);
} else {
    $response = json_encode(["Available"]);
}

// Output the response
echo $response;
?>
