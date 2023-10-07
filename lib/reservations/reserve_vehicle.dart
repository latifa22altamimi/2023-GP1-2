import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/reservations/reservation_list.dart';
import '../customization/clip.dart';
import 'date.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/constants.dart';
import '../main/home.dart';





enum VehicleType { Single, Double }

enum DrivingType { SelfDriving, WithDriver }

String _driverGender = "";


class ReserveVehicle extends StatefulWidget {
  const ReserveVehicle({super.key});

  @override
  State<ReserveVehicle> createState() => _ReserveVehicleState();
}

class _ReserveVehicleState extends State<ReserveVehicle> {
 static VehicleType? _vehicleType;
static DrivingType? _drivingType;
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
                               Radio<String>(
                                value: 'Female',
                                groupValue: _driverGender,
                                onChanged: (value) {
                                  // value is Single
                                  setState(() {
                                    _driverGender =
                                           'Female';//when I want to know which value user choosed use _vehicleType
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
                                       'Male';  //when I want to know which value user choosed use _vehicleType
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

                          if ((_vehicleType != null &&
                                  _drivingType == DrivingType.SelfDriving) ||
                              (_vehicleType != null &&
                                  _drivingType == DrivingType.WithDriver &&
                                  _driverGender != "") && _BookingPageState._dateSelected &&_BookingPageState._timeSelected) {
                            // complete with choose time and dat

                            //confirm msg
                           
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
                                        'Confirmation',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Are you sure you want to confirm the reservation?',
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
                                                                  onPressed: //when press on done
                                                                      () {
                                                                    if (_driverGender !=
                                                                          "") {



                                                                      Navigator.push(
                                                                        context,
                                                                              MaterialPageRoute(builder: ((context) =>  home(driverG : _driverGender))));
                                                                     // var: val passed

                                                                      }},
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
 late final getDate;
 late final getTime;
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
  static  bool _timeSelected = false;
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
                            '${int.parse(timeSlots[index].substring(0,2))}${timeSlots[index].substring(2)} ${int.parse(timeSlots[index].substring(0,2))>11 ? "PM" : "AM"}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _currentIndex == index ? Colors.white : null,
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
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week' , CalendarFormat.twoWeeks: '2 weeks', CalendarFormat.month: 'Month'
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
    );}
    
  


    
}

