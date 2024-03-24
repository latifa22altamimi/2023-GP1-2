<?php
include 'connect.php';

// Assuming you have a database connection established
$userId = $_POST['Userid'];
// Query to check for an active reservation
$query = "SELECT * FROM reservation WHERE userId=$userId AND Status ='Active'";

// Execute the query
$result = $conn->query($query);

// Check if a reservation was found
if ($result && $result->num_rows > 0) {
    // Active reservation found
    $row = $result->fetch_assoc(); // Fetch the reservation details
    $reservationId = $row['reservationId']; // Get the reservation ID
    $response = array(
        'message' => 'User has an active reservation.',
        'userId' => $userId,
        'reservationId' => $reservationId // Add reservationId to the response
      );
} else {
    // No active reservation found
    $response = array(
        'message' => 'User does not have an active reservation.',
        'userId' => $userId
      );
}

// Encode the response into JSON format
$response = json_encode($response);

// Echo the JSON response
echo $response;
?>
