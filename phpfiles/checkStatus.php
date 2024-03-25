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
    $response = json_encode([
        'message' => 'User has an active reservation.',
        'userId' => $userId,
        'reservationId' => $reservationId
    ]);
} else {
    // No active reservation found
    $response = json_encode([
        'message' => 'User does not have an active reservation.',
        'userId' => $userId
    ]);
}

// Echo the JSON response
echo $response;
