<?php
include 'connect.php';

// Get the current time
$currentDateTime = date('h:i A');

// Calculate the time 5 minutes ago
$deleteTime = date('h:i A', strtotime('-1 minutes'));

// Construct the delete query
$deleteQuery = "
  DELETE FROM reservation
  WHERE Status = 'Waiting'
  AND TIME_FORMAT(time, '%h:%i %p') <= '$deleteTime'
";

// Execute the delete query
$result = mysqli_query($conn, $deleteQuery);

if ($result) {
    $response = array('success' => true, 'message' => 'Deletion successful');
} else {
    $response = array('success' => false, 'message' => 'Failed to delete rows');
}

// Close the database connection
mysqli_close($conn);

// Send the JSON response
header('Content-Type: application/json');
echo json_encode($response);
?>