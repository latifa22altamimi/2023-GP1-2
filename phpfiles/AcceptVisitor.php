<?php


include 'connect.php';
$Rid = $_POST['Rid'];
date_default_timezone_set('Asia/Riyadh'); // Set to Makkah
$startTime = date("h:i A");

// Get the average of tawaf to calculate expect finish time 
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
    return $parts[0] * 3600 + $parts[1] * 60;
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
$AvgTime = sprintf('%02d:%02d', $hours, $minutes); // Average from tawaf duration

// Calculate expected finish time
list($startHour, $startMinute, $startPeriod) = explode(':', $startTime);
$startHour = intval($startHour);
$startMinute = intval($startMinute);
$startPeriod = strtoupper(trim($startPeriod));
list($avgHour, $avgMinute) = explode(':', $AvgTime);
$avgHour = intval($avgHour);
$avgMinute = intval($avgMinute);
$totalMinutes = $startHour * 60 + $startMinute + $avgHour * 60 + $avgMinute;
$hours = floor($totalMinutes / 60) % 12;
$minutes = $totalMinutes % 60;
$period = ($startPeriod == 'AM' && $hours >= 12) || ($startPeriod == 'PM' && $hours < 12) ? 'PM' : 'AM';
if ($period == 'PM') {
    $hours += 12;
}
$ExpectFinishTime = sprintf("%02d:%02d %s", $hours, $minutes, $period);



$updateReservationQuery = "UPDATE `reservation` SET `Status`='Active', `time`='$startTime' WHERE reservationId=$Rid";
$resultReservation = mysqli_query($conn, $updateReservationQuery);

$updateManagerQuery = "UPDATE `managerreservation` SET `ExpectedFinishTime`='$ExpectFinishTime' WHERE reservationId=$Rid";
$resultManager = mysqli_query($conn, $updateManagerQuery);

if ($resultReservation && $resultManager) {
    echo 'Update successful';
} else {
    echo 'Failed to update reservation or managerreservation';
}