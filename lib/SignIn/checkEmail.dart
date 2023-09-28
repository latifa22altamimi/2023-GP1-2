
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rehaab/components/page_title_bar.dart';
import 'package:rehaab/components/under_part.dart';
import 'package:rehaab/components/upside.dart';
import 'package:rehaab/constants.dart';
import 'package:rehaab/SignIn/login_screen.dart';
import 'package:rehaab/SignUp/signup_screen.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:rehaab/widgets/rounded_input_field.dart';
import 'package:rehaab/widgets/rounded_password_field.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rehaab/widgets/text_field_container.dart';
import 'package:rehaab/Signin/forgotPass_Screen';
import 'dart:async';


class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({Key? key}) : super(key: key);

  
  @override
State<CheckEmailScreen> createState() => _CheckEmailScreenState();}

class _CheckEmailScreenState extends State<CheckEmailScreen> {


  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     String dropdownValue = 'Al-Haram visitor';
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/images/rehabLogo.png",
                  ),
                const PageTitleBar(title: 'Check your email'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Form(
                          child: Column(
                            children: [
                                    Image.asset(
             "assets/images/icons8-received-90.png",
              alignment: Alignment.topCenter,
              
              scale: 1,
            ),
                         Padding(
                          
                                  padding: EdgeInsets.only(left:30,right:30,top:20,bottom:10),
                                  
                         child: Text("We have sent a password reset mail to your email", 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                                      fontSize:20,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                      fontFamily: 'OpenSans',
                                     
                                      ),
                              ),
                              ), 
                  

          
                             
                            
                              
                              const SizedBox(
                                height: 10,
                              ),
                        
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(child: Text(
                                'GO BACK TO SIGN IN',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                                 onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen())
                                  );
                                },
                                ),
                          
                              
                              const SizedBox(height: 20,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

  
 


