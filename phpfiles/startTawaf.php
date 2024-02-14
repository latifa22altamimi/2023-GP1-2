<?php

include 'connect.php';

$Rid = $_POST['Rid'];
$select = "SELECT Status FROM reservation WHERE reservationId=$Rid";
$result1 = mysqli_query($conn, $select);
$row = mysqli_fetch_assoc($result1);

if ($row["Status"] == "Confirmed") {
    $update = "UPDATE `reservation` SET `Status`='Active' WHERE reservationId=$Rid";
    $result = mysqli_query($conn, $update);

    if ($result) {
        $response = json_encode("Tawaf started successfully");
    } else {
        $response = json_encode("Error in starting Tawaf");
    }
} else {
    $response = json_encode("Reservation status is not Confirmed");
}

echo $response;


