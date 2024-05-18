<?php
include 'connect.php';
$id=$_POST['id'];
$sql = "UPDATE support SET Solved = 1 WHERE supportID=$id";
if ($conn->query($sql) === TRUE) {
    echo json_encode("Solved");
} else {
    echo json_encode("Error");
}