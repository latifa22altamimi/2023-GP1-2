<?php
include 'connect.php';

// Retrieve the reservation ID from the POST request
$reservationId = $_POST['id'];

// Construct the delete query
$deleteQuery = "
  DELETE FROM reservation
  WHERE reservationId = '$reservationId'
";

// Execute the delete query
$result = mysqli_query($conn, $deleteQuery);

if ($result) {
    $response = array('success' => true, 'message' => 'Reservation canceled successfully');
} else {
    $response = array('success' => false, 'message' => 'Failed to cancel reservation');
}

// Close the database connection
mysqli_close($conn);

// Send the JSON response
header('Content-Type: application/json');
echo json_encode($response);
?>
