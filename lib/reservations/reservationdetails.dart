import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/CheckOut/CheckOut.dart';
import 'package:rehaab/customization/clip.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/widgets/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../main/home.dart';
import '../widgets/rounded_button.dart';
import 'date.dart';
import 'package:intl/intl.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:progress_border/progress_border.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:async';

String getUpdatedTime = "";
String getUpdatedDate = "";

class ReservationDetails extends StatefulWidget {
  String? Rid;
  String? Status;
  String? date;
  String? time;

  ReservationDetails({this.Rid, this.Status, this.date, this.time});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState(
      Rid: Rid, Status: Status, date: date, time: time);
}

int ind = 0;
List list = [];
String CancelDur = "";
int CancelDurInt = 0;

var datetime;

class _ReservationDetailsState extends State<ReservationDetails>
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
  _ReservationDetailsState({this.Rid, this.Status, this.date, this.time});
  String encryptIt(String text) {
    final key = enc.Key.fromUtf8("3159a027584ad57a42c03d5dab118f68");
    final iv = enc.IV.fromUtf8("e0c2ed4fbc3e1fb6");
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

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
      if (int.parse(list[i]["reservationId"]) == int.parse(Rid!)) {
        ind = i;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    GetData();
    //GetCancelDur();
    _startCallFunction(); ////////////function that calls _checkout every 1 s till the page disposed
    animationController.addListener(() {
      setState(() {});
    });
    if (list.isNotEmpty) {
      GlobalValues.Status = list[ind]["Status"];
    }

    restart();
  }

  Timer? _timer;
  void _startCallFunction() {
    _Checkout();

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _Checkout();
    });
  }

  void _Checkout() {
    if (GlobalValues.Status == "Active") {
      CheckOutState().Checkoutt();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
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

  Future GetCancelDur() async {
    var url = "http://10.0.2.2/phpfiles/CancelDur.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      CancelDur = json.decode(res.body);

      setState(() {
        var index = CancelDur.indexOf("h");
        CancelDur = CancelDur.substring(0, index);
        print(CancelDur);
        CancelDurInt = int.parse(CancelDur);
        CancelDurInt = CancelDurInt * 60; // convert to minutes
      });
    }
  }

  bool visibility() {
    datetime = date! + " " + time!.substring(0, 5) + ":00";
    final duration = DateTime.parse(datetime).difference(DateTime.now());
    if (Status == 'Cancelled' ||
        duration.inMinutes <= 1440 ||
        Status == "Active" ||
        Status == "Completed") {
      return false;
    } else {
      return true;
    }
  }

  bool start() {
    datetime = date! + " " + time!.substring(0, 5) + ":00";
    final d = DateTime.parse(datetime).difference(DateTime.now());
    if (Status == "Confirmed" && d.inMinutes <= 60 && d.inMinutes >= -15) {
      // "check in" button appears before 60 minutes of reservation time
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
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter, //width: 350,height: 500,
            //  decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20)    ,color: Colors.white, border: Border.all(color: Colors.white)),
            child: TicketWidget(
              width: 350,
              height: 480,
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
                                ? GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)
                                : Status == "Confirmed"
                                    ? GoogleFonts.poppins(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)
                                    : Status == "Completed"
                                        ? GoogleFonts.poppins(
                                            color:
                                                Color.fromRGBO(38, 161, 244, 1),
                                            fontWeight: FontWeight.bold)
                                        : GoogleFonts.poppins(
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
                            width: 150,
                            height: 150,
                            //  decoration: BoxDecoration (border: Border.all(color: Status=='Confirmed'? Colors.green : Colors.red ), borderRadius: BorderRadius.circular(30.0), color: Colors.green.shade900),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Status == "Active"
                                  ? ProgressBorder.all(
                                      color: Color.fromRGBO(255, 196, 4, 1),
                                      width: 5.5,
                                      progress: animationController.value,
                                      clockwise: true,
                                    )
                                  : null,
                            ),
                            child: list.isEmpty
                                ? Text("")
                                : QrImageView(
                                    data: encryptIt(list[ind]["reservationId"]),
                                    size: 150,
                                  )),
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            alignment: Alignment.topCenter,
                            height: 40,
                            child: Text(
                              "Use this QR code at the pickup location to check in\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  ",
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 11),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 52.0),
                          child: list.isNotEmpty
                              ? ticketDetailsWidget(
                                  'Reservation no.',
                                  '#${list[ind]["reservationId"]}',
                                  'Vehicle type',
                                  '${list[ind]["VehicleType"]}')
                              : ticketDetailsWidget("", "", "", ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, right: 52.0),
                          child: list.isNotEmpty
                              ? ticketDetailsWidget(
                                  'Date',
                                  '${list[ind]["date"]}',
                                  'Driving type',
                                  '${list[ind]["drivingType"]}')
                              : ticketDetailsWidget("", "", "", ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, right: 43.0),
                          child: list.isNotEmpty &&
                                  list[ind]["drivingType"] != "Self-driving"
                              ? ticketDetailsWidget(
                                  'Time',
                                  '${list[ind]["time"]}',
                                  'Driver gender',
                                  '${list[ind]["driverGender"]}')
                              : list.isNotEmpty
                                  ? ticketDetailsWidget(
                                      'Time', '${list[ind]["time"]}   ', '', '')
                                  : ticketDetailsWidget('', '', '', ''),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                /* Visibility(
                  visible: start(),
                  child: Container(
                    //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 200),
                    padding: EdgeInsets.only(right: 6, top: 15),
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
                                          'Start Tawaf',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
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
                                                  style: GoogleFonts.poppins(
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
                                                  CheckOutState().Checkoutt();
                                                  setState(() {
                                                    GlobalValues.Status =
                                                        "Active";
                                                    GlobalValues.Rid = Rid!;
                                                  });
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
                                                                style: GoogleFonts.poppins(
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
                                                                'Starting Tawaf is done successfully',
                                                                style: GoogleFonts.poppins(
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
                                                  style: GoogleFonts.poppins(
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
                      child: Text(
                        "Check in",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ), //vehicle manager checks in (temp for testing)
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => Size(300, 45)),
                      ),
                    ),
                  ),
                ),*/

                //Reschedule
                Visibility(
                  visible: visibility(),
                  child: Container(
                    padding: EdgeInsets.only(right: 5.0, top: 15, left: 5.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 650,
                              child: RescheduleBookingPage(Rid: Rid),
                            );
                          },
                        );
                      },
                      label: Text(
                        "Reschdule",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      icon: Icon(Icons.schedule, color: Colors.white),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => Size(300, 45)),
                      ),
                    ),
                  ),
                ),
                //cancel feature
                Visibility(
                  visible: visibility(),
                  child: Container(
                    padding: EdgeInsets.only(right: 5.0, top: 15, left: 5.0),
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
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset('assets/images/warn.json',
                                            width: 100, height: 100),
                                        Text(
                                          'Cancel reservation',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'Your reservation will be cancelled, and \nyour current time slot will be available to the public, but you can reserve again.',
                                          style: GoogleFonts.poppins(
                                              color: Color.fromARGB(
                                                  255, 48, 48, 48),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
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
                                                  style: GoogleFonts.poppins(
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
                                                      height: 38, width: 109),
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
                                                                style: GoogleFonts.poppins(
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
                                                                style: GoogleFonts.poppins(
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
                                                  'Cancel reservation',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
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
                      label: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      icon: Icon(Icons.close, color: Colors.white),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => ErrorColor),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => Size(300, 45)),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: true,
                  child: ElevatedButton.icon(
                    onPressed: () async {},
                    label: Text("Call support"),
                    icon: Icon(Icons.phone),
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
                Offstage(
                    offstage: true,
                    child: Container(
                      // padding: EdgeInsets.only(top: 8),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 247, 247, 247),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(
                                              'assets/images/warn.json',
                                              width: 150,
                                              height: 120),
                                          Text(
                                            'Warning',
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            'Do you want to check out?',
                                            style: GoogleFonts.poppins(
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
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text(
                                                    'Close',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 255, 255),
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                      builder: (context) =>
                                                          Dialog(
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
                                                                style: GoogleFonts.poppins(
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
                                                                'the operation is done successfully',
                                                                style: GoogleFonts.poppins(
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
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Done',
                                                                        style: GoogleFonts.poppins(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(50),
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
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 60, 100, 73),
                                                    shape:
                                                        RoundedRectangleBorder(
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
                              (states) => Size(150, 40)),
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      )),
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
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: GoogleFonts.poppins(color: Colors.black),
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
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: GoogleFonts.poppins(color: Colors.black),
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
  List<String> times = [];
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
      print("hi");
      print(jsonResponse); // Print the jsonResponse to check its contents

      setState(() {
        list.clear(); // Clear the previous data

        list.addAll(jsonResponse);
        tlist.clear();

        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        String selectedDate = DateFormat('yyyy-MM-dd').format(_currentDay);

        // If the selected day (_currentDay) is today
        if (selectedDate == currentDate) {
          for (int i = 0; i < jsonResponse.length; i++) {
            String slot = jsonResponse[i]['time'];
            String hours =
                slot.substring(0, 2); // Extract hours from the time slot
            String minutes =
                slot.substring(3, 5); // Extract minutes from the time slot
            int slotMinutes = int.parse(minutes); // Convert minutes to integer

            String currentHours = currentTime.substring(0, 2); // Current hour
            String currentMinutes =
                currentTime.substring(3, 5); // Current minutes
            int currentSlotMinutes =
                int.parse(currentMinutes); // Convert current minutes to integer

            int slotHours =
                int.parse(hours); // Convert time slot hour to integer
            int currentHoursInt =
                int.parse(currentHours); // Convert current hour to integer

            // Compare current hour and minute with the time slot hour and minute
            if (currentHoursInt < slotHours ||
                (currentHoursInt == slotHours &&
                    currentSlotMinutes < slotMinutes)) {
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
    time =
        "${DateFormat.Hm().format(timeIncrement)} ${timeIncrement.hour > 11 ? 'PM' : 'AM'}";
    timeSlots.add(time);
    while (startTime.isBefore(endTime)) {
      timeIncrement = startTime.add(step);
      if (count == 1440 ~/ duration) {
        break;
      } else {
        time =
            "${DateFormat.Hm().format(timeIncrement)} ${timeIncrement.hour > 11 ? 'PM' : 'AM'}";
        timeSlots.add(time);
        count++;
        startTime = timeIncrement;
      }
    }
    return timeSlots;
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Reservation Time',
                      style: GoogleFonts.poppins(
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
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      'Your reservation will be rescheduled to:',
                                      style: GoogleFonts.poppins(
                                          color:
                                              Color.fromARGB(255, 48, 48, 48),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Container(
                                      width: 350,
                                      height: 74,
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
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '$getUpdatedDate',
                                                style: GoogleFonts.poppins(
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
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '$getUpdatedTime',
                                                style: GoogleFonts.poppins(
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
                                              height: 38, width: 104),
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.poppins(
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
                                              height: 38, width: 126),
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
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts
                                                                .poppins(
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
                                                            textAlign: TextAlign.center,
                                                            'Reschedulling is done successfully',
                                                            style: GoogleFonts
                                                                .poppins(
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
                                                                constraints: BoxConstraints
                                                                    .tightFor(
                                                                        height:
                                                                            38,
                                                                        width:
                                                                            104),
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
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
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
                                      style: GoogleFonts.poppins(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Choose a time!",
                                      style: GoogleFonts.poppins(
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
          var slot = tlist[index];

          return InkWell(
            splashColor: Color.fromARGB(0, 255, 255, 255),
            onTap: () {
              setState(() {
                if (slot["slotStatus"] == "Both") {
                  _currentIndex = index;
                  _timeSelected = true;
                }
                if (slot["slotStatus"] == "OnlySingle" &&
                    list[ind]["VehicleType"] == "Single") {
                  _currentIndex = index;
                  _timeSelected = true;
                }
                if (slot["slotStatus"] == "OnlyDouble" &&
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
                    : slot["slotStatus"] == "Both"
                        ? Colors.white
                        : slot["slotStatus"] == "OnlySingle" &&
                                list[ind]["VehicleType"] == "Double"
                            ? Color.fromARGB(255, 205, 204, 204)
                            : slot["slotStatus"] == "OnlyDouble" &&
                                    list[ind]["VehicleType"] == "Single"
                                ? Color.fromARGB(255, 205, 204, 204)
                                : slot["slotStatus"] == "OnlyDouble" &&
                                        list[ind]["VehicleType"] == "Double"
                                    ? Colors.white
                                    : slot["slotStatus"] == "OnlySingle" &&
                                            list[ind]["VehicleType"] == "Single"
                                        ? Colors.white
                                        : Color.fromARGB(255, 205, 204, 204),
              ),
              alignment: Alignment.center,
              child: Text(
                '${slot["time"]}', // Display the time
                style: GoogleFonts.poppins(
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
        crossAxisCount: 4,
        childAspectRatio: 1.5,
      ),
    );
  }
}
