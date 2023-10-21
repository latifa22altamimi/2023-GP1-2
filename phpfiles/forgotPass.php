<?php
 include 'connect.php';
         
         
function alert($msg) {
    echo "<script type='text/javascript'>alert('$msg');</script>";
} 
$Email= $_GET['Email'];

if($_SERVER['REQUEST_METHOD']=="POST"){
        
        
        

    
        $NewPass=$_POST['Npass'];
        $ConPass=$_POST['Cpass'];
                 
         $uppercase = preg_match('@[A-Z]@', $NewPass);
         $lowercase = preg_match('@[a-z]@', $NewPass);
         $number    = preg_match('@[0-9]@', $NewPass);
         $specialChars = preg_match('@[^\w]@', $NewPass);

         
          
  
        if(strcmp($NewPass, $ConPass) == 0){
           if(!$uppercase || !$lowercase || !$number || !$specialChars || strlen($NewPass) < 8){
              alert("Password must be strong! at least 8 letters, 1 capital and small letter, 1 digit and 1 special character.");    
           }  
           else{
            $hashPass=password_hash($NewPass, PASSWORD_DEFAULT);
              $select= "UPDATE `users` SET `Password`='$hashPass' WHERE Email='$Email'";
              $result= mysqli_query($conn, $select);
              if($result){
             alert("Your password has been changed successfully!");
              }
              else{
                 alert("Can not change!");
              }
           }
         }
         else if(strcmp($NewPass, $ConPass)!= 0){
            
             alert("The passwords does not match!");  
         }
     
         
} 
         
  ?>
<html>
<form action="forgotPass.php?Email=<?php echo $Email?>" method="POST">
  <label for="Npass">New password:</label><br>
  <input type="password" id="Npass" name="Npass" Required><br>
  <label for="Cpass">Confirm password:</label><br>
  <input type="password" id="Cpass" name="Cpass" Required>
    <input type="submit" value="Submit">
</form> 
    
    
</html>