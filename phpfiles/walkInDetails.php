<?php

include 'connect.php';

$sql = "SELECT r.*, v.* 
        FROM reservation r 
        INNER JOIN vehicle v ON r.VehicleId = v.vehicleId";

$result = $conn->query($sql);

$data = array();

if ($result->num_rows > 0) {
    // Fetch rows one by one
    while($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
} else {
    // No rows found
    echo "No records found";
}

// Encode the data array to JSON format and output it
echo json_encode($data);

?>
