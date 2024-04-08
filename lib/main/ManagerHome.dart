import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
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
int numOfAvailable = 0;
int TotalVehicles = 0;

class ManagerHome extends StatefulWidget {
  ManagerHome({Key? key}) : super(key: key);
  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  int index = 1;
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

List vehiclesAvailable = [0,0];
String avgTime = "";
int waitNum = 0;
double waitPercent = 0.0;
double percent = 0.0;
int percentage = 0;
Color emptyColor = kPrimaryColor;
int totalActive = 0;
double totalActiveDouble = 0.0;

class BodyHome extends StatefulWidget {
  const BodyHome({Key? key}) : super(key: key);

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  void initState() {
    super.initState();
    AvgDuration();
    DisplayWaiting();
    WaitingNum();
  }

  Future AvgDuration() async {
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/AvgDuration.php";
    final res = await http.post(Uri.parse(url), body: {});
    var red = json.decode(res.body);
    avgTime = red;
    List<String> timeParts = avgTime.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    String formattedTime = '${hours}h ${minutes}min';

    avgTime = formattedTime;
  }

  Future WaitingNum() async {
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/WaitingNum.php";
    final res = await http.post(Uri.parse(url), body: {});
    var red = json.decode(res.body);
    waitNum = int.parse(red);
    print("$waitNum wait");
    waitPercent = (waitNum * 100) / totalActive;
    if (waitPercent.isNaN) {
      waitPercent = 0.0;
    } else {
      waitPercent = double.parse(
          waitPercent.toStringAsFixed(1)); // Format to one decimal place
    }

    print("$waitPercent waitPercent");
    print(TotalVehicles);
  }

  Future DisplayWaiting() async {
    print(GlobalValues.id);
    var url = "http://10.0.2.2/phpfiles/ActiveWalkIn.php";
    final res = await http.post(Uri.parse(url), body: {
      "Userid": GlobalValues.id,
    });
    vehiclesAvailable.clear();
    if (res.statusCode == 200) {
      var red = json.decode(res.body);
      if (red[0] == "Unavailable") {
        setState(() {
          totalActive = red[5];
          print("$totalActive active");
          totalActiveDouble =
              (totalActive.toDouble() / red.length).clamp(0.0, 1.0);
          emptyColor = ErrorColor;
          unavailableVehicles = true; //if there are no available vehicles

          vehiclesAvailable.insert(0, red[3]);
          vehiclesAvailable.insert(1, red[4]);

          numOfAvailable = red[3] + red[4];
          TotalVehicles = red[1] + red[2];

          percent = (numOfAvailable * 100) / TotalVehicles;

          percentage = percent.toInt();
        });

        print(red[0]);
      } else {
        setState(() {
          totalActive = red[6];
          print("$totalActive active");
          totalActiveDouble =
              (totalActive.toDouble() / red.length).clamp(0.0, 1.0);

          emptyColor = kPrimaryColor;
          numOfAvailable = red[1];
          TotalVehicles = red[2] + red[3];

          vehiclesAvailable.insert(0, red[4]);
          vehiclesAvailable.insert(1, red[5]);

          percent = (numOfAvailable * 100) / TotalVehicles;

          percentage = percent.toInt();

          unavailableVehicles = false; //There are available vehicles
        });
        print(red[0]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Vehicles details',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
                 
                  Container(
                    margin: EdgeInsets.only(right:20.0,top:17.0),
                    child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.white,
    elevation: 2, // Adjust the elevation value as desired
  ),
                                    onPressed: () {
                   
                    vehiclesAvailable.clear();
                     DisplayWaiting();
                                    },
                                    child: Text('Refresh',
                                    style: TextStyle(
                                      color: Colors.black
                                    ),),
                                  ),
                  ),
              
            ],
          ),
               
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(
            height: 18.0,
          ),
          // dashboard

          SizedBox(
            width: 380,
            height: 170,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2.0,
                    spreadRadius: .05,
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                  left: 5.0, right: 5.0, bottom: 10.0, top: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Walk-in vehicles',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${vehiclesAvailable[1]}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: emptyColor),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'Single vehicles',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${vehiclesAvailable[0]}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: emptyColor),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'Double vehicles',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      CircularPercentIndicator(
                        addAutomaticKeepAlive: true,
                        restartAnimation: false,
                        animation: true,
                        animationDuration: 1000,
                        radius: 75,
                        lineWidth: 20,
                        percent: percent / 100.0,
                        progressColor: kPrimaryColor,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${percentage}%',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: emptyColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            const Text(
                              'Available vehicles',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //avg time
              SizedBox(
                height: 118,
                width: 140,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2.0,
                        spreadRadius: .05,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Icon(
                        Icons.timeline,
                        color: ErrorColor,
                        size: 30.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${avgTime}',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Average Tawaf Time',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              //num of people in Waiting list
              SizedBox(
                height: 118,
                width: 230,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2.0,
                        spreadRadius: .05,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 7.0, top: 7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                                width: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 1.0,
                                        spreadRadius: .05,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Color.fromRGBO(68, 159, 220, 1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                'People in waiting list',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${waitNum}',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                        LinearPercentIndicator(
                          restartAnimation: true,
                          addAutomaticKeepAlive: true,
                          animation: false,
                          animateFromLastPercent: true,
                          animationDuration: 1000,
                          lineHeight: 16,
                          barRadius: Radius.circular(10),
                          percent: waitPercent <= 100.0
                              ? waitPercent / 100.0
                              : totalActiveDouble, //var
                          progressColor: Color.fromRGBO(68, 159, 220, 1),
                          backgroundColor: Colors.grey.withOpacity(0.2),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Services',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
              )),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(
            height: 10.0,
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
                  onTap: () {
                    print(unavailableVehicles);
                   
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reserve_WalkInVehicle()));
                    
                  },
                  //() => Navigator.push(context,
                  //  MaterialPageRoute(builder: (context) => Reserve_WalkInVehicle())),
                  child: Container(
                    width: 170,
                    height: 150,
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
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Reserve vehicle',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
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
                    width: 170,
                    height: 150,
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
                            height: 99,
                            width: 105,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Check in',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
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
      ),
    );
  }
}
