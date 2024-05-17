import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/CheckOut/CheckOut.dart';
import 'package:rehaab/customization/clip.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/widgets/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../main/home.dart';
import '../widgets/rounded_button.dart';
import 'package:rehaab/reservations/date.dart';
import 'package:intl/intl.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:progress_border/progress_border.dart';

String getUpdatedTime = "";
String getUpdatedDate = "";

class WalkIn_ReservationDetails extends StatefulWidget {
  String? Rid;
  String? Status;
  String? date;
  String? time;

  WalkIn_ReservationDetails({this.Rid, this.Status, this.date, this.time});

  @override
  State<WalkIn_ReservationDetails> createState() => _WalkIn_ReservationDetailsState(
      Rid: Rid, Status: Status, date: date, time: time);
}

int ind = 0;
List list = [];

var datetime;

class _WalkIn_ReservationDetailsState extends State<WalkIn_ReservationDetails>
    with SingleTickerProviderStateMixin {
  String? Rid;
  String? Status;
  String? date;
  String? time;
  bool cancelIsVisible = false;
  late final animationController = AnimationController(
    vsync: this,
    // this isthe duration of the progress
    duration: const Duration(seconds: 7),
  );

  _WalkIn_ReservationDetailsState({this.Rid, this.Status, this.date, this.time});

  Future GetData() async {
    var url = "http://10.0.2.2/phpfiles/walkInDetails.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      setState(() {
        list.addAll(red);
      });
    }
    for (var i = 0; i < list.length; i++) {
      if (int.parse(list[i]["reservationId"]) == int.parse(Rid!)) {
        ind = i;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    GetData();
    animationController.addListener(() {
      setState(() {});
    });

    restart();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void restart() {
    animationController.repeat();
  }

  StartTawaf() async {
    var url = "http://10.0.2.2/phpfiles/startTawaf.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": Rid,
    });
    var respo = json.decode(res.body);
    print(respo);
    GlobalValues.Status = "Active";
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
   // datetime = date! + " " + time!.substring(0, 5) + ":00";
    if (Status == 'Cancelled' ||

        Status == "Active" ||
        Status == "Completed") {
      return false;
    } else {
      return true;
    }
  }
      
