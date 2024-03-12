<?php

include 'connect.php';

$sql = "SELECT r.*, v.* 
        FROM reservation r 
        JOIN vehicle v ON r.VehicleId = v.vehicleId
        WHERE r.reservationId NOT IN (SELECT reservationId FROM managerreservation)";

$result = $conn->query($sql);

$data = array();

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

// Encode the data array to JSON format and output it
echo json_encode($data);

?>
