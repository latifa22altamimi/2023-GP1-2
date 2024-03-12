import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          if ((list[i]["Status"] == "Confirmed" ||
              list[i]["Status"] == "Waiting")) {
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

  Future GetWaitingList() async {
    // historyList.clear();
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/waitingList.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      setState(() {
        waitingList.addAll(red);
      });
    }
  }

  Future convertToCompleted() async {
    var url = "http://10.0.2.2/phpfiles/DeleteRecord.php";
    final res = await http.post(Uri.parse(url), body: {});

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      print(red);
    }
  }

  Future refresh() async {
    // convertToCompleted();
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
            if ((list[i]["Status"] == "Active")) {
              historyList.add(list[i]);
            }
          }
        }

        //inital current list
      });
    }
  }

  void initState() {
    //convertToCompleted();
    super.initState();
    curpressed = true;
    GetData();
    GetWaitingList();
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
                          style: TextStyle(color: prevTxt),
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
                      style: TextStyle(color: curTxt),
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
                            if ((historyList[index]["Status"] == "Waiting")) {
                              print(historyList[index]["Status"]);
                              return WaitingCard(
                                Id: historyList[index]["reservationId"],
                                Name: historyList[index]["visitorName"],
                                PhoneNumber: historyList[index]["VphoneNumber"],
                                VehicleType: historyList[index]["VehicleType"],
                                ExpectUseTime: historyList[index]
                                    ["ExpectUseTime"],
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
                                'No waiting yet',
                                style: TextStyle(
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
                                (historyList[index]["ReservedForWaiting"] == "0")
                                ) {
                              return ReserveCard(
                                Rid: historyList[index]["reservationId"],
                                datee: historyList[index]["date"],
                                timee: historyList[index]["time"],
                                status: historyList[index]["Status"],
                                VehicleType: historyList[index]["VehicleType"],
                                ExpectFinishTime: historyList[index]
                                    ["ExpectFinishTime"],
                                colorr: Color.fromRGBO(255, 196, 4, 1),
                                widthAdjust: 125.0,
                                buttonColor: Color.fromARGB(255, 37, 149, 190),
                                isButtonEnabled: false,
                              );
                            } else if ((historyList[index]["Status"] ==
                                    "Active") &&
                                (historyList[index]["ReservedForWaiting"] == "1")) {
                              return ReserveCard(
                                Rid: historyList[index]["reservationId"],
                                datee: historyList[index]["date"],
                                timee: historyList[index]["time"],
                                status: historyList[index]["Status"],
                                VehicleType: historyList[index]["VehicleType"],
                                ExpectFinishTime: historyList[index]
                                    ["ExpectFinishTime"],
                                colorr: Color.fromRGBO(255, 196, 4, 1),
                                widthAdjust: 125.0,
                                buttonColor: Colors.grey,
                                isButtonEnabled: true,
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
                                style: TextStyle(
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
      this.isButtonEnabled});

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
    setState(() {});
  }

  void didUpdateWidget(covariant ReserveCard oldWidget) {
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
  }

  Future insertWaitingList() async {
    var url = "http://10.0.2.2/phpfiles/insertWaiting.php";
    final res = await http.post(Uri.parse(url), body: {
      "id": GlobalValues.id,
      "Name": waitName.text,
      "PhoneNumber": waitPhoneNumber.text,
      "VehicleType": widget.VehicleType,
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

  void handleButtonPress() {
    setState(() {
      isVisibleWaiting = true;
    });
    print(isVisibleWaiting);
    if (unavailableVehicles) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Color.fromARGB(255, 247, 247, 247),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.only(
                right: 30.0, left: 30.0, top: 10.0, bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/images/warn.json',
                    width: 100, height: 100),
                Text(
                  'Add to waiting list',
                  style: TextStyle(
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
                  style: TextStyle(
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
                        style: TextStyle(
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
                  onTapOutside: (PointerDownEvent) {
                    setState(() {
                      waitingName = waitName.text;
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
                      hintStyle: const TextStyle(fontFamily: 'OpenSans'),
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
                        width: 10.0,
                      ),
                      Visibility(
                        visible: phoneReq,
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
                    onTapOutside: (PointerDownEvent) {
                      setState(() {
                        waitingNumber = waitPhoneNumber.text;
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
                      constraints:
                          BoxConstraints.tightFor(height: 38, width: 100),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isVisibleWaiting = false;
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
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                      constraints:
                          BoxConstraints.tightFor(height: 38, width: 100),
                      child: ElevatedButton(
                        onPressed: () {
                          if (waitingName == "") {
                            setState(() {
                              nameReq = true;
                              print(nameReq);
                            });
                          }
                          if (waitingNumber == "") {
                            setState(() {
                              phoneReq = true;
                              print(phoneReq);
                            });
                          } else {
                            setWaiting();
                            insertWaitingList();
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ManagerHome()),
                                  );
                                });
                                return Dialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 247, 247, 247),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
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
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'Visitor has been added to the waiting list',
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
                          backgroundColor: Color.fromARGB(255, 60, 100, 73),
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
        ),
      );
    } else {
      //there is already available vehicles
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
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: widget.widthAdjust,
                    ),
                    Text(
                      '${widget.status} ',
                      style: TextStyle(
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
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '${widget.VehicleType}',
                    style: TextStyle(
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
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '${widget.timee}', //widget.timee
                    style: TextStyle(
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
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${widget.ExpectFinishTime}', //widget.timee
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
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
              const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 44),
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

        Container(
          margin: EdgeInsets.only(
            left: 27.0,
          ),
          child: ElevatedButton(
            onPressed: (isButtonEnabled != null && isButtonEnabled == false)
                ? () => handleButtonPress()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.buttonColor,
              padding: EdgeInsets.only(right: 25.0, left: 25.0),

              //Color.fromARGB(131, 60, 100, 73)
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(18.0))),
            ),
            child: const Icon(CupertinoIcons.add, color: Colors.white),
          ),
        ),
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

  WaitingCard(
      {this.Id,
      this.Name,
      this.PhoneNumber,
      this.VehicleType,
      this.ExpectUseTime});

  @override
  State<WaitingCard> createState() => _WaitingCardState();
}

class _WaitingCardState extends State<WaitingCard> {
  void initState() {
    super.initState();
  }

  removeWaiting() async {
    var url = "http://10.0.2.2/phpfiles/RemoveWaiting.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": widget.Id,
    });
    var respo = json.decode(res.body);
    print(respo);
  }

  acceptVisitor() async {
    var url = "http://10.0.2.2/phpfiles/AcceptVisitor.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": widget.Id,
      "startTime": widget.getTimee,
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
                  'WaitingId#${widget.Id}', // reservation id
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 140.0,
                ),
                Text(
                  'Waiting',
                  style: TextStyle(
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
            height: 10.0,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Name: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${widget.Name}',
                style: TextStyle(
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
            height: 8.0,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Vehicle type: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${widget.VehicleType}',
                style: TextStyle(
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
            height: 8.0,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Phone: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${widget.PhoneNumber}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Expected use time: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${widget.ExpectUseTime}',
                      style: TextStyle(
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
                                          'Visitor will be removed from waiting list',
                                          style: TextStyle(
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
                                                                'Visitor has been removed successfully',
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
                                                  'Remove',
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ErrorColor,

                        //Color.fromARGB(131, 60, 100, 73)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5000),
                          ),
                        ),
                      ),
                      child:
                          const Icon(CupertinoIcons.xmark, color: Colors.white),
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
                        if (!unavailableVehicles) {
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
                                            style: TextStyle(
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
                                                    style: TextStyle(
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
                                                                  'Visitor has been accepted',
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
                                                    'Accept',
                                                    style: TextStyle(
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
                                      'There are no available vehicles',
                                      style: TextStyle(
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

                        //Color.fromARGB(131, 60, 100, 73)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5000),
                          ),
                        ),
                      ),
                      child: const Icon(CupertinoIcons.check_mark,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      width: 180,
      height: 170,
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
