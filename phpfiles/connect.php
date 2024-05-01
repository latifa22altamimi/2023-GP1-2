<?php

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Scripting/EmptyPHP.php to edit this template
 */

$conn = new mysqli('103.172.92.27', 'olhruuqq_rehaab', 'gSI&w]xxAbS&', 'olhruuqq_rehaab');

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
