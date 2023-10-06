import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehaab/main/onboardingscreen.dart';
import 'package:rehaab/reservations/reserve_vehicle.dart';
import 'package:rehaab/reservations/myreservations.dart';
import 'package:rehaab/Map_page/map.dart';

class home extends StatefulWidget {
 String? driverG;

  home({this.driverG});
  @override
  State<home> createState() => _homeState(driverG: driverG);
}

class _homeState extends State<home> {
   String? driverG;

  _homeState({this.driverG});
  int index = 0; 
  late final pages = [
    // pages in navigation bar
   MyReservations(driverG: driverG),

    Column(
      //home page
      children: const [
        AppBarr(),
        BodyHome(),
      ],
    ),
    Container(), //settings or log out
  ];
  
 
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: IndexedStack(index: index,
        children: pages,),
        bottomNavigationBar: NavigationBarTheme(
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
                          icon: Icon(Icons.menu),
                          selectedIcon: Icon(Icons.menu_open),
                          label: 'My reservations',
                          ),
                    
                    NavigationDestination(
                        icon: Icon(Icons.home_filled),
                        selectedIcon: Icon(Icons.home_outlined),
                        label: 'Home'),
                    NavigationDestination(
                        icon: Icon(Icons.settings),
                        selectedIcon: Icon(Icons.settings),
                        label: 'Settings'),
                  
                
              ]),
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
          /* boxShadow:[
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 4.0,
                spreadRadius: .05,
              ),
          ],*/
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 60, 100, 73),
              Color.fromARGB(255, 104, 132, 113)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, \nMrs. Shahad',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              )
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
    return Container(
      height: 590,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(90), topLeft: Radius.circular(20)),
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReserveVehicle())),
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
                            height: 120,
                            width: 120,
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnboardingScreen())),
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
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home())),
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
                            width: 120,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Our location',
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
                            'assets/images/pray.png',
                            height: 120,
                            width: 120,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Pray',
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
      ),
    );
  }
}