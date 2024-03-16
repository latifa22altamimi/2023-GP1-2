<?php 
include 'connect.php';
$Rid=$_POST['Rid'];

$select= "UPDATE `managerreservation` SET `ReservedForWaiting`='1' WHERE reservationId=$Rid";
$result= mysqli_query($conn, $select);
if($result){
    echo json_encode("reservation's waiting set to 1");
    
}else{
    echo json_encode("Error in setting waiting");
}
?>