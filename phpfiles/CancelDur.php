<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$sql ="SELECT CancelDur FROM parameters WHERE ParametersId=1";
$result = $conn->query($sql);

$row2 = mysqli_fetch_assoc($result);

$CancelDur=$row2['CancelDur'];
  echo json_encode($CancelDur);
