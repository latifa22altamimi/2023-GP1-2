
<?php
  include 'connect.php';
       $id;
        $Email= $_POST['Email'];
         $Password= $_POST['Password'];
         //$Type=$_POST['Type'];
        
 
         
         $sql= "SELECT * FROM users WHERE Email='".$Email."'  AND status=1";
         $result= mysqli_query($conn, $sql);
         $count= mysqli_num_rows($result);
         
          if($count== 1){
          $pw;
          while($row = mysqli_fetch_assoc($result)) {
            $pw=$row['Password'];
         }
         if(password_verify($Password,$pw)){
          
          while($row = mysqli_fetch_assoc($result)) {
            $id=$row['ID'];
            
         }
            }}

?>
         
<html>
<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js'></script>


          <script> 
           $.ajax({url: "RList.php", data:{Userid:<?php echo $id; ?>}, success: function(result){

    }}); </script> 
</html>