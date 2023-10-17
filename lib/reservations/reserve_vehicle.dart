mport 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/reservations/reservation_list.dart';
import '../customization/clip.dart';
import 'date.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/constants.dart';
import '../main/home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


String _driverGender = "";
String _vehicleType = "";
String _drivingType = "";
late final getDate;
late final getTime;
late Map<String, dynamic> time= {"time":"", "date":"" };
class ReserveVehicle extends StatefulWidget {
  const ReserveVehicle({super.key});

  @override
  State<ReserveVehicle> createState() => _ReserveVehicleState();
}

class _ReserveVehicleState extends State<ReserveVehicle> {
  bool isVisibleGender = false;
  bool isVisibleDriving = false;


    Future insert() async{
   var url = "http://10.0.2.2/phpfiles/reservation.php";
   final res= await http.post(Uri.parse(url),body:{
    "date":getDate, 
    "time":getTime,
    "VehicleType": _vehicleType,
    "DrivingType": _drivingType,
     "DriverGender": _driverGender});
     var resp= json.decode(res.body);
     print(resp);
     time = resp;

     }

     


  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(219, 69, 95, 77);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 244, 244),
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
                'Reserve vehicle',
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
        padding: const EdgeInsets.only(top: 1.0, left: 10.0, right: 30.0),
        margin: EdgeInsets.only(left: 30.0, top: 10.0),
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                //Type of vehicle

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Type of vehicle',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),

                // radio buttons
                Container(
                  child: Column(
                    children: [
                      // groupvalue unique among all radiobuttons
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4.0,
                              spreadRadius: .05,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "Single",
                              groupValue: _vehicleType,
                              onChanged: (value) {
                                // value is Single
                                setState(() {
                                  _vehicleType =
                                      "Single"; //when I want to know which value user choosed use _vehicleType
                                  isVisibleDriving = true;
                                  _drivingType = "Self-driving";
                                  isVisibleGender = false;
                                  _driverGender = "";
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                            ),
                            Text(
                              "Single",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                            SizedBox(
                              width: 96.0,
                            ),
                            Image.asset(
                              'assets/images/single.png',
                              height: 70,
                              width: 120,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4.0,
                              spreadRadius: .05,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              // put it inside sizedbox to solve the problem
                              value: "Double",

                              groupValue: _vehicleType,
                              onChanged: (value) {
                                // value is Single
                                setState(() {
                                  _vehicleType =
                                      "Double"; //when I want to know which value user choosed use _vehicleType
                                  isVisibleDriving = false;
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                            ),
                            Text(
                              "Double",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                            SizedBox(
                              width: 87.0,
                            ),
                            Image.asset(
                              'assets/images/double.png',
                              height: 70,
                              width: 120,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 30.0,
                ),

                //Driving type

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Driving type',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),

                // radio buttons
                Container(
                  child: Row(
                    children: [
                      // groupvalue unique among all radiobuttons
                      Container(
                        padding: const EdgeInsets.only(right: 25.0),
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4.0,
                              spreadRadius: .05,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "Self-driving",
                              groupValue: _drivingType,
                              onChanged: (value) {
                                // value is selfdriving
                                setState(() {
                                  _drivingType =
                                      "Self-driving"; //when I want to know which value user choosed use _vehicleType
                                  isVisibleGender = false;
                                  _driverGender = "";
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                            ),
                            Text(
                              "Self-driving",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: !isVisibleDriving,
                        child: Container(
                          padding: const EdgeInsets.only(right: 23.0),
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4.0,
                                spreadRadius: .05,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                // put it inside sizedbox to solve the problem
                                value: "With-driver",

                                groupValue: _drivingType,
                                onChanged: (value) {
                                  // value is Single
                                  setState(() {
                                    _drivingType =
                                        "With-driver"; //when I want to know which value user choosed use _vehicleType
                                    isVisibleGender = !isVisibleGender;
                                  });
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                              ),
                              Text(
                                "With-driver",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 30.0,
                ),

                //Driver gender

                Visibility(
                  visible: isVisibleGender,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Driver gender',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

                // radio buttons
                Visibility(
                  visible: isVisibleGender,
                  child: Container(
                    child: Row(
                      children: [
                        // groupvalue unique among all radiobuttons
                        Container(
                          padding: const EdgeInsets.only(right: 14.0),
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4.0,
                                spreadRadius: .05,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Female',
                                groupValue: _driverGender,
                                onChanged: (value) {
                                  // value is Single
                                  setState(() {
                                    _driverGender =
                                        'Female'; //when I want to know which value user choosed use _vehicleType
                                  });
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                              ),
                              Text(
                                'Female',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/images/female.png',
                                width: 20,
                                height: 20,
                              )
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.only(right: 32.0),
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4.0,
                                spreadRadius: .05,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: _driverGender,
                                onChanged: (value) {
                                  // value is Single
                                  setState(() {
                                    _driverGender =
                                        'Male'; //when I want to know which value user choosed use _vehicleType
                                  });
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                              ),
                              Text(
                                'Male',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Image.asset(
                                'assets/images/male.png',
                                width: 20,
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 30.0,
                ),

                // Date/Time

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Date/Time',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 1.0, right: 100.0),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Colors.black45,
                    ),
                    label: Text(
                      'View available dates/time',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      //show dates and time
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 600,
                            child: BookingPage(),
                          );
                        },
                      );
                    },
                  ),
                ),

                // reserve button
                Container(
                  padding: EdgeInsets.only(right: 5.0, top: 80.0, left: 5.0),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(height: 50, width: 500),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //form is valid

                          if ((_vehicleType != "" &&
                                  _drivingType == "Self-driving") ||
                              (_vehicleType != "" &&
                                      _drivingType == "With-driver" &&
                                      _driverGender != "" &&_BookingPageState._dateSelected 
                                      && _BookingPageState._timeSelected)) {
                            // complete with choose time and date

                            //confirm msg

                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor:
                                    Color.fromARGB(255, 247, 247, 247),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 30.0,
                                      bottom: 50.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset('assets/images/warn.json',
                                          width: 80, height: 80),
                                      Text(
                                        'Confirm the reservation',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Your reservation will be confirmed with the following information \n',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                        width: 350,
                                        height: 150,
                                        margin: const EdgeInsets.all(12),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 2.0,
                                              spreadRadius: .01,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Vehicle type: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '$_vehicleType',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Driving type: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '$_drivingType',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Visibility(
                                              visible: isVisibleGender,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Driver gender: ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '$_driverGender',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Date: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '$getDate',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Time: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '$getTime',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
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
                                              onPressed: () async{
                                                insert();
                                                //success msg here , insert in db --------------------------------------------

                                                _drivingType = "";
                                                _driverGender = "";
                                                _vehicleType = "";
                                               

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
                                                                'ٌReservation is done successfully',
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
                                                    });
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
                              ),
                            );
                          } else {
                            //Error msg

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Container(
                                  height: 80,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(221, 224, 41, 41),
                                          Color.fromARGB(255, 240, 50, 50),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4.0,
                                          spreadRadius: .05,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Error!',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "There is an empty field!",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Lottie.asset(
                                          'assets/images/erorrr.json',
                                          width: 150,
                                          height: 150,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Reserve',
                        style: TextStyle(fontSize: 23),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 60, 100, 73),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class BookingPage extends StatefulWidget {
  BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  //declaration
  CalendarFormat _format = CalendarFormat.week;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  // ignore: unused_field
  static bool _dateSelected = false;
  static bool _timeSelected = false;
  String? token;

  @override
  /*void initState() {
    super.initState();
    GetData();

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 244, 244),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Reservation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var timeSlots = solts();
                var now= DateTime.now();
print(timeSlots[index]);
var u = timeSlots;

                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _timeSelected = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.white
                            : Color.fromARGB(255, 33, 30, 30),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index
                          ? Color.fromARGB(255, 232, 231, 230)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${int.parse(u[index].substring(0, 2))}${u[index].substring(2)} ${int.parse(u[index].substring(0, 2)) > 11 ? "PM" : "AM"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: solts().length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: RoundedButton(
                text: 'Select',
                press: () async {
                  //convert date/day/time into string first
                  getDate = DateConverted.getDate(_currentDay);
                  //final getDay = DateConverted.getDay(_currentDay.weekday);
                  getTime = DateConverted.getTime(_currentIndex!);

                  Navigator.pop(context);

                  //if booking return status code 200, then redirect to success booking page
                },
                disable: _timeSelected ? false : true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //table calendar
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 90)),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 50,
      //startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week',
        CalendarFormat.twoWeeks: '2 weeks',
        CalendarFormat.month: 'Month'
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
SliverChildBuilderDelegate(
              (context, index) {
                var timeSlots = solts();
                
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _timeSelected = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.white
                            : Color.fromARGB(255, 33, 30, 30),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index
                          ? Color.fromARGB(255, 232, 231, 230)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${int.parse(timeSlots[index].substring(0, 2))}${timeSlots[index].substring(2)} ${int.parse(timeSlots[index].substring(0, 2)) > 11 ? "PM" : "AM"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: solts().length,
            );
          //check if weekend is selected
          /*if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }*/
        });
      }),
    );
  }
}
/*class BookingCalendarDemoApp extends StatefulWidget {
  const BookingCalendarDemoApp({Key? key}) : super(key: key);

  @override
  State<BookingCalendarDemoApp> createState() => _BookingCalendarDemoAppState();
}

class _BookingCalendarDemoAppState extends State<BookingCalendarDemoApp> {
  final now = DateTime.now();
  late BookingService mockBookingService;
  

  @override
  void initState() {
    super.initState();
    
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        serviceName: 'Vehicle',
        serviceDuration: 90,
        bookingEnd: DateTime(now.year, now.month, now.day, 23, 59),
        bookingStart: DateTime(now.year, now.month, now.day, 0, 0));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    getDate = DateConverted.getDate(newBooking.bookingStart);
    getTime= DateConverted.getTime(newBooking.bookingStart);
    

    Navigator.pop(context);
   
    /*converted.add(DateTimeRange(

        start: newBooking.bookingStart, end: newBooking.bookingEnd));*/
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    converted.add(DateTimeRange(start: now.subtract(Duration(hours: now.hour)), end: now));
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
     /* DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))*/
    ];
  }
  void time(Map<String,dynamic> time){
    String t =time["time"].toString();
    print(t);
    //converted.add(DateTimeRange(start: DateTime(), end: end));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
                backgroundColor: Color.fromARGB(255, 244, 244, 244),

          body: Center(
            child: BookingCalendar(
              bookingService: mockBookingService,
              convertStreamResultToDateTimeRanges: convertStreamResultMock,
              getBookingStream: getBookingStreamMock,
              uploadBooking: uploadBookingMock,
              pauseSlots: generatePauseSlots(),
              bookingButtonColor: kPrimaryColor,
              selectedSlotColor: Colors.lightGreen.shade100,
              pauseSlotText: 'LUNCH',
              hideBreakTime: true,
              bookedSlotColor: Colors.grey.shade300,
              availableSlotColor: Colors.white,

              //loadingWidget: const Text('Fetching data...'),
             uploadingWidget: const CircularProgressIndicator(),
              locale: 'en-US',
             //startingDayOfWeek: StartingDayOfWeek.tuesday,
              wholeDayIsBookedWidget:
                  const Text('Sorry, for this day everything is booked'),
              //disabledDates: [DateTime(2023, 1, 20)],
              //disabledDays: [6, 7],
            ),
          ),
        ));
  }
}*/

