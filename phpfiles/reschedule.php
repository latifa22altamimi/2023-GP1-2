<?php 
include 'connect.php';
$Rid=$_POST['Rid'];
$UpdatedTime=$_POST['UpdatedTime'];
$UpdatedDate=$_POST['UpdatedDate'];



$select= "UPDATE `reservation` SET `date`='".$UpdatedDate."' , `time`='".$UpdatedTime."' WHERE reservationId='".$Rid."'";
$result= mysqli_query($conn, $select);
if($result){
    echo json_encode($UpdatedDate);
    
}else{
    echo json_encode("Error in rescheduling reservation");
}
?>
