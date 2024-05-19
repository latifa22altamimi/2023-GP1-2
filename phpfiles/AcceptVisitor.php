<?php


include 'connect.php';
$Rid = $_POST['Rid'];
date_default_timezone_set('Asia/Riyadh'); // Set to Makkah
$startTime = date("h:i A");

// Fetch ReservationDur from parameters
$sql = "SELECT TDuration FROM tawaf";
$result = $conn->query($sql);
$tawafDurations = [];
while ($ro2 = $result->fetch_assoc()) {
    $tawafDurations[] = $ro2['TDuration'];
}

// Function to convert time string to seconds
function timeToSeconds($time) {
    $parts = explode(':', $time);
    $hours = intval($parts[0]);
    $minutes = intval($parts[1]);
    return $hours * 3600 + $minutes * 60;
}

// Convert each time string to seconds
$tawafDurationsSeconds = [];
foreach ($tawafDurations as $time) {
    $tawafDurationsSeconds[] = timeToSeconds($time);
}

// Calculate the average in seconds
$totalSeconds = array_sum($tawafDurationsSeconds);
$averageSeconds = $totalSeconds / count($tawafDurationsSeconds);

// Convert average back to time format (hours:minutes)
$hours = floor($averageSeconds / 3600);
$minutes = floor(($averageSeconds % 3600) / 60);
$AvgTime = sprintf('%02d:%02d', $hours, $minutes); // Average from tawaf duration

// Calculate expected finish time
list($startHourMinute, $startPeriod) = explode(' ', $startTime);
list($startHour, $startMinute) = explode(':', $startHourMinute);
$startHour = intval($startHour);
$startMinute = intval($startMinute);
$startPeriod = strtoupper(trim($startPeriod));

// Adjust start hour if it's PM
if ($startPeriod === 'PM') {
    if ($startHour != 12) {
        $startHour += 12;
    } else {
        $startHour = 0; // Adjust for 12:00 PM (noon)
    }
} else {
    if ($startHour == 12) {
        $startHour = 0; // Adjust for 12:00 AM (midnight)
    }
}

list($avgHour, $avgMinute) = explode(':', $AvgTime);
$avgHour = intval($avgHour);
$avgMinute = intval($avgMinute);

// Calculate total minutes and convert to total hours and minutes
$totalMinutes = $startHour * 60 + $startMinute + $avgHour * 60 + $avgMinute;
$hours = floor($totalMinutes / 60);
$minutes = $totalMinutes % 60;

// Adjust hours to wrap around every 24 hours and format AM/PM
$finalHour = $hours % 12;
$finalHour = ($finalHour === 0) ? 12 : $finalHour; // Adjust for 12-hour format
$period = ($hours >= 12) ? 'PM' : 'AM';

$ExpectFinishTime = sprintf("%02d:%02d %s", $finalHour, $minutes, $period);


$updateReservationQuery = "UPDATE `reservation` SET `Status`='Active', `time`='$startTime' WHERE reservationId=$Rid";
$resultReservation = mysqli_query($conn, $updateReservationQuery);

$updateManagerQuery = "UPDATE `managerreservation` SET `ExpectedFinishTime`='$ExpectFinishTime' WHERE reservationId=$Rid";
$resultManager = mysqli_query($conn, $updateManagerQuery);

if ($resultReservation && $resultManager) {
    echo 'Update successful';
} else {
    echo 'Failed to update reservation or managerreservation';
}