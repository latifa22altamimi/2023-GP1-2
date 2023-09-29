
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rehaab/components/page_title_bar.dart';
import 'package:rehaab/components/under_part.dart';
import 'package:rehaab/components/upside.dart';
import 'package:rehaab/SignUp/signup_screen.dart';
import 'package:rehaab/widgets/constants.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rehaab/widgets/text_field_container.dart';
import 'package:rehaab/Signin/forgotPass_Screen.dart';
import 'dart:async';
import 'package:rehaab/main/home.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  
  @override
State<LoginScreen> createState() => _LoginScreenState();}

class _LoginScreenState extends State<LoginScreen> {
 TextEditingController email = TextEditingController();
 TextEditingController Password=TextEditingController();
var valueChoose;
List listItem=[
  "Al-Haram visitor", "Vehicle manager"
];


   

  Future rehaab() async{
    var url ="http://192.168.100.167/RehabAuth/signin.php";
    final response= await http.post(Uri.parse(url),body:{
    "Email":email.text,
    "Password":Password.text,
    "Type": valueChoose});
  var data =json.decode(response.body);

  if(data == "Success"){
    Fluttertoast.showToast(
        msg: "Signed in successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  home()),
  ); 
  }
    else if( data == "empty"){
      Fluttertoast.showToast(
        msg: "Please fill all the fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
      else if( data == "notVerfied"){
      Fluttertoast.showToast(
        msg: "You are not verfied!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  else{
     Fluttertoast.showToast(
        msg: "Email or password or type is wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                const PageTitleBar(title: 'Login to your account'),
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
                          
                               TextFieldContainer(
                               child: TextField(
                               controller:email,
                               cursorColor: kPrimaryColor,
                               decoration: InputDecoration(
                                icon: Icon(
                                 Icons.email,
                                 color: kPrimaryColor,
                                   ),
                                  hintText: "Email",
                                   hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                                   border: InputBorder.none),
                                   )
                                   ),
                                   TextFieldContainer(
                                  child: TextField(
                                  controller: Password,
                                  obscureText: true,
                                  cursorColor: kPrimaryColor,
                                  decoration: const InputDecoration(
                                   icon: Icon(
                                   Icons.lock,
                                   color: kPrimaryColor,
                                   ),
                                   hintText: "Password",
                                   hintStyle:  TextStyle(fontFamily: 'OpenSans'),
                                   suffixIcon: Icon(
                                   Icons.visibility,
                                   color: kPrimaryColor,
                                    ),
                                   border: InputBorder.none),
                                    ),
                                    ),
                                    
                              Padding(padding:EdgeInsets.all(16), 
                             child: Container(
                              padding: EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(color: kPrimaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(15)
                                  ),
                              child: DropdownButton(
                              hint: Text("User type: "),
                               icon: Icon(Icons.arrow_drop_down),
                               iconSize: 32,
                               underline: SizedBox(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
              
                              ),
                               value: valueChoose,
                               onChanged: (newValue){
                                setState(() {
                                  valueChoose=newValue;
                                });
                              },
                              items: listItem.map((valueItem){
                                return DropdownMenuItem(
                                  value:valueItem,
                                  child:Text(valueItem) ,
                                 );
                              }).toList(),
                              ) 
                              )
                              ),
                              RoundedButton(text: 'LOGIN', press: () {rehaab();}),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "Don't have an account?",
                                navigatorText: "Register here",
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen())
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(child:     Text(
                                'Forgot password?',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                                 onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const ForgotPassScreen())
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

switchListTile() {
  return Padding(
    padding: const EdgeInsets.only(left: 50, right: 40),
    child: SwitchListTile(
      dense: true,
      title: const Text(
        'Remember Me',
        style: TextStyle(fontSize: 16, fontFamily: 'OpenSans'),
      ),
      value: true,
      activeColor: kPrimaryColor,
      onChanged: (val) {},
    ),
  );
  }
  
 


