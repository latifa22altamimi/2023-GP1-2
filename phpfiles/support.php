<?php

include 'connect.php';
$Rid=$_POST['Rid'];
$LAT = $_POST['la'];
$lONG =$_POST['lo'];
$mess = $_POST['message'];


      
$stmt ="INSERT INTO support(ReservationId, Latitude, Longitude, Message) VALUES ('".$Rid."','".$LAT."','".$lONG."','".$mess."')";

$result = mysqli_query($conn,$stmt);
