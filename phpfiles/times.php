<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

include 'connect.php';
$sql = "SELECT * FROM vehicle";
$result = $conn->query($sql);
 while($ro2 = mysqli_fetch_assoc($result)){
     $data[]=$ro2;
 }
      
  
  echo json_encode($data);

