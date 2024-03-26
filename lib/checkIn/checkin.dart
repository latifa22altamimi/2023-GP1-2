import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehaab/GlobalValues.dart';
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

  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool isDetecting=false;
  bool isModalVisible = false;


  
  String code="";

  MobileScannerController controller= MobileScannerController(formats: [BarcodeFormat.qrCode]);
  
  bool isVisibleInvalid=false;

  
  Future<void> StartTawaf(String code) async {
    try {
      // Decrypt the QR code
      final key = enc.Key.fromUtf8("3159a027584ad57a42c03d5dab118f68");
      final iv = enc.IV.fromUtf8("e0c2ed4fbc3e1fb6");
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final decrypted = encrypter.decrypt64(code, iv: iv);

      // Send HTTP POST request to start Tawaf
      var url = "http://10.0.2.2/phpfiles/startTawaf.php";
      final res = await http.post(Uri.parse(url), body: {"Rid": decrypted});

      // Parse response
      var respo = json.decode(res.body);

      // Check response for success or failure
      if (respo == "Tawaf started successfully") {
        setState(() {
          isVisibleSuccess = true;
          GlobalValues.Status="Active";
          GlobalValues.Rid=decrypted;

        });
      } else if (respo == "Reservation status is not Confirmed") {
        setState(() {
          isVisibleInvalid = true;
        });
      } else {
        setState(() {
         isVisibleErr = true;
        });
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print("Error starting Tawaf: $e");
    } finally {
      // Stop the indicator regardless of the result received
      setState(() {
        isDetecting = false;
        code = ''; // Reset code to display "Scan a code" text again
      });
    }
  }

  

 

 @override
void initState() {
  super.initState();
  _requestCameraPermission();
}

Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      // Camera permission granted, initialize the camera here

      initializeCamera();
      print("Camera permission granted.");
    } else if (status.isDenied) {
      // Camera permission denied
      // Handle denied permission
      print("Camera permission denied.");
    } else if (status.isPermanentlyDenied) {
      // Camera permission permanently denied, show a dialog or guide the user to app settings
      // Handle permanently denied permission
      print("Camera permission permanently denied.");
    }
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
                        setState(() {
                          isDetecting = true;
                        });
                        String scannedQrCode = capture.rawValue ?? "";
                        if (scannedQrCode.isNotEmpty) {
                          setState(() {
                            code = scannedQrCode;
                          });
                          await StartTawaf(scannedQrCode);
                          if (isVisibleSuccess) {
                            showSuccessModal(context);
                          } else if (isVisibleErr) {
                            showErrorModal(context);
                          }
                          else if(isVisibleInvalid){
                            showInvalidModal(context);

                          }
                        }
                      },
                    ),
if(isDetecting)
Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 50, color: Colors.white), // Circular progress indicator
                  Image.asset(
                    'assets/images/logoapp-removebg-preview.png', // Image asset for the indicator
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
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
  setState(() {
    isModalVisible = true;
  });
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(
        Duration(seconds: 5),
        () {
          Navigator.of(context).pop();
          setState(() {
            isVisibleSuccess = false;
            isModalVisible=false;
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
  setState(() {
    isModalVisible = true;
  });
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(
        Duration(seconds: 5),
        () {
          Navigator.of(context).pop();
          setState(() {
            isVisibleErr = false;
            isModalVisible=false;
          });
        },
      );
      return buildModalContent(
        context,
        'assets/images/erorrr.json',
        'Error!',
        'The QR code is invalid',
        const Color.fromARGB(255, 228, 223, 223),
        Color.fromARGB(255, 196, 25, 25),
      );
    },
  );
}
void showInvalidModal(BuildContext context) {
  setState(() {
    isModalVisible = true;
  });
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(
        Duration(seconds: 5),
        () {
          Navigator.of(context).pop();
          setState(() {
            isVisibleInvalid = false;
            isModalVisible=false;
          });
        },
      );
      return buildModalContent(
        context,
        'assets/images/erorrr.json',
        'Error!',
        'Invalid QR code',
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
  Widget buildResult() {
    if (code.isEmpty && !isModalVisible) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Text(
          'Scan a code',
          maxLines: 1,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
  }
