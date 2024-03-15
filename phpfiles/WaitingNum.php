<?php

include 'connect.php';
$sql = "SELECT COUNT(*) AS waitingCount FROM reservation WHERE Status = 'Waiting'";

$result = $conn->query($sql);

if ($result) {
   
    $row = $result->fetch_assoc();

    
    $waitingCount = $row['waitingCount'];

    
    echo json_encode($waitingCount);
} else {
    
    echo json_encode("Error");
}