// DateTime.now().isAfter(DateTime.parse(datetime!)) ||
  bool visible() {
    if (Status == 'Active') {
      return true;
    } else {
      return false;
    }
  }

  bool start() {
    datetime = date! + " " + time!.substring(0, 5) + ":00";
    final d= DateTime.parse(datetime).difference(DateTime.now());
      if(Status == "Confirmed" && d.inMinutes<=60 && d.inMinutes>=-15){  // "check in" button appears before 60 minutes of reservation time
      return true;
    } else {
      return false;
    }
  }
  

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 60.0),
          child: BackButton(
            color: Colors.white,
          ),
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
      body:Container( 
         padding: EdgeInsets.only(top:80),

        child: Center(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center, width: 350,height: 400,

            //decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20)    ,color: Colors.white, border: Border.all(color: Colors.white)),
            child: TicketWidget(
              width: 350,
              height: 380,
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
                          border: Border.all(
                              width: 1.0,
                              color: Status == "Cancelled"
                                  ? Colors.red
                                  : Status == "Confirmed"
                                      ? Colors.green
                                      : Status == "Completed"
                                          ? Color.fromRGBO(38, 161, 244, 1)
                                          : Color.fromRGBO(255, 196, 4, 1)),
                        ),
                        child: Center(
                          child: Text(
                            '${Status}', // reservation status
                            style: Status == "Cancelled"
                                ? TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)
                                : Status == "Confirmed"
                                    ? TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)
                                    : Status == "Completed"
                                        ? TextStyle(
                                            color:
                                                Color.fromRGBO(38, 161, 244, 1),
                                            fontWeight: FontWeight.bold)
                                        : TextStyle(
                                            color:
                                                Color.fromRGBO(255, 196, 4, 1),
                                            fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                           padding: EdgeInsets.only(top:15, bottom:20),
                            //  decoration: BoxDecoration (border: Border.all(color: Status=='Confirmed'? Colors.green : Colors.red ), borderRadius: BorderRadius.circular(30.0), color: Colors.green.shade900),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                             /* border: Status == "Active"
                                  ? ProgressBorder.all(
                                      color: Color.fromRGBO(255, 196, 4, 1),
                                      width: 5.5,
                                      progress: animationController.value,
                                      clockwise: true,
                                    )
                                  : null,*/
                            ),

                            //margin: EdgeInsets.only(bottom: 20.0),

                            //padding: EdgeInsets.only(top: 50),
                            child: list.isEmpty
                                ? Text("")
                                :Column(children: [       
                                  
                        
                        
                        Padding(
                          padding: const EdgeInsets.only( top:6, right: 52.0),
                          child: list.isNotEmpty
                              ? ticketDetailsWidget(
                                 'Reservation no.',
                                  '#${list[ind]["reservationId"]}',
                                  'Vistor name',
                                  '${list[ind]["visitorName"]}')
                              : ticketDetailsWidget("", "", "", ""),
                        ),
                         Padding(
                          padding: const EdgeInsets.only(right: 52.0),
                          child: list.isNotEmpty &&list[ind]["VphoneNumber"]!=""
                              ? ticketDetailsWidget(
                                 'Vistor number',
                                  '${list[ind]["VphoneNumber"]}',
                                  'Vehicle type',
                                  '${list[ind]["VehicleType"]}'
                                  ): list.isNotEmpty  ?
                                  ticketDetailsWidget(
                                  'Vehicle type',
                                  '${list[ind]["VehicleType"]}',
                                  '',
                                  '')
                              : ticketDetailsWidget("", "", "", ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, right: 52.0),
                          child: list.isNotEmpty
                              ? ticketDetailsWidget(
                                  'Date',
                                  '${list[ind]["date"]}',
                                  'Driving type',
                                  '${list[ind]["drivingType"]}')
                              : ticketDetailsWidget("", "", "", ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, right: 43.0),
                          child: list.isNotEmpty  && list[ind]["drivingType"]!="Self-driving"
                              ? ticketDetailsWidget(
                                  'Time',
                                  '${list[ind]["time"]}',
                                  'Driver gender',
                                  '${list[ind]["driverGender"]}')
                              : list.isNotEmpty
                                  ? ticketDetailsWidget(
                                      'Time', '${list[ind]["time"]}   ', '', '')
                                  : ticketDetailsWidget('', '', '', ''),
                        ), ],)
                        )  
                      ],
                    ),
                  ),
                ],
              
            ),
            ),
          ),
          
        ],
      ))),
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
        padding: const EdgeInsets.only(
          left: 20.0,
          top: 6.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey,fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black,fontSize: 16),
              ),
            )
          ],
        ),
      ),
      SizedBox(width: 20,),
      Padding(
        padding: const EdgeInsets.only(right: 0.0, top: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey,fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ],
        ),
      )
    ],
  );
}
Widget ticketDetailsWidgetC(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 0.0,
          top: 0.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 0.0, top: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black,fontSize: 18),
              ),
            )
          ],
        ),
      )
    ],
  );
}

class RescheduleBookingPage extends StatefulWidget {
  String? Rid;
  RescheduleBookingPage({this.Rid});

  @override
  State<RescheduleBookingPage> createState() =>
      _RescheduleBookingPage(Rid: Rid);
}

class _RescheduleBookingPage extends State<RescheduleBookingPage> {
  String? Rid;
  _RescheduleBookingPage({this.Rid});

