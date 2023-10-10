import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehaab/reservations/reservationdetails.dart';
import 'package:http/http.dart' as http;

class ReservationList extends StatefulWidget {
  dynamic getDate;
  dynamic getTime;
  ReservationList({this.getDate, this.getTime});

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List list = [];

  Future GetData() async {
    var url =
        "http://192.168.100.167/phpfiles/details.php"; //put your computer IP address instead of 192.168.8.105
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
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              if ({list[0]["Status"] }  == 'Confirmed' || {list[0]["Status"] }  == 'Cancelled') {
                
                return ReserveCard(getDate: widget.getDate, getTime: widget.getTime);
              }
              else{
                //when manager changes status to being used
              }
            }));
  }
}

class ReserveCard extends StatelessWidget {
  dynamic getDate;
  dynamic getTime;
  ReserveCard({this.getDate, this.getTime});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Text(
                  'Reservation#1', // reservation id
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Status: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),


              Text(
                'Confirmed ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),


              
              Image.asset(
                'assets/images/confirm.png',
                width: 25,
                height: 25,
              ),
              SizedBox(
                width: 130,
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
                '$getDate',
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
                '$getTime',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
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
