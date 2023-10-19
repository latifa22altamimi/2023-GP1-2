<?php 
include 'connect.php';
$Rid=$_POST['Rid'];
/*
$sql = "SELECT * FROM reservation WHERE id='45'";
$result1 = $conn->query($sql);
$row = mysqli_fetch_assoc($result1);
$time= $row['time'];



$select1= "SELECT * FROM vehicle WHERE time=$time";
$result2 = $conn->query($select1);
$row2= mysqli_fetch_assoc($result2);

if($result2){
    echo json_encode($row2['numberOfSingleV']);
    
}else{
    echo json_encode("Error in removing reservation");
}

if($row['VehicleType']='Single'){
    $numOfSingleV= $row2['numberOfSingleV'];
    $update="UPDATE `vehicle` SET `numberOfSingleV`= $numOfSingleV+1 WHERE time=$time";
    $result= mysqli_query($conn, $update);
}
*/
$select= "UPDATE `reservation` SET `Status`='Cancelled' WHERE id=$Rid";
$result= mysqli_query($conn, $select);
if($result){
    echo json_encode("Removed successfully");
    
}else{
    echo json_encode("Error in removing reservation");
}
?>