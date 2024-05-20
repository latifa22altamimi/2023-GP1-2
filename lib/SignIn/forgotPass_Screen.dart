import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/components/page_title_bar.dart';
import 'package:rehaab/components/under_part.dart';
import 'package:rehaab/components/upside.dart';
import 'package:rehaab/widgets/constants.dart';
import 'package:rehaab/widgets/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:rehaab/widgets/text_field_container.dart';
import 'dart:async';
import 'package:rehaab/signin/login_screen.dart';
import "package:mailer/mailer.dart";
import 'package:mailer/smtp_server.dart';
import 'package:rehaab/signin/checkEmail.dart';


class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController email = TextEditingController();
  var changelink;

  Future ExistEmail() async {
    var url = "http://10.0.2.2/phpfiles/exsitEmail.php";
    final response = await http.post(Uri.parse(url), body: {
      "Email": email.text,
    });
    var data = json.decode(response.body);
    print(data);
    if (data == "Fail") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Container(
            height: 80,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(221, 224, 41, 41),
                    Color.fromARGB(255, 240, 50, 50),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4.0,
                    spreadRadius: .05,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error!',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Email doesn't exists!",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Lottie.asset(
                    'assets/images/erorrr.json',
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (data == "empty") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Container(
            height: 80,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(221, 224, 41, 41),
                    Color.fromARGB(255, 240, 50, 50),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4.0,
                    spreadRadius: .05,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error!',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "There is an empty field!",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Lottie.asset(
                    'assets/images/erorrr.json',
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      changelink = data;
      sendMail();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CheckEmailScreen()),
      );
    }
  }

  sendMail() async {
    String EmailSystem = "RehaabSystem@gmail.com";
    String passwordSystem = "cnszvdyyrwrlaprn";

    final smtpServer = gmail(EmailSystem, passwordSystem);

    final massage = Message()
      ..from = Address(EmailSystem)
      ..recipients.add(email.text)
      ..subject = 'Reset Password from Rehaab\n ${DateTime.now()}'
      ..html =
          "<h2> Hello, </h2> <h3> <p> A request has been received to reset the password for your Rehaab account, please click this link to reset your password</p></h3>\n<p> <a href= '$changelink'> Reset Password</a></p>\n  <h3> if you did not initate this request, just ignore this email.<h3><h3>Thank you,<br> Rehaab team. </h3>";
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
                const PageTitleBar(title: 'Reset your password'),
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 6, bottom: 10),
                                child: Text(
                                  "Enter the email associated with your account and we will send an email to change your password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                              TextFieldContainer(
                                  child: TextField(
                                controller: email,
                                cursorColor: kPrimaryColor,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.email,
                                      color: kPrimaryColor,
                                    ),
                                    hintText: "Email",
                                    hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                    border: InputBorder.none),
                              )),
                              RoundedButton(
                                  text: 'SEND',
                                  press: () {
                                    ExistEmail();
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "",
                                navigatorText: "GO BACK TO SIGN IN",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 20,
                              )
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
