import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/ManagerReservations/Reserve_WalkInVehicle.dart';
import 'package:rehaab/ManagerReservations/WalkIn_ReservationDetails.dart';
import 'package:rehaab/main/ManagerHome.dart';
import 'package:rehaab/reservations/reservationdetails.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/widgets/constants.dart';
import 'package:intl/intl.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/text_field_container.dart';

bool isVisibleWaiting = false;

List TypesAvailable = [];

class CurrentReservationsList extends StatefulWidget {
  CurrentReservationsList({Key? key}) : super(key: key);

  @override
  State<CurrentReservationsList> createState() =>
      _CurrentReservationsListState();
}

class _CurrentReservationsListState extends State<CurrentReservationsList> {
  List list = [];
  bool empty = true;
  int history = 1;
  List historyList = [];
  Color prevColor = Color.fromARGB(255, 255, 255, 255);
  Color curColor = Colors.black.withOpacity(0);
  Color curBG = Color.fromARGB(255, 255, 255, 255);
  Color prevBG = Color.fromARGB(255, 255, 255, 255);
  Color prevTxt = Colors.white;
  Color curTxt = Colors.black;
  bool prevpressed = false;
  bool curpressed = true;
  bool waitVisible = false;
  List currentList = [];
  List previousList = [];
  bool currentEmpty = false;
  bool listVisible = true;
  List waitingList = [];
  Future GetData() async {
    historyList.clear();
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/RListWalKIn.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      setState(() {
        list.addAll(red);

        for (int i = 0; i < list.length; i++) {
          if ((list[i]["Status"] == "Waiting" ||
              list[i]["Status"] == "Active")) {
            historyList.add(list[i]);
          }
        }
        //inital current list
        for (int i = 0; i < list.length; i++) {
          if ((list[i]["Status"] == "Waiting" ||
              list[i]["Status"] == "Active")) {
            currentList.add(list[i]);
          }
        }

        for (int i = 0; i < list.length; i++) {
          if ((list[i]["Status"] == "Waiting")) {
            previousList.add(list[i]);
          }
        }
        if (curpressed && currentList.isEmpty) {
          currentEmpty = true;
          listVisible = false;
        }
      });
    }
  }

  Future convertToCompleted() async {
    var url = "http://10.0.2.2/phpfiles/ConvertToComplete.php";
    final res = await http.post(Uri.parse(url), body: {});

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      print(red);
    }
  }

  Future AutoCancel() async {
    var url = "http://10.0.2.2/phpfiles/AutoCancel.php";
    final res = await http.post(Uri.parse(url), body: {});

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      print(red);
    }
  }

  Future refresh() async {
    convertToCompleted();
    AutoCancel();
    historyList.clear();
    list.clear();
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/RListWalkIn.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      setState(() {
        list.addAll(red);
        if (curpressed) {
          for (int i = 0; i < list.length; i++) {
            if ((list[i]["Status"] == "Active" ||
                list[i]["Status"] == "Waiting")) {
              historyList.add(list[i]);
            }
          }
        }

        //inital current list
      });
    }
  }

  Future<void> checkAvailableType() async {
    var url = "http://10.0.2.2/phpfiles/checkAvailableType.php";
    final response = await http.post(Uri.parse(url), body: {});
    var responseBody = json.decode(response.body);

    setState(() {
      TypesAvailable.clear();
      TypesAvailable.addAll(responseBody);
    });
    print("ss $TypesAvailable");
    if (TypesAvailable[0]["Single"].runtimeType == String) {
      print("its string");
    }
  }

  void initState() {
    convertToCompleted(); //convert status to completed
    super.initState();
    checkAvailableType();
    curpressed = true;
    AutoCancel();
    GetData();

    curColor = Colors.black.withOpacity(0.5);
    prevColor = Color.fromARGB(255, 255, 255, 255);
    curBG = kPrimaryColor;
    curTxt = Colors.white;
    prevTxt = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 60,
                  width: 180,
                  child: ElevatedButton(
                    //previous button
                    onPressed: () {
                      setState(() {
                        checkAvailableType();
                        currentEmpty = false;
                        listVisible = false;
                        waitVisible = true;
                        print('waiting');
                        print(waitingList);
                        prevpressed = true;
                        curpressed = false;
                        curColor = Colors.black.withOpacity(0.5);
                        prevColor = Color.fromARGB(255, 255, 255, 255);
                        curBG = Color.fromARGB(255, 255, 255, 255);
                        prevBG = kPrimaryColor;
                        curTxt = Colors.black;
                        prevTxt = Colors.white;
                        //previous reservations
                        history = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: prevColor,
                      elevation: 5,
                      backgroundColor: prevBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'Waiting',
                          style: GoogleFonts.poppins(
                              color: prevTxt, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.black.withOpacity(0.2),
                ),
                SizedBox(
                  height: 60,
                  width: 185,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (currentList.isEmpty) {
                          currentEmpty = true;
                          listVisible = true;
                          print('current');
                        }
                        listVisible = true;
                        curpressed = true;
                        prevpressed = false;
                        waitVisible = false;
                        prevColor = Colors.black.withOpacity(0.5);
                        curColor = Color.fromARGB(255, 255, 255, 255);
                        curBG = kPrimaryColor;
                        prevBG = Color.fromARGB(255, 255, 255, 255);
                        curTxt = Colors.white;
                        prevTxt = Colors.black;
                        //current reservations
                        history = 0;

                        historyList.clear();
                        for (int i = 0; i < list.length; i++) {
                          if ((list[i]["Status"] == "Waiting" ||
                              list[i]["Status"] == "Active")) {
                            historyList.add(list[i]);
                          }
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: curColor,
                      backgroundColor: curBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5)),
                      ),
                    ),
                    child: Text(
                      'Current',
                      style: GoogleFonts.poppins(
                          color: curTxt, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //waiting list
          Visibility(
            visible: waitVisible, //////edit
            child: Expanded(
              child: SizedBox(
                height: double.infinity,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: (historyList.isNotEmpty)
                      ? ListView.separated(
                          itemCount: historyList.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 9,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            Widget widget = Container();
                            if (historyList[index]["Status"] == "Waiting") {
                              // Reservation is still within the 2-minutes window
                              if (historyList[index]["VehicleType"] ==
                                  "Single") {
                                if (TypesAvailable.isNotEmpty &&
                                    TypesAvailable[0]["Single"] ==
                                        "AvailableType") {
                                  widget = WaitingCard(
                                    Id: historyList[index]["reservationId"],
                                    Name: historyList[index]["visitorName"],
                                    PhoneNumber: historyList[index]
                                        ["VphoneNumber"],
                                    VehicleType: historyList[index]
                                        ["VehicleType"],
                                    ExpectUseTime: historyList[index]["time"],
                                    availableType: "True",
                                  );
                                } else {
                                  widget = WaitingCard(
                                    Id: historyList[index]["reservationId"],
                                    Name: historyList[index]["visitorName"],
                                    PhoneNumber: historyList[index]
                                        ["VphoneNumber"],
                                    VehicleType: historyList[index]
                                        ["VehicleType"],
                                    ExpectUseTime: historyList[index]["time"],
                                    availableType: "False",
                                  );
                                }
                              } else if (historyList[index]["VehicleType"] ==
                                  "Double") {
                                if (TypesAvailable.isNotEmpty &&
                                    TypesAvailable[1]["Double"] ==
                                        "AvailableType") {
                                  widget = WaitingCard(
                                    Id: historyList[index]["reservationId"],
                                    Name: historyList[index]["visitorName"],
                                    PhoneNumber: historyList[index]
                                        ["VphoneNumber"],
                                    VehicleType: historyList[index]
                                        ["VehicleType"],
                                    ExpectUseTime: historyList[index]["time"],
                                    availableType: "True",
                                  );
                                } else {
                                  widget = WaitingCard(
                                    Id: historyList[index]["reservationId"],
                                    Name: historyList[index]["visitorName"],
                                    PhoneNumber: historyList[index]
                                        ["VphoneNumber"],
                                    VehicleType: historyList[index]
                                        ["VehicleType"],
                                    ExpectUseTime: historyList[index]["time"],
                                    availableType: "False",
                                  );
                                }
                              } else {
                                // Handle other cases if needed
                              }
                            }
                            return widget;
                          })
                      : Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Column(
                            children: [
                              Lottie.asset('assets/images/noavailable.json',
                                  width: 250, height: 250),
                              Text(
                                'No waiting yet',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: const Color.fromARGB(
                                        255, 132, 131, 131)),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                ),
              ),
            ),
          ),

          //Active walk in list
          Visibility(
            visible: listVisible,
            child: Expanded(
              child: SizedBox(
                height: double.infinity,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: (historyList.isNotEmpty)
                      ? ListView.separated(
                          itemCount: historyList.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 9,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            if ((historyList[index]["Status"] == "Active") &&
                                (historyList[index]["ReservedForWaiting"] ==
                                    "0")) {
                              return ReserveCard(
                                Rid: historyList[index]["reservationId"],
                                datee: historyList[index]["date"],
                                timee: historyList[index]["time"],
                                status: historyList[index]["Status"],
                                VehicleType: historyList[index]["VehicleType"],
                                ExpectFinishTime: historyList[index]
                                    ["ExpectedFinishTime"],
                                colorr: Color.fromRGBO(255, 196, 4, 1),
                                widthAdjust: 125.0,
                                buttonColor: Color.fromARGB(255, 37, 149, 190),
                                isButtonEnabled: false,
                                VehicleId: historyList[index]["VehicleId"],
                              );
                            } else if ((historyList[index]["Status"] ==
                                    "Active") &&
                                (historyList[index]["ReservedForWaiting"] !=
                                    "0")) {
                              return ReserveCard(
                                Rid: historyList[index]["reservationId"],
                                datee: historyList[index]["date"],
                                timee: historyList[index]["time"],
                                status: historyList[index]["Status"],
                                VehicleType: historyList[index]["VehicleType"],
                                ExpectFinishTime: historyList[index]
                                    ["ExpectedFinishTime"],
                                colorr: Color.fromRGBO(255, 196, 4, 1),
                                widthAdjust: 125.0,
                                buttonColor: Colors.grey,
                                isButtonEnabled: true,
                                VehicleId: historyList[index]["VehicleId"],
                              );
                            } else {
                              return Container(); // Handle other cases if needed
                            }
                          },
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Column(
                            children: [
                              Lottie.asset('assets/images/noavailable.json',
                                  width: 250, height: 250),
                              Text(
                                'No current reservations yet',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: const Color.fromARGB(
                                        255, 132, 131, 131)),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                ),
              ),
            ),
          ),

          /* Visibility(
            visible: currentEmpty,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Lottie.asset('assets/images/noavailable.json',
                      width: 250, height: 250),
                  Text(
                    'No current reservations yet',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 132, 131, 131)),
                  )
                ],
              ),
              alignment: Alignment.center,
            ),
          ),*/
        ],
      ),
      Visibility(
        visible: false, //here edit when u finish
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            alignment: Alignment.center,
            width: 500,
            height: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    padding: EdgeInsets.all(50.0),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ])),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

bool unavailableVehicles = false;

class ReserveCard extends StatefulWidget {
  String? Rid;
  String? datee;
  String? timee;
  String? status;
  Color? colorr;
  double? widthAdjust;
  Color? buttonColor;
  bool? isButtonEnabled;
  String? VehicleType;
  String? ExpectFinishTime;
  String? VehicleId;
  ReserveCard(
      {this.Rid,
      this.datee,
      this.timee,
      this.status,
      this.colorr,
      this.VehicleType,
      this.ExpectFinishTime,
      this.widthAdjust,
      this.buttonColor,
      this.isButtonEnabled,
      this.VehicleId});

  @override
  State<ReserveCard> createState() => _ReserveCardState();
}

class _ReserveCardState extends State<ReserveCard> {
  int ExpectedFinishTime = 5;
  TextEditingController waitName = TextEditingController();
  TextEditingController waitPhoneNumber = TextEditingController();
  String waitingName = "";
  String waitingNumber = "";
  bool nameReq = false;
  bool phoneReq = false;
  void initState() {
    super.initState();
    // _startTimer();
    DisplayWaiting();

    setState(() {
      nameReq = false;
      phoneReq = false;
    });
  }

  /*void didUpdateWidget(covariant ReserveCard oldWidget) {
    if (widget.Rid != oldWidget.Rid) {
      // Perform some action when the 'data' property changes

      print("Data has changed");
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (ExpectedFinishTime > 0) {
        setState(() {
          ExpectedFinishTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }*/

  Future insertWaitingList() async {
    var url = "http://10.0.2.2/phpfiles/insertWaiting.php";
    final res = await http.post(Uri.parse(url), body: {
      "id": GlobalValues.id,
      "Name": waitName.text,
      "PhoneNumber": waitPhoneNumber.text,
      "VehicleId": widget.VehicleId,
      "ExpectUseTime": widget.ExpectFinishTime
    });
    var resp = json.decode(res.body);

    print(resp);
  }

  Future DisplayWaiting() async {
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/ActiveWalkIn.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      if (red[0] == "Unavailable") {
        setState(() {
          unavailableVehicles = true; //if there are no available vehicles
        });

        print(red[0]);
      } else {
        setState(() {
          unavailableVehicles = false; //There are available vehicles
        });
        print(red[0]);
      }
    }
  }

  Future setWaiting() async {
    var url = "http://10.0.2.2/phpfiles/setWaiting.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": widget.Rid,
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);

      print(red);
    }
  }

  void handleButtonPress(BuildContext context) {
    setState(() {
      isVisibleWaiting = true;
      nameReq = false;
    });
    print(isVisibleWaiting);
    if (TypesAvailable.isNotEmpty &&
        ((TypesAvailable[0]["${widget.VehicleType}"] == "UnavailableType") ||
            (TypesAvailable[1]["${widget.VehicleType}"] ==
                "UnavailableType"))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Color.fromARGB(255, 247, 247, 247),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    padding: const EdgeInsets.only(
                        right: 30.0, left: 30.0, top: 10.0, bottom: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/images/warn.json',
                            width: 100, height: 100),
                        Text(
                          'Add to waiting list',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'The visitor will be added to the waiting list and will be able to use the current reservation' +
                              "'" +
                              's vehicle as soon as it becomes available',
                          style: GoogleFonts.poppins(
                              color: Color.fromARGB(255, 48, 48, 48),
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                'Name',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Visibility(
                                visible: nameReq,
                                child: Text(
                                  'required*',
                                  style: TextStyle(
                                      color: ErrorColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFieldContainer(
                            child: TextField(
                          onChanged: (value) {
                            setState(() {
                              waitingName = value;

                              print('nameReq: $nameReq');
                            });
                          },
                          controller: waitName,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              hintText: "Visitor name",
                              hintStyle:
                                  const TextStyle(fontFamily: 'OpenSans'),
                              border: InputBorder.none),
                        )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '(Optional)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Visibility(
                                visible: false,
                                child: Text(
                                  'required*',
                                  style: TextStyle(
                                      color: ErrorColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFieldContainer(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                waitingNumber = value;
                              });
                            },
                            controller: waitPhoneNumber,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.phone,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Visitor Number",
                                hintStyle: TextStyle(fontFamily: 'OpenSans'),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //add to waiting list button
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  height: 38, width: 100),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isVisibleWaiting = false;
                                    nameReq = false;
                                    phoneReq = false;
                                  });
                                  print(isVisibleWaiting);

                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 255),
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
                            //press on add
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  height: 38, width: 100),
                              child: ElevatedButton(
                                onPressed: () {
                                  print(waitingName);
                                  /*  if (waitingName.isEmpty &&
                                      waitingNumber.isEmpty) {
                                    setState(() {
                                      print(waitName);
                                      nameReq = true;
                                      phoneReq = true;
                                      print("waiting number is empty");
                                      print("waiting name is empty");
                                    });
                                  }
              
                                  if (waitingNumber.isEmpty &&
                                      waitingName.isNotEmpty) {
                                    setState(() {
                                      phoneReq = true;
                                      nameReq = false;
                                    });
                                  }
                                  */
                                  if (waitingNumber.isEmpty) {
                                    setState(() {
                                      waitPhoneNumber.text = "";
                                    });
                                  }
                                  if (waitingName.isEmpty) {
                                    setState(() {
                                      phoneReq = false;
                                      nameReq = true;
                                    });
                                  }
                                  if (waitingName.isNotEmpty) {
                                    setState(() {
                                      nameReq = false;
                                      phoneReq = false;
                                    });

                                    setWaiting(); //reserved for waiting set to true
                                    insertWaitingList();
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 2),
                                            () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ManagerHome()),
                                          );
                                        });
                                        return Dialog(
                                          backgroundColor: Color.fromARGB(
                                              255, 247, 247, 247),
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
                                                    'assets/images/success.json',
                                                    width: 100,
                                                    height: 100),
                                                Text(
                                                  'Success',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  'Visitor has been added to the waiting list',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints
                                                              .tightFor(
                                                                  height: 38,
                                                                  width: 100),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 60, 100, 73),
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
                  );
                },
              ),
            ),
          );
        },
      );
    } else {
      //there are already available vehicles
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Color.fromARGB(255, 247, 247, 247),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.only(
                right: 10.0, left: 10.0, top: 10.0, bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/images/warn.json',
                    width: 100, height: 100),
                Text(
                  'Unable to add to waiting list',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'There are already available vehicles',
                  style: TextStyle(
                      color: Color.fromARGB(255, 48, 48, 48),
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //add to waiting list button
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 38, width: 100),
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
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
    }
    print('Button pressed!');
  }

  bool? isButtonEnabled;
  @override
  Widget build(BuildContext context) {
    isButtonEnabled = widget.isButtonEnabled;
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Row(
                  children: [
                    Text(
                      'Reservation#${widget.Rid}', // reservation id
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 107.0,
                    ),
                    Text(
                      '${widget.status} ',
                      style: GoogleFonts.poppins(
                          color: widget.colorr,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Image.asset(
                      'assets/images/${widget.status}.png',
                      width: 20,
                      height: 22,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10.0,
              ),
              //display time and date

              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Vehicle type: ',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '${widget.VehicleType}',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  // Text(ExpectedFinishTime.toString()),
                ],
              ),

              SizedBox(
                height: 6.0,
              ),

              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Start time: ',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '${widget.timee}', //widget.timee
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(
                height: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          'Expected finish time: ',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${widget.ExpectFinishTime}', //widget.timee
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 47.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    WalkIn_ReservationDetails(
                                        Rid: widget.Rid,
                                        Status: widget.status,
                                        date: widget.datee,
                                        time: widget.timee))));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        //Color.fromARGB(131, 60, 100, 73)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(500),
                          ),
                        ),
                      ),
                      child: const Icon(CupertinoIcons.chevron_right,
                          color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
          width: 390,
          height: 153,
          margin:
              const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 30),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                spreadRadius: .05,
              ),
            ],
          ),
        ),
        //add to waiting list button
