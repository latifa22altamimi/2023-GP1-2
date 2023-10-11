<?php
  include 'connect.php';
$Email= $_POST['Email'];
 $sql= "SELECT * FROM users WHERE Email='".$Email."' AND status=1";
         $result= mysqli_query($conn, $sql);
         $count= mysqli_num_rows($result);
         
if($count== 1){
   echo json_encode("http://".$_SERVER['SERVER_NAME']."/phpfiles/forgotPass.php?Email=$Email");
}
else if(empty($Email)){
   echo json_encode("empty");  
}
else{
   echo json_encode("Fail");  
}