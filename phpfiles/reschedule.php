<?php 
include 'connect.php';
$Rid=$_POST['Rid'];
$UpdatedTime=$_POST['UpdatedTime'];
$UpdatedDate=$_POST['UpdatedDate'];

$slots = "SELECT slotId FROM timeslots WHERE time='$UpdatedTime'";
$slotIdResult =  mysqli_query($conn, $slots);
$row = mysqli_fetch_assoc($slotIdResult);
$slotId = $row['slotId'];

$select= "UPDATE `reservation` SET `date`='".$UpdatedDate."' , `slotId`='".$slotId."' WHERE id='".$Rid."'";
$result= mysqli_query($conn, $select);
if($result){
    echo json_encode($UpdatedDate);
    
}else{
    echo json_encode("Error in rescheduling reservation");
}
?>