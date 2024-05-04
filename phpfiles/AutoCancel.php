<?php
include 'connect.php';

date_default_timezone_set('Asia/Riyadh');
$currentDateTime = date('h:i A');
$currentDateTimeObj = DateTime::createFromFormat('h:i A', $currentDateTime);
$currentDateTimeObj->modify('-1 minutes');
$twoMinutesAgo = $currentDateTimeObj->format('h:i A');

// Delete records with status 'Waiting' and time 2 minutes or more in the past
$deleteSql = "DELETE FROM reservation 
              WHERE status = 'Waiting' 
              AND TIME_FORMAT(time, '%h:%i %p') <= '$twoMinutesAgo'";

$result = $conn->query($deleteSql);

if ($result) {
    echo json_encode($twoMinutesAgo);
}
?>
