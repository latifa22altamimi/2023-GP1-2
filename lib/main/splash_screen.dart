import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rehaab/GlobalValues.dart';
import 'package:rehaab/main/ManagerHome.dart';
import 'package:rehaab/main/home.dart';
import 'package:rehaab/main/onboardingscreen.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> main() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id  = prefs.getString('id');
    final String? type= prefs.getString('type');
    final String? Fullname=prefs.getString('name');
    if(Fullname!=null && id!=null &&type!=null){
GlobalValues.Fullname=Fullname;
    GlobalValues.id=id;
    GlobalValues.type=type;
    }
    
 if(id==null || id.isEmpty) {
  Timer(  const Duration(seconds: 3),
   ()=>   Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OnboardingScreen())));
    } else if(id.isNotEmpty && type=='Vehicle manager') {
Timer(  const Duration(seconds: 3),()=>
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ManagerHome())));
        
    }
    else if(id.isNotEmpty && type=='Al-haram visitor') {
      Timer(const Duration(seconds: 3),()=>

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => home())));
        
    }
  }
  @override
  void initState() {
    super.initState();
    main();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/logoapp.png',
                    height: 200,
                    width: 200,
                    alignment: Alignment.center,
                  ),
                  const Text(
                    'في رحاب الله',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                     color: Color.fromARGB(255, 47, 76, 58),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
