<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

$conn = new mysqli('localhost', 'root', '', 'rehaab');

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
