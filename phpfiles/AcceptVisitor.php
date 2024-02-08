<?php


include 'connect.php';
$Rid=$_POST['Rid'];

$select= "UPDATE `reservation` SET `Status`='Active' WHERE reservationId=$Rid";
$result= mysqli_query($conn, $select);