  //declaration
  CalendarFormat _format = CalendarFormat.week;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  // ignore: unused_field
  static bool _dateSelected = false;
  static bool _timeSelected = false;
  List olist = [];
  List tlist = [];
  Future GetData() async {
    var url = "http://10.0.2.2/phpfiles/times.php";
    final res = await http.post(Uri.parse(url), body: {
      "date": DateConverted.getDate(_currentDay),
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      setState(() {
        olist.addAll(red);
        tlist.clear();

        String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
        String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
        String curr = DateConverted.getDate(_currentDay);
        String dateTime =
            DateFormat('yyyy-MM-dd ').format(DateTime.now()) + timeNow;

        if (curr == dateNow) {
          print(timeNow);
          for (int i = 0; i < red.length; i++) {
            print(olist[i]['time']);
            String dd = olist[i]['time'];
            String sub = dd.substring(0, 2);
            String f = dd.substring(3, 5);
            int k = int.parse(f);

            String dj = timeNow.substring(0, 2);
            String g = timeNow.substring(3, 5);
            int j = int.parse(g);

            int d = int.parse(sub);
            int l = int.parse(dj);

            if (l < d || (l == d && k > j)) {
              tlist.add(olist[i]);
            }
          }
        } else {
          tlist.addAll(red);
        }
        // tlist.addAll(red);
      });
    }
  }

  void initState() {
    super.initState();
    GetData();
  }

  reschedule() async {
    var url = "http://10.0.2.2/phpfiles/reschedule.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": Rid,
      "UpdatedTime": getUpdatedTime,
      "UpdatedDate": getUpdatedDate,
    });
    var respo = json.decode(res.body);
    print(respo);
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
          timeSlotsContainer(),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: RoundedButton(
                text: 'Select',
                press: () async {
                  //convert date/day/time into string first
                  if (_timeSelected) {
                    getUpdatedDate = DateConverted.getDate(_currentDay);
                    //final getDay = DateConverted.getDay(_currentDay.weekday);
                    getUpdatedTime = tlist[_currentIndex!]['time'];
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset('assets/images/warn.json',
                                        width: 100, height: 100),
                                    Text(
                                      'Reschedule reservation',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'Your reservation will be rescheduled to:',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 48, 48, 48),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Container(
                                      width: 350,
                                      height: 70,
                                      margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
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
                                                'Date: ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '$getUpdatedDate',
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
                                                '$getUpdatedTime',
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
                                      height: 18.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              height: 38, width: 100),
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
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
                                          constraints: BoxConstraints.tightFor(
                                              height: 38, width: 118),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              reschedule();

                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  Future.delayed(
                                                      Duration(seconds: 2), () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              home()),
                                                    );
                                                  });
                                                  return Dialog(
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
                                                            'Reschedulling is done successfully',
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
                                              'Reschedule',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 60, 100, 73),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
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
                                  ErrorColor,
                                  Color.fromARGB(255, 237, 66, 66),
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

          timeSlotsContainer();
          GetData();
        });
      }),
    );
  }

  Widget timeSlotsContainer() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var timeSlots = tlist;

          print(timeSlots);
          return InkWell(
            splashColor: Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                if (timeSlots[index]["slotStatus"] == "Both") {
                  _currentIndex = index;
                  _timeSelected = true;
                }
                if (timeSlots[index]["slotStatus"] == "OnlySingle" &&
                    list[ind]["VehicleType"] == "Single") {
                  _currentIndex = index;
                  _timeSelected = true;
                }
                if (timeSlots[index]["slotStatus"] == "OnlyDouble" &&
                    list[ind]["VehicleType"] == "Double") {
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
                    : timeSlots[index]["slotStatus"] == "Both"
                        ? Colors.white
                        : timeSlots[index]["slotStatus"] == "OnlySingle" &&
                                list[ind]["VehicleType"] == "Double"
                            ? Color.fromARGB(255, 205, 204, 204)
                            : timeSlots[index]["slotStatus"] == "OnlyDouble" &&
                                    list[ind]["VehicleType"] == "Single"
                                ? Color.fromARGB(255, 205, 204, 204)
                                : timeSlots[index]["slotStatus"] ==
                                            "OnlyDouble" &&
                                        list[ind]["VehicleType"] == "Double"
                                    ? Colors.white
                                    : timeSlots[index]["slotStatus"] ==
                                                "OnlySingle" &&
                                            list[ind]["VehicleType"] == "Single"
                                        ? Colors.white
                                        : Color.fromARGB(255, 205, 204, 204),
              ),
              alignment: Alignment.center,
              child: Text(
                '${timeSlots[index]["time"]}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _currentIndex == index ? Colors.white : null,
                ),
              ),
            ),
          );
        },
        childCount: tlist.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, childAspectRatio: 1.5),
    );
  }
}
