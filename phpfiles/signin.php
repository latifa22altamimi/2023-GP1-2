<?php
    $db= mysqli_connect('localhost','root','','rehaab');
         if(!$db){
             echo "Database connection faild";
         }
       $id;
        $Email= $_POST['Email'];
         $Password= $_POST['Password'];
         //$Type=$_POST['Type'];
        
     
     
         
         $sql= "SELECT * FROM users WHERE Email='".$Email."' AND Password='".$Password."' AND status=1";
         $result= mysqli_query($db, $sql);
         $count= mysqli_num_rows($result);
         
         
         $sql1= "SELECT * FROM users WHERE Email='".$Email."' AND Password='".$Password."' AND status=0";
         $result1= mysqli_query($db, $sql1);
         $count1= mysqli_num_rows($result1);
         
         if($count== 1){
          
            while($row = mysqli_fetch_assoc($result)) {
                $id=$row['ID'];
             }
             
             

             $data=array();
             $data[0]="Success";
             $data[1]="<html>  <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js'></script>
             <script>    $.get('RList.php', {Userid:$id}); </script></html>";
             echo json_encode($data);
            
             
         }
           else if(empty($Password)|| empty($Email)){
             echo json_encode("empty");
             }
             
             else if($count1==1){
              echo json_encode("notVerfied");   
             }
         else{
           echo json_encode("Fail");  
         }


    
?>
         
             