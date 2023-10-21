<?php

include 'connect.php';
 
        $id= $_GET['id'];
        $select= "UPDATE users SET status=1 WHERE id=$id";
        $result= mysqli_query($conn, $select);
        
        /*if($result){
            echo json_encode("Your Email has been verified successfully,you can sign in now!");
            
        }
        else{
        
            echo json_encode("Couldn't verify your email for some reason, Sorry.");
        } ?>*/ 
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
    width: 500px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 8px 16px rgba(0,0,0,0.3);

} 
.continer h1{
    text-align: center;
    padding:0 0 20px 0;
    color:#3C6348;
}  
.logo{
    width: 15%;
}  
.log{
    margin-top:15px;
  margin-left:180px;
  width: 20%;
}
</style> 
</head> 
<body>  
    <img Src="http://www.localhost/phpfiles/logo1.png"   class="logo" >

    <div class="continer">   
    <img Src="http://www.localhost/phpfiles/Confirmed.png"   class="log" >

    
        <?php 
        if($result)
        {
            echo "<h1>";
            echo json_encode( " Your Email has been verified successfully, you can sign in now! ");     
echo"</h1>";}
            else{
                echo "<h1>";
                echo json_encode("Couldn't verify your email for some reason, Sorry. "); 
                echo "</h1>";}
  ?>

</div>
</body>  
    
</html>