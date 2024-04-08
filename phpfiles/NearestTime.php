<?php
include 'connect.php';
// Get the VehicleType value from the request
$vehicleType = $_POST['VehicleType'];

// Query to find nearest time for reservations
$query = "
  SELECT reservation.reservationId, MIN(managerreservation.ExpectedFinishTime) AS nearestTime
  FROM reservation
  LEFT JOIN managerreservation ON reservation.reservationId = managerreservation.reservationId
  WHERE (
      (reservation.Status = 'Active' AND managerreservation.ReservedForWaiting = 0)
      OR (reservation.Status = 'Waiting' AND managerreservation.ReservedForWaiting = 0)
    )
    AND reservation.VehicleId IN (
      SELECT VehicleId
      FROM vehicle
      WHERE VehicleType = '$vehicleType'
    )
  GROUP BY reservation.reservationId
  ORDER BY nearestTime ASC
  LIMIT 1
";

$result = mysqli_query($conn, $query);

if ($result) {
  $response = array();

  if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $nearestTime = $row['nearestTime'];
    $reservationId = $row['reservationId'];

    $response['success'] = true;
    $response['nearestTime'] = $nearestTime;
    $response['reservationId'] = $reservationId;
  } else {
    $response['success'] = false;
    $response['message'] = 'No times found.';
  }

  echo json_encode($response);
} else {
  $response['success'] = false;
  $response['message'] = 'Failed to retrieve data.';
  echo json_encode($response);
}

// Close the database connection
mysqli_close($conn);
?>