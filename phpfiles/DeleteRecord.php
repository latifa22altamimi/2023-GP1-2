<?php
include 'connect.php';
date_default_timezone_set('Asia/Riyadh');
$oneMinuteAgo = date('Y-m-d H:i:s', strtotime('-1 minutes'));
$currentDateTime = date('Y-m-d H:i:s');
$deleteSql = "UPDATE reservation SET status = 'Completed' WHERE (DATE(timestamp) = DATE('$currentDateTime') AND timestamp < '$oneMinuteAgo') OR (DATE(timestamp) != DATE('$currentDateTime') AND timestamp < '$oneMinuteAgo')";
$result = $conn->query($deleteSql);
if($result){
    echo json_encode($oneMinuteAgo);
}