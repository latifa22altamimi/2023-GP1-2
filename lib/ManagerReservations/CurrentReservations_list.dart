import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/ManagerReservations/Reserve_WalkInVehicle.dart';
import 'package:rehaab/ManagerReservations/WalkIn_ReservationDetails.dart';
import 'package:rehaab/reservations/reservationdetails.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/widgets/constants.dart';

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
          if ((list[i]["Status"] == "Confirmed" ||
              list[i]["Status"] == "Active")) {
            historyList.add(list[i]);
          }
        }
        //inital current list
        for (int i = 0; i < list.length; i++) {
          if ((list[i]["Status"] == "Confirmed" ||
              list[i]["Status"] == "Active")) {
            currentList.add(list[i]);
          }
        }

        for (int i = 0; i < list.length; i++) {
          if ((list[i]["Status"] == "Confirmed" ||
              list[i]["Status"] == "Active")) {
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

  Future refresh() async {
    historyList.clear();
    list.clear();
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/RList.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      setState(() {
        list.addAll(red);
        if (curpressed) {
          for (int i = 0; i < list.length; i++) {
            if ((list[i]["Status"] == "Confirmed" ||
                list[i]["Status"] == "Active")) {
              historyList.add(list[i]);
            }
          }
        }

        //inital current list
      });
    }
  }

  void initState() {
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
    return Column(
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
                        if ((list[i]["Status"] == "Confirmed" ||
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
                child: ListView.separated(
                  itemCount: waitingList.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 9,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (waitingList[0] != null) {
                      return WaitingCard(
                        Id: waitingList[index]["Id"],
                        Name: waitingList[index]["Name"],
                        PhoneNumber: waitingList[index]["PhoneNumber"],
                      );
                    } else {
                      print("empty list");
                    }
                  },
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
                child: ListView.separated(
                  itemCount: historyList.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 9,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (historyList[0] != null) {
                      if (historyList[index]["Status"] == "Confirmed") {
                        return ReserveCard(
                            Rid: historyList[index]["reservationId"],
                            datee: historyList[index]["date"],
                            timee: historyList[index]["time"],
                            status: historyList[index]["Status"],
                            colorr: Color.fromARGB(255, 33, 152, 51),
                            widthAdjust: 90.0);
                      }
                      if (historyList[index]["Status"] == "Cancelled") {
                        return ReserveCard(
                          Rid: historyList[index]["reservationId"],
                          datee: historyList[index]["date"],
                          timee: historyList[index]["time"],
                          status: historyList[index]["Status"],
                          colorr: Color.fromARGB(255, 215, 53, 53),
                          widthAdjust: 95.0,
                        );
                      }
                      if (historyList[index]["Status"] == "Active") {
                        return ReserveCard(
                          Rid: historyList[index]["reservationId"],
                          datee: historyList[index]["date"],
                          timee: historyList[index]["time"],
                          status: historyList[index]["Status"],
                          colorr: Color.fromRGBO(255, 196, 4, 1),
                          widthAdjust: 125.0,
                        );
                      }
                      if (historyList[index]["Status"] == "Completed") {
                        return ReserveCard(
                          Rid: historyList[index]["reservationId"],
                          datee: historyList[index]["date"],
                          timee: historyList[index]["time"],
                          status: historyList[index]["Status"],
                          colorr: Color.fromRGBO(38, 161, 244, 1),
                          widthAdjust: 88.0,
                        );
                      }
                    } else {
                      print("empty list");
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: currentEmpty,
          child: Container(
            margin: EdgeInsets.only(top: 140),
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
        ),
      ],
    );
  }
}

class ReserveCard extends StatefulWidget {
  String? Rid;
  String? datee;
  String? timee;
  String? status;
  Color? colorr;
  double? widthAdjust;
  ReserveCard(
      {this.Rid,
      this.datee,
      this.timee,
      this.status,
      this.colorr,
      this.widthAdjust});

  @override
  State<ReserveCard> createState() => _ReserveCardState();
}

class _ReserveCardState extends State<ReserveCard> {
  int ExpectedFinishTime = 5;
  void initState() {
    super.initState();
   // _startTimer();
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
            height: 20.0,
          ),
          //display time and date

          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Date: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${widget.datee}',
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
                  'Time: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '12:00 PM',//widget.timee
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              
            
            ],
          ),
SizedBox(height: 1.0,),
            Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Expected finish time: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '01:00 PM',//widget.timee
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
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
                            builder: ((context) => WalkIn_ReservationDetails(
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
      width: 180,
      height: 153,
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

class WaitingCard extends StatefulWidget {
  String? Id;
  String? Name;
  String? PhoneNumber;

  WaitingCard({
    this.Id,
    this.Name,
    this.PhoneNumber,
  });

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
      "waitingId": widget.Id,
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
            height: 20.0,
          ),
          //display time and date

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
            height: 5.0,
          ),

          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Phone: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${widget.PhoneNumber}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                width: 120.0,
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 10.0),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset('assets/images/warn.json',
                                        width: 100, height: 100),
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
                                                      Duration(seconds: 2), () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Reserve_WalkInVehicle()),
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
                                                            'Visitor has been accepted',
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
                                              'Accept',
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
                  child: Text('Accept'),
                ),
              ),
            ],
          )
        ],
      ),
      width: 180,
      height: 140,
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
