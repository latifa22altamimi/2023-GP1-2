import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/GlobalValues.dart';
import '../customization/clip.dart';
import 'date.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/constants.dart';
import '../main/home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

String _driverGender = "";
String _vehicleType = "";
String _drivingType = "Double";
String getDate = "";
String getTime = "";
String label = "";
int duration=0;

Color labelColor = Colors.white;

class ReserveVehicle extends StatefulWidget {
  const ReserveVehicle({super.key});

  @override
  State<ReserveVehicle> createState() => _ReserveVehicleState();
}

class _ReserveVehicleState extends State<ReserveVehicle> {
  bool isVisibleGender = false;
  bool isVisibleDriving = false;

  Future insert() async {
    var url = "http://10.0.2.2/phpfiles/reservation.php";
    final res = await http.post(Uri.parse(url), body: {
      "id": GlobalValues.id,
      "visitorName": GlobalValues.Fullname,
      "Vnumber": "",
      "date": getDate,
      "time": getTime,
      "VehicleType": _vehicleType,
      "DrivingType": _drivingType,
      "DriverGender": _driverGender
    });
    var resp = json.decode(res.body);
    print(resp);
  }

  void initState() {
    setState(() {
      _vehicleType = "";
      _drivingType = "";
      getTime = "";
      _BookingPageState._timeSelected = false;
    });
    super.initState();
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
            color: kPrimaryColor,
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
                                  label = "Double vehicle available";
                                  labelColor = Color.fromRGBO(174, 193, 174, 1);
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
                                  label = "OnlySingle";
                                  labelColor =
                                      Color.fromARGB(255, 231, 229, 208);
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
                      if (_vehicleType != "") {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 650,
                              child: BookingPage(),
                            );
                          },
                        );
                      } else {
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
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
                                          "Choose type of vehicle",
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
                                  _drivingType == "Self-driving" &&
                                  _BookingPageState._timeSelected) ||
                              (_vehicleType != "" &&
                                  _drivingType == "With-driver" &&
                                  _driverGender != "" &&
                                  _BookingPageState._timeSelected)) {
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
                                            color:
                                                Color.fromARGB(255, 48, 48, 48),
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
                                              onPressed: () async {
                                                insert();
                                                //success msg here , insert in db --------------------------------------------

                                                _drivingType = "";
                                                _driverGender = "";
                                                _vehicleType = "";
                                                getTime = "";
                                                getDate = '';

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
                            String errorMsg = "";
                            if (!_BookingPageState._timeSelected) {
                              errorMsg = "Choose time";
                            }
                            if (_vehicleType == "") {
                              errorMsg = "Choose vehicle type";
                            }
                            if (_drivingType == "") {
                              errorMsg = "Choose driving type";
                            }
                            if (_vehicleType == "Double" &&
                                _drivingType == "") {
                              errorMsg = "Choose driving type";
                            }
                            if (_vehicleType == "" &&
                                _drivingType == "" &&
                                !_BookingPageState._timeSelected) {
                              errorMsg = "Empty fields";
                            }
                            if (_drivingType == "With-driver" &&
                                _driverGender == "") {
                              errorMsg = "Choose driving gender";
                            }

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
                                              "$errorMsg",
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
 

List<String> times=[];
int duration = 0; // Initialize duration
String timeSlotsString = ''; // Initialize timeSlotsString
List list = []; // Initialize list for time slots
List tlist = []; // Initialize filtered time slots list

@override
void initState() {
  super.initState();
  // Fetch the average duration asynchronously
  GetDuration();
}

Future<void> GetDuration() async {
  var url = "http://10.0.2.2/phpfiles/AvgDuration.php";
  final result = await http.get(Uri.parse(url));
  if (result.statusCode == 200) {
    String dur = json.decode(result.body);
    var Durations = dur.split(':');
    if (Durations[0] != "" && Durations[1] != "") {
      duration = int.parse(Durations[0]) * 60 + int.parse(Durations[1]);
      print(duration);
      times = slots(duration);
      timeSlotsString = times.join(',');
      GetData();
    }
  }
}

Future<void> GetData() async {
  var url = "http://10.0.2.2/phpfiles/times.php";
  final res = await http.post(Uri.parse(url), body: {
    "date": DateFormat('yyyy-MM-dd').format(_currentDay),
    "times": timeSlotsString, // Send the string representation of time slots
  });

  if (res.statusCode == 200) {
    var jsonResponse = json.decode(res.body);
      print(jsonResponse); // Print the jsonResponse to check its contents

    setState(() {
      list.addAll(jsonResponse);
      tlist.clear();

      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      String selectedDate = DateFormat('yyyy-MM-dd').format(_currentDay);

      // If the selected day (_currentDay) is today
      if (selectedDate == currentDate) {
        for (int i = 0; i < jsonResponse.length; i++) {
          String slot = jsonResponse[i]['time'];
          String hours = slot.substring(0, 2); // Extract hours from the time slot
          String minutes = slot.substring(3, 5); // Extract minutes from the time slot
          int slotMinutes = int.parse(minutes); // Convert minutes to integer

          String currentHours = currentTime.substring(0, 2); // Current hour
          String currentMinutes = currentTime.substring(3, 5); // Current minutes
          int currentSlotMinutes = int.parse(currentMinutes); // Convert current minutes to integer

          int slotHours = int.parse(hours); // Convert time slot hour to integer
          int currentHoursInt = int.parse(currentHours); // Convert current hour to integer

          // Compare current hour and minute with the time slot hour and minute
          if (currentHoursInt < slotHours ||
              (currentHoursInt == slotHours && currentSlotMinutes > slotMinutes)) {
            tlist.add(list[i]);
          }
        }
      } else {
        // If the selected day is not today, add all time slots to tlist
        tlist.addAll(list);
      }
    });
  }
}

List<String> slots(int duration) {
  DateTime now = DateTime.now();
  DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
  DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 0);

  String time;
  Duration step = Duration(minutes: duration);
  int count = 0;
  List<String> timeSlots = [];
  DateTime timeIncrement = startTime;
  time = "${DateFormat.Hm().format(timeIncrement)} ${timeIncrement.hour > 11 ? 'PM' : 'AM'}";
  timeSlots.add(time);
  while (startTime.isBefore(endTime)) {
    timeIncrement = startTime.add(step);
    if (count == 1440 ~/ duration) {
      break;
    } else {
      time = "${DateFormat.Hm().format(timeIncrement)} ${timeIncrement.hour > 11 ? 'PM' : 'AM'}";
      timeSlots.add(time);
      count++;
      startTime = timeIncrement;
    }
  }
  return timeSlots;
}



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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromARGB(255, 205, 204, 204)),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'No available vehicles',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          timeSlotsContainer(tlist),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: RoundedButton(
                text: 'Select',
                press: () async {
                  //convert date/day/time into string first
                  if (_timeSelected) {
                    getDate = DateConverted.getDate(_currentDay);
                    //final getDay = DateConverted.getDay(_currentDay.weekday);
                    getTime = tlist[_currentIndex!]['time'];
                    Navigator.pop(context);
                  } else {
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "Choose a time!",
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

          timeSlotsContainer(tlist);
          GetData();
        });
      }),
    );
  }

  Widget timeSlotsContainer(List timeSlots) {
  return SliverGrid(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
      var slot = timeSlots[index];

        return InkWell(
          splashColor: Color.fromARGB(0, 255, 255, 255),
          onTap: () {
            setState(() {
              if (slot["slotStatus"] == "Both") {
                _currentIndex = index;
                _timeSelected = true;
              }
              if (slot["slotStatus"] == "OnlySingle" &&
                  _vehicleType == "Single") {
                _currentIndex = index;
                _timeSelected = true;
              }
              if (slot["slotStatus"] == "OnlyDouble" &&
                  _vehicleType == "Double") {
                _currentIndex = index;
                _timeSelected = true;
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: _currentIndex == index
                    ? Color.fromARGB(255, 243, 239, 239)
                    : Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
              color: _currentIndex == index
                  ? kPrimaryColor
                  : slot["slotStatus"] == "Both"
                      ? Colors.white
                      : slot["slotStatus"] == "OnlySingle" &&
                              _vehicleType == "Double"
                          ? Color.fromARGB(255, 205, 204, 204)
                          : slot["slotStatus"] == "OnlyDouble" &&
                                  _vehicleType == "Single"
                              ? Color.fromARGB(255, 205, 204, 204)
                              : slot["slotStatus"] == "OnlyDouble" &&
                                      _vehicleType == "Double"
                                  ? Colors.white
                                  : slot["slotStatus"] ==
                                              "OnlySingle" &&
                                          _vehicleType == "Single"
                                      ? Colors.white
                                      : Color.fromARGB(255, 205, 204, 204),
            ),
            alignment: Alignment.center,
            child: Text(
              '${slot["time"]}', // Display the time
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _currentIndex == index ? Colors.white : null,
              ),
            ),
          ),
        );
      },
      childCount: timeSlots.length,
    ),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 1.5,
    ),
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

