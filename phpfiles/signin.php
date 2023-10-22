<?php
  include 'connect.php';
       $id;
        $Email= $_POST['Email'];
         $Password= $_POST['Password'];
        
     
     
         
         $sql= "SELECT * FROM users WHERE Email='".$Email."'  AND status=1";
         $result= mysqli_query($conn, $sql);
         $count= mysqli_num_rows($result);
         
         
         $sql1= "SELECT * FROM users WHERE Email='".$Email."' AND status=0";
         $result1= mysqli_query($conn, $sql1);
         $count1= mysqli_num_rows($result1);


         if(empty($Password)|| empty($Email)){
          echo json_encode("empty");
          }
         else if($count== 1){
          $pw;
          $id;
          $name;
          $Lname;
          while($row = mysqli_fetch_assoc($result)) {
            $pw=$row['Password'];
            $id=$row['ID'];
            $name=$row['FirstName'];
            $Lname=$row['LastName'];
         }
         $id=strval($id);

         if(password_verify($Password,$pw)){
          echo json_encode([0=>"Success",1=>$id,2=>$name,3=>$Lname]); 


          
         
            }  
            else{
              echo json_encode("Fail");
            }
         }
       else if($count1==1){
              echo json_encode("notVerfied");   
             }
         else{
           echo json_encode("Fail");  
         }


    
?>
         
             