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
    $response = array(
        'message' => 'User has an active reservation.',
        'userId' => $userId
      );
      echo json_encode($response);
} else {
    // No active reservation found
    echo json_encode("User does not have an active reservation.$userId");
}
?>
