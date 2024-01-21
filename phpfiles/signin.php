<?php
  include 'connect.php';
  
  $Email = $_POST['Email'];
  $Password = $_POST['Password'];
  
  $stmt = $conn->prepare("SELECT * FROM users WHERE Email = ? AND VerificationStatus = 1");
  $stmt->bind_param("s", $Email);
  $stmt->execute();
  $result = $stmt->get_result();
  $count = $result->num_rows;
  

  $stmt1 = $conn->prepare("SELECT * FROM users WHERE Email = ? AND VerificationStatus = 0");
  $stmt1->bind_param("s", $Email);
  $stmt1->execute();
  $result1 = $stmt1->get_result();
  $count1 = $result1->num_rows;

  if (empty($Password) || empty($Email)) {
    echo json_encode("empty");
  }
  else if ($count == 1) {
    $row = $result->fetch_assoc();
    $pw = $row['Password'];
    $id = strval($row['userID']);
    $name = $row['FullName'];
    $type= $row['Type'];

    if (password_verify($Password, $pw)) {
      echo json_encode([0 => "Success", 1 => $id, 2 => $name, 3 => $type]);
    }
    else {
      echo json_encode("Fail");
    }
  }
  else if ($count1 == 1) {
    echo json_encode("notVerified");
  }
  else {
    echo json_encode("Fail");
  }
?>