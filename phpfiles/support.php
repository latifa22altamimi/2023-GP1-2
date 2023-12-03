<?php

include 'connect.php';
$Rid = $_POST['Rid'];
$LAT = $_POST['la'];
$lONG = $_POST['lo'];
$mess = $_POST['message'];

$stmt = $conn->prepare("INSERT INTO support (ReservationId, Latitude, Longitude, Message) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $Rid, $LAT, $lONG, $mess);
$stmt->execute();

$stmt->close();
$conn->close();
?>