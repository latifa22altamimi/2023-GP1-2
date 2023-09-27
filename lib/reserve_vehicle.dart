import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'clip.dart';
import 'home.dart';

enum VehicleType { Single, Double }

enum DrivingType { SelfDriving, WithDriver }

enum DriverGender { Female, Male }

class ReserveVehicle extends StatefulWidget {
  const ReserveVehicle({super.key});

  @override
  State<ReserveVehicle> createState() => _ReserveVehicleState();
}

class _ReserveVehicleState extends State<ReserveVehicle> {
  VehicleType? _vehicleType;
  DrivingType? _drivingType;
  DriverGender? _driverGender;
  bool isVisibleGender = false;
  bool isVisibleDriving = false;
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
                            Radio<VehicleType>(
                              value: VehicleType.Single,
                              groupValue: _vehicleType,
                              onChanged: (value) {
                                // value is Single
                                setState(() {
                                  _vehicleType =
                                      value; //when I want to know which value user choosed use _vehicleType
                                  isVisibleDriving = true;
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                            ),
                            Text(
                              VehicleType.Single.name,
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
                            Radio<VehicleType>(
                              // put it inside sizedbox to solve the problem
                              value: VehicleType.Double,

                              groupValue: _vehicleType,
                              onChanged: (value) {
                                // value is Single
                                setState(() {
                                  _vehicleType =
                                      value; //when I want to know which value user choosed use _vehicleType
                                  isVisibleDriving = false;
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                            ),
                            Text(
                              VehicleType.Double.name,
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
                            Radio<DrivingType>(
                              value: DrivingType.SelfDriving,
                              groupValue: _drivingType,
                              onChanged: (value) {
                                // value is Single
                                setState(() {
                                  _drivingType =
                                      value; //when I want to know which value user choosed use _vehicleType
                                  isVisibleGender = false;
                                });
                              },
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                            ),
                            Text(
                              DrivingType.SelfDriving.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17),
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: !isVisibleDriving,
                        child: Container(
                          padding: const EdgeInsets.only(right: 25.0),
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
                              Radio<DrivingType>(
                                // put it inside sizedbox to solve the problem
                                value: DrivingType.WithDriver,

                                groupValue: _drivingType,
                                onChanged: (value) {
                                  // value is Single
                                  setState(() {
                                    _drivingType =
                                        value; //when I want to know which value user choosed use _vehicleType
                                    isVisibleGender = !isVisibleGender;
                                  });
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                              ),
                              Text(
                                DrivingType.WithDriver.name,
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
                              Radio<DriverGender>(
                                value: DriverGender.Female,
                                groupValue: _driverGender,
                                onChanged: (value) {
                                  // value is Single
                                  setState(() {
                                    _driverGender =
                                        value; //when I want to know which value user choosed use _vehicleType
                                  });
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                              ),
                              Text(
                                DriverGender.Female.name,
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
                              Radio<DriverGender>(
                                value: DriverGender.Male,
                                groupValue: _driverGender,
                                onChanged: (value) {
                                  // value is Single
                                  setState(() {
                                    _driverGender =
                                        value; //when I want to know which value user choosed use _vehicleType
                                  });
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                              ),
                              Text(
                                DriverGender.Male.name,
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
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 600,
                            child: ElevatedButton(
                              child: Text('back'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // reserve button
                Container(
                  padding: EdgeInsets.only(right: 5.0,top: 80.0,left: 5.0),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(height: 50, width: 500),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // mdre wsh faydtha
                          //form is valids

                          if (_vehicleType != null &&
                              _drivingType == DrivingType.SelfDriving) { //put or between them w admjehm
                            // && choosed time and date
                            print('Success 1'); //show dialog and insert in db
                          } else if (_vehicleType != null &&
                              _drivingType == DrivingType.WithDriver &&
                              _driverGender != null) {
                            // && choosed date and time

                            //confirm msg
                            print('Success 2');
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
                                        'Do you want to confirm the operation?',
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
                                                            'Reservation is done successfully',
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
                                                                  onPressed: (){
                                                                     Navigator.push(
                                                                      context,
                                                                       MaterialPageRoute(builder: (context) => const home()), //navigate to sign up page
                                                                      );

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
                              ),
                            );
                          } else {
                            //Error msg
                            print('error');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
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