/*
        Container(
          margin: EdgeInsets.only(
            left: 27.0,
          ),
          child: ElevatedButton(
            onPressed: (isButtonEnabled != null && isButtonEnabled == false)
                ? () => handleButtonPress(context)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.buttonColor,
              padding: EdgeInsets.only(right: 25.0, left: 25.0),

              //Color.fromARGB(131, 60, 100, 73)
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(18.0))),
            ),
            child: Text(
              'Add to waiting',
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        */
      ],
    );
  }
}

class WaitingCard extends StatefulWidget {
  String? Id;
  String? Name;
  String? PhoneNumber;
  String? VehicleType;
  String? ExpectUseTime;
  String getTimee =
      '${DateFormat('HH:mm').format(DateTime.now())} ${DateTime.now().hour > 12 ? 'PM' : 'AM'}';
  String? availableType;

  WaitingCard(
      {this.Id,
      this.Name,
      this.PhoneNumber,
      this.VehicleType,
      this.ExpectUseTime,
      this.availableType});

  @override
  State<WaitingCard> createState() => _WaitingCardState();
}

class _WaitingCardState extends State<WaitingCard> {
  bool availableType = false;
  bool phoneVisible = true;
  double wHeight = 0.0;
  void initState() {
    super.initState();
    checkAvailableType();
    if (widget.PhoneNumber == "") {
      phoneVisible = false;
      wHeight = 150;
    } else {
      wHeight = 170;
    }
  }

