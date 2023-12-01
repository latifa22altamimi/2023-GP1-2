import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/reservations/reservation_list.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/widgets/constants.dart';
import '../customization/clip.dart';
import 'package:rehaab/GlobalValues.dart';

class MyReservations extends StatefulWidget {
  MyReservations({Key? Key});

  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  List list = [];

  Future GetData() async {
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/RList.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove back button

        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100,
        flexibleSpace: ClipPath(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(20),
                  ),
                  color: kPrimaryColor),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'My reservations',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )),
        ),
      ),
      body: content(),
    );
  }

  Widget content() {
    if (list.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 110),
        child: Column(
          children: [
            Lottie.asset('assets/images/noavailable.json',
                width: 250, height: 250),
            Text(
              'No reservations yet',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color.fromARGB(255, 132, 131, 131)),
            )
          ],
        ),
        alignment: Alignment.center,
      );
    } else {
      return ReservationList();
    }
  }
}
