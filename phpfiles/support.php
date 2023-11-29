<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$RId=$_POST['RId'];
$LAT = $_POST['la'];
$lONG =$_POST['lo'];
$mess = $_POST['message'];

      
$stmt ="INSERT INTO support(ReservationId, Latitude, Longitude, Message) VALUES ('".$RId."','".$LAT."','".$lONG."','".$mess."')";

$result = mysqli_query($conn,$stmt);
