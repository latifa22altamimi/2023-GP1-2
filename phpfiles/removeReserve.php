<?php 
include 'connect.php';
$Rid=$_POST['Rid'];

$select= "UPDATE `reservation` SET `Status`='Cancelled' WHERE id='$Rid'";
$result= mysqli_query($conn, $select);
if($result){
    echo json_encode("Removed successfully");
    
}else{
    echo json_encode("Error in removing reservation");
}
?>