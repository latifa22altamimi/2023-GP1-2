<?php
include 'connect.php';
$Rid=$_POST['Rid'];
$deleteSql = "DELETE FROM reservation WHERE reservationId = $Rid";
$result = mysqli_query($conn, $deleteSql);

if ($result) {
    echo 'Deletion waiting successful';
} else {
    echo 'Failed to delete waiting from reservation';
}