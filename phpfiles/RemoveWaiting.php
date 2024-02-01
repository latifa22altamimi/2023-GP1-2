<?php
include 'connect.php';
$waitingId=$_POST['waitingId'];
$deleteSql = "DELETE FROM waitinglist WHERE Id=$waitingId";
$result= mysqli_query($conn, $deleteSql);
if($result){
    echo 'succccc';
}