  removeWaiting() async {
    var url = "http://10.0.2.2/phpfiles/RemoveWaiting.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": widget.Id,
    });
    var respo = json.decode(res.body);
    print(respo);
  }

  Future<void> checkAvailableType() async {
    var url = "http://10.0.2.2/phpfiles/checkAvailableType.php";
    final response = await http.post(Uri.parse(url), body: {});
    var responseBody = json.decode(response.body);

    setState(() {
      TypesAvailable.clear();
      TypesAvailable.addAll(responseBody);
    });
    print("ss $TypesAvailable");
    if (TypesAvailable[0]["Single"].runtimeType == String) {
      print("its string");
    }
  }

  acceptVisitor() async {
    var url = "http://10.0.2.2/phpfiles/AcceptVisitor.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": widget.Id,
    });
    var respo = json.decode(res.body);
    print(respo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.0, top: 10.0),
            child: Row(
              children: [
                Text(
                  'Waiting#${widget.Id}', // reservation id
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 130.0,
                ),
                Text(
                  'Waiting',
                  style: GoogleFonts.poppins(
                      color: Color.fromARGB(255, 37, 149, 190),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Image.asset(
                  'assets/images/waiting.png',
                  width: 20,
                  height: 22,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Name: ',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${widget.Name}',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                width: 30.0,
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Vehicle type: ',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${widget.VehicleType}',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                width: 30.0,
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          Visibility(
            visible: phoneVisible,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text(
                        'Phone: ',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${widget.PhoneNumber}',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Expect use time: ',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${widget.ExpectUseTime}',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 5.0),
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
                                    padding: const EdgeInsets.only(
                                        right: 6.0,
                                        left: 6.0,
                                        top: 10.0,
                                        bottom: 30.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset('assets/images/warn.json',
                                            width: 100, height: 100),
                                        Text(
                                          'Remove visitor',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'Visitor will be removed \nfrom waiting list',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              color: Color.fromARGB(
                                                  255, 48, 48, 48),
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
                                                  'Cancel',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 14,
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
                                                      height: 38, width: 101),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  //execute remove from waiting list
                                                  removeWaiting();
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
                                                              builder: (context) =>
                                                                  ManagerHome()),
                                                        );
                                                        //default is waiting
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
                                                                  .only(
                                                                  top: 15.0,
                                                                  bottom: 15.0,
                                                                  left: 10.0,
                                                                  right: 10.0),
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                'Visitor has been \nremoved successfully',
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
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  'Remove',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 12,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ErrorColor,
                        padding: EdgeInsets.only(top:2.0,left:10.0,right:10.0,bottom:2.0),
                        //Color.fromARGB(131, 60, 100, 73)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5000),
                          ),
                        ),
                      ),
                      child:
                          const Icon(CupertinoIcons.xmark, color: Colors.white,size: 20.0,),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  //accept visitor checkmark
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (widget.availableType == "True") {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 247, 247, 247),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(
                                              'assets/images/warn.json',
                                              width: 100,
                                              height: 100),
                                          Text(
                                            'Accept visitor',
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
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text(
                                                    'Cancel',
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
                                                    acceptVisitor();
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 2),
                                                            () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ManagerHome()),
                                                          );
                                                        });
                                                        return Dialog(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  247,
                                                                  247,
                                                                  247),
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
                                                                    height:
                                                                        100),
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
                                                                  'Visitor has been accepted',
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
                                                    'Accept',
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor:
                                  Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    right: 10.0,
                                    left: 10.0,
                                    top: 10.0,
                                    bottom: 30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset('assets/images/warn.json',
                                        width: 100, height: 100),
                                    Text(
                                      'Unable to accept visitor',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      'There are no available vehicles',
                                      style: GoogleFonts.poppins(
                                          color:
                                              Color.fromARGB(255, 48, 48, 48),
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
                                        //add to waiting list button
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              height: 38, width: 100),
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 14,
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
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.only(top:2.0,left:10.0,right:10.0,bottom:2.0),
                        //Color.fromARGB(131, 60, 100, 73)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5000),
                          ),
                        ),
                      ),
                      child: const Icon(CupertinoIcons.check_mark,
                          color: Colors.white,size: 20.0,),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      width: 180,
      height: wHeight,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1.0,
            spreadRadius: .05,
          ),
        ],
      ),
    );
  }
}
