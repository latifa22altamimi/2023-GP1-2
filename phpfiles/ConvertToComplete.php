<?php
include 'connect.php';
date_default_timezone_set('Asia/Riyadh');
$oneMinuteAgo = date('Y-m-d H:i:s', strtotime('-1 minutes'));
$currentDateTime = date('Y-m-d H:i:s');

// Update only reservations with status 'Active' to 'Completed' 
// and have reservationId in managerreservation (for walk in only)
$updateSql = "UPDATE reservation 
              SET status = 'Completed' 
              WHERE status = 'Active' 
              AND reservationId IN (SELECT reservationId FROM managerreservation) 
              AND ((DATE(timestamp) = DATE('$currentDateTime') AND timestamp < '$oneMinuteAgo') 
                   OR (DATE(timestamp) != DATE('$currentDateTime') AND timestamp < '$oneMinuteAgo'))";

$result = $conn->query($updateSql);

if($result) {
    echo json_encode($oneMinuteAgo);
}
