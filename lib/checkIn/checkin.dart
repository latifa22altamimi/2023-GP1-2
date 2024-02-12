import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../customization/clip.dart';
import '../widgets/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:http/http.dart' as http;

class CheckIn extends StatefulWidget {
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  bool isVisibleSuccess=false;
  StartTawaf() async {
    final key = enc.Key.fromUtf8("3159a027584ad57a42c03d5dab118f68");
  final iv = enc.IV.fromUtf8("e0c2ed4fbc3e1fb6");

  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final decrypted = encrypter.decrypt(barcode!.code as enc.Encrypted, iv: iv);
    var url = "http://10.0.2.2/phpfiles/startTawaf.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": decrypted,
    });
    var respo = json.decode(res.body);
    print(respo);
    if(respo=="started successfully"){
      setState(() {
        isVisibleSuccess=true;
      });
    
    }
    else{
      setState(() {
         isVisibleSuccess=false;
      });
    }
  }
  
  Barcode? barcode;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() async{
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    
  }

 

  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
     backgroundColor: kPrimaryLightColor,

      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 60.0),
          child: BackButton(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 100,
        flexibleSpace: ClipPath(
          clipper: AppbarClip(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            color: kPrimaryColor,
            child: Center(
              child: Text(
                'Chenk In',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        alignment:AlignmentDirectional.topCenter ,
        children: <Widget>[
          buildQrView(context), 
          Visibility(
            visible: isVisibleSuccess,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                width: 500,
                height: double.infinity,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        padding: EdgeInsets.all(50.0),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.13)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.05),
                              ])),
                    )
                  ],
                ),
              ),
            ),
          ),
          /////////////////////////////////////////////////////
          //Waiting list
          Visibility(
            visible: isVisibleSuccess,
            
            child: Dialog(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                247, 247, 247),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Lottie.asset(
                                                                  'assets/images/success.json',
                                                                  width: 100,
                                                                  height: 100),
                                                              Text(
                                                                'Success',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Text(
                                                                'Checked in successfully',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  ConstrainedBox(
                                                                    constraints: BoxConstraints.tightFor(
                                                                        height:
                                                                            38,
                                                                        width:
                                                                            100),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //add to waiting list button

                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(height: 45, width: 120),
                          child: ElevatedButton(
                            onPressed: () {
                          Navigator.of(context).pop();
                         
                              
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 60, 100, 73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                                                            ],
                                                          ),
                                                        ),
                                                      )
          ), Visibility(
            visible: isVisibleSuccess,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                width: 500,
                height: double.infinity,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        padding: EdgeInsets.all(50.0),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.13)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.05),
                              ])),
                    )
                  ],
                ),
              ),
            ),
          ),
          /////////////////////////////////////////////////////
          //Waiting list
          Visibility(
            visible: isVisibleSuccess,
            
            child: Dialog(
                                                        backgroundColor:
                                                            Color.fromARGB(255, 196, 25, 25),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Lottie.asset(
                                                                  'assets/images/erorrr.json',
                                                                  width: 100,
                                                                  height: 100),
                                                              Text(
                                                                ' Error!',
                                                                style: TextStyle(
                                                                    color: const Color.fromARGB(255, 228, 223, 223),
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Text(
                                                    'Check in failed',
                                                                style: TextStyle(
                                                                    color: Color.fromARGB(255, 226, 219, 219),
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  ConstrainedBox(
                                                                    constraints: BoxConstraints.tightFor(
                                                                        height:
                                                                            38,
                                                                        width:
                                                                            100),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //add to waiting list button

                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(height: 45, width: 120),
                          child: ElevatedButton(
                            onPressed: () {
                          Navigator.of(context).pop();
                         
                              
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 10, 7, 7),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 237, 241, 238),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                                                            ],
                                                          ),
                                                        ),
                                                      )
          )
        ],)
    ));
  
  Widget buildResult()=> Container(
    padding: EdgeInsets.all(20),
    child: Text( 
    barcode!= null? 'Result: ${barcode!.code}': 'Scan a code' ,
    maxLines: 10,
    )
  );

   Widget buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller)  async {
    setState(() {
      this.controller = controller;
    });
      controller.scannedDataStream.listen((scanData) {
      setState(() async {
        barcode = scanData;

await StartTawaf();      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}
