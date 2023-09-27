import 'package:flutter/material.dart';

import 'clip.dart';

class MyReservations extends StatefulWidget {
  const MyReservations({super.key});

  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
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
          child: Center(
            child: Text(
              'Reservations list',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w500
              ),
            ),
          ),

        ),
       ),
      ),

      body: Container(

      ),
    );
  }
}