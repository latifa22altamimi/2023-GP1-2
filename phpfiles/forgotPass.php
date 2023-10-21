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
  <head>  
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset password</title> 
  <style> 

body{ 
margin:0;
padding: 0;
font-family: sans-serif;
background: linear-gradient(120deg,#3C6348,#a4c8ae);
height: 100vh;
overflow: hidden;

} 
.continer{
    position: absolute;
    top:50%;
    left:50%;
    transform: translate(-50%,-50%);
    width: 400px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 8px 16px rgba(0,0,0,0.3);

} 
.continer h1{
    text-align: center;
    padding:0 0 20px 0;
    color:#3C6348;
} 
.continer form{
    padding: 0 40px;
    box-sizing: border-box;
} 
form .f1{
    position: relative;
    border-bottom: 2px solid #adadad;
    margin: 30px 0;
}
.f1 input{
 width: 100%;
 padding: 0 5px;  
  height: 40px; 
  font-size: 16px;
  border: none;
  background: none;
  outline: none;
}
.f1 label{
    position: absolute;
    top:50%;
    left:5px;
    color:#adadad;
    transform: translateY(-50%);
    font-size: 16px;
    pointer-events: none;
    transition: 0.5s;
 
}
.f1 span::before{
    content: '';
    position: absolute;
    top: 40px;
    left: 0;
    width: 100%;
    height: 2px;
    background:#a4c8ae ;
} 
.f1 input:focus ~label,.f1 input:valid ~label{
    top: -5px; 
    color:#a4c8ae ;

} 
.f1 input:focus ~ span::before,.f1 input:valid ~ span::before{
  width:100%;
}
.continer form .btn{
  margin-left:30%;
  transform:translateX(-50%);
  width: 120px;
  height: 34px;
  border: none;
  outline:none;
  background:#3C6348;
  cursor:pointer;
  text-transform:uppercase;
   color: white;
   border-radius:25px;
   transition:.3s;

}
.continer form .btn:hover{
  opacity:0.7;
} 
.logo{
    width: 15%;
} 
.log{
  margin-top:15px;
  margin-left:150px;
  width: 20%;
}

  </style>
</head> 
<body>  
    <img Src="http://www.localhost/phpfiles/logo1.png"   class="logo" >

    <div class="continer">   
    <img Src="https://cdn-icons-png.flaticon.com/512/6146/6146587.png"   class="log" >
      
      <h1>Reset Password <h1>
<form  action="forgotPass.php?Email=<?php echo $Email?>" method="POST"> 
    <div class="f1"> 
        <input type="password" id="Npass" name="Npass" Required> 

  <span></span>
  <label for="Npass">New password:</label><br> 

</div> 
<div class="f1"> 
    <input type="password" id="Cpass" name="Cpass" Required> 

  <span></span>
  <label for="Cpass">Confirm password:</label><br> 
</div>
    <input type="submit" value="Submit" class="btn">
</form>   

</div>
</body>  
    
</html>