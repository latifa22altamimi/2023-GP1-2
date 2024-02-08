import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/TrackTawafStatus/TrackTawaf.dart';
import 'package:rehaab/checkIn/checkin.dart';
import 'package:rehaab/main/onboardingscreen.dart';
import 'package:rehaab/profile/profile.dart';
import 'package:rehaab/reservations/reserve_vehicle.dart';
import 'package:rehaab/reservations/myreservations.dart';
import 'package:rehaab/Map_page/map.dart';
import 'package:rehaab/widgets/constants.dart';
import 'package:rehaab/callSupport/support.dart';
import 'package:http/http.dart' as http;
import '../ManagerReservations/Reservations.dart';
import '../ManagerReservations/Reserve_WalkInVehicle.dart';

bool unavailableVehicles = false;

class ManagerHome extends StatefulWidget {
  ManagerHome({Key? key}) : super(key: key);
  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  int index = 0;
  late final pages = [
    // pages in navigation bar
    Reservations(),

    Column(
      //home page
      children: const [
        AppBarr(),
        BodyHome(),
      ],
    ),
    Profile(), //settings or log out
  ];
  void initState() {
    super.initState();
    DisplayWaiting();
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 1),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                height: 80,
                labelTextStyle: MaterialStateProperty.all(
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                shadowColor: Colors.black,
                indicatorColor:
                    Color.fromARGB(255, 104, 132, 113).withOpacity(0.34),
              ),
              child: NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: (index) =>
                      setState(() => this.index = index),
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.menu_outlined),
                      selectedIcon: Icon(Icons.menu_open),
                      label: 'Reservations',
                    ),
                    NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home_outlined),
                        label: 'Home'),
                    NavigationDestination(
                        icon: Icon(Icons.person_2),
                        selectedIcon: Icon(Icons.person_2),
                        label: 'My profile')
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarr extends StatelessWidget {
  const AppBarr({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(20),
          ),
          color: kPrimaryColor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello manager, \n' + GlobalValues.Fullname,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
              Visibility(
                  visible: GlobalValues.Status == "Active" ? true : false,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => callSupport())),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        Row(
                          children: [
                            //  Container (child: Icon(Icons.support_agent, size:35, color:Colors.white ,),

                            Container(
                              child: Image.asset(
                                  'assets/images/support_icon.png',
                                  width: 50,
                                  height: 50),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
              /*   Visibility(
                    visible: false,
                      child: FloatingActionButton( 
                        backgroundColor: Colors.white,
                      onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => callSupport())),
                 
                  
                   child: Container(
                    child:
                   
                    
                     //  Container (child: Icon(Icons.support_agent, size:35, color:Colors.white ,), 
                        
                        Center (child: Image.asset('assets/images/support_icon.png' , width :40 , height: 40, color: Colors.black,),
                        ),)
                       
                     
               
                    
                  
                 )
              ),
              Visibility(
                    visible: false,
                      child: ElevatedButton( 
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                        padding: EdgeInsets.all(20)
                        ),
                      onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => callSupport())),
                 
                  
                   child: Container(child:
                   
                    
                     //  Container (child: Icon(Icons.support_agent, size:35, color:Colors.white ,), 
                        
                        Center (child: Image.asset('assets/images/support_icon.png' , width :40 , height: 40, color: Colors.black,),
                        ),)
                       
                     
               
                    
                  
                 )
              ),*/
              /*  Visibility(
           //   visible: GlobalValues.Status=="Active"? true: false,
           visible: true,
              child:    Container ( padding: EdgeInsets.only(left:40, right: 10, top:5),    child:  ElevatedButton.icon(
                onPressed: () async { Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        callSupport()), //navigate to sign up page
              );},
                label: Text("Call for support"),
                icon: Icon(Icons.phone),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Color.fromARGB(255, 207, 202, 202)),
                  shape: MaterialStateProperty.resolveWith((states) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  fixedSize: MaterialStateProperty.resolveWith(
                      (states) => Size(  170,40 )),
                ),
              ),)
            ),*/
            ],
          )
        ],
      ),
    );
  }
}

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Text(
              'Services',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            )),

        // cards

        Container(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.vertical,
            spacing: 1,
            runSpacing: 2,
            children: <Widget>[
              InkWell(
                onTap: () {
                  print(unavailableVehicles);
                  if (unavailableVehicles) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Color.fromARGB(255, 247, 247, 247),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.only(
                              right: 5.0, left: 5.0, top: 10.0, bottom: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset('assets/images/warn.json',
                                  width: 100, height: 100),
                              Text(
                                'No available vehicles',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
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
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Reserve_WalkInVehicle()));
                  }
                },
                //() => Navigator.push(context,
                //  MaterialPageRoute(builder: (context) => Reserve_WalkInVehicle())),
                child: Container(
                  width: 300,
                  height: 180,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4.0,
                        spreadRadius: .05,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/vehicle1.png',
                          height: 115,
                          width: 115,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Reserve vehicle',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CheckIn())),
                child: Container(
                  width: 300,
                  height: 180,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4.0,
                        spreadRadius: .05,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/barcode.png',
                          height: 120,
                          width: 120,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Check in',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
