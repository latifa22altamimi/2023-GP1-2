import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:rehaab/components/page_title_bar.dart';
import 'package:rehaab/components/under_part.dart';
import 'package:rehaab/components/upside.dart';
import 'package:rehaab/constants.dart';
import 'package:rehaab/Signin/login_screen.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:rehaab/widgets/rounded_input_field.dart';
import 'package:rehaab/widgets/rounded_password_field.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rehaab/widgets/text_field_container.dart';
import 'dart:async';
import "package:mailer/mailer.dart";
import 'package:mailer/smtp_server.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);


 State<SignUpScreen> createState() => _SignUpScreenState();}

class _SignUpScreenState extends State<SignUpScreen> {
  
 TextEditingController FirstName = TextEditingController();
 TextEditingController email = TextEditingController();
 TextEditingController LastName = TextEditingController();
 TextEditingController Password=TextEditingController();
   
var verifylink;
  Future signup() async{
    var url ="http://192.168.100.167/RehabAuth/signup.php";
    final response= await http.post(Uri.parse(url),body:{
    "FirstName":FirstName.text,
    "Email":email.text,
    "LastName":LastName.text,
    "Password":Password.text,
  });
  var data =json.decode(response.body);
  print(data);

  if(data == "Error"){
    Fluttertoast.showToast(
        msg: "Email already exists",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
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
   else if( data == "invalidPass"){
      Fluttertoast.showToast(
        msg: "Password should be at least 8 characters in length and should include at least one upper case letter, one number, and one special character.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
     else if( data == "invalidEmail"){
      Fluttertoast.showToast(
        msg: "Invalid Email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  else{
    verifylink=data;
    sendMail();
     Fluttertoast.showToast(
        msg: "Thank you for regestration! Verfiy your email to sign in!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  }
 
 sendMail() async{
  String EmailSystem= "RehaabSystem@gmail.com";
  String passwordSystem="cnszvdyyrwrlaprn";


  final smtpServer= gmail(EmailSystem,passwordSystem);

  final massage= Message()
  ..from = Address(EmailSystem)
  ..recipients.add(email.text)
  ..subject= 'SignUp verification link from Rehaab :${DateTime.now()}'
  ..html = "<h3> Thanks for registering with Rehaab, please click this link to complete the registration</h3>\n<p> <a href= '$verifylink'> Click me to verify</a></p>";
   try {
    final sendReport = await send(massage, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
 }
 }


  @override
  Widget build(BuildContext context) {
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
                const PageTitleBar(title: 'Create New Account'),
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
                             /* const RoundedInputField(
                                  hintText: "Email", icon: Icons.email),
                                   const RoundedInputField(
                                  hintText: "Phone number", icon: Icons.phone),
                              const RoundedInputField(
                                  hintText: "Username", icon: Icons.person),
                              const RoundedPasswordField(),*/
                              TextFieldContainer(
      child: TextField(
        controller:FirstName,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            icon: Icon(
              Icons.person,
              color: kPrimaryColor,
            ),
            hintText: "First name",
            hintStyle: const TextStyle(fontFamily: 'OpenSans'),
            border: InputBorder.none),
      ),
    ),
                            TextFieldContainer(
      child: TextField(
        controller:LastName,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            icon: Icon(
              Icons.person,
              color: kPrimaryColor,
            ),
            hintText: "Last name",
            hintStyle: const TextStyle(fontFamily: 'OpenSans'),
            border: InputBorder.none),
      ),
    ),                        TextFieldContainer(
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
      ),
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
                        
                              RoundedButton(text: 'REGISTER', press:(){signup();}),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "Already have an account?",
                                navigatorText: "Login here",
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen())
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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

  }
