<?php
include 'connect.php';
$id=$_POST['id'];
$waitingName= $_POST['Name'];
$waitingNumber=$_POST['PhoneNumber'];


$s ="INSERT INTO waitinglist (Name,PhoneNumber,userId) VALUES ('".$waitingName."','".$waitingNumber."','".$id."')";

$result2 = mysqli_query($conn, $s);