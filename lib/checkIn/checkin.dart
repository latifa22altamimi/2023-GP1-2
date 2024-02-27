import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;
//import 'package:rehaab/checkIn/Result.dart';
import '../customization/clip.dart';
import '../widgets/constants.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

class CheckIn extends StatefulWidget {
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  bool isVisibleSuccess=false;
  bool isVisibleErr=false;
  bool isScanCompleted=false;

  bool isFlashOn = false;
  bool isFrontCamera = false;
  
  void closeScreen() {
    isScanCompleted = false;
  }
  String code="";

  late MobileScannerController controller;
  
  StartTawaf(String code) async {
  final key = enc.Key.fromUtf8("3159a027584ad57a42c03d5dab118f68");
  final iv = enc.IV.fromUtf8("e0c2ed4fbc3e1fb6");
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final decrypted = encrypter.decrypt64(code, iv: iv);
    var url = "http://10.0.2.2/phpfiles/startTawaf.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": decrypted,
    });
    var respo = json.decode(res.body);
    print(respo);
    if(respo=="Tawaf started successfully"){
      setState(() {
        isVisibleSuccess=true;
      });
    }
    else{
      setState(() {
        isVisibleErr=true;
      });
    }
  }
  
  

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  /*void reassemble() async{
    super.reassemble();
    if (Platform.isAndroid) {
      await controllerQ!.pauseCamera();
    }
    controllerQ!.resumeCamera();
  }*/

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(formats: [BarcodeFormat.qrCode]);
    initializeCamera();
 
  }

Future<void> initializeCamera() async {
    try {
      await controller.start();

    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

 

  @override
Widget build(BuildContext context) => SafeArea(
  child: Scaffold(
    drawer: const Drawer(),
    backgroundColor: kPrimaryLightColor,
    appBar: AppBar(
      actions: [],
      iconTheme: IconThemeData(color: Colors.black87),
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
              'Check In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Place the QR code in the area",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "Scanning will be started automatically",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Stack(
            children: [
            MobileScanner(
  controller: controller,
  fit: BoxFit.cover,
  onDetect: (capture, args) async {
    // Extract the scanned QR code from the capture object
    String scannedQrCode = capture.rawValue ?? "";
    
    // Check if a QR code was scanned
    if (scannedQrCode.isNotEmpty) {
      // Process the scanned QR code (e.g., start Tawaf)
      await StartTawaf(scannedQrCode);
      // Update the 'code' variable to display the scanned code
      setState(() {
        code = scannedQrCode;
      });

      // Show success or error modal based on the result
      if (isVisibleSuccess) {
        showSuccessModal(context);
      } else if (isVisibleErr) {
        showErrorModal(context);
      }
    }
  },
),

              QRScannerOverlay(
                borderColor: kPrimaryColor,
                overlayColor: kPrimaryLightColor,
                borderRadius: 12,
                scanAreaWidth: (MediaQuery.of(context).size.width) * 0.6,
                scanAreaHeight: MediaQuery.of(context).size.height * 0.3,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: kPrimaryLightColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFlashOn = !isFlashOn;
                        });
                        controller.toggleTorch();
                      },
                      icon: Icon(
                        Icons.flash_on,
                        color: isFlashOn ? kPrimaryColor : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFrontCamera = !isFrontCamera;
                        });
                        controller.switchCamera();
                      },
                      icon: Icon(
                        Icons.cameraswitch_sharp,
                        color: isFrontCamera ? kPrimaryColor : Colors.grey,
                      ),
                    ),
                  ],
                ),
                buildResult(),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);

void showSuccessModal(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(
        Duration(seconds: 5),
        () {
          Navigator.of(context).pop();
          setState(() {
            isVisibleSuccess = !isVisibleSuccess;
          });
        },
      );
      return buildModalContent(
        context,
        'assets/images/success.json',
        'Success',
        'Checked in successfully',
        Colors.black,
        Color.fromARGB(255, 247, 247, 247),
      );
    },
  );
}

void showErrorModal(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(
        Duration(seconds: 5),
        () {
          Navigator.of(context).pop();
          setState(() {
            isVisibleErr = !isVisibleErr;
          });
        },
      );
      return buildModalContent(
        context,
        'assets/images/erorrr.json',
        'Error!',
        'Check in failed',
        const Color.fromARGB(255, 228, 223, 223),
        Color.fromARGB(255, 196, 25, 25),
      );
    },
  );
}

Widget buildModalContent(BuildContext context, String animationAsset, String title, String subtitle, Color titleColor, Color backgroundColor) {
  return Container(
    height: 350,
    child: Stack(
      children: [
        ClipRRect(
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
                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),                ),
              ],
            ),
          ),
        ),
        Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  animationAsset,
                  width: 100,
                  height: 100,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: 38,
                        width: 100,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add to waiting list button
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


    
  
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget buildResult()=> Container(
    padding: EdgeInsets.all(10),
    child: Text( 
    code!= ""? 'Result: ${code}': 'Scan a code' ,
    maxLines: 1,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold
    ),
    )
  );}
/*import 'dart:convert';
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
  bool isVisibleErr=false;
  StartTawaf() async {
  final key = enc.Key.fromUtf8("3159a027584ad57a42c03d5dab118f68");
  final iv = enc.IV.fromUtf8("e0c2ed4fbc3e1fb6");
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final decrypted = encrypter.decrypt64(barcode!.code!, iv: iv);
    var url = "http://192.168.8.105/phpfiles/startTawaf.php";
    final res = await http.post(Uri.parse(url), body: {
      "Rid": decrypted
     // "Rid": decrypted,
    });
    var respo = json.decode(res.body);
    print(respo);
    if(respo=="Tawaf started successfully"){
      setState(() {
        isVisibleSuccess=true;
      });
    }
    else{
      setState(() {
        isVisibleErr=true;
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
                'Check In',
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
          /*Expanded(child: Container(child: 
            Text("Place the QR code in the area", 
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,

            ))
          ),),*/
          buildQrView(context),
          Positioned(child: buildResult(), bottom: 10,),
          Visibility(
            visible: isVisibleSuccess,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                width: 500,
                height: double.infinity,
                color: const Color.fromARGB(0, 80, 59, 59),
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
            visible: isVisibleErr,
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
            visible: isVisibleErr,
            
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
   
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: kPrimaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: (MediaQuery.of(context).size.width)*0.6),
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
  }*/




