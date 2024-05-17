<?php
include 'connect.php';

date_default_timezone_set('Asia/Riyadh');
$currentDateTime = date('Y-m-d H:i:s');

// Update the reservations with status 'Active' to 'Completed' if the ExpectedFinishTime in managerreservation has passed
$updateSql = "UPDATE reservation 
              SET status = 'Completed' 
              WHERE status = 'Active' 
              AND reservationId IN (SELECT reservationId FROM managerreservation 
                                   WHERE STR_TO_DATE(ExpectedFinishTime, '%h:%i %p') <= TIME('$currentDateTime'))";

$result = $conn->query($updateSql);

if ($result) {
    echo "Status updated successfully.";
} else {
    echo "Error updating status: " . $conn->error;
}
?>
