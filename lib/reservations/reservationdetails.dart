import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/TrackTawafStatus/TrackTawaf.dart';
import 'package:rehaab/customization/clip.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/reservations/reservation_list.dart';
import 'package:rehaab/widgets/constants.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../main/home.dart';
import 'package:intl/intl.dart';

//import 'package:rehaab/callSupport/support.dart';

class ReservationDetails extends StatefulWidget {
  String? Rid;
  String? Status;
  String? date;
  String? time;

  ReservationDetails({this.Rid, this.Status, this.date , this.time});

/*Future Send(Rid) async{
var s = await http.post(Uri.parse("http://192.168.8.105/phpfiles/details.php"), body: json.encode({"rid": Rid}));
if(s.statusCode==200){

}
}*/
  @override
  State<ReservationDetails> createState() =>
      _ReservationDetailsState(Rid: Rid, Status: Status, date:date , time:time);
}

class _ReservationDetailsState extends State<ReservationDetails> {
  int ind=0;
  List list = [];
  String? Rid;
  String? Status;
  String? date;
  String? time;
  var datetime ;

  bool cancelIsVisible = false;

  _ReservationDetailsState({this.Rid, this.Status, this.date, this.time});

  Future GetData() async {
    var url = "http://10.0.2.2/phpfiles/details.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      
      setState(() {
        list.addAll(red);
      });
    }
    for (var i = 0; i < list.length; i++) {
      if (int.parse(list[i]["id"]) == int.parse(Rid!)) {
        
          ind = i;
        
      }
     
    }
  }

  @override
  void initState() {
    super.initState();
    GetData();
  }
  StartTawaf() async{
    var url = "http://10.0.2.2/phpfiles/startTawaf.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": Rid,
    });
    var respo = json.decode(res.body);
    print(respo);
    GlobalValues.Status="In-active";
  }
  remove() async {
    var url = "http://10.0.2.2/phpfiles/removeReserve.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": Rid,
    });
    var respo = json.decode(res.body);
    print(respo);
  }
  bool visibility() {
  datetime = date!+" "+time!.substring(0,5)+":00";
    if (Status =='Cancelled' ||  DateTime.now().isAfter(DateTime.parse(datetime!))|| Status=='In-active') {
      return false;
    } else{
      return true;
    }
  }
  bool visible(){
    if(Status=='In-active'){
      return true;

    }
    else{
      return false;
    }
  }
  bool start(){
      datetime = date!+" "+time!.substring(0,5)+":00";

    if(Status=="Confirmed" && DateFormat('yyyy-MM-dd').format(DateTime.now())==date){
      return true;
    }
    else{
      return false;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 60.0),
          child: BackButton(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100,
        flexibleSpace: ClipPath(
          clipper: AppbarClip(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 60, 100, 73),
                  Color.fromARGB(255, 104, 132, 113)
                ],
              ),
            ),
            child: Center(
              child: Text(
                'Reservation details',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
        body: Container(
          
          child: Column(children: [Container(alignment: Alignment.topCenter, //width: 350,height: 500,
        //  decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20)    ,color: Colors.white, border: Border.all(color: Colors.white)),
        child: TicketWidget(
          width: 350,
          height: 500,
          isCornerRounded: true,
          padding: EdgeInsets.all(20),
          child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(

              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Status== "Cancelled"?  Colors.red : Status=="Confirmed"?   Colors.green: Colors.yellow  ),
              ),
              child:  Center(
                
                child: Text(
                  '${Status}',// reservation status 
                  style: Status == "Cancelled"? TextStyle(color: Colors.red , fontWeight: FontWeight.bold):Status=="Confirmed"?  TextStyle(color: Colors.green , fontWeight: FontWeight.bold) : TextStyle(color: Colors.yellow , fontWeight: FontWeight.bold ),
                ),
              ),
            ),
            
           
          ],
        ),
        
        Padding(
          padding:  const EdgeInsets.only(top: 25.0),
          child: Column(
          
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
              //  decoration: BoxDecoration (border: Border.all(color: Status=='Confirmed'? Colors.green : Colors.red ), borderRadius: BorderRadius.circular(30.0), color: Colors.green.shade900),
                alignment: Alignment.topCenter,
               
                //margin: EdgeInsets.only(bottom: 20.0),
                
                //padding: EdgeInsets.only(top: 50),
                child: list.isEmpty? Text("") : QrImageView(
                        data:
                            "Date:${list[ind]["date"]}\nTime:${list[ind]["time"]}\nVehicle Type: ${list[ind]["VehicleType"]}\nDriving Type: ${list[ind]["drivingType"]}\n ${list[ind]["VehicleType"]=="Single"? "Driver gender:${list[ind]["driverGender"]}" : ""}\n Status: ${Status}",
                        size: 150,
                      )),
                        Container(
                padding: const EdgeInsets.only(top: 5),
                alignment: Alignment.topCenter,
                height: 40,
                child: const Text(
                  "Use this QR code at the pickup location to check in\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  ",
                  maxLines: 2,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )),

                Padding(padding: const EdgeInsets.only(top: 6, right: 52.0),
                child: list.isNotEmpty?    ticketDetailsWidget('Reservation no.', '#${list[ind]["id"]}', 'Vehicle type','${list[ind]["VehicleType"]}'):ticketDetailsWidget("", "", "", "") ,
                ),
             
              Padding(
                padding: const EdgeInsets.only(top: 6.0, right: 52.0),
                child: list.isNotEmpty?     ticketDetailsWidget('Date', '${list[ind]["date"]}', 'Driving type', '${list[ind]["drivingType"]}') : ticketDetailsWidget("", "", "", ""),

              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, right: 43.0),
                child:  list.isNotEmpty && list[ind]["VehicleType"] =="Double" ? ticketDetailsWidget('Time', '${list[ind]["time"]}','Driver gender', '${list[ind]["driverGender"]}'): list.isNotEmpty? ticketDetailsWidget('Time', '${list[ind]["time"]}   ', '', ''): ticketDetailsWidget('','','','') ,
                
              ),
            ],
          ),
        ),
       
        
      
      ],
    ),
        ),),
        Visibility(
                  visible: start(),
                  child: Container(

                    //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 200),
                   padding: EdgeInsets.only(right: 6 , top:25),
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 247, 247, 247),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset('assets/images/warn.json',
                                            width: 100, height: 100),
                                        Text(
                                          'Are you sure you want to start Tawaf?',
                                          style: TextStyle(
                                              color: Colors.black,

                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),textAlign: TextAlign.center,
                                        ),
                                        
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      height: 38, width: 100),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              width: 30.0,
                                            ),
                                            //when press on confirm

                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      height: 38, width: 100),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  StartTawaf();
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      Future.delayed(
                                                          Duration(seconds: 2),
                                                          () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      TrackTawaf()),
                                                        );
                                                      });
                                                      return Dialog(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                247, 247, 247),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Lottie.asset(
                                                                  'assets/images/success.json',
                                                                  width: 100,
                                                                  height: 100),
                                                              Text(
                                                                'Success',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Text(
                                                                'Starting Tawaf is done sucessfully',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  ConstrainedBox(
                                                                    constraints: BoxConstraints.tightFor(
                                                                        height:
                                                                            38,
                                                                        width:
                                                                            100),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  'Start',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 60, 100, 73),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: Text("Start Tawaf", style: TextStyle(fontSize: 17),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => Size(300, 50)),
                      ),
                    ),
                  ),
                ),
          Container (

                child: Column(
              children: [ Row(children: [Visibility(
                  visible: visibility(),
                  child: Container(
                   padding: EdgeInsets.only(left:55, right: 10, top:35),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 247, 247, 247),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset('assets/images/warn.json',
                                            width: 100, height: 100),
                                        Text(
                                          'Cancel reservation',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'Your reservation will be cancelled, and \nyour current time slot will be available to the public, but you can reserve again.',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 48, 48, 48),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      height: 38, width: 100),
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text(
                                                  'Close',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              width: 30.0,
                                            ),
                                            //when press on confirm

                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      height: 38, width: 100),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  remove();
                                                  cancelIsVisible = false;
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      Future.delayed(
                                                          Duration(seconds: 2),
                                                          () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      home()),
                                                        );
                                                      });
                                                      return Dialog(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                247, 247, 247),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Lottie.asset(
                                                                  'assets/images/success.json',
                                                                  width: 100,
                                                                  height: 100),
                                                              Text(
                                                                'Success',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Text(
                                                                'Cancellation is done successfully',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  ConstrainedBox(
                                                                    constraints: BoxConstraints.tightFor(
                                                                        height:
                                                                            38,
                                                                        width:
                                                                            100),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 60, 100, 73),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      label: Text("Cancel"),
                      icon: Icon(Icons.close),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.red),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => Size(150,40)),
                      ),
                    ),
                  ),
                ), Visibility(
                  visible: visibility(),
                  child: Container(

                    //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 200),
                   padding: EdgeInsets.only(right: 6 , top:35),
                    child: ElevatedButton.icon(
                      onPressed: () async {},
                      label: Text("Reschdule"),
                      icon: Icon(Icons.schedule),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color.fromARGB(255, 207, 202, 202)),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => Size(150, 40)),
                      ),
                    ),
                  ),
                ),],
                ) 
               
                //cancel button
                ,Row(children: [Visibility(
              visible: visible(),
              child:    Container ( padding: EdgeInsets.only(left:40, right: 10, top:35),    child:  ElevatedButton.icon(
                onPressed: () async { /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        callSupport()), //navigate to sign up page
              );*/},
                label: Text("Call for support"),
                icon: Icon(Icons.phone),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Color.fromARGB(255, 207, 202, 202)),
                  shape: MaterialStateProperty.resolveWith((states) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  fixedSize: MaterialStateProperty.resolveWith(
                      (states) => Size(  170,40 )),
                ),
              ),)
            ),
            Visibility(
                visible: visible(),
                child: Container(
                                     padding: EdgeInsets.only(right: 6 , top:35),

                 // padding: EdgeInsets.only(top: 8),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                backgroundColor:
                                    Color.fromARGB(255, 247, 247, 247),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset('assets/images/warn.json',
                                          width: 150, height: 120),
                                      Text(
                                        'Warning',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Do you want to check out?',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    height: 38, width: 100),
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 30.0,
                                          ),
                                          //when press on confirm

                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    height: 38, width: 100),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                //success msg here , insert in db --------------------------------------------
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 247, 247, 247),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Lottie.asset(
                                                              'assets/images/success.json',
                                                              width: 100,
                                                              height: 100),
                                                          Text(
                                                            'Success',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                            'the operation is done successfully',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ConstrainedBox(
                                                                constraints: BoxConstraints
                                                                    .tightFor(
                                                                        height:
                                                                            38,
                                                                        width:
                                                                            100),
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Done',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            50),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 60, 100, 73),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    },
                    label: Text("Check out"),
                    icon: Icon(Icons.check),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.red),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      fixedSize: MaterialStateProperty.resolveWith(
                          (states) => Size(150,40)),
                    ),
                  ),
                ))],)

                 
              ],
            ),
            
            
          )],)
          
      ),
          
          );
        
//padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 200),

        
  }

}
Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0,top: 6.0, ),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 0.0, top: 6.0),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
