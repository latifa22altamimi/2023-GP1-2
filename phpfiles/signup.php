<?php
   include 'connect.php';
   
   $FullName = $_POST['FullName'];
   $Password = $_POST['Password'];
   $ConfirmPass = $_POST['ConfirmPass'];
   $Email = $_POST['Email'];
   $hashPass = password_hash($Password, PASSWORD_DEFAULT);
   
   $uppercase = preg_match('@[A-Z]@', $Password);
   $lowercase = preg_match('@[a-z]@', $Password);
   $number = preg_match('@[0-9]@', $Password);
   $specialChars = preg_match('@[^\w]@', $Password);
   
   $stmt = $conn->prepare("SELECT * FROM users WHERE Email = ?");
   $stmt->bind_param("s", $Email);
   $stmt->execute();
   $result = $stmt->get_result();
   $count = $result->num_rows;
   
   if ($count == 1) {
      echo json_encode("Error");
   } elseif (empty($FullName) || empty($Password) || empty($Email) || empty($ConfirmPass)) {
      echo json_encode("empty");
   } elseif (!filter_var($Email, FILTER_VALIDATE_EMAIL)) {
      echo json_encode("invalidEmail");
   } elseif (!$uppercase || !$lowercase || !$number || !$specialChars || strlen($Password) < 8) {
      echo json_encode("invalidPass");
   } elseif (strcmp($Password, $ConfirmPass) != 0) {
      echo json_encode("PassDoesntMatch");
   } else {
      $stmt = $conn->prepare("INSERT INTO users (FullName, Email, Password) VALUES (?, ?, ?)");
      $stmt->bind_param("sss", $FullName, $Email, $hashPass);
      $stmt->execute();
      
      if ($stmt->affected_rows > 0) {
         $id = $stmt->insert_id;
         echo json_encode("http://".$_SERVER['SERVER_NAME']."/phpfiles/verfiy.php?id=$id");
      }
   }
?>