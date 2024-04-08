<?php
include 'connect.php';

$Rid = $_POST['Rid'];

// Update ReservedForWaiting to 0 in managerreservation
$updateSql = "UPDATE managerreservation SET ReservedForWaiting = 0 WHERE ReservedForWaiting = $Rid";
$result = mysqli_query($conn, $updateSql);

if ($result) {
    // Delete from reservation table
    $deleteSql = "DELETE FROM reservation WHERE reservationId = $Rid";
    $deleteResult = mysqli_query($conn, $deleteSql);

    if ($deleteResult) {
        echo 'Deletion waiting successful';
    } else {
        echo 'Failed to delete waiting from reservation';
    }
} else {
    echo 'Failed to update ReservedForWaiting';
}

// Close the database connection
mysqli_close($conn);
?>