<?php


include 'connect.php';
$Rid=$_POST['Rid'];
$startTime=$_POST['startTime'];
$select= "UPDATE `reservation` SET `Status`='Active', `startTime`='$startTime' WHERE reservationId=$Rid";
$result= mysqli_query($conn, $select);