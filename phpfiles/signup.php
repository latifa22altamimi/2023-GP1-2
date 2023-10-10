<?php
    $db= mysqli_connect('localhost','root','','rehaab');
         if(!$db){
             echo "Database connection faild";
         }
        $FirstName= $_POST['FirstName'];
        $LastName=$_POST['LastName'];
         $Password= $_POST['Password'];
         $Email=$_POST['Email'];
         $hashPass=hash('sha256',$Password);
         
         $uppercase = preg_match('@[A-Z]@', $Password);
$lowercase = preg_match('@[a-z]@', $Password);
$number    = preg_match('@[0-9]@', $Password);
$specialChars = preg_match('@[^\w]@', $Password);
     
   
         $sql= "SELECT * FROM users WHERE Email='".$Email."'";
         $result= mysqli_query($db, $sql);
         $count= mysqli_num_rows($result);
         
         if($count== 1){
             echo json_encode("Error");
         }
         else if(empty($FirstName)|| empty($Password)|| empty($Email)|| empty($LastName)){
             echo json_encode("empty");
             }
         else if(!$uppercase || !$lowercase || !$number || !$specialChars || strlen($Password) < 8) {
             echo json_encode("invalidPass");
    }
         else if (!filter_var($Email, FILTER_VALIDATE_EMAIL)) {
             echo json_encode("invalidEmail");
} 
         else {
             $id;
             $insert= "INSERT INTO users(FirstName,LastName,Email,Password) VALUES('".$FirstName."','".$LastName."','".$Email."','".$hashPass."')";
             $query= mysqli_query($db, $insert);
             
  
             if($query){
                 $id = mysqli_insert_id($db);
                 echo json_encode("http://".$_SERVER['SERVER_NAME']."/phpfiles/verfiy.php?id=$id");
             }
         }

        