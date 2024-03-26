<?php
include 'connect.php';

/*
$sql= "SELECT TDuration FROM tawaf";
$result = $conn->query($sql);
$tawafDurations = [];
$allTimes = []; // Array of time strings
while ($ro2 = $result->fetch_assoc()) {
    $tawafDurations[] = $ro2;
}

foreach ($tawafDurations as $time) {
   $allTimes[]= $time['TDuration'];
    
}
// Function to convert time string to seconds
function timeToSeconds($time) {
    $parts = explode(':', $time);
    $hours = intval($parts[0]);
    $minutes = intval($parts[1]);
    return $hours * 3600 + $minutes * 60;
}
// Convert each time string to seconds and calculate total sum
$totalSeconds = 0;
foreach ($allTimes as $time) {
    $totalSeconds += timeToSeconds($time);
}

// Calculate the average in seconds
$averageSeconds = $totalSeconds / count($allTimes);

// Convert average back to time format (hours:minutes)
$hours = floor($averageSeconds / 3600);
$minutes = floor(($averageSeconds % 3600) / 60);
$averageTime = sprintf('%02d:%02d', $hours, $minutes);
*/


date_default_timezone_set('Asia/Riyadh');
$oneMinuteAgo = date('Y-m-d H:i:s', strtotime('-2 minutes'));
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
