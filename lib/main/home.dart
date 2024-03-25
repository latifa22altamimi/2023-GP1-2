import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/TrackTawafStatus/TrackTawaf.dart';
import 'package:rehaab/main/onboardingscreen.dart';
import 'package:rehaab/profile/profile.dart';
import 'package:rehaab/reservations/reserve_vehicle.dart';
import 'package:rehaab/reservations/myreservations.dart';
import 'package:rehaab/Map_page/map.dart';
import 'package:rehaab/widgets/constants.dart';
import 'package:rehaab/callSupport/support.dart';
import 'package:http/http.dart' as http;

bool appearsupport = false;

class home extends StatefulWidget {
  home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
  try {
    var url = "http://10.0.2.2/phpfiles/checkStatus.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });

    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      print(red);
      String message = red['message'];
      print(message);
      bool supportStatus = message == 'User has an active reservation.';
      setState(() {
        appearsupport = supportStatus;
        print("Support status: $appearsupport");
        GlobalValues.Status = supportStatus ? "Active" : "Inactive";
      });
    } else {
      // Handle non-200 status code
      print("Error: ${res.statusCode}");
    }
    
    // Trigger UI update
    setState(() {});
  } catch (e) {
    // Handle network or other errors
    print("Error: $e");
  }
}


  

  int index = 1;
  late final pages = [
    // pages in navigation bar
    MyReservations(),

    Column(
      //home page
      children: const [
        AppBarr(),
        BodyHome(),
      ],
    ),
    Profile(), //settings or log out
  ];

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
                      label: 'My reservations',
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
                'Hello, \n' + GlobalValues.Fullname,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
                 Container(

                  child:appearsupport?  TextButton(
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
                  )
                  :  Text('')
                  )
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
          child: Row(
            children: [
              Text(
                'Our Services',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),

        // cards

        Container(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            spacing: 1,
            runSpacing: 2,
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReserveVehicle())),
                child: Container(
                  width: 180,
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
                    MaterialPageRoute(builder: (context) => TrackTawaf())),
                child: Container(
                  width: 180,
                  height: 180,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(5),
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
                          'assets/images/kaaba.png',
                          height: 120,
                          width: 120,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Track tawaf status',
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
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home())),
                child: Container(
                  width: 180,
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
                          'assets/images/loc.png',
                          height: 120,
                          width: 109,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Vehicles location',
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
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingScreen())),
                child: Container(
                  width: 180,
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
                          'assets/images/qibla.png',
                          height: 120,
                          width: 120,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Qibla',
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
