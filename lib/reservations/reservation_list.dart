import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/reservations/reservationdetails.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/widgets/constants.dart';

class ReservationList extends StatefulWidget {
  ReservationList({Key? key}) : super(key: key);

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
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
  List currentList = [];
  List previousList = [];
  bool currentEmpty = false;
  bool listVisible = true;
  Future GetData() async {
    historyList.clear();
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/RList.php";
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
        if (prevpressed) {
          for (int i = 0; i < list.length; i++) {
            if ((list[i]["Status"] == "Cancelled") ||
                (list[i]["Status"] == "Completed")) {
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
                      listVisible = true;
                      print('previous');

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
                      historyList.clear();

                      for (int i = 0; i < list.length; i++) {
                        if ((list[i]["Status"] == "Cancelled") ||
                            (list[i]["Status"] == "Completed")) {
                          historyList.add(list[i]);
                        }
                      }
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
                        'Previous',
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
                        listVisible = false;
                        print('current');
                      }
                      curpressed = true;
                      prevpressed = false;
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

class ReserveCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.0, top: 10.0),
            child: Row(
              children: [
                Text(
                  'Reservation#$Rid', // reservation id
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: widthAdjust,
                ),
                Text(
                  '$status ',
                  style: TextStyle(
                      color: colorr, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Image.asset(
                  'assets/images/$status.png',
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
                '$datee',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
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
                  'Time: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '$timee',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                width: 170.0,
              ),
              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ReservationDetails(
                                Rid: Rid,
                                Status: status,
                                date: datee,
                                time: timee))));
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
