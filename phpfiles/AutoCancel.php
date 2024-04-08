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
  AND time <= '$deleteTime'
";

// Execute the delete query
$result = mysqli_query($conn, $deleteQuery);

if ($result) {
    echo 'Deletion successful';
} else {
    echo 'Failed to delete rows';
}

// Close the database connection
mysqli_close($conn);
?>