/*
class BookingPage extends StatefulWidget {
  BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final datePicker = Get.put(DatePicker2());
  
  final timeList=list;
  static  RxInt isSelect=0.obs;
   static RxString time="".obs;
 static TextEditingController date=TextEditingController();
   @override
  void initState() {
    super.initState();
    GetData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(children: [
        GestureDetector(
          onTap: ()=> datePicker.getDate(controller: date, c: context),
          child:  TextFormField(
            controller: date,
            enabled: false,
            decoration:const InputDecoration(
          hintText:" date",
            prefixIcon: const Icon(Icons.date_range_outlined),   
  ), 
          ),
        ),

        Expanded(child:
          ListView.builder(shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: timeList.length,itemBuilder: (context, index) {

            return GestureDetector(onTap: () {
              isSelect.value=index;
              time.value=timeList[index]["time"].toString();
            },
              child: Obx(()=>Container(//shape: ShapeBorder.lerp(Border(top: BorderSide), b, t) ,
              width: 10,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black) ,color:timeList[index]["numberOfSingleV"]!=0 || timeList[index]["numberOfDoubleV"]!=0?isSelect.value==index?Colors.limeAccent : Colors.white:   Colors.grey  ,),
                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4), child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                  child:Text(timeList[index]["time"].toString()),
                ),),
              ),
            );
          },),
        ),
         RoundedButton(text: 'Select', press: () {
          
         if(date.text.isNotEmpty){
         setState(() {
                getTime = timeList[isSelect.value]["time"].toString();
            getDate= date.text;
            });
            print(_vehicleType);

  if(_vehicleType == "Single"){   
          if(timeList[isSelect.value]["numberOfSingleV"]!=0){
            var data=timeList[isSelect.value];
            int newAvailable=(int.parse(data["numberOfSingleV"].toString()))-1;
            timeList.removeAt(isSelect.value);
            timeList.insert(isSelect.value,{ "id":int.parse(data["id"].toString()) ,"time":data["time"].toString(),"numberOfSingleV":newAvailable , "numberOfDoubleV": data["numberOfDoubleV"].toString() } );
            isSelect.value=0;
            // date.clear();
          }
          else{
            Fluttertoast.showToast(
        msg: "There is no single vehicles in chosen time",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
          }
          }
          if(_vehicleType == "Double") {
           if(timeList[isSelect.value]["numberOfDoubleV"]!=0){
            var data=timeList[isSelect.value];
            int newAvailable=(int.parse(data["numberOfDoubleV"].toString()))-1;
            
            timeList.removeAt(isSelect.value);
            timeList.insert(isSelect.value,{ "id":int.parse(data["id"].toString()) ,"time":data["time"].toString(),"numberOfDoubleV":newAvailable , "numberOfSingleV": data["numberOfSingleV"].toString() } );

          }
          else{
            Fluttertoast.showToast(
        msg: "There is no double vehicles in chosen time",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
          }
          
          }
          else{
            Fluttertoast.showToast(
        msg: "Reservation is full",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
          }
          } else{
           Fluttertoast.showToast(
        msg: "choose date",
                toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

          }
                Navigator.pop(context);
                           }),
        Spacer(),
        Spacer(),
      ],),
    );
  }
  
  Future GetData() async {
    var url = "http://10.0.2.2/phpfiles/times.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      setState(() {
        list.addAll(red);
      });
    }
    
      }
     
    }
  */
