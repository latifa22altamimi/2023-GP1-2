<?php
include 'connect.php';
$id=$_POST['id'];
$sql = "UPDATE support SET Solved = 1 WHERE supportID=$id";
if ($conn->query($sql) === TRUE) {
    echo "Solved value updated in the database.";
} else {
    echo "Error updating the Solved value: " . $conn->error;
}