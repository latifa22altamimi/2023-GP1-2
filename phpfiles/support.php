<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$UserId=$_POST['UserId'];
$LAT = $_POST['la'];
$lONG =$_POST['lo'];
$mess = $_POST['message'];

      
$stmt ="INSERT INTO support(UserId, Latitude, Longitude, Message) VALUES ('".$UserId."','".$LAT."','".$lONG."','".$mess."')";

$result = mysqli_query($conn,$stmt);
