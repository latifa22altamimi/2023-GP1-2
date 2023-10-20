<?php


include 'connect.php';
$date=$_POST['date'];

$sql = "SELECT * FROM vehicle";
$result = $conn->query($sql);
$OriginalTimeSlots=array();
$numOfvehicle=array();
 while($row = mysqli_fetch_assoc($result)){
     $OriginalTimeSlots[]=$row['time'];
     $numOfvehicle[$row['time']]=["double"=>$row['numberOfDoubleV'],"single"=>$row['numberOfSingleV']];
 }


 $ValueOfTimes=array();

foreach($OriginalTimeSlots as $times) {
    $sql2= "SELECT * from reservation WHERE date='$date' AND Status='Confirmed' AND time='$times'";
 $result2= $conn->query($sql2);
 $count= mysqli_num_rows($result2);
  if($count==$numOfvehicle[$times]['single']){  
$ValueOfTimes[]=["time"=>$times,"value"=>"False"];
}
  else{
    $ValueOfTimes[]=["time"=>$times,"value"=>"True"];
}
}

echo json_encode($ValueOfTimes);
 /*    $CurrentTimeSlots=array();
  $sql2= "SELECT * from reservation WHERE date=$date AND Status='Confirmed'";
  $result2= $conn->query($sql2);

  $count= mysqli_num_rows($result2);



if($count==$OriginalTimeSlots['numberOfSingleV']+$OriginalTimeSlots['numberOfDoubleV']){
    json_encode([0=>$OriginalTimeSlots,1=>"true"]);
}
else{
    json_encode([0=>$OriginalTimeSlots,1=>"true"]);
}

/*
  while($row2 = mysqli_fetch_assoc($result2)){
    $CurrentTimeSlots[]=$row2;
}

for ($i=0; $i<count($CurrentTimeSlots); $i++){
    $time= $CurrentTimeSlots[$i]['time'];
    $vehicleType= $CurrentTimeSlots[$i]['VehicleType'];
    
    for($j=0;$j<count($OriginalTimeSlots);$j++){

        if($OriginalTimeSlots[$j]['time']==$time){
               
            if($vehicleType='Single'){
                $numSingle= $OriginalTimeSlots[$j]['numberOfSingleV'];
                $OriginalTimeSlots[$j]['numberOfSingleV']= $numSingle-1;
            }else 
            if($vehicleType='Double'){
               $OriginalTimeSlots[$j]['numberOfDoubleV']= $OriginalTimeSlots[$j]['numberOfDoubleV']-1;
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

   */
  

