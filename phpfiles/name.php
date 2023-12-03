<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */
include 'connect.php';
$id=$_POST['id'];
$sql = "SELECT  ID, FirstName ,LastName FROM users WHERE ID=$id";
$result = $conn->query($sql);
$data=array();
while($ro2 = mysqli_fetch_assoc($result)){
     $data[]=$ro2;
 }
      
  
  echo json_encode($data);