<?php

include 'connect.php';
$TDuration=$_POST['TDuration']*7;
$UserId=$_POST['Userid'];



$query="INSERT INTO Tawaf (UserId,TDuration) VALUES ('".$UserId."', '".$TDuration."')";

$result=mysqli_query($conn,$query);




?>