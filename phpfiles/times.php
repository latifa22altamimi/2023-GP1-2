<?php


include 'connect.php';
$date=$_POST['date'];

$sql = "SELECT * FROM timeslots";
$result = $conn->query($sql);
$OriginalTimeSlots=array(); //time slots from database
 while($row = mysqli_fetch_assoc($result)){
     $OriginalTimeSlots[]=$row;
 }


      $CurrentTimeSlots=array();
  $sql2= "SELECT * from reservation WHERE date='$date' AND Status='Confirmed'";
  $result2= $conn->query($sql2);

  while($row2 = mysqli_fetch_assoc($result2)){
    $CurrentTimeSlots[]=$row2;
}

for ($i=0; $i<count($CurrentTimeSlots); $i++){
    $time= $CurrentTimeSlots[$i]['time'];
    $vehicleType= $CurrentTimeSlots[$i]['VehicleType'];
    
    for($j=0;$j<count($OriginalTimeSlots);$j++){

        if($OriginalTimeSlots[$j]['time']==$time){
               
            if($vehicleType=='Single'){
                $numSingle= $OriginalTimeSlots[$j]['numberOfSingleV'];
                $OriginalTimeSlots[$j]['numberOfSingleV']= $numSingle-1;
            }else 
            if($vehicleType=='Double'){
                $numDouble= $OriginalTimeSlots[$j]['numberOfDoubleV'];
               $OriginalTimeSlots[$j]['numberOfDoubleV']= $numDouble-1;
             
            }

            if($OriginalTimeSlots[$j]['numberOfSingleV']==0 && $OriginalTimeSlots[$j]['numberOfDoubleV']!=0){
                $OriginalTimeSlots[$j]['slotStatus']='OnlyDouble';
            }

            if($OriginalTimeSlots[$j]['numberOfDoubleV']==0 && $OriginalTimeSlots[$j]['numberOfSingleV']!=0){
                $OriginalTimeSlots[$j]['slotStatus']='OnlySingle';
            }

            if($OriginalTimeSlots[$j]['numberOfSingleV']==0 && $OriginalTimeSlots[$j]['numberOfDoubleV']==0){
                $OriginalTimeSlots[$j]['slotStatus']='Occupied';
            }

        }

    }
}

echo json_encode($OriginalTimeSlots);