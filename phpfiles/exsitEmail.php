<?php
  include 'connect.php';
  $Email = $_POST['Email'];
  
  $stmt = $conn->prepare("SELECT * FROM users WHERE Email = ? AND VerificationStatus = 1");
  $stmt->bind_param("s", $Email);
  $stmt->execute();
  $result = $stmt->get_result();
  $count = $result->num_rows;
  
  if ($count == 1) {
    echo json_encode("http://".$_SERVER['SERVER_NAME']."/phpfiles/forgotPass.php?Email=$Email");
  } elseif (empty($Email)) {
    echo json_encode("empty");
  } else {
    echo json_encode("Fail");
  }
?>