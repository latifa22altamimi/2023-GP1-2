<?php
include 'connect.php';

$id = $_POST['id'];
$waitingName =$_POST['Name'];
$waitingNumber = $_POST['PhoneNumber'];
$VehicleId = $_POST['VehicleId'];
$ExpectUseTime = $_POST['ExpectUseTime'];

// Insert into the "reservation" table
$sql = "INSERT INTO reservation (date, time, VehicleId, drivingType, driverGender, Status, userId) VALUES (CURRENT_DATE(), '$ExpectUseTime', '$VehicleId', NULL, NULL, 'Waiting', '$id')";
$result = mysqli_query($conn, $sql);

if ($result) {
    // Retrieve the generated reservationId
    $reservationId = mysqli_insert_id($conn);

    // Insert into the "managerreservation" table
    $sql2 = "INSERT INTO managerreservation (reservationId, visitorName, VphoneNumber, ExpectedFinishTime) VALUES ('$reservationId', '$waitingName', '$waitingNumber', NULL)";
    $result2 = mysqli_query($conn, $sql2);

   
        

        if ($result2) {
            // All queries were successful
            echo "Data inserted into all tables updated successfully.";
        }
    else {
        // Error in inserting into "managerreservation" table
        echo " Error in inserting into managerreservation table " . mysqli_error($conn);
    }
} else {
    // Error in inserting into "reservation" table
    echo "Error in inserting into reservation table " . mysqli_error($conn);
}

mysqli_close($conn);
?>