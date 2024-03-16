<?php
include 'connect.php';



$sql = "SELECT TotalNumberofVehicles FROM parameters WHERE VehicleType = 'Single' AND VehicleDedicatedTo = 'walkIn'";
$result = mysqli_query($conn, $sql);
$row = mysqli_fetch_assoc($result);
$NumOfSAllowedVehicles = $row['TotalNumberofVehicles']; // Number of allowed vehicles of that type

$sql2 = "SELECT TotalNumberofVehicles FROM parameters WHERE VehicleType = 'Double' AND VehicleDedicatedTo = 'walkIn'";
$result2 = mysqli_query($conn, $sql2);
$row2 = mysqli_fetch_assoc($result2);
$NumOfDAllowedVehicles = $row2['TotalNumberofVehicles']; // Number of allowed vehicles of that type

$sql3 = "SELECT COUNT(*) AS count
        FROM reservation
        INNER JOIN managerreservation ON reservation.reservationId = managerreservation.reservationId
        INNER JOIN vehicle ON reservation.vehicleId = vehicle.vehicleId
        WHERE reservation.Status = 'Active' AND vehicle.VehicleType = 'Single'";

$sql4 = "SELECT COUNT(*) AS count
FROM reservation
INNER JOIN managerreservation ON reservation.reservationId = managerreservation.reservationId
INNER JOIN vehicle ON reservation.vehicleId = vehicle.vehicleId
WHERE reservation.Status = 'Active' AND vehicle.VehicleType = 'Double'";

$result3 = mysqli_query($conn, $sql3);
$result4 = mysqli_query($conn, $sql4);

if ($result3 && mysqli_num_rows($result3) > 0) {
    $rowSingle = mysqli_fetch_assoc($result3);
    $countSingle= $rowSingle['count'];
}

if ($result4 && mysqli_num_rows($result4) > 0) {
    $rowDouble = mysqli_fetch_assoc($result4);
    $countDouble= $rowDouble['count'];
}

$response = [];

if ($NumOfSAllowedVehicles != $countSingle) {
    $response[0]['Single'] = "AvailableType";
} else {
    $response[0]['Single'] = "UnavailableType";
}

if ($NumOfDAllowedVehicles != $countDouble) {
    $response[1]['Double'] = "AvailableType";
} else {
    $response[1]['Double'] = "UnavailableType";
}

echo json_encode($response);
?>