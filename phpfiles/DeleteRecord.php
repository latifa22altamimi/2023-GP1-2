<?php
include 'connect.php';
$twoMinutesAgo = date('Y-m-d H:i:s', strtotime('-1 minutes'));

$deleteSql = "DELETE FROM reservation WHERE timestamp < '$twoMinutesAgo'";
if($deleteSql){
    echo 'succccc';
}