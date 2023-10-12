import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/reservations/reservationdetails.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/reservations/reserve_vehicle.dart';

class ReservationList extends StatefulWidget {
  ReservationList({Key? key}) : super(key: key);

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List list = [];

  Future GetData() async {
    var url =
        "http://10.6.198.101/phpfiles/RList.php"; //put your computer IP address instead of 192.168.8.105
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      setState(() {
        list.addAll(red);
      });
    }
  }

  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          if (list[0] != null) {

            if (list[index]["Status"] == "Confirmed") {
              return ReserveCard(
                Rid: list[index]["id"],
                datee: list[index]["date"],
                timee: list[index]["time"],
                status: list[index]["Status"],
                colorr: Color.fromARGB(255, 33, 152, 51),
              );
            }
             if (list[index]["Status"] == "Cancelled") {
              return ReserveCard(
                Rid: list[index]["id"],
                datee: list[index]["date"],
                timee: list[index]["time"],
                status: list[index]["Status"],
                colorr:  Color.fromARGB(255, 215, 53, 53),
              );
            }
            
          } else {
            //when manager changes status to being used
          }
        },
      ),
    );
  }
}

class ReserveCard extends StatelessWidget {
  String? Rid;
  String? datee;
  String? timee;
  String? status;
  Color? colorr;

  ReserveCard({this.Rid, this.datee, this.timee, this.status, this.colorr});
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
                  width: 110.0,
                ),
                Text(
                  '$status ',
                  style: TextStyle(
                      color: colorr,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
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
                width: 200.0,
              ),
              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ReservationDetails())));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(131, 60, 100, 73),
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
