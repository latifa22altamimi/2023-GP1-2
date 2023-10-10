import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rehaab/reservations/reservation_list.dart';

import '../customization/clip.dart';

class MyReservations extends StatelessWidget {
  dynamic getDate;
  dynamic getTime;

  MyReservations({this.getDate, this.getTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove back button

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
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2.0,
                    sigmaY: 2.0
                  ),
                  
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.2)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.09),
                           Colors.white.withOpacity(0.1),
                          
                        ])
                    ),
                  ),

                  
                  ),

                   Container(
                   alignment: Alignment.center,
                     child: Text(
                                   'My reservations',
                                   style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w500),
                                 ),
                   ),
                  
              ],
            )
          ),
        ),
      ),
      body: Column(
        children: [ReservationList(getDate: getDate, getTime: getTime)],
      ),
    );
  }
}
