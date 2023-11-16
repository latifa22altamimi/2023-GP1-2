<?php

include 'connect.php';
$Duration=$_POST['Duration']*7;
$UserId=$_POST['Userid'];



$query="INSERT INTO Duration (UserId,Duration) VALUES ('".$UserId."', '".$Duration."')";

$result=mysqli_query($conn,$query);




?>