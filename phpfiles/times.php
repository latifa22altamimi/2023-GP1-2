<?php
include 'connect.php';

$date = $_POST['date'];
$OriginalTimeSlots = [];
$timeSlotsString = $_POST['times'];
$OriginalTimeSlots = explode(',', $timeSlotsString);



$sqlSingle = "SELECT TotalNumberofVehicles FROM parameters WHERE VehicleType='Single' AND VehicleDedicatedTo='visitor'";
$resultSingle = mysqli_query($conn, $sqlSingle);
$rowSingle = mysqli_fetch_assoc($resultSingle);
$numSingle = $rowSingle['TotalNumberofVehicles'];

$sqlDouble = "SELECT TotalNumberofVehicles FROM parameters WHERE VehicleType='Double' AND VehicleDedicatedTo='visitor'";
$resultDouble = mysqli_query($conn, $sqlDouble);
$rowDouble = mysqli_fetch_assoc($resultDouble);
$numDouble = $rowDouble['TotalNumberofVehicles'];


$ModifiedTimes = [];

foreach ($OriginalTimeSlots as $timeSlot) {
    // Trim any whitespace from the time slot

    if (!empty($timeSlot)) {
        // Only process non-empty time slots
        $ModifiedTimes[] = [ 
            'time' => $timeSlot, // Assign the original time slot
            'numberOfSingleV' => $numSingle,
            'numberOfDoubleV' => $numDouble,
            'slotStatus' => 'Both' // Default slotStatus
        ];
    }
}



$CurrentTimeSlots = array();
$sql2 = "SELECT r.*, v.VehicleType
         FROM reservation r
         JOIN vehicle v ON r.VehicleId = v.vehicleId
         WHERE r.date='$date' AND r.Status='Confirmed'";
$result2 = $conn->query($sql2);

while ($row2 = mysqli_fetch_assoc($result2)) {
    $time = $row2['time']; // Access time value
    $vehicleType = $row2['VehicleType'];

    foreach ($ModifiedTimes as &$modifiedTime) {

        if ($modifiedTime['time'] == $time) {

            if ($vehicleType == 'Single') {
                $numS=$modifiedTime['numberOfSingleV'];
                $modifiedTime['numberOfSingleV']= $numS-1;
            } elseif ($vehicleType == 'Double') {
                $numD =$modifiedTime['numberOfDoubleV'];
                $modifiedTime['numberOfDoubleV']=$numD-1;
            }

            if ($modifiedTime['numberOfSingleV'] == 0 && $modifiedTime['numberOfDoubleV'] != 0) {
                $modifiedTime['slotStatus'] = 'OnlyDouble';
            } elseif ($modifiedTime['numberOfDoubleV'] == 0 && $modifiedTime['numberOfSingleV'] != 0) {
                $modifiedTime['slotStatus'] = 'OnlySingle';
            } elseif ($modifiedTime['numberOfSingleV'] == 0 && $modifiedTime['numberOfDoubleV'] == 0) {
                $modifiedTime['slotStatus'] = 'Occupied';
            }
        }
    }
}

echo json_encode($ModifiedTimes);
?>
