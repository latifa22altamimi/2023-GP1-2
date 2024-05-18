<?php
include 'connect.php';
$UserId = $_POST['Userid'];

$query = "SELECT * FROM support WHERE AssignedTo = '".$UserId."' AND Solved = 0";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $id = $row["supportID"];
        $assignedTo = $row["AssignedTo"];
        $solved = $row["Solved"];
        $longitude = $row["Latitude"];
        $latitude = $row["Longitude"];
        $Message= $row["Message"];
        echo json_encode([0 => true, 1 => $longitude, 2 => $latitude, 3 => $id, 4=>$Message]);
    }
} else {
    echo json_encode([0 => false, 1 => "0.0", 2 => "0.0", 3 =>"0", 4=>'']);}

$conn->close();











